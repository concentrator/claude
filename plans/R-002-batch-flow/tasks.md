# R-002 tasks

Task index for this initiative. Items:
`T-001 (R-001) [feat|fix|refactor]: description` — format and closure:
`rules/planning.md § Levels`. Cross-R index: `plans/ROADMAP.md`.

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
