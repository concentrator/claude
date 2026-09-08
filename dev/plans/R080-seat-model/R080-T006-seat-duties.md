---
task: R080-T006
type: mnt
depends-on: R080-T008
supervised: approved
---

# R080-T006: seat responsibilities per mode

Branch: `mnt/seat-duties`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 6.

One table says who does what: a row per duty - writing and updating a
plan, dispatching, answering a seat's question, clearing a permission
prompt, verifying the boundary, merging, being asked - a column per
supervisor mode, and in each cell the seat that holds it: user,
supervisor, planner, implementer, reviewer or doc writer. The duty
statements scattered across the flow, the runbook, the declarations and
the hand-off note cite the table instead of restating it.

- [ ] `run.md § Seats`: the table, with the halt rule under it - a run
  reaching a duty the table leaves unassigned halts and reports, never
  improvises. Under `Supervisor: human` the user holds every
  supervisor cell; under `Supervisor: AI` the user holds only the
  asked-of row and the supervisor the rest. The prompt-clearing cell
  reads "nobody: a prompt is a pre-flight defect" under both modes
  (`requirements.md § Desired state` 8). The reviewer seat is the
  close review's `code-reviewer` dispatch and the spec reviewer of
  `companions/spec-reviewer-prompt.md`.
- [ ] Cite from the sites that assign duties today, in the form
  `(run.md § Seats)`: `companions/declarations.md § Supervisor bounds`
  keeps the merge grant and the always-ask list and cites the table
  for who exercises them; `companions/supervisor-runbook.md § Two
  variants` re-keys its who-starts and who-clears rows by supervisor
  mode and cites, `§ Modes` keeps its permission table and its role
  sentences cite; `handoff.md`'s role lines take the seat names;
  `branch-plan.md § Session boundary` and `§ Rails`, and the `run.md`
  sections inherited from `supervise.md` (dispatch, question
  resolution, merge or ask) cite. `grep -n` over `skills/dev/` for
  the five seat names other than user finds no sentence assigning a
  duty without the citation.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
