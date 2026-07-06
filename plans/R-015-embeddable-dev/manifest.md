# R-015 portable-core manifest

The skills, rules, and scaffolding the vendor transform (T-031) copies
into an embedded `<project>/.claude/`, with classification, exclusions,
and the transform/readiness notes. Source of truth for what is portable;
linked from `DESIGN.md`.

Classes:
- **portable-generic** - a DEV-workflow skill/rule any adopting project
  needs; copied into the embedded core.
- **project-specific** - tied to this repo's domain/stack; excluded.
- **global-only / self-hosting** - the enforcement/maintenance layer;
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

## Skills

Portable-generic (copied, with companions): `adding-a-feature`,
`brainstorming`, `delegating-to-agents`, `dev`, `dispatching-parallel-agents`,
`doing-a-refactor`, `finishing-a-branch`, `fixing-a-bug`, `migrating-to-dev`,
`receiving-code-review`, `release`, `skill-creator`, `starting-a-project`,
`systematic-debugging`, `test-driven-development`,
`verification-before-completion`, `writing-plans`, `writing-skills` (18).

Excluded (project-specific): `wallarm-api-abuse`, `wallarm-api-sessions`,
`wallarm-api-tf-rules`, `wallarm-ip-lists`, `wallarm-mitigation-controls`,
`wallarm-tf-usage`, `wallarm-triggers` (7, gitignored domain skills).

Companions travel with their skill (all portable): `brainstorming`
(`visual-companion.md` + `scripts/`), `delegating-to-agents`
(`implementer-prompt.md`, `spec-reviewer-prompt.md`, `report-template.md`,
`verification-policy.md`, `toolchain.md`, `auto-permissions.template.json`),
`systematic-debugging` (4), `test-driven-development` (1), `writing-skills`
(5 incl. the example), `writing-plans` (1), `migrating-to-dev`
(`tbd-migration.md`).

## CI subset

Embedded gate runs the **portable** checks, `.claude/`-rooted via
`CLAUDE_ROOT` (T-035):
- Copied: `check-caps.sh`, `check-plan-integrity.sh`, `check-references.sh`.
- Emitted: a ledger-free `run-all.sh` that sets `CLAUDE_ROOT=.claude`.
- **Excluded**: `check-ledger.sh` (self-hosting); `check-stray.sh`
  (validates the repo root against `DESIGN.md`'s tree-map - N/A to an
  adopter); `check-todos.sh` (scoped to this repo's `scripts/`/`.githooks/`).

## Scaffolding

- Generic DEV `CLAUDE.md` backbone - authored by T-031 (VIBE/DEV modes +
  `@`-imports of the embedded rules); this repo's own `CLAUDE.md` is not
  copied (self-hosting content).
- `settings.json` baseline - minimal; this repo's `settings.local.json`
  is not copied.

## Excluded (not vendored)

- `rules/js.md`; `skills/wallarm-*` (×7).
- Self-hosting: `MAINTENANCE.md`, `maintenance.jsonl`,
  `scripts/ci/check-ledger.sh`, the ledger CI/hook wiring, the auto-memory.
- Instance docs: this repo's `REQUIREMENTS.md`, `DESIGN.md`, `ROADMAP.md`,
  `plans/` - the adopter writes its own.

## Transform rules (T-031)

1. Path rewrite: `~/.claude/rules/…`→`.claude/rules/…`,
   `~/.claude/skills/…`→`.claude/skills/…`, `~/.claude/CLAUDE.md`→ the
   `@`-import target.
2. `dev-*` namespacing of the embedded sub-skills (never collide with a
   global toolchain).
3. Protect from rewrite: `__HOME__`/`__PROJECT_DIR__` placeholders in
   `auto-permissions.template.json`; `writing-skills/examples/CLAUDE_MD_TESTING.md`
   (illustrative content, ~13 example refs).
4. Genericize `delegating-to-agents/verification-policy.md`: replace this
   repo's Models table + effort/`B-003` evidence with a generic
   model-routing slot the adopter fills.

## Embed-readiness (global-source fixes - done in T-030)

- Normalize 3 bare `rules/X.md` refs that don't resolve from a skill's
  location → `~/.claude/rules/…`: `delegating-to-agents/verification-policy.md`
  (×2), `migrating-to-dev/tbd-migration.md` (×1).
- Lift `git-workflow.md` line 39 self-hosting clause (Tier-1 + `gh pr merge`
  fallback) → this repo's `CLAUDE.md § Agent toolchain`; the portable rule
  keeps only the generic merge policy.
- Trim `branch-plan.md` line 202 friction-log-hook clause (repo maintenance
  detail) from the generic rule.
- Bare sibling-rule refs inside `rules/` resolve rules-relative both
  globally and embedded - left as-is.
