# R-045 tasks - DEV artifacts root

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R045-T###`, counter scoped to this initiative).

## Open

- [ ] **R045-T001 [doc]**: the declared root - `layout.md` and the
  `plan.md` path table state an artifacts root rather than a fixed
  `.claude/` prefix; `CLAUDE.md § Agent toolchain` gains the
  declaration; absence resolves to `dev/`.
- [ ] **R045-T002 [refactor]**: inventory, then sweep. The first commit
  writes the inventory beside this task: the adopter path set that
  `migrate` will move, and every DEV system-source reference that must
  be rewritten to match. Remaining commits work that list across
  `skills/`, `rules/`, and `scripts/`, gates included. `start.md`
  scaffolds rather than describes, so its paths are a behavior change,
  not a text substitution. Nothing in this repo relocates.
- [ ] **R045-T003 [feat]**: the adoption path - `migrate` moves a
  `.claude/`-layout project onto its declared root, reporting the moves
  and rewrites before applying them.
