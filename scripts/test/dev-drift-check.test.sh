#!/usr/bin/env bash
# Tests for scripts/dev-drift-check.sh — source-side drift report.
# Run: bash scripts/test/dev-drift-check.test.sh
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

CHECK="$PWD/scripts/dev-drift-check.sh"
fail=0
pass() { echo "ok - $1"; }
die() { echo "not ok - $1"; fail=1; }

proj=$(mktemp -d); trap 'rm -rf "$proj"' EXIT
mkdir -p "$proj/.claude"

stamp() { printf '{"source":"%s"}\n' "$1" > "$proj/.claude/.dev-toolchain.json"; }

stamp "v1.0"
out=$(DEV_SRC_VER="v2.0" bash "$CHECK" "$proj"); echo "$out" | grep -q '^stale' \
  && pass "lagging embed → stale" || die "stale msg: $out"
out=$(DEV_SRC_VER="v1.0" bash "$CHECK" "$proj"); echo "$out" | grep -q '^up-to-date' \
  && pass "matching embed → up-to-date" || die "up-to-date msg: $out"
rm -f "$proj/.claude/.dev-toolchain.json"
out=$(DEV_SRC_VER="v1.0" bash "$CHECK" "$proj"); echo "$out" | grep -q '^unknown' \
  && pass "no stamp → unknown" || die "unknown msg: $out"

(( fail == 0 )) && echo "dev-drift-check.test: OK"
exit $fail
