#!/usr/bin/env bash
# Tier-1 mechanical gate: run every check, aggregate, fail if any fails.
# Used by .github/workflows/ci.yml and the .githooks/pre-push hook.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0
failed=""
for c in caps code-size no-em-dash stray plan-integrity accretion todos references batch-tags; do
  echo "== check-$c =="
  bash "scripts/ci/check-$c.sh" || { fail=1; failed="$failed $c"; }
done

# The verdict is always the LAST line, both ways - a truncated or
# tail-ed reading can never mistake a failing run for a green one.
if (( fail == 0 )); then echo "run-all: ALL OK"; else echo "run-all: FAILED -$failed"; fi
exit $fail
