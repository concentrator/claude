---
approved: 2026-07-08
kind: feat
---

# R-028: Self-enforcement layer hygiene

## Motivation

The self-enforcement layer has two gaps. First, the `scripts/test/*.test.sh`
suites (check-ledger, branch-guard, secrets-guard, code-size, install-dev)
run only by hand - CI runs the `check-*` gates but never the tests, so a
regression in a gate's or hook's own logic ships unnoticed. Second, the
ledger store `maintenance.d/` accumulates one stamp per PR forever, and
after a squash-merge every stamp's sha is a dead (non-ancestor) reference,
so the directory only grows.

## Goals

- CI runs the test suite as a blocking check: a `scripts/test/run-all.sh`
  runs every `*.test.sh`, wired into `ci.yml` and the pre-push mirror, so a
  broken gate, hook, or test fails the PR.
- Ledger hygiene: a `MAINTENANCE.md` Routine target plus a helper script
  prune stamps whose sha is no longer an ancestor of `main`, run on demand,
  non-blocking, with the operator reviewing before deletion.

## Non-goals

- Writing new tests for gates that lack them - only wire up the existing
  suites.
- Automated or unattended pruning, or anything pushing to protected `main`.
- Changing the ledger format or the Tier-1 check semantics (R-027).

## User experience

- Contributor: opening a PR runs the tests in CI alongside the `check-*`
  gates; a failing `.test.sh` blocks the merge. The pre-push hook mirrors it
  locally (advisory).
- Maintainer: when `maintenance.d/` grows, run the prune helper; it lists
  the dead-sha stamps and removes them after review, delivered via a normal
  PR.

## Acceptance criteria

- [ ] `scripts/test/run-all.sh` runs every `scripts/test/*.test.sh`,
  aggregates results, and fails if any suite fails; green when all pass.
- [ ] `ci.yml` runs the test suite as a required check on PRs; the pre-push
  hook mirrors it.
- [ ] A prune helper lists and removes `maintenance.d/` stamps whose `.sha`
  is not an ancestor of `HEAD`, leaves live stamps untouched, and reports
  before deleting.
- [ ] `MAINTENANCE.md § Routine` documents the `maintenance.d/` prune target
  (cadence + the helper).
- [ ] Full Tier-1 gate green + the new test-suite check green + a stamp.

## Constraints

- Tests stay hermetic (temp repos), as the existing suites are.
- Self-hosting repo infrastructure; not shipped to adopters (the installer
  does not ship these tests).
- Pruning is non-blocking and review-before-delete; it never pushes to
  protected `main`.
- Trunk-based delivery (`git-workflow.md`).

## Open questions

- CI structure: the tests as a step in the existing `tier1` job vs a
  separate required `tests` job. Settle in detail.
- Whether pre-push runs the full suite every push or a fast subset. Settle
  in detail.

## References

- Surfaced closing R-027 (the T-059 review's LOW-1 "tests not run by CI" and
  the stamp-accumulation note). Builds on R-006 (two-tier CI) and R-027 (the
  per-commit ledger store).
