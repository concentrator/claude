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

The planner's set is `companions/planner-prompt.md § Inputs`.

## Steps

Steps 1 and 3 to 5 belong to one planner dispatched per task
(`agents/dev-planner.md`); its step 1 runs once the session has
settled step 2. The session keeps steps 2, 6 and 7 and writes no plan
text itself.

1. **Resolve chain.** Read task line; walk back T → R. Read
   `<plans>/R<NNN>-<slug>/requirements.md` for acceptance criteria, and the
   changed feature's `<docs>` doc (if any) for its current behavior.
2. **Propose slug and mode** (`git-workflow.md § Trunk` rules;
   `branch-plan.md § Modes`); confirm both with the user. The mode is
   `normal` unless the user picks `strict`. The slug names both the plan
   branch and the plan file `<plans>/R<NNN>-<slug>/<task-id>-<slug>.md`,
   so it is settled and the branch created before the dispatch, which
   names that file.
3. **Decompose work** into commit-sized checkboxes in the plan's mode
   (`branch-plan.md § Modes`). Each `[ ]` = one commit, written as what
   it delivers against the requirements, one or a few sentences, then
   `Approach:` and the suggested files and order (`branch-plan.md
   § Body`; task right-sizing: `plan.md § Levels`). Beside the plan,
   the planner writes its task report skeleton (`branch-plan.md § Task
   report`). For a `[feat]` /
   `[fix]` task, each checkbox is one behavior slice carrying its test
   and its implementation together (`feat.md`, `fix.md`), so "write
   tests" is never its own commit item. A strict plan is proven before
   it is written: the planner builds a throwaway draft in the
   scratchpad, runs it until it produces the expected result, probes
   every undocumented surface it uses, and records what worked in the
   plan. A wire-level detail (response envelope, field names,
   pagination keys) in a strict plan comes from its `## Probes`, never
   from the repo's idiom.
4. **Add header** per `branch-plan.md § Header`: `task`, `type`,
   `mode`, and `architecture-changing` / `depends-on` where they apply.
   `cold-read: passed` is written by step 6, never ahead of it.
5. **Add the mandatory final item** at the end - the completion commit
   (per `branch-plan.md § Closing routine`), then commit the plan and
   its task report together, in one commit.
6. **Cold read**, strict mode only, per
   `companions/verification-policy.md § Comprehension check`: one read
   of the plan, the docs and the code. Each gap it reports goes to the
   planner once; the plan is not read again, and the header then
   records `cold-read: passed`. The session commits that header edit on
   the plan branch. A plan whose `depends-on` names an unmerged task is
   read at its start instead.
7. **Confirm with user**, then deliver the committed plan via a
   short-lived plan MR/PR (`plan.md § Where plans live in git`).

## Soft cap

Per `branch-plan.md § Size cap` (warn/split thresholds live there).

## Bulk mode (`/dev plan all`)

The same dispatch, once per open task lacking a plan: the tasks are
independent, so the planners run in parallel on the one plan branch
the session cut for all of them. Strict plans take their read (step 6)
first; then the user reviews all slugs and plans in one pass, and they
are delivered as one plan MR/PR.

## Out of scope

- Per-commit implementation - the execution skill (`feat`,
  `fix`, `refactor`) handles iteration.
- Initiative / task creation - separate `/dev plan` targets.
