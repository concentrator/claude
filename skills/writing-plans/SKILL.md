---
name: writing-plans
description: Use when generating a branch plan from a task.
---

# Writing Plans

Generate a branch plan (`.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md`)
from a task in `tasks.md`. Invoked by `/dev plan T-XXX`.

## Inputs

- Task ID (e.g. `T-014`) from `.claude/tasks.md`
- Task tag: `[feat] | [fix] | [refactor]`
- Parent chain for context: T-XXX → R-XXX → REQ-XXX
- Project `CLAUDE.md` (build/test/lint), `.claude/design.md` (architecture)

## Steps

1. **Resolve chain.** Read task line; walk back T → R → REQ. Read the
   REQ-XXX file for acceptance criteria.
2. **Propose slug.** ≤20 chars, kebab-case, prune redundant words.
   Confirm with user.
3. **Decompose work** into commit-sized checkboxes. Each `[ ]` = one
   commit, ~2–5 minutes of focused work. Each item names the change in
   one sentence and the documentation it touches.
4. **Add header** per `~/.claude/rules/branch-plan.md`:
   - `task: T-014`
   - `type: <inherited from task tag>`
   - `architecture-changing: true` (only if it touches design)
   - `depends-on: T-012` (if cross-task dependency)
5. **Add mandatory final commit** at the end (per branch-plan.md).
6. **Confirm with user**, then write to
   `plans/R-XXX-<slug>/T-XXX-<slug>.md` — create the parent R-dir if
   absent (slug from the roadmap entry subject, fixed at creation, per
   `planning.md § Directory conventions`) — and commit to `main`.

## Soft cap

If decomposition exceeds 15 commits, warn. At 20, prompt to split.
Override requires stated reason in plan header.

## Bulk mode (`/dev plan all`)

One plan-writer subagent per open task lacking a plan (independent —
dispatch in parallel), each following this skill. Then a single user
review pass over all slugs + plans before committing to main.

## Out of scope

- Per-commit implementation — the execution skill (`adding-a-feature`,
  `fixing-a-bug`, `doing-a-refactor`) handles iteration.
- Roadmap / task / requirement creation — separate `/dev plan` targets.

See `~/.claude/rules/branch-plan.md` for plan structure and execution
rules.
