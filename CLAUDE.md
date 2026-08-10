# Global Instructions

## Session Workflow

Two modes:

- **VIBE** (default) - no skill, freestyle.
- **DEV** - spec-driven: requirements → design → initiatives → tasks →
  branch plans → commits. Entered via `/dev`; plan hierarchy and
  per-branch routine live in the `dev` skill and `~/.claude/rules/`.

Git workflow (both modes): `skills/dev/git-workflow.md`
(repo pin: `rules/git-workflow.md`).

Delivery cadence: one branch = one coherent unit, not a per-edit PR
(`git-workflow.md § Delivery cadence`).

@delegation.md

## Agent toolchain

- DEV artifacts root: .

Self-hosting: this file is also the project CLAUDE.md. Test/lint:
`bash scripts/ci/run-all.sh` (the Tier-1 gate), also run by CI on PRs and the
`.githooks/pre-push` hook. Supervisor bounds: batch-scoped delivery
(`skills/dev/companions/toolchain.md § Supervisor bounds`).
VCS-host CLI: `gh`; state-check:
`gh pr view <n> --json state,mergedAt,statusCheckRollup`; batch-push carve-out in
`.claude/settings.local.json` (deny narrowed to default-branch/force
pushes). Merge gate: `main` is protected - a PR + a green `tier1` check
required (`enforce_admins` on), so `gh pr merge` merges only on green.

## Code Comments

When you change a function's behavior, update or remove any comment that
described the old behavior. Stale comments are worse than no comments.

## Audience visibility

In user-facing writing (CHANGELOG, release notes, docs, code comments, PR
bodies), don't reference what the reader can't see: gitignored paths,
internal tickets, prior conversations, agent names.

## Verify before stating

Before asserting a fact, confirm it against an authoritative source you
can point to. No source → verify it, or say you're unsure; never present
a guess as confirmed. Schemas, configs, API shapes: read the reference
first.

## Writing

@writing.md

## Approval and persistence

- Any conclusion or decision (test result or approach; architectural,
  design, config, or behavior change) needs explicit approval before it
  is saved or applied. Auto-merge automates delivery after approval,
  never the decision.
- Memory holds no project data - that belongs in project docs. In DEV,
  write no memories: record findings in the right artifact; a behavior
  change cites the repo update (commit/PR). VIBE: cross-project user
  preferences only.

## Communication

- Replies: decision first, rationale ≤3 lines, depth on request.
- Discuss before making significant changes. Get approval before writing code.
- If the user asks a question, reply and suggest - do not take action until
  explicitly instructed.
- If your reasoning produces "the rule says X, but Y is fine here because…",
  that's rationalization. Name the conflict and ask before deviating. Written
  rules only.
