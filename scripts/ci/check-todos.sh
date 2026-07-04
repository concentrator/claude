#!/usr/bin/env bash
# Tier-1: no TODO/FIXME/XXX markers in code (scripts/, .githooks/), per
# skills/dev/branch-plan.md § No TODOs. Rule/skill prose that names these
# tokens is out of scope; the [RT]-XXX plan-id placeholder is not a
# marker; this script excludes itself.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

files=$(git ls-files scripts .githooks 2>/dev/null | grep -v 'scripts/ci/check-todos.sh' || true)
hits=""
[ -n "$files" ] && hits=$(echo "$files" | xargs grep -nE '\b(TODO|FIXME|XXX)\b' 2>/dev/null \
  | grep -vE '\b[A-Z]-XXX\b' || true)

if [ -n "$hits" ]; then
  echo "TODO/FIXME/XXX markers in code:"; echo "$hits"; exit 1
fi
echo "check-todos: OK"
