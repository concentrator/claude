# R072 tasks - Slim the per-task workflow

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R072-T###`, counter scoped to this initiative).

Draft list from the shape round; the detail round refines it.

## Open

- [x] **R072-T001 [mnt]**: size-scale the close review - the rubric
  and diff classes in `agents/code-reviewer.md`, the second-agent
  condition, the closing-routine table rows, the `delegation.md`
  line; close R-057 (T002 superseded) and tombstone R-025.

- [ ] **R072-T002 [mnt]**: merge the operator seat into the
  supervisor - `supervise.md`, `companions/supervisor-runbook.md`,
  `companions/declarations.md`: merge authority within bounds,
  direct-to-user escalation with the always-ask list, handover
  verification without local gate re-runs, the `supervised` label at
  merge.

- [x] **R072-T003 [mnt]**: proportional tests - the condition in
  `plan.md § Proportionality`, the reviewer conduct line in
  `agents/code-reviewer.md`, the close-review checklist wording.

- [ ] **R072-T004 [mnt]**: tiered verify - per commit runs lint plus
  tests scoped to the change (a project-declared fast subset; without
  one, lint only); the full suite runs once at close (`finish.md
  § 3`), CI the authority on the MR/PR; projects declare `Test (fast)`
  and `Test (full)` in `## Agent toolchain`; `branch-plan.md § Commit
  cadence`, `auto.md` and the implementer prompt aligned so subagent
  workers inherit the cadence.
