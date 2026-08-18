---
approved: 2026-08-18
kind: bug
---

# R-051: Verifier isolation

## Observed behavior

Fixture git commands in `scripts/test/*.test.sh` operate on the host
repository instead of their throwaway fixture whenever `GIT_DIR` is
absolute in the environment. In one run this moved a feature branch onto
a fixture commit, layered fixture commits above it, planted five refs,
set `core.bare` to true, and overwrote a linked worktree's index. The
suite reported `ALL OK` throughout.

## Expected behavior

A verifier run leaves the host repository byte-identical, from any
invocation context.

## Reproduction steps

    git init A && git init B
    GIT_DIR="$PWD/A/.git" git -C B branch probe

`probe` is created in **A**. `git -C` sets the working directory and does
not override `GIT_DIR`, so a fixture isolated by `-C` alone is not
isolated.

Git exports `GIT_DIR` to hooks. From a primary checkout it is the
relative `.git`, which resolves against the `-C` directory and lands in
the fixture by luck; from a linked worktree it is absolute, which does
not. So `.githooks/pre-push` reproduces this from a worktree and nowhere
else.

## Impact

Silent and destructive. The suite passes while corrupting the repository
it runs in, and recovery took hand repair of a branch tip, five refs, a
config flag, and a discarded worktree.

`scripts/install-dev.sh` ships `test/check-batch-tags.test.sh` to adopter
projects, so an adopter running their gate under the same conditions gets
their repository rewritten the same way.

The defect is as old as the tests. The primary checkout's relative
`GIT_DIR` made them safe by accident rather than by design, which is why
nothing surfaced until a verifier ran from a worktree.
`companions/verification-policy.md § Verifier isolation` already requires
these three variables to be unset; no test does it.

## Acceptance criteria

- [ ] `scripts/test/run-all.sh` unsets `GIT_DIR`, `GIT_WORK_TREE` and
      `GIT_INDEX_FILE` before invoking any test, and a case proves a test
      run through it stays isolated with an absolute `GIT_DIR` in the
      environment.
- [ ] Every fixture-creating test unsets the three itself, and a case
      proves direct invocation stays isolated under the same condition.
- [ ] A full-suite run with an absolute `GIT_DIR` set leaves the host
      repository's refs, config and index unchanged, compared before and
      after; the comparison is proved to bite by running it against an
      unfixed copy.
- [ ] `scripts/test/install-dev.test.sh` asserts the shipped test scrubs
      the environment, so the fix cannot be vendored away.
- [ ] Tier-1 green: `bash scripts/ci/run-all.sh`.

## Constraints

- Isolation only. No test changes what it asserts.
- The set of files `install-dev.sh` ships is unchanged; only their
  contents.
- The scrub holds under `set -u`, which every test enables.

## Open questions

- Whether `env -i` or `GIT_CEILING_DIRECTORIES` is a better instrument
  than unsetting three named variables. Resolve in the detail round.

## References

`companions/verification-policy.md § Verifier isolation` states the rule
this initiative implements. R-049 is adjacent, covering the vendored
checks and a copyable runner rather than verifier safety. R-050 is the
initiative whose branch the defect damaged.
