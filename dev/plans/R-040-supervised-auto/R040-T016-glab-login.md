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
  <host> --stdin`. The token travels on stdin, never in argv. Storage is
  the default config file: `glab` offers a keyring only as opt-in
  (`--use-keyring`), and a headless VM has none.
- **Repo-relative check** - a `glab` call that resolves the host from
  the checkout's remote, run inside a project checkout: `glab repo view
  --output json` in `$1`, exit status only. `glab auth status` stays
  rejected for the reason the script's comment above `forge_auth`
  records.

## Commits

- [x] `forge_auth` runs Login before its identity check and the dry-run
  text names Login and the identity check as what runs.
  `scripts/test/worker-workspace.test.sh`: a stub `glab` on `PATH`
  records its argv and stdin; the real run calls `auth login` with
  `--hostname` and `--stdin`, the token reaches stdin and never argv
  (the leak canary of case 23 applied to the argv log), and the dry run
  names the login.
- [x] `forge-cli` takes an optional project checkout path and, when
  given one and `GITLAB_TOKEN` is set, runs the Repo-relative check
  there, failing with one line naming the host when it fails.
  `project_clone` (`scripts/worker-workspace.sh`) ends by running
  `worker-credentials.sh forge-cli <fresh checkout>`: the checkout is
  born there, after `forge-cli`'s own step in the provisioning order,
  and the install and login it repeats are idempotent.
  Test: the stub `glab` fails `repo view` and the run reports the host;
  succeeds and the run stays silent; `project-clone --dry-run` names
  the check. `skills/worker-host/companions/provisioning.md` step 9
  states the login, step 10 the in-checkout check.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (code row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
