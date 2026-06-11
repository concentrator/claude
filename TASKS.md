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
- [x] T-003 (R-001) [refactor]: Migrate wallarm-api-js plans to the new
      layout — `git mv` per REQ-002 (incl. uppercase renames per
      Amendment 1), update `B-XXX` manifest references, verify file
      count preserved. Lands as documentation commits on that repo's
      main (plans exception); run only between batches, after T-004.
- [x] T-004 (R-001) [refactor]: Uppercase the foundational docs (REQ-002
      Amendment 1) — update every reference in rules and skills, then
      `git mv` this repo's five files to `REQUIREMENTS.md`, `DESIGN.md`,
      `MAINTENANCE.md`, `ROADMAP.md`, `TASKS.md`. Runs before T-003.
- [x] T-005 (R-002) [feat]: Batch integration branch — rewrite
      `branch-plan.md § Agentic execution`: `batch/B-XXX` created at
      pre-flight, member branches merge into it (default branch
      untouched during the run), rollback = delete batch branch
      (`pre-B-XXX` tag stays as belt-and-braces), never-push rail
      narrowed to mid-batch, task checkboxes close on MR merge
      (planning.md + finishing-a-branch alignment).
- [x] T-006 (R-002) [feat]: Batch close phase + report artifact —
      `delegating-to-agents`: full-diff review of `batch/B-XXX` vs
      default on the most capable model, fixes as batch-branch commits,
      tests + lint re-run, docs coherence pass; checkpoint writes and
      presents `plans/batches/B-XXX.report.md` (per-branch + batch
      sections); accept is invalid without the report.
- [x] T-007 (R-002) [feat]: Push + MR at accept — checkpoint accept
      pushes `batch/B-XXX` and creates the MR (`glab`/`gh`, description
      from the report); explicit defer-push option; VCS-CLI toolchain
      requirement with push-only fallback; deny-rule carve-out guidance
      for `git push origin batch/B-XXX` in the permission template
      docs.
