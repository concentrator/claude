# R080 tasks - Work by seats

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R080-T###`, counter scoped to this initiative).

Order matters: the docs move first so the doc writer has one target,
the planner and the duties table after the flow, the permission
pre-flight after every seat exists, the pilot last.

## Open

- [x] **R080-T001 [mnt]**: docs move - `dev/docs/` moves to `docs/`
  with every rule naming the old path (`layout.md § Docs`,
  `companions/documentation.md`, project overlays); migration steps
  for consuming projects, applied per project at its next planning
  round.

- [x] **R080-T002 [mnt]**: cold read at the planner's exit - a fresh
  agent given the worker's inputs says what it would build; re-homed
  from `branch-plan.md § Stamps` and
  `companions/verification-policy.md § Comprehension check`; a gap is
  fixed before approval; mandatory - the plan records the passed read
  and `/dev code` and the flow refuse a plan without it.

- [ ] **R080-T003 [mnt]**: one runner - `/dev run <scope>` replaces
  `/dev code`, `/dev auto` and `/dev supervise`, and `/dev docs`
  retires: planned work runs as dispatched seats under a supervisor
  seat declared `Supervisor: human | AI`, the session never
  implementing itself; the stamp pair retires; a seat is a subagent
  of the runner started for one item and shut down at its exit; the
  implementer's dispatch carries the task's plan, docs and code only,
  and the reviewer's the plan, its acceptance criteria and the diff.
  Depends on R080-T002.

- [ ] **R080-T008 [mnt]**: planner seat - a dispatched agent that
  writes or updates one branch plan from the initiative's
  requirements, the task line, the docs, the code and the initiative's
  other plans, exiting through the cold read; the detail round and
  `plan.md § Adjusting existing plans` dispatch it, a worker's blocker
  or cold-read gap re-dispatches it with the worker paused, and no
  other seat edits plan content. Depends on R080-T003.

- [ ] **R080-T006 [mnt]**: seat responsibilities per mode - one table
  in the flow file, a row per duty - plan, dispatch, answer, clear a
  prompt, verify, merge, be asked - a column per supervisor mode and a
  seat in each cell; every duty statement in `skills/dev/` cites it; a duty
  the table leaves unassigned halts the run. Depends on R080-T003.

- [ ] **R080-T004 [mnt]**: doc-writer seat - a dispatched agent that
  writes `docs/` on the worker's branch from the diff, the plan item,
  and the existing docs, exiting through
  `companions/documentation.md § Verification gate`; the implementer
  prompt drops doc targets; `branch-plan.md § Commit cadence`'s docs
  step re-points to the seat.

- [ ] **R080-T007 [mnt]**: deterministic permission pre-flight - a
  declared permission set per seat (mode plus allow rules) derived
  from the toolchain declaration and the seat prompts; a pre-flight
  script that resolves the set against the tracked tiers, applies
  every adjustment before the first dispatch and reports every gap in
  one message, with its test; the runbook's prompt-clearing rows and
  failure modes re-read against it. Depends on R080-T004.

- [ ] **R080-T005 [mnt]**: pilot task end to end under the seats -
  pre-flight, cold read, worker dispatch, doc-writer pass, supervised
  merge, no prompt outside the declared set; fixes from the pilot land
  on the same branch. Depends on R080-T007.
