task: T-046
type: refactor

# refactor/retire-r015 — remove the embedding machinery (R-021)

T-046 of `plans/R-021-command-toolset/`. **Phase D.** R-021's skill-router
+ install model replaces R-015 embedding, so retire the vendor/embed/drift
machinery and mark R-015 superseded. The R-015 plan dir stays (historical,
marked `[x]`). The wallarm-repo unwind is a linked MR in that repo.

- [ ] Remove embed scripts: `scripts/{vendor-toolchain,dev-embed-check,dev-drift-check}.sh`.
- [ ] Remove embed/vendor/drift tests: `scripts/test/{vendor-toolchain,vendor-update,embedded-ci,dev-embed-check,dev-drift-check,embed-gitignore}.test.sh`.
- [ ] Drop the `CLAUDE_ROOT` parameterization in `check-caps.sh` +
  `check-plan-integrity.sh` (revert to self-hosting `.`; CI never ran the
  vendor tests, so no gate impact).
- [ ] Remove the `DESIGN.md § Embeddable toolchain (R-015)` section.
- [ ] ROADMAP: mark **R-015 `[x]`** (superseded by R-021); reconcile —
  **R-019** mooted (no vendoring), **R-020** partially absorbed
  (`finishing-a-branch`→`finish` companion done; verify-gate → R-024),
  **R-018** remains open (git-workflow bootstrap-rule cleanup + `start`
  reorder; T-048 already fixed the migrate/start companions).
- [ ] **Wallarm unwind** (separate MR in `~/wallarm_pure/skills`): remove
  its `dev-*` embed (`skills/dev-*`, `.dev-toolchain.json`,
  `dev-embed-check.sh`, embedded `scripts/ci/`, vendored DEV rules),
  preserve the team's own artifacts. Tracked here; executed in that repo.
- [ ] Complete the branch: full gate green; close review; mark plan complete.
