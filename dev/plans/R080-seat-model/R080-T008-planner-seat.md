---
task: R080-T008
type: mnt
depends-on: R080-T003
supervised: approved
---

# R080-T008: planner seat

Branch: `mnt/planner-seat`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 4 and 7.

Plans get an author. The planner is a dispatched agent that writes or
updates one branch plan from the initiative's requirements, the task
line, the docs, the code and the initiative's other plans, and exits
through the cold read. Every other seat reads plans; none edits their
content.

- [ ] `companions/planner-prompt.md`: the dispatch template - inputs
  (the requirements, the task line, `docs/`, the code, the
  initiative's other plans, and on a re-dispatch the blocker's text;
  never a transcript or the planning conversation), the job (one
  branch plan per `write-plan.md`, or one change to an existing plan,
  stated as the diff of items, written to the plan file and committed
  on the branch the dispatcher created, never pushed), the exit (the
  cold read of `write-plan.md` step 6, re-run until it passes, then
  `cold-read: passed` in the plan header), and the report format with
  the implementer's statuses.
- [ ] `write-plan.md` and `plan.md § Adjusting existing plans`: the
  detail round dispatches one planner per task and the adjustment path
  dispatches one per change; the interactive session dispatches and
  presents the result for the user's approval, it no longer writes
  plan text itself. `§ Bulk mode` is the same dispatch in parallel.
- [ ] `run.md`: a worker's blocker that needs the plan changed, or a
  cold-read gap found in flight, pauses the worker, re-dispatches the
  planner with the blocker's text, and resumes the same worker on the
  re-read plan; the change rides the worker's branch (`git-workflow.md
  § Trunk`). `branch-plan.md § Scope discoveries` (blocker), `§ Scope
  changes mid-branch` and `§ Stop conditions` route the plan change to
  that re-dispatch; `§ Rails` says no seat but the planner edits plan
  content, the implementer keeping checkboxes and findings files;
  `companions/implementer-prompt.md § Plan & Findings Files` matches.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
