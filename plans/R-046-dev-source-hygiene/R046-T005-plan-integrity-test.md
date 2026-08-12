---
task: R046-T005
type: test
---

# R046-T005 - a test for the plan-integrity check

Branch: `test/plan-integrity-test`.

- [x] `scripts/test/check-plan-integrity.test.sh`: the fixture harness
      modeled on `check-accretion.test.sh` (temporary repo, declared
      root, pass and fail assertions), covering the happy path - plus
      the legacy bare-id form and each violation class the check
      reports.
- [x] The root-seam cases the accretion suite only reaches indirectly:
      nested-root attribution (a root dir named like an R-dir stays
      attributable to the inner R, and still reports a real mismatch),
      the missing-ROADMAP guard, the guard naming its resolved root, and
      the default `dev/` root ignoring an outside-root tree. Landed in
      the harness commit rather than its own - one commit covering two
      checkboxes.
- [x] Wired into `scripts/test/run-all.sh`: the aggregator globs
      `scripts/test/*.test.sh`, so the filename is the wiring; verified
      by the full suite naming all seven and reporting green.
- [x] Each case verified against a mutated copy of the check (`CHECK` is
      overridable for this): breaking root attribution, the ROADMAP
      guard, duplicate detection, or task resolution each fails exactly
      the cases that guard it, so no case passes vacuously.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
