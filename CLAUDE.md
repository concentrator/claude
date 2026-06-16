# Global Instructions

## Session Workflow

Two modes:

- **VIBE** (default) — no skill, freestyle.
- **DEV** — spec-driven: requirements → design → initiatives → tasks →
  branch plans → commits. Entered via `/dev`; plan hierarchy and
  per-branch routine live in the `dev` skill and `~/.claude/rules/`.

Both modes strictly follow defined Git Workflow: `rules/git-workflow.md`.

Projects run via `/dev auto` declare their build/test/VCS commands as
`permissions.allow` rules in an `## Agent toolchain` section of the project
CLAUDE.md — including a VCS-host CLI (`glab`/`gh`) for the checkpoint
push + MR; the `delegating-to-agents` pre-flight reads it to prepare
agent settings deterministically. Push-permission patterns:
`skills/delegating-to-agents/toolchain.md`.

## Agent toolchain

This repo's own `/dev auto` toolchain (self-hosting: this file is also
the project CLAUDE.md). No test suite — green means SKILL.md word caps
(`wc -w`) and grep sweeps per plan item. Rules live in
`.claude/settings.local.json`: template + `Bash(gh pr create:*)`,
`Bash(git push -u origin batch/*)` carve-out (deny narrowed to
default-branch/force pushes).

## Code Comments

When you change a function's behavior, update or remove any comment that
described the old behavior. Stale comments are worse than no comments.

## Audience visibility

In user-facing writing (CHANGELOG, release notes, docs, code comments, PR
bodies), don't reference what the reader can't see: gitignored paths,
internal tickets, prior conversations, agent names.

## Structured Data / API parameters

When constructing schemas, configs, or API payloads: read the authoritative
reference first. Never approximate from memory — Claude hallucinates field
names and shapes. If there's no reference - ask for it, or suggest probing, 
don't try to guess.

## Temporary Files

Store planning artifacts in `.claude/plans/` and foundational specs
(`REQUIREMENTS.md`, `DESIGN.md`) in `.claude/` (layout:
`rules/planning.md § Where things live`). Never use `docs/` or other
project directories for these.

## Communication

- Discuss before making significant changes. Get approval before writing code.
- If the user asks a question, reply and suggest — do not take action until
  explicitly instructed.
- If your reasoning produces "the rule says X, but Y is fine here because…",
  that's rationalization. Name the conflict and ask before deviating. Written
  rules only.
