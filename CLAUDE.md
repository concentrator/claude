# Global Instructions

## Session Workflow

- **Free mode**: just start a session, no skill invoked.
- **Dev mode**: `/dev <subcommand>` for structured work (project / feature / bug / refactor / release).

## Commit Messages

Single-line, ~50 chars / 6-8 words, subject only. No semicolons joining clauses,
no body, no multi-line descriptions, no Co-Authored-By tags. Convey the WHAT,
not the HOW or rationale — the diff has those.

Examples:
- GOOD: `Fix period chrome over logo`
- GOOD: `Collapse multi-xxl into multi with dense modifier`
- BAD: `Fix period chrome shadowing the logo; anchor via .container::before`
- BAD: `Add slide--st03-multi--dense modifier toggled by tenant count for 9+ tenants`

## Branching

Never commit to `main` or `master`. Before making changes, check the current
branch; if it's the default branch, create a feature branch first.

**Exception**: initial project scaffold (first commits on a fresh repo) goes on
the default branch.

## Code Comments

When you change a function's behavior, update or remove any comment that
described the old behavior. Stale comments are worse than no comments.

## Audience visibility

In user-facing writing (CHANGELOG, release notes, docs, code comments, PR
bodies), don't reference what the reader can't see: gitignored paths,
internal tickets, prior conversations, agent names.

## Structured Data

When constructing schemas, configs, or API payloads: read the authoritative
reference first. Never approximate from memory — Claude hallucinates field
names and shapes.

## Temporary Files

Store plans, specs, and other working documents in `.claude/plans/` inside the
project directory. Never use `docs/` or other project directories for temporary
or internal files.

## Communication

- Discuss before making significant changes. Get approval before writing code.
- If the user asks a question, reply and suggest — do not take action until
  explicitly instructed.
