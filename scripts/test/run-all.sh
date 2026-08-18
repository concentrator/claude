#!/usr/bin/env bash
# Test-suite aggregator: run every scripts/test/*.test.sh, aggregate, fail if
# any fails. Complements scripts/ci/run-all.sh (the mechanical gate) so a
# regression in a gate's or hook's own logic is caught. Run by
# .github/workflows/ci.yml and the .githooks/pre-push hook.
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
# Resolved from this file, not by git discovery: discovery writes nothing to
# stdout when it fails, `cd ""` succeeds without moving, and nullglob then
# turns a zero-test run into ALL OK.
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)" || exit 1
shopt -s nullglob

fail=0
ran=0
for t in scripts/test/*.test.sh; do
  echo "== $(basename "$t") =="
  bash "$t" || fail=1
  ran=$((ran + 1))
done

if (( ran == 0 )); then
  echo "test/run-all: no tests found - refusing to report a pass" >&2
  fail=1
fi
(( fail == 0 )) && echo "test/run-all: ALL OK"
exit $fail
