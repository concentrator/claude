# R-055 tasks - Archive an initiative when it closes

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R055-T###`, counter scoped to this initiative).

## Open

- [x] **R055-T001 [doc]**: fix the trigger in `finish.md § 4` - the
  closure plan MR/PR opens whenever the merge closed the initiative,
  carrying the closure records when the branch did not and the
  archive move always, with the promotion check first.

- [ ] **R055-T002 [mnt]**: archive the backlog - promotion check,
  then `git mv` the R-049 and R-054 directories to `plans/archive/`,
  delivered via plan MR/PR per the fixed flow.
