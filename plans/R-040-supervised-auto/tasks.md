# R-040 tasks - Supervisor-orchestrated autonomous DEV

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R040-T###`, counter scoped to this initiative).

## Open

- [x] **R040-T001 [doc]**: capability-bounds declaration - format,
  per-project home, and the batch-scoped-delivery default; extends
  `git-workflow.md § Merge policy` with the delegation clause and its
  escalation list (releases, convention changes, red gates, off-plan
  work).
- [x] **R040-T002 [feat]**: supervisor mode (`/dev supervise` +
  `skills/dev/supervise.md`) - the operating loop: dispatch, monitor,
  boundary verification via existing gates, merge-or-escalate, sync
  reporting from artifacts. Local transport (the default); remote is
  R040-T003. `depends-on: R040-T001`
- [ ] **R040-T003 [feat]**: remote transport - `ssh <target>` worker
  sessions on the remote machine under declared permissions, plus the
  per-project `transport:` switch in the portfolio (`local` default);
  the session-lifetime decision lands here.
  `depends-on: R040-T002`
- [ ] **R040-T004 [test]**: supervised pilot, stage 1 (local) - the
  attack-checker plans/docs migration batch, planned and stamped in
  that repo, dispatched and delivered supervised on the same machine;
  exercises question resolution, the decision ledger, and the prompt
  constraint. `depends-on: R040-T005`
- [x] **R040-T005 [doc]**: the quality-acceptance amendment -
  `supervise.md` gains the question-resolution step (the supervisor
  answers a worker's implementation questions and the run continues;
  design-touching questions escalate), the implementation-vs-design
  decision split, and the decision ledger;
  `companions/declarations.md § Supervisor bounds` adds design and
  architectural decisions to the always-escalated list;
  `companions/report-template.md` gains the supervisor-decisions
  field; the worker-prompt constraint (guaranteed acceptance or
  supervisor-accepted edits) lands beside the transport rules.
- [ ] **R040-T006 [test]**: supervised pilot, stage 2 (local) - one
  real task's batch in attack-checker end to end on the same machine,
  user only at sync points; findings feed a fix round before the
  initiative closes. `depends-on: R040-T004`
