---
task: R051-T001
type: test
---

# R051-T001 - isolate the verifiers

Branch: `test/verifier-isolation`.

`git -C` sets the working directory and does not override `GIT_DIR`, so a
fixture isolated by `-C` alone is isolated only while nothing exports that
variable. Git exports it, absolute, to a hook running in a linked
worktree. Unsetting the three names
`companions/verification-policy.md § Verifier isolation` lists closes the
corruption: `GIT_DIR` is the one that bites today, and a fixture is safe
from the other two once they are unset with it. Other git variables do
reach a hook - `GIT_AUTHOR_*`, `GIT_INDEX_FILE`, and
`GIT_CONFIG_PARAMETERS`, which survives this scrub and injects config into
every fixture. That is a different failure (a fixture configured by its
caller, not a damaged host) and belongs to R051-T004.

Two slices, each carrying the assertion that proves it. The assertions
share one file, since both ask the same question of two invocation paths.

- [x] Runner path: `scripts/test/isolation.test.sh` asserts that a
      fixture-creating test invoked through `scripts/test/run-all.sh`
      leaves a throwaway host repository's refs and config unchanged with
      an absolute `GIT_DIR` exported, and `run-all.sh` unsets `GIT_DIR`,
      `GIT_WORK_TREE` and `GIT_INDEX_FILE` before invoking any test. The
      case must fail with the unset removed.
- [x] Direct path: the same assertion for a test invoked directly rather
      than through the runner, and each test that uses git unsets the
      three itself: `check-accretion`, `check-batch-tags`,
      `check-code-size`, `check-no-em-dash`, `check-plan-integrity`,
      `check-settings`, `context-cost`, `dev-branch-guard`,
      `secrets-guard`, `install-dev`. Scrub at file scope rather than at
      each call site, so a new fixture in an existing test inherits it.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
