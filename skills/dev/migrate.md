# Migrating to DEV

Bring an existing project under DEV. Always run § 1 Inventory, then
route. DEV artifacts live at `dev/` (`plan.md § Where things live`);
probe both `dev/` and the legacy `.claude/` locations before
classifying:

- **Legacy / non-canonical** - the artifacts tree deviates from
  `layout.md` (lowercase foundational files, `REQ-XXX`, flat
  `tasks.md`): canonicalize per `companions/legacy-migration.md`, then
  route as `.claude/`-layout.
- **`.claude/`-layout** - anything canonical still under
  `.claude/plans/` or `.claude/docs/`, whether or not `dev/` also
  exists (a both-trees state is a partial migration; a `dev/`-side
  destination that already exists is a collision `root-migration.md
  § 1` reports): relocate onto `dev/` per
  `companions/root-migration.md` (report the moves and rewrites,
  apply on approval), then treat as Already-DEV. This class takes
  precedence over Already-DEV.
- **Fresh** - no artifacts anywhere: no `plans/` or `docs/` under
  either `dev/` or `.claude/`. Reverse-engineer requirements +
  design from code, then layer planning infrastructure (steps 2–9).
- **Already-DEV** - canonical R-rooted `dev/plans/ROADMAP.md`: pre-TBD → TBD
  migration (`companions/tbd-migration.md`; approval-gated - the agent executes
  each
  approved step; host-side settings stay the user's); TBD-conformant →
  conformant, no changes.
  Either way, check the id/archival schema: a project on the legacy global
  T-id scheme adopts composite ids for NEW tasks (`plan.md § ID format`;
  legacy ids frozen, never renumbered) by stating the convention in each
  open `tasks.md` header. Draining the stock - archive closed work,
  compact living docs, gate accretion (`plan.md § Archival`,
  `rules/writing-artifacts.md § State the present`) - is proposed as a
  docs-reconcile
  initiative, never done inline during migration. The accretion gate
  in that proposal reuses the shipped
  `.claude/scripts/ci/check-accretion.sh` (placed by
  `install-dev.sh --project`) - tune its `MARKERS` list, never
  rewrite the check.

  **Stale root** - a project set up while the artifacts root was
  configurable may still carry a `- DEV artifacts root:` line in
  `CLAUDE.md`, `<root>` or "artifacts root" wording in its own docs.
  Report each hit with its rewrite to `dev/...`; apply on approval.

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
publish-external, extended-docs, and a `dev/docs/index.md` pointer if
the docs layer is used) + stack, base branch, and an `## Agent
toolchain` section (VCS host + build/test/lint/change-request/
state-check commands - `companions/declarations.md`); backfill it if
absent. Propose deletion of any
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

Create `dev/plans/` with `ROADMAP.md` (per-R `tasks.md`, created
lazily). Ask about ongoing work → initiatives (R<NNN>) and open tasks
(composite ids, `plan.md § ID format`) in their R's `tasks.md`.
Known bugs or tech debt → R stubs per `plan.md
§ Referential integrity`.

## 7. Docs adoption

If the project keeps `dev/docs/` feature docs (`layout.md § Docs`), run
the docs-adoption procedure (`companions/docs-adoption.md`) - audit, build,
and workflow correction - to bring them onto the doc-first convention.

## 8. Commit

Deliver adoption artifacts via a short-lived branch + MR/PR
(`git-workflow.md`) - `main` already exists, so no bootstrap exception;
separate commits per category (untracked mode deltas:
`companions/untracked-claude.md`).

## 9. Next

Propose a task from a per-R `tasks.md` → `/dev plan <task-id>`.
