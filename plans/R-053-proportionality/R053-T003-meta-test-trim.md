---
task: R053-T003
type: mnt
depends-on: R053-T002
---

# R053-T003 - meta-test trim

Branch: `mnt/meta-test-trim`.

Trim standard (R-053 requirements): one passing and one biting case
per check; isolation keeps the static scrub sweep plus one canary per
invocation path. The R-051 closure cites `install-dev.test.sh` case
"vendored self-tests carry the isolation scrub" - that assertion
stays.

- [ ] `isolation.test.sh`: reduce to the static sweep, one canary per
      invocation path (runner, direct), and one leak counter-case
      proving detection still bites; drop the index-only and git-dir
      variants. `context-cost.test.sh`: remove the mutant cases.
- [ ] `check-plan-integrity.test.sh`, `check-batch-tags.test.sh`,
      `check-accretion.test.sh`, `check-settings.test.sh`: one
      passing and one biting case each; drop the per-code-path
      variants.
- [ ] `install-dev.test.sh`: reconcile to the trimmed vendored
      self-tests, keeping the isolation-scrub assertion and one
      bites-from-install-location case per shipped check.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
