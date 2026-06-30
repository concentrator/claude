---
name: migrating-to-dev
description: Use when adopting an existing project into DEV mode.
---

# Migrating to DEV

Bring an existing project under DEV. Detect mode by state:

- **Fresh** — no `.claude/plans/ROADMAP.md`: reverse-engineer
  requirements + design from code, then layer planning infrastructure
  (steps 1–8 below).
- **Already-DEV, pre-TBD** — `.claude/plans/ROADMAP.md` present: the
  project has the planning hierarchy but runs the pre-TBD delivery
  model. Run the TBD migration (`tbd-migration.md`; advisory — you
  execute the irreversible/host steps), not steps 1–8. An
  already-TBD-conformant project → report
  conformant, no changes.

## 1. Inventory

Check existing: `CLAUDE.md`, `README.md`, `CHANGELOG.md`, language/stack,
build/test/lint commands, CI config, open branches, `docs/`. Cross-check
against `~/.claude/rules/project-layout.md` and report gaps.

## 2. Requirements

Read README + code. Ask user 3–5 clarifying questions. Write
`.claude/REQUIREMENTS.md` with
`approved: pending` per `~/.claude/rules/planning-templates.md
§ Foundational`. **Block on user approval** — then update `approved:` to
today.

## 3. Design

Document module boundaries, data/control flow, architectural decisions.
Write `.claude/DESIGN.md` (≤1000 words inline). User approves.

## 4. CLAUDE.md alignment

Ensure project `CLAUDE.md` has `## Conventions` (release-routine,
publish-external, extended-docs) + stack, base branch, build/test/lint.
Propose deletion of any restated global rules.

## 5. Quality infrastructure

Check inventory against the baseline: lint configured + a passing smoke
test + CI running lint + tests on every MR/PR. Ask before changing
existing config. If user defers any item, record
`quality-deferred: true` in `CLAUDE.md § Conventions`.

Optionally embed the toolchain (`~/.claude/scripts/vendor-toolchain.sh
<root>`) for contributors without `~/.claude`.

## 6. Backfill plans

Create `.claude/plans/` with `ROADMAP.md` (per-R `tasks.md`, created
lazily). Ask about ongoing work → initiatives (R-XXX) and open tasks
(T-XXX) in their R's `tasks.md`.
Known bugs or tech debt → R stubs per `~/.claude/rules/planning.md
§ Referential integrity`.

## 7. Commit

Commit adoption artifacts to the default branch — the bootstrap
exception (`git-workflow.md`); separate commits per category.

## 8. Next

Propose a `T-XXX` from a per-R `tasks.md` → `/dev plan T-XXX`.
