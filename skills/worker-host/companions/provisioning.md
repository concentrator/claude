# Provisioning order

Each position below is held by a reason, not by convention. Run the
subcommands in this sequence.

1. **`preflight`** - resolve and run the operator's `gcloud`. Not "is it
   installed": resolve which binary runs and prove it executes. A working
   SDK is routinely invisible to a non-interactive shell, because its
   `path.*.inc` is sourced from an interactive rc.
2. **`deploy`** - create the instance. Acceptance is
   `gcloud compute ssh --tunnel-through-iap` connecting **before**
   anything else is configured. That path must work independently of
   every later change, so it is proven first.
3. **`push-scripts`** - stage the three VM-side scripts in
   `~/.worker-bootstrap` on the host. Nothing VM-side can run until they
   are there, and the config repo that is their permanent home is not
   cloned until step 8 - by one of the three. Re-run it to refresh the
   host after editing a script.
4. **`baseline`** - Node >= 22 from NodeSource, `jq`, `tmux`, swap sized
   to memory and capped, timezone, `/opt/wallarm`. Idempotent.
5. **`harden`** - inventory first with `ss -tulpn`, then remove what is
   not justified. Then `firewall` on the operator side, which creates the
   IAP allow, **verifies the tunnel**, and only then denies public SSH.
6. **`keys`** - one ed25519 key per forge, generated on the VM, which
   can create a key but not install it. Then `keys-install` on the
   operator side, under their own `gh` and `glab` logins rather than the
   host's tokens: it adds each public key to its forge and retires any
   `claude-worker` key the host no longer holds. GitHub scopes that:
   `write:public_key` installs a key, `admin:public_key` also deletes
   one; on GitLab the `api` scope covers both. `keys-verify` reports the identity each forge hands back -
   a key that authenticates as the wrong account looks like success.
7. **`claude-install`**, then the operator authenticates by running
   `claude` once and completing SSO.
8. **`config-clone`** - this config repo becomes the worker's `~/.claude`,
   which makes `~/.claude/scripts/` the VM-side scripts' home. It retires
   `~/.worker-bootstrap` on the way out, so only one copy of each script
   is ever on the host.
9. **`forge-cli`** - installs `glab` and `gh`, then authenticates from
   `~/.claude/.env`. The clone brings `.env.example` but never `.env`,
   which is gitignored: the operator copies one to the other and fills
   in the tokens. Each variable's purpose and scope is in that file.
10. **`project-clone`** then **`settings`** - repositories into
   `/opt/wallarm`, then the per-project allowlist and workspace trust.

## Rebuilding

Everything is idempotent, so re-running against an existing host is safe.
To start clean, delete the instance and its two firewall rules
(`claude-worker-allow-iap`, `claude-worker-deny-public-ssh`) and run the
order above.

A rebuilt host generates a new key pair, so the old one is left valid on
both forges: access for a machine that no longer exists. `keys-install`
is what removes it, and only when run after the new keys exist.

The shared `default-allow-ssh` rule is never touched: it carries
`0.0.0.0/0` with no target tags, so every other instance in the project
depends on it.
