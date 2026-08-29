# Global Instructions

## Session Workflow

Two modes:

- **VIBE** (default) - no skill, freestyle.
- **DEV** - spec-driven: requirements → design → initiatives → tasks →
  branch plans → commits. Entered via `/dev`.

Git workflow (both modes): `skills/dev/git-workflow.md`; host GitHub, so
MR/PR resolves to PR.

Subagents are pre-authorised for genuinely wide searches (many files,
only the conclusion wanted), never for a fan-out one `grep` answers.

## Scope

Do the task asked, at the size asked. Extras (tests, reviews, tuning,
hardening for a hazard that has not fired) are proposed in one line,
never built unasked. Adjacent work goes to the owning R's backlog
line (`skills/dev/plan.md § Referential integrity`).

## Agent toolchain

- Test/lint: `bash scripts/ci/run-all.sh` (Tier-1 gate, also CI and
  pre-push).
- Supervisor bounds: batch-scoped delivery; operator mode: AI operated
  (`skills/dev/companions/declarations.md`).
- VCS-host CLI: `gh`; state-check:
  `gh pr view <n> --json state,mergedAt,statusCheckRollup`.
- Merge gate: PR + green `tier1` on protected `main`.

## Code Comments

A behavior change updates or removes the comment describing the old
behavior; a stale comment is worse than none.
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
