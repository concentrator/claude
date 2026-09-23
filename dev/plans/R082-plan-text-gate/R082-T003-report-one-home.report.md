# R082-T003 report

## Implementer
### Divergences
- Item 5: no gate change. `check-plan-text.sh` already fails a plan
  item over 6 lines, and a report checkbox without `Evidence:`, so the
  `## Planner` form uses headings and plain bullets, no checkboxes.
- Item 5: `branch-plan.md § Task report` also names `## Planner`, so the
  skeleton rule and the strict form agree.
- Item 6: `branch-plan.md § Task report` gains the `## Answers` form,
  so the section the runner writes has one stated shape; the skeleton
  stays as is and the runner adds the heading with its first answer.
- Item 6: `dev-implementer.md § When You're in Over Your Head` and the
  runbook's loop diagram also said the answer goes into the plan, so
  they now name the report too.

## Review
- [ ] The gate fails a plan whose legacy findings file is its report
  (Important) - scripts/ci/check-plan-text.sh:104
  Evidence: observed `plan without task report`, exit 1, for a plan
  beside its `.findings.md` in a throwaway repo
- [ ] Scope changes mid-branch adds plan checkboxes during a run
  (Important) - skills/dev/branch-plan.md:167
  Evidence: contract branch-plan.md § Plan edits, run.md § Question resolution
- [ ] A redo `## Review` entry has no stated form or `Evidence:` line
  (Important) - skills/dev/run.md:97
  Evidence: contract branch-plan.md § Task report, the gate's evidence check
- [ ] migrate.md puts a convention statement in each tasks.md header
  (Important) - skills/dev/migrate.md:31
  Evidence: contract templates.md § Per-initiative tasks.md
- [ ] TODOs route to a plan commit or tasks.md, not the task report
  (Suggestion) - skills/dev/branch-plan.md:100
  Evidence: contract requirements.md outcome 3
- [ ] Closing routine writes `## Review` findings after the fixes apply
  (Suggestion) - skills/dev/branch-plan.md, Closing routine steps 4 and 6
  Evidence: contract run.md § Close 2
- [ ] A step-4 line over 100 characters (Suggestion) - agents/dev-planner.md
  Evidence: observed the line's length against the file's ~72 wrap
