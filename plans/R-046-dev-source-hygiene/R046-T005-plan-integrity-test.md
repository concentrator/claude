---
task: R046-T005
type: test
---

# R046-T005 - a test for the plan-integrity check

Branch: `test/plan-integrity-test`.

- [ ] `scripts/test/check-plan-integrity.test.sh`: the fixture harness
      modeled on `check-accretion.test.sh` (temporary repo, declared
      root, pass and fail assertions), covering the happy path.
- [ ] The root-seam cases the accretion suite only reaches indirectly:
      nested-root attribution and the missing-ROADMAP guard.
- [ ] Wired into `scripts/test/run-all.sh`, with the full suite green.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
