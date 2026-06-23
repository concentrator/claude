---
approved: 2026-06-23
kind: refactor
status: done 2026-06-23
---

# R-014: Per-initiative task indexes

## Current state

All tasks live in one flat `plans/TASKS.md` (26 tasks, 176 lines, growing
every initiative) — hard for a human to scan, and no single place lists
one initiative's tasks. Each `R-XXX-<slug>/` dir already holds that R's
`requirements.md`, branch plans, and `batches/`, but its task index sits
elsewhere (the flat file).

## Desired state

Each initiative owns a `plans/R-XXX-<slug>/tasks.md` — its task index,
co-located with its requirements / branch plans / batches, created
lazily with the first task (an R with no tasks has none). The flat root
`TASKS.md` is removed. `ROADMAP.md` stays the cross-R index (initiative
granularity); task detail lives per-R. Navigation: ROADMAP → R-dir →
tasks.md. Global monotonic T-ids are kept, relocated into the owning R's
`tasks.md`.

## Invariants

- The DEV chain (R → T → branch plan → batch → PR), approval, and closure
  semantics are unchanged — only *where* the task index lives.
- T-ids stay global + monotonic; existing `T-XXX` references and
  `depends-on` resolve.
- `check-plan-integrity` still verifies task → parent R, branch-plan
  `task:`/`depends-on:` → a task, R-dir → ROADMAP.
- No flat global task list (ROADMAP is the cross-R view) — accepted.

## Scope

- Rules: `planning.md` (index is per-R `tasks.md`, created lazily),
  `project-layout.md` (tree: per-R `tasks.md`; drop root `TASKS.md`),
  `branch-plan.md` (closure marks the R's `tasks.md`).
- Skills: `writing-plans`, `finishing-a-branch` (§4), `starting-a-project`,
  `migrating-to-dev` (+ the split step); `dev` if it references TASKS.md.
- `scripts/ci/check-plan-integrity.sh` — read per-R `tasks.md`; compute
  next-id across them.
- `DESIGN.md` tree-map.
- Self-migration: split this repo's `plans/TASKS.md` (all 26 tasks, incl.
  closed, status preserved) into per-R `tasks.md`, remove the flat file.
- `migrating-to-dev`: a structure-reconcile step that splits an adopter's
  flat `TASKS.md` into per-R `tasks.md`.

## Acceptance criteria

- [ ] Each `R-XXX-<slug>/` with tasks has a `tasks.md` (same one-line
      format + checkbox), created lazily with the first task; root
      `plans/TASKS.md` removed.
- [ ] `planning.md` / `project-layout.md` / `branch-plan.md` describe
      per-R `tasks.md`; no reference to a root `TASKS.md` remains.
- [ ] T-ids stay global + monotonic; "next free id" = max across per-R
      `tasks.md`.
- [ ] `check-plan-integrity.sh` reads per-R `tasks.md` and is green on the
      migrated tree (task→R, branch-plan refs, next-id).
- [ ] `finishing-a-branch` §4 marks `T-XXX [x]` in the R's `tasks.md`.
- [ ] `migrating-to-dev` documents the split (flat `TASKS.md` → per-R) as
      a structure-reconcile step.
- [ ] This repo's 26 tasks (incl. closed) migrated into per-R `tasks.md`,
      status preserved; `run-all` green.
- [ ] `DESIGN.md` tree-map updated.

## Constraints

- Behavior/closure semantics preserved (refactor).
- Global T-ids preserved (no R-scoped renumbering).
- `tasks.md` lowercase (mirrors `requirements.md`).
- ROADMAP is the only cross-R index (no aggregator).
- Self-modifying: the integrity check that validates tasks is itself
  changed while the tasks are relocated — sequence the branch so
  `run-all` (esp. `check-plan-integrity`) stays green at the PR head
  (like the T-022 ledger conversion).

## Open questions

- None — creation is lazy; migrate all tasks (incl. closed), status
  preserved (settled at shaping).

## References

- `plans/TASKS.md` (being split), `ROADMAP.md` (retained cross-R index).
- `planning.md § Levels` / `§ Where things live`, `project-layout.md`,
  `branch-plan.md`.
- `scripts/ci/check-plan-integrity.sh`.
- R-009 (`migrating-to-dev` adopter flow — gains the split step).

## Closure verification (2026-06-23)

One-line evidence per criterion (T-027 merged, PR #38):

1. Each R-dir with tasks has a `tasks.md` (same one-line format +
   checkbox), created lazily; root `plans/TASKS.md` removed — 11 per-R
   files, flat file gone. [T-027]
2. `planning.md` / `project-layout.md` / `branch-plan.md` describe per-R
   `tasks.md`; zero `TASKS.md` references remain in the three files.
   [T-027]
3. T-ids stay global + monotonic; next free id = max across per-R
   `tasks.md` (now T-028), documented in `planning.md § Levels`. [T-027]
4. `check-plan-integrity.sh` reads every `plans/R-*/tasks.md` and is
   green on the migrated tree (task→owning R, branch-plan refs, no
   duplicate ids). [T-027]
5. `finishing-a-branch` §4 marks `T-XXX [x]` in the parent R's
   `tasks.md`. [T-027]
6. `migrating-to-dev` (`tbd-migration.md § 2`) documents the flat
   `TASKS.md` → per-R split as a structure-reconcile step. [T-027]
7. All 27 task lines (T-001..T-027, incl. closed) migrated with status
   preserved; `run-all` green. [T-027]
8. `DESIGN.md` tree-map updated (per-R `tasks.md`; root node removed).
   [T-027]
