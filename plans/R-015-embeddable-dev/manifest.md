# R-015 portable-core manifest

The skills, rules, and scaffolding the vendor transform (T-031) copies
into an embedded `<project>/.claude/`, with classification, exclusions,
and the transform/readiness notes. Source of truth for what is portable;
linked from `DESIGN.md`.

Classes:
- **portable-generic** — a DEV-workflow skill/rule any adopting project
  needs; copied into the embedded core.
- **project-specific** — tied to this repo's domain/stack; excluded.
- **global-only / self-hosting** — the enforcement/maintenance layer;
  excluded.

## Rules

| Rule | Class | Reason |
|---|---|---|
| `branch-plan.md` | portable-generic | Core branch-plan contract; one self-hosting clause to lift (friction-log hook, line 202). |
| `changelog.md` | portable-generic | Generic CHANGELOG style (path-scoped). |
| `claude-md.md` | portable-generic | Generic CLAUDE.md maintenance rules. |
| `git-workflow.md` | portable-generic | Trunk/PR/release workflow; one self-hosting clause to lift (line 39). |
| `js.md` | project-specific | JS stack naming/quotes/indent; excluded. |
| `planning-templates.md` | portable-generic | Generic planning-artifact templates. |
| `planning.md` | portable-generic | R→T→branch hierarchy + approval/closure. |
| `project-layout.md` | portable-generic | Canonical `.claude/` layout. |
| `skills.md` | portable-generic | Generic SKILL.md maintenance constraints. |

**Portable rules** = all except `js.md`.
