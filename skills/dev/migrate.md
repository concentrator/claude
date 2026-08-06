# Migrating to DEV

Bring an existing project under DEV. Always run § 1 Inventory, then route:

- **Legacy / non-canonical** - `.claude/` deviates from
  `layout.md` (lowercase foundational files, `REQ-XXX`, flat
  `tasks.md`): canonicalize per `companions/legacy-migration.md`, then treat as
  Already-DEV.
- **Fresh** - no `.claude/plans/`: reverse-engineer requirements + design
  from code, then layer planning infrastructure (steps 2–9).
- **Already-DEV** - canonical R-rooted `ROADMAP.md`: pre-TBD → TBD
  migration (`companions/tbd-migration.md`; approval-gated - the agent executes each
  approved step; host-side settings stay the user's); TBD-conformant → conformant, no changes.
  Either way, check the id/archival schema: a project on the legacy global
  T-id scheme adopts composite ids for NEW tasks (`plan.md § ID format`;
  legacy ids frozen, never renumbered) by stating the convention in each
  open `tasks.md` header. Draining the stock - archive closed work,
  compact living docs, gate accretion (`plan.md § Archival`,
  `writing.md § State the present`) - is proposed as a docs-reconcile
  initiative, never done inline during migration.

## 1. Inventory

Check existing: `CLAUDE.md`, `README.md`, `CHANGELOG.md`, language/stack,
build/test/lint commands, CI config, open branches, `docs/`. Cross-check
against `layout.md` and report gaps.

`git check-ignore -q .claude` exits 0 → activate untracked mode for
the rest of the migration (flag + deltas:
`companions/untracked-claude.md`).

## 2. Requirements

Read README + code. Ask user 3–5 clarifying questions. Write
`.claude/REQUIREMENTS.md` with
`approved: pending` per `templates.md
§ Foundational`. **Block on user approval** - then update `approved:` to
today.

## 3. Design

Document module boundaries, data/control flow, architectural decisions.
Write `.claude/DESIGN.md` (≤1000 words inline). User approves.

## 4. CLAUDE.md alignment

Ensure project `CLAUDE.md` has `## Conventions` (release-routine,
publish-external, extended-docs, and a `.claude/docs/index.md` pointer if
`.claude/docs/` is used) + stack, base branch, and an `## Agent
toolchain` section (VCS host + build/test/lint/change-request/
state-check commands - `companions/toolchain.md`); backfill it if absent. Propose deletion of any
restated global rules. Keep it within the `rules/claude-md.md` limits
(§ Content, § Size and structure).

## 5. Quality infrastructure

Check inventory against the baseline: lint configured + a passing smoke
test + CI running lint + tests on every MR/PR. Ask before changing
existing config. If user defers any item, record
`quality-deferred: true` in `CLAUDE.md § Conventions`.

For contributors without a global toolset, install it into their
`~/.claude/skills/`, or ship a project copy at `.claude/skills/dev/` - skill
precedence means a personal copy wins and a project copy serves no-global
contributors.

## 6. Backfill plans

Create `.claude/plans/` with `ROADMAP.md` (per-R `tasks.md`, created
lazily). Ask about ongoing work → initiatives (R-XXX) and open tasks
(composite ids, `plan.md § ID format`) in their R's `tasks.md`.
Known bugs or tech debt → R stubs per `plan.md
§ Referential integrity`.

## 7. Docs adoption

If the project keeps `.claude/docs/` feature docs (`layout.md § Docs`), run
the docs-adoption procedure (`companions/docs-adoption.md`) - audit, build,
and workflow correction - to bring them onto the doc-first convention.

## 8. Commit

Deliver adoption artifacts via a short-lived branch + MR/PR
(`git-workflow.md`) - `main` already exists, so no bootstrap exception;
separate commits per category (untracked mode deltas:
`companions/untracked-claude.md`).

## 9. Next

Propose a task from a per-R `tasks.md` → `/dev plan <task-id>`.
