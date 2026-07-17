# Writing Plans

Generate a branch plan (`.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md`)
from a task in its initiative's `tasks.md`. Invoked within the detail
round (`/dev plan R-XXX`), or per task via `/dev plan T-XXX` / `all`.

## Inputs

- Task ID (e.g. `T-014`) from the parent R's
  `.claude/plans/R-XXX-<slug>/tasks.md`
- Task tag: `[feat] | [fix] | [refactor]`
- Parent chain for context: T-XXX → R-XXX
- Project `CLAUDE.md` (build/test/lint), `.claude/DESIGN.md` (architecture)
- The changed feature's `.claude/docs/` doc, if it exists (`layout.md § Docs`)
  - plan against the current documented behavior
- Probe findings for the surfaces the task touches - wire formats,
  response envelopes, schemas established by shape/detail-round probing,
  wherever recorded (the R's `requirements.md`, `references/`, or the
  session transcript). Required whenever commit items carry wire-level
  detail.

## Steps

1. **Resolve chain.** Read task line; walk back T → R. Read
   `plans/R-XXX-<slug>/requirements.md` for acceptance criteria, and the
   changed feature's `.claude/docs/` doc (if any) for its current behavior.
2. **Propose slug.** ≤20 chars, kebab-case, prune redundant words.
   Confirm with user.
3. **Decompose work** into commit-sized checkboxes. Each `[ ]` = one
   commit, ~2–5 minutes of focused work, naming the change in one
   sentence and the docs it touches. The task itself is right-sized
   (multi-commit) per `plan.md § Levels`; checkboxes are its
   commit-sized steps. For a `[feat]` / `[fix]` task, each checkbox is
   one behavior slice carrying its test and its implementation together -
   the execution cadence commits a whole red→green→refactor pass as one
   commit (`feat.md`, `fix.md`) - so "write tests" is never its own
   commit item. A wire-level detail in a commit item (response
   envelope, field names, pagination keys, accepted shapes) cites the
   probe findings, never the repo's idiom or a `DESIGN.md` convention -
   the house shape does not predict an external surface. A wire detail
   the plan depends on with no probe behind it → probe first, then plan.
4. **Add header** per `branch-plan.md`:
   - `task: T-014`
   - `type: <inherited from task tag>`
   - `architecture-changing: true` (only if it touches design)
   - `depends-on: T-012` (if cross-task dependency)
5. **Add mandatory final commit** at the end (per branch-plan.md).
6. **Confirm with user**, then write to
   `plans/R-XXX-<slug>/T-XXX-<slug>.md` and deliver via a short-lived
   plan MR/PR (`plan.md § Where plans live in git`).

## Soft cap

Warn past ~20 commits, split past 30 - subordinate to the short-lived
governor (`branch-plan.md § Size cap`). Override requires a stated reason.

## Bulk mode (`/dev plan all`)

One plan-writer subagent per open task lacking a plan (independent -
dispatch in parallel), each following this skill. Then a single user
review pass over all slugs + plans before delivering them (one plan MR/PR).

## Out of scope

- Per-commit implementation - the execution skill (`feat`,
  `fix`, `refactor`) handles iteration.
- Initiative / task creation - separate `/dev plan` targets.

See `branch-plan.md` for plan structure and execution
rules.
