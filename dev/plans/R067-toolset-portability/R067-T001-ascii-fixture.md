---
task: R067-T001
type: fix
---

Branch: `fix/ascii-fixture`.

`scripts/test/check-accretion.test.sh` case 16 ("non-ASCII filename")
spells its fixture in Cyrillic, three times on two adjacent lines. `install-dev.sh
--project` ships the file as a tracked copy, and a git host that rejects
Cyrillic in file content then rejects every adopter push touching it.
The case's premise is only that git quotes the name under default
`core.quotePath`, which any non-ASCII name satisfies.

## Commits

- [x] Rename the fixture to `plán.md` at every occurrence. The case's
  own two assertions are the test: they pass before and after, and
  they would fail if the new name broke the quoting premise. The
  reproduction of the defect is the tracked-file search in the R's
  first acceptance criterion, run before and after.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (code row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit. R067-T001 is the R's only task, so the closure check and
  archival ride the close-out plan PR per `finish.md § 4`.
