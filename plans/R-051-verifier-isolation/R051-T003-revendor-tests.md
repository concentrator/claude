---
task: R051-T003
type: mnt
depends-on: R051-T001
---

# R051-T003 - re-vendor the shipped tests

Branch: `mnt/revendor-tests`.

`scripts/install-dev.sh` ships `test/check-accretion.test.sh` and
`test/check-batch-tags.test.sh` to adopter projects, so adopters hold
unsafe copies until they re-install. The fix reaches them through the
existing update path; this task makes sure it is in the shipped content
and cannot be dropped from it later.

The set of files shipped does not change, only their contents.

- [ ] Confirm the shipped copies carry T001's scrub, and adjust
      `install-dev.sh` if it rewrites or filters any part of the test
      bodies on the way.
- [ ] `scripts/test/install-dev.test.sh`: assert the copied tests scrub
      the three variables, beside the existing assertions that the copied
      gates bite from their install location. Without it a later edit can
      vendor the fix away and no case notices.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
