#!/usr/bin/env bash
# Tier-1 mechanical gate: run every check, aggregate, fail if any fails.
# Used by .github/workflows/ci.yml and the .githooks/pre-push hook.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0
for c in caps code-size no-em-dash stray plan-integrity todos references; do
  echo "== check-$c =="
  bash "scripts/ci/check-$c.sh" || fail=1
done

(( fail == 0 )) && echo "run-all: ALL OK"
exit $fail
