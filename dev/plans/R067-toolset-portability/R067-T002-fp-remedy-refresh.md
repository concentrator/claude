---
task: R067-T002
type: mnt
depends-on: R067-T001
---

Branch: `mnt/fp-remedy-refresh` here, carrying the marks; the work is
in fp-remedy's checkout on its `mnt/toolset-refresh` branch.

fp-remedy's toolset refresh (its R010-T001) rewrote the tracked
`.claude/` copy from this source before R067-T001 landed, so the copy
carries the Cyrillic fixture and gl.wallarm.com rejects the push:
`PUSH REJECTED: Cyrillic characters are not allowed`. Six commits sit
unpushed with no MR. Re-running the installer from the fixed source
changes one file on that branch; the pushed content then carries no
Cyrillic, which is what the host checks.

## Commits

- [x] In fp-remedy, on `mnt/toolset-refresh`: `bash
  ~/.claude/scripts/install-dev.sh --project
  /Users/skywalker/wallarm-claude/fp-remedy` from a toolset checkout at
  or after R067-T001; confirm the only change is
  `.claude/scripts/test/check-accretion.test.sh` and that
  `git grep -l -P '[\x{0400}-\x{04FF}]' -- .claude` prints nothing;
  its gate `bash .claude/scripts/ci/run-all.sh` green; commit there as
  "Refresh the accretion self-test from its fixed source"; push; MR;
  poll `glab mr view <n> -F json` to green; merge on the user's word.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`, citing the
  MR id.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (bookkeeping only here keys no review row; the fp-remedy MR
  carries the diff), `bash scripts/ci/run-all.sh` green, mark plan
  complete, commit. R067-T002 is the R's last task: the closure check
  and archival ride `plan/r067-close` per `finish.md § 4`.
