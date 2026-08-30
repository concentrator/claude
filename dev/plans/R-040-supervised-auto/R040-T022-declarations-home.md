---
task: R040-T022
type: refactor
depends-on: R040-T018
---

Branch: `refactor/declarations-home`.

`companions/toolchain.md` defines `CLAUDE.md § Agent toolchain` as the
build, test and VCS declarations; the supervisor's `Supervisor bounds`
and `Operator mode` lines sit in the same section because that was the
one declaration home when R040-T001 wrote them. They are a different
concern with their own companion (`companions/declarations.md`), and a
reader of § Agent toolchain meets merge authority among lint commands.

## Commits

- [x] `CLAUDE.md`: the two lines move to a `## Supervision` section
  directly after § Agent toolchain, within the 100-line hold;
  `companions/declarations.md § Supervisor bounds` and `§ Operator
  modes` name that section as the home, `supervise.md § Resolve` step 2
  and `companions/supervisor-runbook.md` read it from there, and the
  R040-T018 declaration carve-out names it. `rules/claude-md.md`
  changes only if it lists the sections a `CLAUDE.md` holds.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [x] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
