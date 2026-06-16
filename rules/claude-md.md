---
paths:
  - "**/CLAUDE.md"
  - "**/CLAUDE.local.md"
---

# CLAUDE.md maintenance

Rules for any CLAUDE.md (global, project, nested). Apply on every read and edit.

## Content
- **Only persistent facts.** Build/test commands, conventions, architecture, "always do X" rules. If it's a procedure or only matters for one area, move to a skill or `.claude/rules/*.md`.
- **Project/tech/process specifics only.** The reader is Claude — he already knows languages, frameworks, standard tooling, and common best practices. Skip anything you'd find in an "intro to X" or generic style guide. Keep only what's non-obvious, custom to this project, or contradicts a sensible default.
- **Every entry must earn its place.** For each instruction ask: what concrete value does it add, would behavior change without it, are we actually relying on it? If the answer is unclear → remove.
- **Compaction strips rationale, not meaning.** Shrinking the file means cutting framing and justification down to the operative WHAT — not trimming wording to hit `wc -w`. Every surviving rule stays accurate and earns its place.
- **Concrete and verifiable.** "2-space indent", not "format nicely". "Run `npm test` before commit", not "test changes".
- **No transient content.** No changelogs, task lists, in-progress notes, dated entries, history.
- **No secrets.** No tokens, keys, credentials, private URLs.
- **No absolute home paths** (`/Users/...`, `/home/...`). Use `~/` or repo-relative.
- **Operative instructions only.** State the WHAT, not the why. Never transplant conversational wording or justifications from a discussion into the file — rationale belongs in requirements/DESIGN, not the rule.

## Size and structure
- **Max 200 lines.** Over budget → split via `@path/to/file` import or move narrow rules to `.claude/rules/*.md` with `paths:` frontmatter.
- **Markdown headers and bullets.** No dense paragraphs.
- **No duplication.** Same rule in two files → pick one location, delete the other.

## On edit
- Check whether the rule belongs in a path-scoped `.claude/rules/*.md` instead — narrow scope = rule file, universal = CLAUDE.md.
- Remove anything now stale (renamed commands, removed conventions, outdated paths).
- Verify line count stays ≤ 200.

## Agent toolchain declaration
- Projects run via `/dev auto` declare their build/test/VCS commands as `permissions.allow` rules in an `## Agent toolchain` section of the project CLAUDE.md — including a VCS-host CLI (`glab`/`gh`) for the checkpoint push + MR. The `delegating-to-agents` pre-flight reads it to prepare agent settings deterministically. Push-permission patterns: `skills/delegating-to-agents/toolchain.md`.

## Approval
- **Never auto-fix CLAUDE.md.** Report violations and propose changes; wait for explicit approval before editing.
