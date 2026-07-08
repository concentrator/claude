#!/usr/bin/env bash
# Test-suite aggregator: run every scripts/test/*.test.sh, aggregate, fail if
# any fails. Complements scripts/ci/run-all.sh (the mechanical gate) so a
# regression in a gate's or hook's own logic is caught. Run by
# .github/workflows/ci.yml and the .githooks/pre-push hook.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"
shopt -s nullglob

fail=0
for t in scripts/test/*.test.sh; do
  echo "== $(basename "$t") =="
  bash "$t" || fail=1
done

(( fail == 0 )) && echo "test/run-all: ALL OK"
exit $fail
