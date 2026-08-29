---
task: R040-T016
type: fix
depends-on: R040-T010
---

Branch: `fix/glab-login`.

`forge_auth` (`scripts/worker-credentials.sh § forge_auth`) exports
`GITLAB_TOKEN` and verifies with `glab api user --hostname <host>`,
which passes on a token whose instance `glab` holds no host entry for.
Every repo-relative `glab` command then fails ("None of the git remotes
configured for this repository point to a known GitLab host"), so a
worker runs a batch to completion and cannot open its MR. The dry-run
text promises a `glab auth login` the real run never performs, and the
check it does run is the one shape that cannot detect the omission.

## Terms used below

- **Host** - `GITLAB_HOST` from `~/.claude/.env` when set
  (`skills/worker-host/companions/pitfalls.md` records why a worker
  needs it), else the literal the script uses today.
- **Login** - `printf '%s' "$GITLAB_TOKEN" | glab auth login --hostname
  <host> --stdin --insecure-storage`; `--insecure-storage` because a
  headless VM has no keyring to fall back on. The token travels on
  stdin, never in argv.
- **Repo-relative check** - a `glab` call that resolves the host from
  the checkout's remote, run inside a project checkout: `glab repo view
  --output json` in `$1`, exit status only. `glab auth status` stays
  rejected for the reason the script's comment above `forge_auth`
  records.

## Commits

- [ ] `forge_auth` runs Login before its identity check and the dry-run
  text names Login and the identity check as what runs.
  `scripts/test/worker-workspace.test.sh`: a stub `glab` on `PATH`
  records its argv and stdin; the real run calls `auth login` with
  `--hostname`, `--stdin` and `--insecure-storage`, the token reaches
  stdin and never argv (the leak canary of case 23 applied to the argv
  log), and the dry run names the login.
- [ ] `forge-cli` takes an optional project checkout path and, when
  given one and `GITLAB_TOKEN` is set, runs the Repo-relative check
  there, failing with one line naming the host when it fails;
  `provision-worker.sh`'s project-clone step passes the fresh checkout.
  Test: the stub `glab` fails `repo view` and the run reports the host;
  succeeds and the run stays silent. `skills/worker-host/companions/
  provisioning.md` step 9 states the login and the in-checkout check.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (code row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
