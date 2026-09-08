---
task: R080-T006
type: mnt
depends-on: R080-T008
---

# R080-T006: seat responsibilities per mode

Branch: `mnt/seat-duties`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 6.

One table says who does what: a row per seat - user, supervisor,
planner, implementer, reviewer, doc writer - under each supervisor mode,
for writing and updating a plan, dispatching, answering a seat's
question, clearing a permission prompt, verifying the boundary,
merging, and being asked. The duty
statements scattered across the flow, the runbook, the declarations and
the hand-off note cite the table instead of restating it.

- [ ] `run.md § Seats`: the table, with the halt rule under it - a run
  reaching a duty the table leaves unassigned halts and reports, never
  improvises. Under `Supervisor: human` the user holds every
  supervisor cell; under `Supervisor: AI` the user holds only the
  asked-of column and the supervisor the rest.
- [ ] Cite from the sites that assign duties today:
  `companions/declarations.md § Supervisor bounds` (merge, the
  always-ask list), `companions/supervisor-runbook.md § Two variants`
  (who starts, who clears) and `§ Modes`, `handoff.md`'s role lines,
  `branch-plan.md § Session boundary` and `§ Rails`; each keeps its
  own rule and drops the duty restatement. `grep -n` over `skills/dev/`
  for the six seat names finds no duty sentence without the citation.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
