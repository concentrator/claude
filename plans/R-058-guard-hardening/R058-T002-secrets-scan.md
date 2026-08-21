task: R058-T002
type: feat

# R058-T002 - Tier-1 secrets scan

- [ ] Extract the secret predicate to one home: `has_secret()` and its
  pattern list move to `hooks/secret-patterns.sh`, sourced by
  `dev-secrets-guard.sh`; `install-dev.sh` copies the new file
  (`install-dev.test.sh` asserts it); existing secrets-guard tests
  stay green
- [ ] Add `scripts/ci/check-secrets.sh`: scans tracked files (skipping
  symlinks and >1MB blobs, honoring the `secrets-guard: allow`
  marker) with the shared predicate, registers in
  `scripts/ci/run-all.sh`, ships `scripts/test/check-secrets.test.sh`
  with a seeded case per pattern class and a clean-tree pass;
  `DESIGN.md § Self-enforcement` and tree-map gain the check in the
  same commit
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [ ] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
