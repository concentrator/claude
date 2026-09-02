# Global Instructions

## Session Workflow

Two modes:

- **VIBE** (default) - no skill, freestyle.
- **DEV** - spec-driven: requirements → design → initiatives → tasks →
  branch plans → commits. Entered via `/dev`.

Git workflow (both modes): `skills/dev/git-workflow.md`.

Subagents are pre-authorised for wide searches (many files, conclusion
only), never for a fan-out one `grep` answers or whose token cost the
task does not justify.

## Scope

Do the task asked, at the size asked. Extras (tests, reviews, tuning,
hardening for a hazard that has not fired) are proposed in one line,
never built unasked. Adjacent work goes to the owning R's backlog
line (`skills/dev/plan.md § Referential integrity`).

## Agent toolchain

This repository's declarations; a project's own `## Agent toolchain`
wins.

- Test (fast) + lint: `bash scripts/ci/run-all.sh`
- Test (full): fast, then `bash scripts/test/run-all.sh`
- VCS host: GitHub, CLI `gh` (MR/PR resolves to PR)
- Change request: `gh pr create`
- State-check: `gh pr view <n> --json state,mergedAt,statusCheckRollup`
- Merge: `gh pr merge <n> --merge --delete-branch`

## Supervision

This repository's own declarations; they never stand in for a
project's missing `## Supervision`.

- Supervisor bounds: batch-scoped delivery
- Operator mode: AI operated (`skills/dev/companions/declarations.md`)

## Code Comments

A comment explains what the code cannot show: the reason behind a
non-obvious choice, a constraint, a workaround. Code says what it does;
a comment never restates it. A behavior change updates or removes the
comment describing the old behavior; a stale comment is worse than none.
Code and data files carry no history or annotation fields
(`rules/writing-artifacts.md § One home per finding`).

## Audience visibility

User-facing writing (CHANGELOG, docs, comments, PR bodies) never
references what the reader can't see: gitignored paths, internal
tickets, prior conversations, agent names.

## Verify before stating

Before asserting a fact, confirm it against a source you can point to;
otherwise verify it or say you're unsure. Observed means read or run this session; a
permission prompt, another screen, an unread ticket is inference: say
so and name what would confirm it.

## Writing

@writing.md

Commit and MR/PR text cites work by durable id, never a bare hash
(`rules/writing-artifacts.md § Name things by their durable id`).

## Approval and persistence

- Any decision (test result, approach, design, config or behavior
  change) needs explicit approval before it is saved or applied;
  auto-merge delivers, never decides.
- Memory holds cross-project user preferences only, never project
  data: in DEV, findings go to the owning artifact and a behavior
  change cites its commit/PR.

## Communication

- Replies: decision first, rationale ≤3 lines, depth on request.
- Discuss before making significant changes.
- A question gets a reply and a suggestion, no action until instructed.
- "The rule says X, but Y is fine here because…" is rationalization:
  name the conflict and ask. Written rules only.
