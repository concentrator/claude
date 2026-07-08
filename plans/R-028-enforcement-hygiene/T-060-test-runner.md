task: T-060
type: feat

# feat/test-runner - run the test suites in CI (R-028)

T-060 of `plans/R-028-enforcement-hygiene/`. CI runs the `check-*` gates but
never the `scripts/test/*.test.sh` suites, so a regression in a gate's or
hook's own logic ships unnoticed. Add a `scripts/test/run-all.sh` aggregator
and wire it into the Tier-1 CI job + the pre-push mirror. Settled: a step in
the existing `tier1` job (not a separate job); pre-push runs the full suite.

Acceptance criteria: see `requirements.md` (`run-all.sh` runs every
`*.test.sh` and fails if any fails; `ci.yml` runs it as a required check;
pre-push mirrors it; Tier-1 gate + the new test check green).

- [ ] Add `scripts/test/run-all.sh`: loop `scripts/test/*.test.sh`, run each, aggregate, fail if any fails - mirroring `scripts/ci/run-all.sh` (no parallelism, no self-run).
- [ ] Run all five suites under a clean `bash`; fix any CI-portability break (the suites have only run on macOS - they must be green on ubuntu / `C.UTF-8` before becoming blocking).
- [ ] Wire it in: a "Test suites" step in the `tier1` job of `.github/workflows/ci.yml`, and a line in `.githooks/pre-push` running the full suite after the mechanical gate.
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
