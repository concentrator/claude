#!/usr/bin/env bash
# Tier-1: no TODO/FIXME/XXX markers in code (scripts/, .githooks/), per
# skills/dev/branch-plan.md § No TODOs. Rule/skill prose that names these
# tokens is out of scope; the [RT]-XXX plan-id placeholder is not a
# marker; this script excludes itself.
set -euo pipefail
h="$(dirname "${BASH_SOURCE[0]}")/branch-diff.sh"
{ [ -r "$h" ] && . "$h"; } \
  || { echo "check-todos: cannot load branch-diff.sh"; exit 1; }
cd "$(git rev-parse --show-toplevel)"

T=$'\t'
base=$(branch_base) || base=
hits=$(branch_added "$base" scripts .githooks ':(exclude)scripts/ci/check-todos.sh' \
  | grep -E "^[^$T]*$T[0-9]+$T.*\b(TODO|FIXME|XXX)\b" \
  | grep -vE "^[^$T]*$T[0-9]+$T.*\b[A-Z]-XXX\b" \
  | awk -F '\t' '{ line = $0; sub(/^[^\t]*\t[^\t]*\t/, "", line); print $1 ":" $2 ":" line }' || true)

if [ -n "$hits" ]; then
  echo "TODO/FIXME/XXX markers in code:"; echo "$hits"; exit 1
fi
echo "check-todos: OK"
