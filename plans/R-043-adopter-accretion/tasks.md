# R-043 tasks - Ship the accretion check to adopters

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R043-T###`, counter scoped to this initiative).

## Open

- [x] **R043-T001 [fix]**: harden the reference - `check-accretion.sh`
  requires a full `YYYY-MM-DD` after the marker verb, lists files with
  `core.quotePath=false`, and gains the six recall verbs
  (`supersedes`, `delivered`, `restored`, `revised`, `deferred`,
  `complete`); self-test asserts bare-year pass, full-date fail,
  non-ASCII filename scanned, new verbs caught.
- [ ] **R043-T002 [feat]**: vendor the gate set - `install-dev.sh`
  copies `check-accretion.sh`, `check-batch-tags.sh`, their
  self-tests, and `resolve-root.sh` (its test asserts the set);
  `start.md` scaffolds them into a new project's CI; `migrate.md`'s
  reconcile proposal names the reference copy.

## Backlog

- Sweep the sibling checks that walk `git ls-files` output per file
  (`check-caps.sh`, `check-code-size.sh`, `check-plan-integrity.sh`,
  `check-stray.sh`) for the quoted-filename silent-skip fixed in
  R043-T001; the deeper shared form is NUL-delimited enumeration
  (`git ls-files -z`). `check-code-size.sh` is already vendored, so
  its copy reaches adopters as-is.
