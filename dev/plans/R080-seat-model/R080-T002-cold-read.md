---
task: R080-T002
type: mnt
---

# R080-T002: cold read at the planner's exit

Branch: `mnt/cold-read`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 2.

The cold read leaves the stamps and becomes the last step of writing a
branch plan: a fresh agent given the worker's inputs says what it would
build, and a question those inputs cannot answer is fixed before the
plan is offered for approval. It is mandatory: the plan records that
the read passed, and nothing dispatches a plan without the record.
Runs before T003 so the check has a home before the stamps retire.

- [ ] `write-plan.md`: a new step between the final item and the
  confirm - dispatch a fresh subagent with the commit-item texts plus
  parent-chain context, never the plan file or the planning
  conversation; it reports what it would build and what is ambiguous
  or assumed; each gap is fixed in the plan and the read re-run until
  it reports none, and the plan header then records `cold-read:
  passed`. `§ Bulk mode` runs it per plan; a plan is never offered for
  approval without the record.
- [ ] `companions/verification-policy.md § Comprehension check`: the
  section describes the planner's exit and cites `write-plan.md`; the
  readiness-review framing and `branch-plan.md § Stamps` reference
  go; `branch-plan.md § Stamps` cites the exit in place of its own
  cold-reader clause, and `plan.md § Approval and closure` says a
  detail round is offered for approval only with every plan's read
  passed.
- [ ] Refuse the unread plan: `branch-plan.md § Header` documents
  `cold-read: passed`; `SKILL.md § /dev code`'s plan verification and
  `supervise.md § Resolve`'s NOT READY rule both refuse a plan without
  it, naming the missing record; `auto.md § Pre-flight` the same for
  a batch member. T003 carries the refusal into `run.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
