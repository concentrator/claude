# R-014 tasks

Task index for this initiative. Items:
`T-001 (R-001) [feat|fix|refactor]: description` - format and closure:
`rules/planning.md § Levels`. Cross-R index: `plans/ROADMAP.md`.

- [x] T-027 (R-014) [refactor]: Per-initiative task indexes - deprecate
      flat `plans/TASKS.md`; define per-R `tasks.md` (lazy) in
      `planning.md` / `project-layout.md` / `branch-plan.md` + `DESIGN.md`
      tree-map; update `check-plan-integrity.sh` to read per-R `tasks.md`
      (next-id = max across them); update consuming skills
      (`writing-plans`, `finishing-a-branch` §4, `starting-a-project`,
      `dev`) + add the `migrating-to-dev` adopter split step;
      self-migrate this repo's 26 tasks (incl. closed, status preserved)
      into per-R `tasks.md` and remove the flat file. One coherent
      branch; self-modifying - sequence so `check-plan-integrity` stays
      green at the PR head (per-R files created before the check-swap +
      flat-file removal).
