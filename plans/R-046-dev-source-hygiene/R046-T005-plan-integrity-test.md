---
task: R046-T005
type: test
---

# R046-T005 - a test for the plan-integrity check

Branch: `test/plan-integrity-test`.

- [x] `scripts/test/check-plan-integrity.test.sh`: the fixture harness
      modeled on `check-accretion.test.sh` (temporary repo, declared
      root, pass and fail assertions), covering the happy path - plus
      the legacy bare-id form and one case per report site the check
      carries.
- [x] The root-seam cases the accretion suite only reaches indirectly:
      nested-root attribution (a root dir named like an R-dir stays
      attributable to the inner R, and still reports a real mismatch),
      the missing-ROADMAP guard, the guard naming its resolved root, and
      the default `dev/` root ignoring an outside-root tree. Landed in
      the harness commit rather than its own - one commit covering two
      checkboxes.
- [x] Wired into `scripts/test/run-all.sh`: the aggregator globs
      `scripts/test/*.test.sh`, so the filename is the wiring; verified
      by the aggregator naming this suite among the ones it runs and
      reporting green.
- [x] Coverage measured, not assumed: every one of the check's report
      sites, its `report()` fail flag, and the ROADMAP guard were each
      mutated away in turn against a copy beside `resolve-root.sh`, and
      each mutation failed the case that guards it. Four sites had no
      case until the close review measured what the first mutation run
      had not - it re-tested only the sites already covered.
- [x] Every violation case asserts a nonzero exit as well as the report
      text (`fails_with`). Without it, dropping `report()`'s fail flag
      left the gate reporting violations while exiting 0 and the whole
      suite still green - the pattern `check-accretion.test.sh` had and
      this suite first lacked.
- [x] Mark and commit `R046-T005 [x]` in the R's `tasks.md`.
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
