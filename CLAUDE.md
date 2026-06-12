# Global Instructions

## Session Workflow

Two modes:

- **VIBE** (default) — no skill, freestyle. Commit-message style below
  still applies.
- **DEV** — spec-driven: requirements → design → initiatives → tasks →
  branch plans → commits. Entered explicitly via `/dev`. Branching, plan
  hierarchy, and per-branch routine live in the `dev` skill and
  `~/.claude/rules/`.

Projects run via `/dev auto` declare their build/test/VCS commands as
`permissions.allow` rules in an `## Agent toolchain` section of the project
CLAUDE.md — including a VCS-host CLI (`glab`/`gh`) for the checkpoint
push + MR; the `delegating-to-agents` pre-flight reads it to prepare
agent settings deterministically. Push-permission patterns:
`skills/delegating-to-agents/toolchain.md`.

## Commit Messages

Single-line, ~50 chars / 6-8 words, subject only. No semicolons joining clauses,
no body, no multi-line descriptions, no Co-Authored-By tags. Convey the WHAT,
not the HOW or rationale — the diff has those.

Examples:
- GOOD: `Fix period chrome over logo`
- GOOD: `Collapse multi-xxl into multi with dense modifier`
- BAD: `Fix period chrome shadowing the logo; anchor via .container::before`
- BAD: `Add slide--st03-multi--dense modifier toggled by tenant count for 9+ tenants`

## MR / PR Messages

Unlike commits, an MR carries a body. **Title**: commit-subject style
(imperative, ~50 chars, WHAT not how). **Body**: a short summary (what
changed and why — prose or bullets) and a test plan (what was run, or
how to verify). Scannable, not a wall of text.

- No agent attribution, "Generated with…", or Co-Authored-By trailers.
- Per Audience visibility below: no gitignored paths, internal ticket
  IDs, or references to this conversation. Link issues only if the
  reader can open them.

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
