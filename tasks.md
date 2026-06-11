# Tasks

Concrete units of work. Items:
`T-001 (R-001) [feat|fix|refactor]: description`. The tag determines the
branch prefix. A checkbox closes only when the task's branch is merged.

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
- [ ] T-003 (R-001) [refactor]: Migrate wallarm-api-js plans to the new
      layout — `git mv` per REQ-002, update `B-XXX` manifest
      references, verify file count preserved. Lands as documentation
      commits on that repo's main (plans exception); run only between
      batches.
