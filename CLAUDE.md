# Global Instructions

## Session Workflow

Two modes:

- **VIBE** (default) — no skill, freestyle.
- **DEV** — spec-driven: requirements → design → initiatives → tasks →
  branch plans → commits. Entered via `/dev`; plan hierarchy and
  per-branch routine live in the `dev` skill and `~/.claude/rules/`.

Git workflow (both modes): `rules/git-workflow.md`. Agent-toolchain
declaration rule: `rules/claude-md.md`.

## Agent toolchain

Self-hosting: this file is also the project CLAUDE.md. No test suite —
green means SKILL.md word caps (`wc -w`) and grep sweeps. VCS-host CLI:
`gh`; batch-push carve-out in `.claude/settings.local.json` (deny
narrowed to default-branch/force pushes). More tools added as defined.

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

## Communication

- Discuss before making significant changes. Get approval before writing code.
- If the user asks a question, reply and suggest — do not take action until
  explicitly instructed.
- If your reasoning produces "the rule says X, but Y is fine here because…",
  that's rationalization. Name the conflict and ask before deviating. Written
  rules only.
