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
  docs and the code (`companions/implementer-prompt.md`), so an answer
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
- [x] `run.md`, three sites and nothing else. `§ Close` step 2: "The
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
- [x] `write-plan.md` and `companions/planner-prompt.md`, the planning
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
- [x] The companion files that still let the runner answer a seat's
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
- [x] `run.md`, `companions/implementer-prompt.md` and
  `companions/verification-policy.md § Spec-check skip`, three files:
  the concern route, one cite, the implementer's one channel and the
  second spec-check skip class. `run.md § Dispatch per item` 2 reads:
  "DONE → spec check. DONE_WITH_CONCERNS → a concern that changes plan
  text takes § Question resolution as
  NEEDS_CONTEXT does: the item's `[x]` stands and its commit goes
  unchecked; the planner's change adds a new checkbox for the redo, as
  § Close step 2 does for fixes, so the fresh implementer works the
  concern and its commit is what the spec check reads; the runner
  records `<item>: spec check skipped: superseded by plan change`,
  carried verbatim into the report's Cost section like every skip
  (`companions/verification-policy.md § Spec-check skip`). Any other
  concern the runner ledgers (§ Ledger) and carries into the report,
  then spec check. NEEDS_CONTEXT → § Question resolution. Halt
  triggers: `branch-plan.md § Stop conditions`." - "resolve first"
  names no resolver, and the runner answers no seat.
  `run.md § Ledger` cites `handoff.md § The file` where it cites
  `handoff.md § Blocks`, the block format being a bold run-in under
  that heading and no heading of its own.
  `companions/implementer-prompt.md`, three sites, the report statuses
  (DONE, DONE_WITH_CONCERNS, BLOCKED, NEEDS_CONTEXT) being the
  implementer's only channel. `## Before You Begin`'s closing line
  "**Ask them now.** Raise any concerns before starting work." reads
  "Report them as NEEDS_CONTEXT before starting work: the statuses
  under ## Report Format are your only channel." `## Your Job`'s
  closing paragraph, "**While you work:** If you encounter something
  unexpected or unclear, **ask questions**. It's always OK to pause and
  clarify. Don't guess or make assumptions.", reads "**While you
  work:** something unexpected or unclear is a NEEDS_CONTEXT report.
  Don't guess or make assumptions." `## When You're in Over Your
  Head`, the "How to escalate" run-in's last sentence, "The runner can
  provide more context, re-dispatch with a more capable model, or break
  the task into smaller pieces", becomes: "The runner routes it through
  `run.md § Question resolution`: a planner changes the plan, the user
  approves the change and a fresh implementer works the re-read plan;
  no answer reaches you directly, since your inputs are the plan, the
  docs and the code." `companions/verification-policy.md § Spec-check
  skip` opens with two skip classes - a commit classified mechanical
  (the predicate above it, guard not voided), and a commit superseded
  by a plan change (`run.md § Dispatch per item` 2) - and its
  recording rule covers both record forms, `…: mechanical` and
  `…: superseded by plan change`; the section's scope and drift
  paragraphs stay. Three files, so the item takes a spec check.
  `run.md` grows by the concern clause and stays within 300 lines and
  80 columns.
- [x] `run.md § Question resolution`, `§ Resolve` and `§ Checkpoint`,
  the halted item's tree, the re-read and the rejection path.
  `§ Question resolution`, first paragraph: the halt reverts the
  item's uncommitted edits - `git checkout -- .` and removal of the
  untracked files the seat created - so the branch stands at its last
  commit before the planner is dispatched; the planner commits its
  change locally (nothing is pushed until the runner delivers), and a
  planner reporting DONE_WITH_CONCERNS (`companions/planner-prompt.md
  § Report Format`) has committed too, so its change takes the read
  below as DONE's does and its concern reaches the user with the
  change for approval; the runner then runs `write-plan.md` step 6 on
  the changed plan, the reader a dispatched seat
  (`companions/verification-policy.md § Comprehension check`), never
  the runner's own read; where the change dropped `cold-read: passed`
  - a change adding a decision, `companions/planner-prompt.md` Job 3 -
  the pass is recorded in the runner's own bookkeeping commit on the
  item's branch, while a change that only cites text already in the
  tree keeps the record and needs no commit; the change is the
  **user**'s to approve under either supervisor mode; a rejection
  re-dispatches the planner with the objection's text, and the next
  planner commit replaces the text - no revert, and the runner edits no
  plan content; only then is a fresh implementer dispatched, starting
  from the last commit. "The runner reads the changed plan" drops, the
  read being the reader seat's.
  Second paragraph: "The re-dispatch carries the blocker's or the
  gap's text" reads "The re-dispatch carries the blocker's, the
  concern's, the cold-read gap's or the user's objection text", the
  same list `companions/planner-prompt.md § Inputs` carries (item 11).
  `§ Resolve` 1 adds, after
  "a plan whose `depends-on` is unmerged the same": the check runs at
  every implementer dispatch, not at scope start alone - the reader
  seat's dispatch is not one, its read being what earns the record -
  so a plan changed mid-branch is admitted again once the record
  stands, kept through a cite-only change or restored by the
  bookkeeping commit (§ Question resolution). `§ Checkpoint`, the Halt
  bullet reads: "**Halt** → failed item reported. A question halt - an
  implementer's plan-changing concern, NEEDS_CONTEXT or an absorbable
  blocker (`branch-plan.md § Scope discoveries`) - takes § Question
  resolution, whose revert drops the item's uncommitted edits; any
  other halt - a red tier, a spec check rejecting twice
  (`branch-plan.md § Stop conditions`) - keeps the work intact. The
  run resumes on the same scope." The file grows by these sentences
  and stays within 300 lines and 80 columns (table rows exempt).
- [x] `branch-plan.md § Stop conditions` and `§ Scope discoveries`.
  The table's first row event reads "Blocker the plan can absorb
  (§ Scope discoveries), or an implementer's NEEDS_CONTEXT", action
  unchanged: every NEEDS_CONTEXT takes the planner re-dispatch, none
  is the runner's to answer from `requirements.md` or the design. The
  row "NEEDS_CONTEXT unanswerable from the R's `requirements.md`/design
  | Halt, report" becomes "Planner reports BLOCKED or NEEDS_CONTEXT on
  its re-dispatch | Halt, report"; the planner's DONE_WITH_CONCERNS
  gets no row, `run.md § Question resolution` (item 8) reading its
  committed change and putting the concern before the user with it.
  `§ Scope discoveries`, the **Stop** bullet's second sentence reads:
  "A blocker the plan can absorb - an ambiguous item, a missing step -
  halts the item: the runner reverts its uncommitted edits and
  re-dispatches the planner with the blocker's text (`run.md
  § Question resolution`), and the fresh implementer starts from the
  last commit." The rest of the bullet stays. The file stays within 80
  columns (table rows exempt).
- [x] `companions/declarations.md § Supervisor bounds` and
  `companions/supervisor-runbook.md`, what the user approves under
  either mode. `declarations.md`, the two mode sentences and the one
  after them: "`Supervisor: human` - the user's own interactive session
  holds the seat: it dispatches the seats, and the user answers their
  questions, clears what stops them and merges." reads: "... it
  dispatches the seats, and the user approves the planner's changes
  (`run.md § Question resolution`), clears what stops them and
  merges." "`Supervisor: AI` - a supervising session dispatches,
  answers and merges within the bounds below, and the user gets the
  always-ask list only." reads "`Supervisor: AI` - a supervising
  session dispatches, verifies and merges within the bounds below, and
  the user approves plan changes and answers the always-ask list.",
  mirroring `run.md`'s opening paragraph; "That list reaches the user
  under either." reads "Both reach the user under either." Nothing
  else in the section changes. `supervisor-runbook.md`, three sites:
  the `§ Two variants` table row "Where the user answers" reads "Where
  the user approves", cells unchanged; `§ The loop`'s two mode lines
  above the runner box become four, the `|` column unmoved and each
  within 80 columns:
  `|  Supervisor: human - approves plan changes, answers the`,
  `|                      always-ask escalations, clears, merges`,
  `|  Supervisor: AI    - approves plan changes, answers the`,
  `|                      always-ask escalations only`;
  `§ Variant B` step 6 "**User** answers the always-ask escalations -
  over `SendMessage`" reads "**User** approves plan changes and answers
  the always-ask escalations - over `SendMessage`", the rest of the
  step staying.
- [x] `companions/planner-prompt.md`, the rejection path. The opening
  paragraph's "whenever a blocker or a cold-read gap needs plan text
  changed" reads "whenever a blocker, an implementer's plan-changing
  concern, a cold-read gap or the user's rejection of a change needs
  plan text changed". The `## Inputs` re-dispatch bullet reads
  "<Re-dispatch only: the blocker's, the concern's, the cold-read
  gap's or the user's objection text, verbatim.>", the list `run.md
  § Question resolution` carries (item 8). Job 4
  gains, after "Never push: delivery is the dispatcher's.": "Your
  commit stands whether or not the user approves the change: nothing
  is pushed until the runner delivers, a rejection re-dispatches a
  planner with the objection's text, and that planner's commit
  replaces the text - no revert, and no other seat edits plan
  content." The `## Exit` paragraph adds, after "a gap re-dispatches a
  planner with the gap's text", ", the user's rejection one with the
  objection's text".
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
