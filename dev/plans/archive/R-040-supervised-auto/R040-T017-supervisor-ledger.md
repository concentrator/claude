---
task: R040-T017
type: feat
depends-on: R040-T011
---

Branch: `feat/supervisor-ledger`.

Both places the rules say "ledgered" (`supervise.md § Dispatch`,
`companions/declarations.md § Supervisor bounds`) mean an entry in the
report's `## Supervisor decisions`; no file is defined. The R-020 B-002
supervisor kept one anyway, 330 KB in its session scratchpad, and that
is why a supervisor cannot take the worker's clearing rule
(`branch-plan.md § Session boundary`): clearing first destroys the
state it reasons from.

## Terms used below

- **Ledger** - `<project-dir>/dev/supervisor/<scope>.md`, beside
  `dev/session/` and ignored like it, so an append dirties nothing and
  stays on the host that runs the supervisor. One file per scope; a
  resumed supervisor on the same host opens the same file.
- **Entry** - one appended block: a timestamp, the event (dispatch,
  question, answer, prompt cleared, verify, escalation, hand-over) and
  the ids it names; written with a single `printf '%s\n' ... >>`, which
  the auto-mode classifier reads as an append, never with `Edit`, which
  rewrites the file per entry.
- **Working memory only** - a decision still lands in the report's
  `## Supervisor decisions`; the ledger is the evidence a re-brief reads,
  never a second home for a finding.

## Commits

- [x] `supervise.md` gains `## Ledger`: the three terms above, opened at
  § Resolve and appended at each § Monitor event; the two "ledgered"
  phrases cite it. `companions/report-template.md § Supervisor
  decisions` states that the ledger is its evidence, not its copy.
- [x] `branch-plan.md § Session boundary`: the supervisor's unit is the
  scope, and it clears at the unit boundary like the worker, re-briefed
  from the ledger and its hand-off note (`handoff.md` names the ledger
  path for the `supervisor` role). `companions/supervisor-runbook.md`
  Variant A and B: the supervisor opens the ledger before dispatch, one
  line each.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [x] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.

## Amendment

The home above puts runtime state in the config repo's tree, and on a
worker host that tree is a provisioned clone a re-provision wipes.
The ledger moves beside the session files instead:
`<project-dir>/dev/supervisor/<scope>.md`, in the supervisor's cwd,
host-local, ignored like `dev/session/`.

- [x] `supervise.md § Ledger` names the new path; `handoff.md`'s role
  list follows. `.gitignore` gains `/dev/supervisor/`;
  `scripts/install-dev.sh` step 7 writes that line into adopters
  beside `/dev/session/`, and `scripts/test/install-dev.test.sh`
  asserts it once and anchored.
- [x] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose and code rows: `code-reviewer`), Tier-2 compliance
  review, `bash scripts/ci/run-all.sh` green, cleanup, mark plan
  complete, commit.
