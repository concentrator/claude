---
task: R080-T008
type: mnt
depends-on: R080-T003
cold-read: passed
---

# R080-T008: planner seat

Branch: `mnt/planner-seat`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 4 and 7.

Plans get an author. The planner is a dispatched agent that writes or
updates one branch plan from the initiative's requirements, the task
line, the docs, the code and the initiative's other plans. Every other
seat reads plans; none edits their content. Vocabulary throughout is
`run.md`'s: the seat that builds an item is the implementer, never
"worker". The duty sentences this plan writes are provisional wording
until R080-T006's table exists and they cite it.

- [x] `companions/planner-prompt.md`: the dispatch template - inputs
  (the requirements, the task line, `DESIGN.md`, `README.md` and the
  docs directory, the code, the initiative's other plans, and on a
  re-dispatch the blocker's or gap's text; never a transcript or the
  planning conversation), the job (one branch plan per `write-plan.md`
  steps 1 and 3 to 5, or one change to an existing plan stated as the
  diff of items, written to the plan file named in the dispatch and
  committed on the branch the dispatcher created, never pushed), the
  exit (return for the cold read: the dispatching session runs
  `write-plan.md` step 6, a gap re-dispatches the planner with the
  gap's text, a pass records `cold-read: passed`; no seat dispatches a
  seat), and the report format with the implementer's statuses.
  `companions/verification-policy.md § Models` gains a planner row at
  `fable` under the capacity fallback that already governs the review
  rows.
- [x] `write-plan.md` and `plan.md § Adjusting existing plans`: the
  detail round dispatches one planner per task and the adjustment path
  dispatches one per change; the interactive session keeps step 2 (the
  slug, proposed before the dispatch, which names the plan file) and
  step 7 (present for the user's approval, MR/PR), creates the plan
  branch before the dispatch as `§ Bulk mode` already has it, runs the
  step 6 read on the planner's output, and writes no plan text itself.
  "The planner's exit" as the name of step 6 becomes "the dispatcher's
  read of the plan" at its four sites: `companions/verification-policy.md
  § Comprehension check`, `branch-plan.md § Header` comment and
  `§ Agentic execution`, `DESIGN.md § Decisions`.
  `§ Bulk mode` is the same dispatch in parallel; step 3 drops "or the
  session transcript" from the reader's inputs, and
  `companions/verification-policy.md § Comprehension check` drops
  "when the user is present" since the read now also runs mid-branch.
  `SKILL.md § /dev plan` `<slug>` row reads `write-plan.md`.
- [x] `run.md § Question resolution`: a question whose answer changes
  plan text - an implementer's blocker, a cold-read gap found in
  flight - halts the item, re-dispatches the planner with that text on
  the item's branch (`git-workflow.md § Trunk`), takes the **user**'s
  approval of the change under either supervisor mode, then dispatches
  a fresh implementer on the re-read plan; a seat never resumes. Every
  answer takes that route: an implementer's inputs are the plan, the
  docs and the code (`requirements.md § Desired state` 4), so an answer
  reaches the next implementer only as plan text, and the planner
  writes it there.
  `§ Dispatch per item` 2 routes NEEDS_CONTEXT there in place of "then
  re-dispatch". `branch-plan.md § Scope discoveries` (blocker) and
  `§ Stop conditions` route the plan change to that re-dispatch, Halt
  staying for an invalid premise; `§ Scope changes mid-branch`, after
  the final commit, dispatches the planner on the same branch with no
  implementer to halt, a new item then getting a fresh implementer.
  `§ Rails` says no seat but the planner edits plan content, the
  implementer keeping checkboxes and findings files;
  `git-workflow.md § Trunk` "dispatched seats stay on checkboxes and
  findings files" and `companions/implementer-prompt.md § Plan &
  Findings Files` say the same. `DESIGN.md § Git & delivery model`
  lists the planner among the seats that exist.
- [ ] `run.md`, three sites and nothing else. `§ Close` step 2: "The
  approved fixes are an implementer seat's item, the findings its
  text" becomes: the approved fixes go to the planner as one change on
  the branch (`plan.md § Adjusting existing plans`), each fix a new
  checkbox, the change approved per `§ Question resolution`, and a
  fresh implementer works them - so the step agrees with `§ Question
  resolution` and `branch-plan.md § Rails` (plan content is the
  planner's alone); the step's first sentence stays. `§ Checkpoint`,
  Halt bullet: "the resolver (§ Question resolution) resolves and the
  run resumes on the same scope" becomes "the halted item takes
  § Question resolution and the run resumes on the same scope".
  `§ Sync`: "a fresh implementer on the re-read plan" becomes "a fresh
  implementer on the plan, re-read where it changed". The file stays
  within 300 lines and 80 columns (table rows exempt).
- [ ] `write-plan.md` and `companions/planner-prompt.md`, the planning
  side of the same route. `write-plan.md`: the opening paragraph
  reflows and gains one line routing `/dev plan <slug>` to `plan.md
  § Adjusting existing plans`, since `SKILL.md § /dev plan` sends its
  `<slug>` row here; `§ Inputs` keeps the task id and the task tag as
  the session's entries (they settle step 2: the slug, the branch
  prefix, the plan file) and replaces the remaining entries with one
  line citing `companions/planner-prompt.md § Inputs` as the planner's
  set, a restated list drifting (`§ Readiness checklist`); the
  `§ Steps` lead says the planner's step 1 runs after the session
  settles step 2; step 3's ragged wrap ("or `references/`. For a" /
  "`[feat]` / `[fix]` task, each checkbox is") reflows; step 6 "The
  session commits that header edit on the plan branch itself" becomes
  "on the branch the planner committed to". The file stays within 300
  lines and 80 columns. `companions/planner-prompt.md`: the
  placeholder `<plan branch>` becomes `<branch>` at its two sites (the
  `## Inputs` Code bullet, Job 4), a mid-branch re-dispatch committing
  on the item's branch; Job 3 reads "item 1 above" for "step 1", and
  adds that a change adding a decision drops `cold-read: passed` from
  the header, the re-read re-earning it, while a change that only
  cites text already in the tree leaves it - the split `write-plan.md`
  step 6 already draws.
- [ ] The companion files that still let the runner answer a seat's
  question (the findings file's entry). `companions/supervisor-runbook.md`
  `§ Variant A` step 3 reads: the runner routes a seat's question
  through `run.md § Question resolution` - the item halts, the planner
  changes the plan, the **user** approves under either supervisor
  mode, a fresh implementer follows. `§ The loop`: the two-line
  "asking?" branch ("implementation: answer" and "design or
  unclassifiable: escalate") becomes one line, "asking? -> planner
  change, user approves, fresh implementer"; the runner box's
  "answers" becomes "routes questions". `§ Modes by seat`: the clause
  "and can always answer a seat" drops, "never blocked" standing; the
  seat table's second row reads "Planner, implementer, reviewer",
  cells unchanged. `companions/declarations.md § Supervisor bounds`: the
  grant bullet "implementation-level resolutions of worker questions
  and queued judgment calls" narrows to queued judgment calls at
  implementation level, an implementer's question taking the
  planner's change and the user's approval under either mode
  (`run.md § Question resolution`); "worker" retires for "implementer"
  at its other site ("the worker/supervisor seam").
  `companions/report-template.md § Supervisor decisions`:
  "implementation questions and queued calls resolved by the
  supervisor" becomes the queued calls the supervisor resolved and the
  plan changes the user approved. The findings file's entry goes
  `[x]`, ending "Resolved by R080-T008 item 6."
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
