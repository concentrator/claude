---
task: R053-T003
type: mnt
depends-on: R053-T002
---

# R053-T003 - meta-test trim

Branch: `mnt/meta-test-trim`.

Trim standard (R-053 requirements): the meta depth to remove is the
two files the acceptance criterion names - isolation and context-cost.
The four check tests (plan-integrity, batch-tags, accretion, settings)
already carry passing and biting cases and stay as they are: resizing
working tests is the churn the proportionality rule argues against.
The R-051 closure cites `install-dev.test.sh` case "vendored
self-tests carry the isolation scrub" - that assertion stays.

- [x] `isolation.test.sh`: reduce to the static scrub sweep with one
      biting fixture, one canary per invocation path (runner, direct),
      and the bare-direct leak case proving detection still bites;
      drop the mutant-runner, index-only and partial-scrub variants.
      `context-cost.test.sh`: remove the mutant cases.
- [x] `install-dev.test.sh` stays green unchanged; reconcile only if
      the trim breaks it.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`; the merge
      closes R-053, so the same commit verifies the acceptance
      criteria and stamps `status: done` (`plan.md § Approval and
      closure`).
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
