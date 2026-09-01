# R073 tasks - Planning moves to Jira

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R073-T###`, counter scoped to this initiative).

Draft list from the shape round; the detail round refines it. Order
matters: the integration surface first, the teardown last.

## Open

- [ ] **R073-T001 [feat]**: Jira integration surface - project key(s),
  issue-type mapping, agent credentials on both seats, and the
  read/write skill the flows call (create epic/ticket, read ticket,
  comment, transition status).

- [ ] **R073-T002 [mnt]**: rewrite the planning flows - `/dev plan`
  targets produce epics and tickets; `templates.md` becomes ticket
  description shapes; approval is the user approving the epic.

- [ ] **R073-T003 [mnt]**: rewrite the execution flows - `/dev code
  <ticket>` and the supervised dispatch pull the ticket and inject it;
  reports and findings as ticket comments; `finish` closes the ticket
  with the MR link; branch sizing rule (one ticket, one branch,
  non-atomic commits).

- [ ] **R073-T004 [mnt]**: pilot task end to end under the new flow;
  fixes from the pilot land on the same branch.

- [ ] **R073-T005 [mnt]**: migrate and tear down - open initiatives
  to epics with source-id manifest comments, `dev/docs/` moves to
  `docs/` with every rule naming the old path, delete `dev/plans/`
  (no tracked `dev/` remains), retire the plan CI checks and the
  archival gate, drop R071.

- [ ] **R073-T006 [mnt]**: consuming-project rollout - migration
  steps for projects on these skills, applied per project at its next
  planning round.
