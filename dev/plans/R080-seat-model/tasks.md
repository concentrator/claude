# R080 tasks - Work by seats

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R080-T###`, counter scoped to this initiative).

Draft list from the split of R073; the detail round refines it and adds
branch plans. Order matters: the docs move first so the doc writer has
one target, the pilot last.

## Open

- [ ] **R080-T001 [mnt]**: docs move - `dev/docs/` moves to `docs/`
  with every rule naming the old path (`layout.md § Docs`,
  `companions/documentation.md`, project overlays); migration steps
  for consuming projects, applied per project at its next planning
  round.

- [ ] **R080-T002 [mnt]**: cold read at the planner's exit - a fresh
  agent given the worker's inputs says what it would build; re-homed
  from `branch-plan.md § Stamps` and
  `companions/verification-policy.md § Comprehension check`; a gap is
  fixed before approval.

- [ ] **R080-T003 [mnt]**: one unattended flow - `/dev auto` and
  `/dev supervise` merge into the worker engine under a supervisor
  seat declared `Supervisor: human | AI`; `Operator mode:` and the
  stamp pair retire; a seat starts for one item and shuts down at its
  exit; the implementer's dispatch carries the plan item, the
  initiative's requirements, docs, and code only, and the reviewer's
  the plan item plus its acceptance criteria. Depends on R072-T002.

- [ ] **R080-T004 [mnt]**: doc-writer seat - a dispatched agent that
  writes `docs/` on the worker's branch from the diff, the plan item,
  and the existing docs, exiting through
  `companions/documentation.md § Verification gate`; the implementer
  prompt drops doc targets; `branch-plan.md § Commit cadence`'s docs
  step re-points to the seat.

- [ ] **R080-T005 [mnt]**: pilot task end to end under the seats -
  cold read, worker dispatch, doc-writer pass, supervised merge; fixes
  from the pilot land on the same branch.
