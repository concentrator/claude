# Tasks

Task index. Items: `T-001 (R-001) [feat|fix|refactor]: description` —
format and closure: `rules/planning.md § Levels`.

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
- [x] T-008 (R-003) [refactor]: Define the flattened layout in rules —
      `planning.md` (R-rooted chain, in-dir `requirements.md` template,
      initiative-time dir creation, R-closure rule with criteria
      verification + `status: done`, indexes at `plans/`, R-scoped
      batch paths, findings promotion to R stub),
      `branch-plan.md` (batch manifest/report under
      `R-XXX-<slug>/batches/`, single-R batch scope, batch-close
      bookkeeping on the batch branch), `project-layout.md` tree.
- [x] T-009 (R-003) [refactor]: Update skills to the flattened chain —
      `dev` (merge `REQ`/`REQ-XXX`/`roadmap` targets into `R`/`R-XXX`,
      net words out), `brainstorming` (entry + dir + requirements in
      one act), `writing-plans`, `finishing-a-branch` (R-closure
      criteria check; auto-mode bookkeeping onto the batch branch),
      `delegating-to-agents` + prompts (criteria wording, checkpoint
      re-verification, R-scoped batch/report paths, close phase marks
      checkboxes before the MR), `starting-a-project`,
      `migrating-to-dev`, `release`.
- [ ] T-010 (R-003) [refactor]: Migrate this repo to the new layout —
      `ROADMAP.md`/`TASKS.md` → `plans/`, REQ-002/REQ-003 criteria
      stamped `status: done` under the new rule, REQ-004 superseded
      mark verified, REQ-001 → R-stub dir (`requirements.md`,
      `approved: pending`), path updates in `CLAUDE.md`, `README.md`,
      `DESIGN.md` tree-map, `MAINTENANCE.md` targets.
- [ ] T-011 (R-003) [refactor]: Migrate wallarm-api-js to the new
      layout — indexes → `plans/`, REQ-001 content → its R-dir
      `requirements.md`, `plans/batches/` B-001..003 manifests +
      reports → that R's `batches/`, manifest references updated, file
      count preserved; runs only between batches.
