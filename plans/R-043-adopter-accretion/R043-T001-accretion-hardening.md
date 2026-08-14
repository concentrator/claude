---
task: R043-T001
type: fix
---

# R043-T001 - accretion hardening

Branch: `fix/accretion-hardening`.

- [ ] Full-date rule and recall verbs: `check-accretion.sh`'s pattern
      requires a full `20\d\d-\d\d-\d\d` after the separator (bare
      years stop matching) and the verb list gains `supersedes`,
      `delivered`, `restored`, `revised`, `deferred`, `complete`;
      header comment states the tightened contract. Tests assert a
      marker verb followed by a bare year and no full date passes,
      the existing full-date cases still fail, and `supersedes` plus
      one more new verb with a full date are caught.
- [ ] Quoted filenames: file listing runs with
      `-c core.quotePath=false`, so a non-ASCII plan filename is
      scanned rather than silently skipped; test creates such a file
      carrying a violation and asserts it is caught, both live and
      under `archive/` (exemption still applies).
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
