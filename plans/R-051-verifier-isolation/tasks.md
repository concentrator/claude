# R-051 tasks - Verifier isolation

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R051-T###`, counter scoped to this initiative).

## Open

- [x] **R051-T001 [test]**: scrub `GIT_DIR`, `GIT_WORK_TREE` and
  `GIT_INDEX_FILE` in `scripts/test/run-all.sh` and in every
  fixture-creating test, with a case proving isolation under an absolute
  `GIT_DIR` both through the runner and by direct invocation.
- [ ] **R051-T002 [test]**: a whole-suite isolation assertion comparing
  host refs, config and index before and after a run, proved to bite by
  running it against an unfixed copy. `depends-on: R051-T001`
- [x] **R051-T003 [mnt]**: re-vendor the shipped tests and assert in
  `install-dev.test.sh` that the shipped copy scrubs, so the fix cannot
  be vendored away. `depends-on: R051-T001`
- [ ] **R051-T004 [test]**: `GIT_CONFIG_PARAMETERS` and the
  `GIT_CONFIG_COUNT`/`KEY`/`VALUE` triple survive the scrub and set config
  in every fixture, so a test asserting on branch names, `core.*` or hook
  paths measures under configuration it did not choose. Decide whether
  `companions/verification-policy.md § Verifier isolation` widens beyond
  the three names it lists. `depends-on: R051-T001`
