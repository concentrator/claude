# R086 tasks - Agent contracts

Why: agents repeat convention breaches and docs carry stale claims, because rules are scattered and evidence goes stale in old reports.

## Open

- [x] **R086-T001 [mnt]**: Make a new convention bind only what is created
  after it, and have the gates check only what a branch adds.

- [x] **R086-T002 [mnt]**: Give each seat one contract of inputs, steps and
  outputs, and narrow the global instructions to what every seat needs.

- [x] **R086-T003 [feat]**: List each doc claim and its evidence in the plan,
  have the implementer fill the planner's report, and scope docs to what exists.

- [x] **R086-T004 [mnt]**: Fail a checkbox in a requirements file a branch
  adds, and run the code-size gate in an installed project's fast tier.

- [x] **R086-T005 [fix]**: Skip registering a project hook the global
  settings already run.

- [ ] **R086-T006 [mnt]**: Branch before the first edit, and sync the default
  branch without switching onto a dirty tree.

- The implementer prompt says which instructions are in context; it should give only its own context.
- The code-comments rule lives in the global instructions; the implementer needs it in its prompt.
- About a third of the planner prompt is its shell-config section.
- This repo declares a docs path that holds no docs.
- Find where git workflow rules are restated outside the git workflow file.
- The docs gate verifies a whole doc, though older text changes only on request.
- The planner's contract has no input for the user's decisions on a plan change.
