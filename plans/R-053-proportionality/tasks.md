# R-053 tasks - Proportional engineering

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R053-T###`, counter scoped to this initiative).

## Open

- [x] **R053-T001 [doc]**: the proportionality rule - a short section
  in `plan.md`, and a one-line hook in `brainstorm.md § Rules` so every
  shape round applies it.
- [x] **R053-T002 [mnt]**: delete `scripts/test/check-no-em-dash.test.sh`
  and `scripts/test/check-code-size.test.sh`; reconcile
  `scripts/test/run-all.sh` and any installer references.
- [ ] **R053-T003 [mnt]**: shrink the two meta-depth tests:
  `isolation.test.sh` to the static scrub sweep plus one canary per
  invocation path, `context-cost.test.sh` minus the mutant cases. The
  four check tests keep their current cases - each already has a
  passing and a biting case, and resizing working tests is the churn
  the proportionality rule argues against. `depends-on: R053-T002`
