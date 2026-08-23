---
name: worker-host
description: Use when provisioning or rebuilding a GCP Claude Code worker host.
---

# Worker host

Takes a GCP project to a machine a supervised worker can run a batch on.
Four scripts, split by where they run:

| Script | Runs on | Subcommands |
|---|---|---|
| `scripts/provision-worker.sh` | the operator | `preflight`, `deploy`, `push-scripts`, `firewall`, `keys-install` |
| `scripts/worker-setup.sh` | the VM | `baseline`, `harden`, `claude-install` |
| `scripts/worker-credentials.sh` | the VM | `keys`, `keys-verify`, `forge-cli` |
| `scripts/worker-workspace.sh` | the VM | `config-clone`, `project-clone`, `settings` |

Every subcommand takes `--dry-run` and prints what it would do without
doing it. Use it before anything that spends money or changes a firewall.

Run them in the order set out in `companions/provisioning.md`, which
gives the reason for each position and covers rebuilding. Read
`companions/pitfalls.md` before the first run: every entry there cost a
debugging round to find.

## What only the operator can do

Three steps need a human and are not failures when they pause:

- Run `keys-install`, which needs their forge credentials.
- Run `claude` once on the VM and complete SSO.
- Copy `.env.example` to `~/.claude/.env` and fill in the tokens.
  Secrets are the operator's to move; the scripts read them and never
  echo them.

## Connecting

```
gcloud compute ssh claude-worker --zone=<zone> --project=<project> --tunnel-through-iap
```

Public SSH is denied by a tagged firewall rule, so this is the only
network path. Run worker sessions under `tmux` so they survive a dropped
tunnel: append `-- -t 'tmux new -A -s worker'`.

When IAP or sshd fails, `gcloud compute connect-to-serial-port` reaches
the box independently of the network stack. Exercise it once while
nothing is broken.

`scripts/provision-worker.sh` is supervisor infrastructure and is
deliberately not shipped by `install-dev.sh`, which targets adopter
projects.
