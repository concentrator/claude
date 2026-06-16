# T-017 claude-md-compact — findings

## Rule-preservation mapping (R-006 invariant)

Every CLAUDE.md rule touched by T-017 → kept / relocated / dropped.
Nothing dropped silently; T-017 has no intentional drops.

| Was (CLAUDE.md) | Now |
|---|---|
| `## Structured Data / API parameters` (read the authoritative reference first; never approximate from memory) | **Subsumed** into `## Verify before stating` (CLAUDE.md) — the schema/config/API-shape "read the reference first" clause is preserved as its closing sentence |
| `## Temporary Files` — planning-artifact / spec locations (`.claude/plans/`, `.claude/`) | **Already present** in `planning.md § Where things live` (the location table); duplicate removed |
| `## Temporary Files` — "never use `docs/` or other project directories" guard | **Relocated** to `planning.md § Where things live` (new closing sentence) — the one operative bit not already in the table |
| Session-Workflow Agent-toolchain **declaration rule** ("projects run via `/dev auto` declare … in an `## Agent toolchain` section") | **Relocated** to `rules/claude-md.md § Agent toolchain declaration` |
| `## Agent toolchain` self-hosting block (this repo's own toolchain) | **Kept** in CLAUDE.md, **truncated** to operative essentials (green definition, VCS-host CLI, batch-push carve-out); grows as tools are defined (Decision A) |

## Additions (new R-006 content, not relocations)

- `## Verify before stating` (CLAUDE.md) — new global behavior rule
  (absorbs the Structured-Data section).
- Anti-rationale rule — `rules/claude-md.md § Content` and
  `rules/skills.md § Content`.
- Operative-only compaction criterion — `rules/claude-md.md § Content`.

## Triage

- The `planning.md` "never use `docs/`" relocation was a mid-execution
  preservation decision (the Temporary-Files section was not a pure dup);
  recorded above, no separate follow-up.
- No scope-discovery findings open.
