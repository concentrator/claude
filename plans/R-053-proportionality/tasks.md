# R-053 tasks - Proportional engineering

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R053-T###`, counter scoped to this initiative).

## Open

- [x] **R053-T001 [doc]**: the proportionality rule - a short section
  in `plan.md`, and a one-line hook in `brainstorm.md § Rules` so every
  shape round applies it.
- [ ] **R053-T002 [mnt]**: delete `scripts/test/check-no-em-dash.test.sh`
  and `scripts/test/check-code-size.test.sh`; reconcile
  `scripts/test/run-all.sh` and any installer references.
- [ ] **R053-T003 [mnt]**: shrink the meta tests to the
  one-pass/one-bite standard: `isolation.test.sh` to the static scrub
  sweep plus one canary per invocation path, `context-cost.test.sh`
  minus the mutant cases, the plan-integrity, batch-tags, accretion and
  settings tests to representative cases; reconcile
  `install-dev.test.sh`. `depends-on: R053-T002`
