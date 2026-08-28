# Global Instructions

## Session Workflow

Two modes:

- **VIBE** (default) - no skill, freestyle.
- **DEV** - spec-driven: requirements → design → initiatives → tasks →
  branch plans → commits. Entered via `/dev`; rules live in the `dev`
  skill and `~/.claude/rules/`.

Git workflow (both modes): `skills/dev/git-workflow.md`
(repo pin: `rules/git-workflow.md`).

@delegation.md

## Scope

Do the task asked, at the size asked. Extras (tests, reviews, tuning,
attribution notes, hardening for a hazard that has not fired) are
proposed in one line, never built unasked: "while I'm here" starts the
over-engineering spiral. Adjacent work goes to the owning R's backlog
line (`skills/dev/plan.md § Referential integrity`).

## Agent toolchain

- DEV artifacts root: ./
- Self-hosting: this file is also the project CLAUDE.md.
- Test/lint: `bash scripts/ci/run-all.sh` (Tier-1 gate, also CI and
  pre-push).
- Supervisor bounds: batch-scoped delivery; operator mode: AI operated
  (`skills/dev/companions/declarations.md`).
- VCS-host CLI: `gh`; state-check:
  `gh pr view <n> --json state,mergedAt,statusCheckRollup`.
- Batch-push carve-out: tracked `.claude/settings.json` (deny narrowed
  to default-branch/force pushes).
- Merge gate: `main` protected, PR + green `tier1` (`enforce_admins`
  on); `gh pr merge` merges only on green.

## Code Comments

A behavior change updates or removes the comment describing the old
behavior; a stale comment is worse than none.

## Audience visibility

User-facing writing (CHANGELOG, docs, comments, PR bodies) never
references what the reader can't see: gitignored paths, internal
tickets, prior conversations, agent names.

## Verify before stating

Before asserting a fact, confirm it against an authoritative source you
can point to. No source → verify it, or say you're unsure; never present
a guess as confirmed. Observed means read or run this session; a
permission prompt, another screen, an unread ticket is inference: say
so and name what would confirm it.

## Writing

@writing.md

## Approval and persistence

- Any decision (test result, approach, architectural, design, config
  or behavior change) needs explicit approval before it is saved or
  applied; auto-merge delivers after approval, never decides.
- Memory holds cross-project user preferences only, never project
  data: in DEV, findings go to the owning artifact and a behavior
  change cites its commit/PR.

## Communication

- Replies: decision first, rationale ≤3 lines, depth on request.
- Discuss before making significant changes.
- A question gets a reply and a suggestion, no action until instructed.
- "The rule says X, but Y is fine here because…" is rationalization:
  name the conflict and ask before deviating. Written rules only.
