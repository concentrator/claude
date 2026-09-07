# R073 tasks - Planning moves to Jira

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R073-T###`, counter scoped to this initiative).

Draft list from the shape round, extended with the seat model; the
detail round refines it and adds branch plans. Order matters: the
integration surface first, the teardown last, T007 before the pilot.

## Open

- [ ] **R073-T001 [feat]**: Jira integration surface - project key(s),
  issue-type mapping, agent credentials on both seats, and the
  read/write skill the flows call (create epic/ticket, read ticket,
  comment, transition status).

- [ ] **R073-T002 [mnt]**: rewrite the planning flows - `/dev plan`
  targets produce epics and tickets; `templates.md` becomes ticket
  description shapes; approval is the user approving the epic; the
  planner's exit is a cold read of each ticket's plan with the
  worker's inputs, re-homed from `branch-plan.md § Stamps` and
  `companions/verification-policy.md § Comprehension check`.

- [ ] **R073-T003 [mnt]**: rewrite the execution flows - `/dev code
  <ticket>` pulls the ticket and injects it; `/dev auto` and
  `/dev supervise` merge into one unattended flow, the worker engine
  under a supervisor seat declared `Supervisor: human | AI`, with
  `Operator mode:` and the stamp pair retired and the worker's
  dispatch carrying the ticket, the epic's requirements, docs, and
  code only; reports and findings as ticket comments; `finish` closes
  the ticket with the MR link; branch sizing rule (one ticket, one
  branch, non-atomic commits). Depends on R072-T002.

- [ ] **R073-T007 [mnt]**: doc-writer seat - a dispatched agent that
  writes `docs/` on the worker's branch from the diff, the ticket, and
  the existing docs, exiting through
  `companions/documentation.md § Verification gate`; the implementer
  prompt drops doc targets; `branch-plan.md § Commit cadence`'s docs
  step and `layout.md § Docs` re-point to the seat.

- [ ] **R073-T004 [mnt]**: pilot task end to end under the new flow -
  cold read, worker dispatch, doc-writer pass, supervised merge; fixes
  from the pilot land on the same branch.

- [ ] **R073-T005 [mnt]**: migrate and tear down - open initiatives
  to epics with source-id manifest comments, `dev/docs/` moves to
  `docs/` with every rule naming the old path, delete `dev/plans/`
  (no tracked `dev/` remains), retire the plan CI checks and the
  archival gate, drop R071.

- [ ] **R073-T006 [mnt]**: consuming-project rollout - migration
  steps for projects on these skills, applied per project at its next
  planning round.
