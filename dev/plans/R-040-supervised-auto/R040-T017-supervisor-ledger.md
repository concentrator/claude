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

- **Ledger** - `~/.claude/supervisor/ledger/<project>-<scope>.md`. The
  directory is the supervisor's gitignored home beside
  `portfolio.md`, so an append dirties neither the config repo nor the
  project checkout. One file per scope; a resumed supervisor opens the
  same file.
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
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
