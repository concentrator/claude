# Migrating to DEV

Bring an existing project under DEV. Always run § 1 Inventory, then route:

- **Legacy / non-canonical** - `.claude/` deviates from
  `layout.md` (lowercase foundational files, `REQ-XXX`, flat
  `tasks.md`): canonicalize per `companions/legacy-migration.md`, then treat as
  Already-DEV.
- **Fresh** - no `.claude/plans/`: reverse-engineer requirements + design
  from code, then layer planning infrastructure (steps 2–9).
- **Already-DEV** - canonical R-rooted `ROADMAP.md`: pre-TBD → TBD
  migration (`companions/tbd-migration.md`; advisory - you execute irreversible/host
  steps); TBD-conformant → conformant, no changes.

## 1. Inventory

Check existing: `CLAUDE.md`, `README.md`, `CHANGELOG.md`, language/stack,
build/test/lint commands, CI config, open branches, `docs/`. Cross-check
against `layout.md` and report gaps.

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
toolchain` section (VCS host + build/test/lint/change-request commands -
`companions/toolchain.md`); backfill it if absent. Propose deletion of any
restated global rules. Keep it within the CLAUDE.md
limits: ≤200 lines; persistent operative facts only (project/tech/process
specifics); no transient content, secrets, or absolute home paths.

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
(T-XXX) in their R's `tasks.md`.
Known bugs or tech debt → R stubs per `plan.md
§ Referential integrity`.

## 7. Docs adoption

If the project keeps `.claude/docs/` feature docs (`layout.md § Docs`), bring
them onto the doc-first convention.

**Audit** the whole project at its docs-granularity. Per feature: an existing
doc → grade it against the code with a fresh-agent spec-check
(`dispatching-parallel-agents`) as PASS / WARN / FAIL / TODO, and keep it as
input when the doc is (re)built; no doc → FAIL/TODO (no agent needed).
Register any code issues found while probing (bugs, inconsistencies, debt) as
fixable tasks - a `T-XXX` under a fitting open `R-XXX`, else an R stub (per
§ 6 / `plan.md § Referential integrity`). Record the coverage report; the
gaps are the docs backlog.

**Build** `.claude/docs/` for the features the user prioritizes - ask which
matter most (entrypoints and high-churn areas are good candidates). The build
always runs, even from zero docs; the rest stay on the backlog, backfilled
on-touch by the doc-first cycle. Reuse any graded existing docs as input, and
add each built doc to `.claude/docs/index.md`.

**Correct the workflow** so future work maintains the docs: the
`.claude/docs/index.md` pointer in `CLAUDE.md § Conventions` (§ 4) and the
read-at-plan / reconcile-at-close lifecycle (`branch-plan.md`,
`write-plan.md`) that ship with DEV.

## 8. Commit

Deliver adoption artifacts via a short-lived branch + PR
(`git-workflow.md`) - `main` already exists, so no bootstrap exception;
separate commits per category.

## 9. Next

Propose a `T-XXX` from a per-R `tasks.md` → `/dev plan T-XXX`.
