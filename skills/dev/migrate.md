# Migrating to DEV

Bring an existing project under DEV. Always run § 1 Inventory, then route:

- **Legacy / non-canonical** — `.claude/` deviates from
  `layout.md` (lowercase foundational files, `REQ-XXX`, flat
  `tasks.md`): canonicalize per `companions/legacy-migration.md`, then treat as
  Already-DEV.
- **Fresh** — no `.claude/plans/`: reverse-engineer requirements + design
  from code, then layer planning infrastructure (steps 2–8).
- **Already-DEV** — canonical R-rooted `ROADMAP.md`: pre-TBD → TBD
  migration (`companions/tbd-migration.md`; advisory — you execute irreversible/host
  steps); TBD-conformant → conformant, no changes.

## 1. Inventory

Check existing: `CLAUDE.md`, `README.md`, `CHANGELOG.md`, language/stack,
build/test/lint commands, CI config, open branches, `docs/`. Cross-check
against `layout.md` and report gaps.

## 2. Requirements

Read README + code. Ask user 3–5 clarifying questions. Write
`.claude/REQUIREMENTS.md` with
`approved: pending` per `templates.md
§ Foundational`. **Block on user approval** — then update `approved:` to
today.

## 3. Design

Document module boundaries, data/control flow, architectural decisions.
Write `.claude/DESIGN.md` (≤1000 words inline). User approves.

## 4. CLAUDE.md alignment

Ensure project `CLAUDE.md` has `## Conventions` (release-routine,
publish-external, extended-docs) + stack, base branch, build/test/lint.
Propose deletion of any restated global rules. Keep it within the CLAUDE.md
limits: ≤200 lines; persistent operative facts only (project/tech/process
specifics); no transient content, secrets, or absolute home paths.

## 5. Quality infrastructure

Check inventory against the baseline: lint configured + a passing smoke
test + CI running lint + tests on every MR/PR. Ask before changing
existing config. If user defers any item, record
`quality-deferred: true` in `CLAUDE.md § Conventions`.

For contributors without a global toolset, install it into their
`~/.claude/skills/`, or ship a project copy at `.claude/skills/dev/` — skill
precedence means a personal copy wins and a project copy serves no-global
contributors.

## 6. Backfill plans

Create `.claude/plans/` with `ROADMAP.md` (per-R `tasks.md`, created
lazily). Ask about ongoing work → initiatives (R-XXX) and open tasks
(T-XXX) in their R's `tasks.md`.
Known bugs or tech debt → R stubs per `plan.md
§ Referential integrity`.

## 7. Commit

Commit adoption artifacts to the default branch — the bootstrap
exception (`git-workflow.md`); separate commits per category.

## 8. Next

Propose a `T-XXX` from a per-R `tasks.md` → `/dev plan T-XXX`.
