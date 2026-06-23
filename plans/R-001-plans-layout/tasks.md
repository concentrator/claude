# R-001 tasks

Task index for this initiative. Items:
`T-001 (R-001) [feat|fix|refactor]: description` — format and closure:
`rules/planning.md § Levels`. Cross-R index: `plans/ROADMAP.md`.

- [x] T-001 (R-001) [refactor]: Define the new planning layout — update
      `rules/planning.md`, `rules/project-layout.md`,
      `rules/branch-plan.md`, all skills with hardcoded `plans/` paths
      (`dev`, `writing-plans`, `delegating-to-agents` + prompts,
      `finishing-a-branch`, `starting-a-project`, `migrating-to-dev`,
      `release`, `brainstorming`), and this repo's `design.md`
      tree-map + `maintenance.md` targets.
- [x] T-002 (R-001) [refactor]: Migrate this repo's own planning
      artifacts to the new layout (`roadmap.md`/`tasks.md` to root,
      `plans/batches/`, R-dirs, task-id-prefixed plan files). Manual
      mode only — the branch moves active plan files, including its
      own; final commit relocates the remainder.
- [x] T-003 (R-001) [refactor]: Migrate wallarm-api-js plans to the new
      layout — `git mv` per REQ-002 (incl. uppercase renames per
      Amendment 1), update `B-XXX` manifest references, verify file
      count preserved. Lands as documentation commits on that repo's
      main (plans exception); run only between batches, after T-004.
- [x] T-004 (R-001) [refactor]: Uppercase the foundational docs (REQ-002
      Amendment 1) — update every reference in rules and skills, then
      `git mv` this repo's five files to `REQUIREMENTS.md`, `DESIGN.md`,
      `MAINTENANCE.md`, `ROADMAP.md`, `TASKS.md`. Runs before T-003.
