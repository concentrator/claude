---
name: worker-host
description: Stand up a Claude Code worker host on GCP - create the instance, harden it, install the toolchain, and place the credentials and repositories a supervised worker needs. Use when provisioning a new worker VM or rebuilding an existing one.
---

# Worker host

Takes a GCP project to a machine a supervised worker can run a batch on
(R040-T010). Two scripts, split by where they run:

| Script | Runs on | Subcommands |
|---|---|---|
| `scripts/provision-worker.sh` | the operator's machine | `preflight`, `deploy`, `firewall` |
| `scripts/worker-setup.sh` | the VM | `baseline`, `harden`, `claude-install` |
| `scripts/worker-credentials.sh` | the VM | `keys`, `keys-verify`, `forge-cli` |
| `scripts/worker-workspace.sh` | the VM | `config-clone`, `project-clone`, `settings` |

Every subcommand takes `--dry-run` and prints what it would do without
doing it. Use it before anything that spends money or changes a firewall.

## Order, and why it is this order

1. **`preflight`** - resolve and run the operator's `gcloud`. Not "is it
   installed": resolve which binary runs and prove it executes. A working
   SDK is routinely invisible to a non-interactive shell, because its
   `path.*.inc` is sourced from an interactive rc.
2. **`deploy`** - create the instance. Acceptance is
   `gcloud compute ssh --tunnel-through-iap` connecting **before** anything
   else is configured. That path must work independently of every later
   change, so it is proven first.
3. **`baseline`** - Node >= 22 from NodeSource, `jq`, `tmux`, swap sized to
   memory and capped, timezone, `/opt/wallarm`. Idempotent.
4. **`harden`** - inventory first with `ss -tulpn`, then remove what is not
   justified. Then `firewall` on the operator side, which creates the IAP
   allow, **verifies the tunnel**, and only then denies public SSH.
5. **`keys`** - one ed25519 key per forge. Prints both public keys; the
   operator installs them. `keys-verify` reports the identity each forge
   hands back.
6. **`claude-install`**, then the operator authenticates by running `claude`
   once and completing SSO.
7. **`config-clone`** - this config repo becomes the worker's `~/.claude`.
8. **`forge-cli`** - installs `glab` and `gh`, then authenticates from
   `~/.claude/.env`, which the operator places.
9. **`project-clone`** then **`settings`** - repositories into
   `/opt/wallarm`, then the per-project allowlist and workspace trust.

## What the operator must do, and what cannot be automated

Three steps need a human and are not failures when they pause:

- **Installing the two public keys** on GitHub and GitLab.
- **Claude Code SSO** - run `claude` once on the VM and complete it in a
  browser.
- **Placing `~/.claude/.env`** with `GITLAB_TOKEN`, and `GITHUB_TOKEN` if the
  worker will deliver toolset PRs. Secrets are the operator's to move; the
  scripts read them and never echo them.

## Connecting

```
gcloud compute ssh claude-worker --zone=<zone> --project=<project> --tunnel-through-iap
```

Public SSH is denied by a tagged firewall rule, so this is the only network
path. For worker sessions use `tmux` so the session survives a dropped
tunnel: append `-- -t 'tmux new -A -s worker'`.

Break-glass, when IAP or sshd fails: `gcloud compute connect-to-serial-port`.
It reaches the box independently of the network stack. Exercise it once while
nothing is broken.

## Things that will bite

- **First contact with any new remote fails, then works.** The first IAP
  connection after creation exits 255 while the OS Login key propagates; the
  first forge SSH produces no output while host keys are accepted. Retry
  rather than treating the first failure as a verdict.
- **A non-interactive shell is the dispatch context.** `ssh host command` does
  not read past Debian's interactivity guard in `~/.bashrc`, so anything a
  worker needs - the `claude` binary, the forge tokens - is exported *above*
  that guard. Verify tooling from `bash -c`, never from a login shell.
- **Headless sessions cannot edit anything under `.claude/`.** Protected paths
  are denied outright with no prompt to accept, so a task touching guarded
  config cannot be delivered by a headless worker.
- **An untrusted workspace silently drops allow entries.** Claude reports
  "this workspace has not been trusted" and ignores them. `settings` sets
  `projects[<dir>].hasTrustDialogAccepted` in `~/.claude.json`, which lives
  outside the project and arrives with neither the clone nor the settings.
- **Sibling repositories are not optional.** `attack-checker` depends on
  `file:../wallarm-api-js`, so `npm ci` fails outright unless both sit
  adjacent under `/opt/wallarm`.

## Rebuilding

Everything is idempotent, so re-running against an existing host is safe. To
start clean, delete the instance and its two firewall rules
(`claude-worker-allow-iap`, `claude-worker-deny-public-ssh`) and run the order
above. The shared `default-allow-ssh` rule is never touched: it carries
`0.0.0.0/0` with no target tags, so every other instance in the project
depends on it.

`scripts/provision-worker.sh` is supervisor infrastructure and is deliberately
not shipped by `install-dev.sh`, which targets adopter projects.
