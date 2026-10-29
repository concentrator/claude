# R088-T009 report

## Implementer
### Divergences
- Item 5: the two `---` lines took `skills/dev/branch-plan.md` to 352
  lines, past the 350-line cap `scripts/ci/check-caps.sh` enforces;
  rewrapping the § Size cap paragraph and the § Agentic execution batch
  paragraph, wording unchanged, brings it back to 350.
- Item 8: `dev-instructions.md § Writing` no longer names the
  `Claude-Session` trailer, since that trailer follows the setting's
  `sessionUrl` key rather than `commit` or `pr` (the R088 backlog line on
  `attribution.sessionUrl`); the sentence names Co-Authored-By and kin.

## Review

- [ ] Item 8: `dev-instructions.md § Writing` credits the no-trailer
  intent to `commit` and `pr` alone, while `sessionUrl` governs the
  `Claude-Session` trailer (Critical) - dev-instructions.md:51
  Evidence: observed the settings reference's `attribution.sessionUrl`
  entry, a separate boolean defaulting to `true`
- [ ] Item 7: `run.md § Dispatch per item` 1 lists the `## Review`
  sources as "(2, § Close 2)", leaving out § Batch close 2 (Important) -
  skills/dev/run.md:107
  Evidence: observed run.md:107 and the § Seats implementer row
- [ ] Item 8: the `git-workflow.md § MR/PR messages` bullet restates the
  `dev-instructions.md § Writing` rule instead of only citing it
  (Suggestion) - skills/dev/git-workflow.md:153
  Evidence: observed git-workflow.md:153-154
- [ ] Item 4: `start.md § 3` repeats why `## [Unreleased]` exists, which
  `release.md` already states (Suggestion) - skills/dev/start.md:35
  Evidence: observed start.md:35-37 and release.md:27-29
