# R-046 tasks - DEV system-source hygiene

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R046-T###`, counter scoped to this initiative).

## Open

- [x] **R046-T001 [doc]**: the doc-sync obligation - a review concern in
  `MAINTENANCE.md § Tier-2 AI review` for staleness a change induces in
  files it does not touch, the repo's change-to-doc pair table in
  § This environment, and the root docs added to the Routine's
  stale-reference row. Single-homes the concern set: `branch-plan.md`
  and `DESIGN.md` cite it instead of restating the count.
- [x] **R046-T002 [doc]**: root-doc repair - `README.md` (command
  surface, § Contents, artifacts root, installer paragraph), the
  `DESIGN.md` tree-map, and `REQUIREMENTS.md`'s dead `rules/` pointers,
  including the id form in these three files.
- [x] **R046-T003 [doc]**: canon consistency - the retired bare id form
  out of `plan.md § Levels` and its § Where things live table,
  `branch-plan.md`, `finish.md`, and `templates.md`; `templates.md`'s
  `kind:` enum and `write-plan.md`'s tag list aligned with the branch
  taxonomy; `SKILL.md`'s `/dev code` dispatch covers `doc`, `test`, and
  `mnt`; `plan.md § Archival` admits one reading of when artifacts move;
  the branch-plan template carries the index mark as a checkbox.
- [ ] **R046-T004 [refactor]**: declaration syntax gets its own
  companion - the three `§ Agent toolchain` keys move out of
  `companions/toolchain.md`, which keeps push and MR mechanics; all
  inbound references repointed.
- [x] **R046-T005 [test]**: `scripts/test/check-plan-integrity.test.sh`
  covering the root-seam behaviors, wired into `scripts/test/run-all.sh`.

## Backlog

Unnumbered until this R's next round (`plan.md § Referential integrity`).

- `branch-plan.md § Closing routine` step 1 dispatches close review by
  `refactor` / `feature` / `bugfix` only, so a `doc`, `test`, or `mnt`
  branch has no declared route - the gap R046-T003 closed for the
  execution dispatch in `SKILL.md`, still open for the close-review one.
