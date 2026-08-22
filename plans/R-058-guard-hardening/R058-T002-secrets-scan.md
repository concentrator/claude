task: R058-T002
type: feat

# R058-T002 - Tier-1 secrets scan

- [x] Extract the secret predicate to one home: `has_secret()` and its
  pattern list move to `hooks/secret-patterns.sh`, sourced by
  `dev-secrets-guard.sh`; `install-dev.sh` copies the new file
  (`install-dev.test.sh` asserts it); existing secrets-guard tests
  stay green
- [x] Add `scripts/ci/check-secrets.sh`: scans tracked files (skipping
  symlinks and >1MB blobs, honoring the `secrets-guard: allow`
  marker) with the shared predicate, registers in
  `scripts/ci/run-all.sh`, ships `scripts/test/check-secrets.test.sh`
  with a seeded case per pattern class and a clean-tree pass;
  `DESIGN.md § Self-enforcement` gains the check in the same commit
  (the tree-map's `ci/` directory entry already covers it)
- [x] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [x] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
