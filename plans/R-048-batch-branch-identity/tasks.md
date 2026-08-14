# R-048 tasks - Batch branch identity

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R048-T###`, counter scoped to this initiative).

## Open

- [ ] **R048-T001 [doc]**: the composite branch form and lifecycle
  rail - `auto.md`, `branch-plan.md § Batches` and `§ Rails`,
  `companions/toolchain.md`, `companions/report-template.md`,
  `git-workflow.md § Trunk`, `agents/code-reviewer.md`, `DESIGN.md`,
  and foundational `REQUIREMENTS.md` state `batch/R<NNN>-B-<MMM>` in
  place of the flat form, plus the delete-after-merge rail.
- [ ] **R048-T002 [feat]**: the gate covers branch refs -
  `check-batch-tags.sh` fails a `batch/*` ref whose report is on the
  trunk and any flat or malformed `batch/*` ref as unresolvable, with
  test cases; the live `batch/B-001` is renamed to `batch/R042-B-001`
  when the gate lands (local ref action, no commit).
