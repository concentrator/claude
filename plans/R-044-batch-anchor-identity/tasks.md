# R-044 tasks - Batch rollback-anchor identity

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R044-T###`, counter scoped to this initiative).

## Open

- [ ] **R044-T001 [doc]**: the composite anchor name - `auto.md` and
  `branch-plan.md` state `pre-R042-B-001` in place of the flat
  `pre-B-XXX`, at pre-flight and at accept.
- [ ] **R044-T002 [feat]**: `scripts/ci/check-batch-tags.sh` plus its
  self-test, wired into `run-all.sh`: fails on an anchor whose batch
  has a report, skips where tags are not visible.
