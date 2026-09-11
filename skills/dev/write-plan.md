# Writing Plans

Generate a branch plan (`<plans>/R<NNN>-<slug>/<task-id>-<slug>.md`)
from a task in its initiative's `tasks.md`. Invoked within the detail
round (`/dev plan R<NNN>`), or per task via `/dev plan <task-id>` /
`all`. `/dev plan <slug>` adjusts a plan that already exists, which is
`plan.md § Adjusting existing plans`.

## Inputs

The session's own, which settle step 2 - the slug, the branch prefix
and the plan file:

- Task ID (e.g. `R008-T001`; legacy `T-014`) from the parent R's
  `<plans>/R<NNN>-<slug>/tasks.md`
- Task tag: `[feat] | [fix] | [refactor] | [doc] | [test] | [mnt]`

The planner's set is `companions/planner-prompt.md § Inputs`; restating
it here would drift from it (`§ Readiness checklist`).

## Steps

Steps 1 and 3 to 5 belong to one planner dispatched per task
(`agents/dev-planner.md`); its step 1 runs once the session has
settled step 2. The session keeps steps 2, 6 and 7 and writes no plan
text itself.

1. **Resolve chain.** Read task line; walk back T → R. Read
   `<plans>/R<NNN>-<slug>/requirements.md` for acceptance criteria, and the
   changed feature's `<docs>` doc (if any) for its current behavior.
2. **Propose slug** (`git-workflow.md § Trunk` rules); confirm with
   user. The slug names both the plan branch and the plan file
   `<plans>/R<NNN>-<slug>/<task-id>-<slug>.md`, so it is settled and
   the branch created before the dispatch, which names that file.
3. **Decompose work** into commit-sized checkboxes. Each `[ ]` = one
   commit, ~2–5 minutes of focused work, written as its acceptance -
   what it delivers against the requirements, one or a few sentences -
   then `Approach:` and the files, sentences and order
   (`branch-plan.md § Body`; task right-sizing: `plan.md § Levels`).
   Probe findings live in the R's `requirements.md`
   or `references/`. For a `[feat]` / `[fix]` task, each checkbox is one
   behavior slice carrying its test and its implementation together - the
   execution cadence commits a whole red→green→refactor pass as one
   commit (`feat.md`, `fix.md`) - so "write tests" is never its own
   commit item. A wire-level detail in a commit item (response envelope,
   field names, pagination keys, accepted shapes) cites the probe
   findings, never the repo's idiom or a `DESIGN.md` convention - the
   house shape does not predict an external surface. A wire detail the
   plan depends on with no probe behind it → probe first, then plan.
   Apply `§ Readiness checklist` to every item.
4. **Add header** per `branch-plan.md`:
   - `task: R008-T002`
   - `type: <inherited from task tag>`
   - `architecture-changing: true` (only if it touches design)
   - `depends-on: R008-T001` (if cross-task dependency)
   - `cold-read: passed` is written by step 6, never ahead of it
5. **Add the mandatory final item** at the end - the completion commit
   (per `branch-plan.md § Closing routine`).
6. **Cold read** of the planner's output per
   `companions/verification-policy.md § Comprehension check`, the reader given
   the plan, the docs and the code: each gap it reports re-dispatches a planner
   with the gap's text (`plan.md § Adjusting existing plans`); the reader tests
   the acceptance and the initial approach, so an acceptance fix that adds a
   decision re-runs the read, an acceptance fix that cites text already in the
   tree does not, and an approach gap is fixed once and re-runs no read
   (`run.md § Seats`). Two bounds: the first read covers the whole plan, a
   later one only the items the planner changed and the lines the previous
   read's gaps named; and the second read is the last - an acceptance gap it
   still reports goes to `<task-id>-<slug>.findings.md` beside the plan
   (created if absent) as a note the implementer reads, one bullet per gap
   with its text, and no planner is re-dispatched. A planner change made
   after the pass is recorded starts a count of its own, scoped to what it
   changed. When the read reports none, or at the second read, the header
   records `cold-read: passed`. The session commits that header edit and the
   notes on the branch the planner committed to - the record is bookkeeping,
   not plan text. A plan whose `depends-on` names an unmerged task is read at
   its start instead, when its targets exist,
   and carries no record until then.
7. **Confirm with user**, then deliver the committed plan via a
   short-lived plan MR/PR (`plan.md § Where plans live in git`).

## Readiness checklist

Applied while decomposing (step 3), before the read, so the read
confirms rather than discovers. Each entry is a gap class cold reads
have found:

- **Targets exist.** An item names only files and sections on the tree
  at branch start, or names the task that creates them.
- **Decisions are homed.** Every choice an item implies is stated in it
  or cited to the requirement point that makes it; no decision is left
  to the implementer, and no item closes an open question without the
  answer.
- **Casualties are listed.** Grep the tree for every rule sentence the
  change invalidates and name each; "among others" is a gap.
- **Requirements are cited, not paraphrased.** A restated input list or
  invariant drifts; cite the point.
- **Terms have one reading.** A word with two meanings in the tree
  (mode: permission or supervisor) is qualified every time.
- **Mechanisms are probed.** An item resting on host behavior (what a
  subagent inherits, what a setting scopes) cites a probe, as a wire
  detail does.
- **Order is declared.** `depends-on` names every task whose output
  the items cite or retire.
- **Design is not an item.** An item that creates or merges a skill
  carries the file's section outline; "merge A, B and C into D" is a
  design task, not a commit.

## Soft cap

Per `branch-plan.md § Size cap` (warn/split thresholds live there).

## Bulk mode (`/dev plan all`)

The same dispatch, once per open task lacking a plan: the tasks are
independent, so the planners run in parallel on the one plan branch
the session cut for all of them. The session reads each plan (step 6),
and the single user review pass over all slugs + plans opens only when
every plan carries `cold-read: passed`; then deliver them (one plan
MR/PR).

## Out of scope

- Per-commit implementation - the execution skill (`feat`,
  `fix`, `refactor`) handles iteration.
- Initiative / task creation - separate `/dev plan` targets.
