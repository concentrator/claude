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

## Steps

1. **Resolve chain.** Read task line; walk back T → R. Read
   `plans/R-XXX-<slug>/requirements.md` for acceptance criteria.
2. **Propose slug.** ≤20 chars, kebab-case, prune redundant words.
   Confirm with user.
3. **Decompose work** into commit-sized checkboxes. Each `[ ]` = one
   commit, ~2–5 minutes of focused work, naming the change in one
   sentence and the docs it touches. The task itself is right-sized
   (multi-commit) per `plan.md § Levels`; checkboxes are its
   commit-sized steps.
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

Warn past ~20 commits, split past 30 — subordinate to the short-lived
governor (`branch-plan.md § Size cap`). Override requires a stated reason.

## Bulk mode (`/dev plan all`)

One plan-writer subagent per open task lacking a plan (independent —
dispatch in parallel), each following this skill. Then a single user
review pass over all slugs + plans before delivering them (one plan MR/PR).

## Out of scope

- Per-commit implementation — the execution skill (`feat`,
  `fix`, `refactor`) handles iteration.
- Initiative / task creation — separate `/dev plan` targets.

See `branch-plan.md` for plan structure and execution
rules.
