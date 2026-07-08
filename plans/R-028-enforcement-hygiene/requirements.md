---
approved: 2026-07-08
kind: feat
status: done 2026-07-08
---

# R-028: Self-enforcement layer hygiene

## Motivation

The `scripts/test/*.test.sh` suites (branch-guard, secrets-guard,
code-size, install-dev) run only by hand - CI runs the `check-*` gates but
never the tests, so a regression in a gate's or hook's own logic ships
unnoticed.

## Goals

- CI runs the test suite as a blocking check: a `scripts/test/run-all.sh`
  runs every `*.test.sh`, wired into `ci.yml` and the pre-push mirror, so a
  broken gate, hook, or test fails the PR.

## Non-goals

- Writing new tests for gates that lack them - only wire up the existing
  suites.

## User experience

- Contributor: opening a PR runs the tests in CI alongside the `check-*`
  gates; a failing `.test.sh` blocks the merge. The pre-push hook mirrors it
  locally (advisory).

## Acceptance criteria

- [x] `scripts/test/run-all.sh` runs every `scripts/test/*.test.sh`,
  aggregates results, and fails if any suite fails; green when all pass.
  *Aggregator mirrors `scripts/ci/run-all.sh` (nullglob loop, aggregate);
  runs all 5 suites (T-060).*
- [x] `ci.yml` runs the test suite as a required check on PRs; the pre-push
  hook mirrors it.
  *A "Test suites" step in the `tier1` job; pre-push runs mechanical then
  suites (T-060).*
- [x] Full Tier-1 gate green + the new test-suite check green.
  *#154 merged on a green gate; the 5 suites passed on ubuntu/`C.UTF-8`
  (their first run outside macOS) (T-060).*

## Constraints

- Tests stay hermetic (temp repos), as the existing suites are.
- Self-hosting repo infrastructure; not shipped to adopters (the installer
  does not ship these tests).
- Trunk-based delivery (`git-workflow.md`).

## Open questions

- CI structure: the tests as a step in the existing `tier1` job vs a
  separate required `tests` job. Settle in detail.
- Whether pre-push runs the full suite every push or a fast subset. Settle
  in detail.

## References

- Surfaced closing R-027 (the T-059 review's LOW-1 "tests not run by CI").
  Builds on R-006 (two-tier CI).
