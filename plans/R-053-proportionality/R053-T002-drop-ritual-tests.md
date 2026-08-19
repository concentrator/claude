---
task: R053-T002
type: mnt
---

# R053-T002 - drop the ritual tests

Branch: `mnt/drop-ritual-tests`.

The two checks stay in Tier-1; only their self-tests go. The test
runner globs `scripts/test/*.test.sh` and the installer ships neither
file, so deletion reconciles both by itself.

- [x] Delete `scripts/test/check-no-em-dash.test.sh` and
      `scripts/test/check-code-size.test.sh`; both runners stay green
      (`bash scripts/ci/run-all.sh`, `bash scripts/test/run-all.sh`).
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
