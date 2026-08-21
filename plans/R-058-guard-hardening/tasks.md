# R-058 tasks - Guard hardening

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R058-T###`, counter scoped to this initiative).

## Open

- [x] **R058-T001 [feat]**: push rules in `dev-branch-guard.sh` - deny
  a force push in any spelling (`-f`, `--force` in any position,
  `+refspec`) and any refspec targeting the default branch; task-branch
  pushes pass; fail-open elsewhere; one test per denied class plus the
  allowed-push case in `dev-push-guard.test.sh`.

- [ ] **R058-T002 [feat]**: Tier-1 secrets scan -
  `scripts/ci/check-secrets.sh` scans tracked files with the pattern
  list shared from `dev-secrets-guard.sh` (one home), registers in
  `run-all.sh`, ships a self-test; `DESIGN.md § Self-enforcement` and
  the doc-sync pairs updated per the new-check row.

- [x] **R058-T003 [fix]**: `is_trunk()` resolves the repo's actual
  default branch - `origin/HEAD`, then `init.defaultBranch`, then the
  `main`/`master` fallback; unresolvable → fail open; a test repo with
  a differently named trunk proves the deny.
