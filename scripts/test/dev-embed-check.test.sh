#!/usr/bin/env bash
# Tests for scripts/dev-embed-check.sh — the clone-time embed-host check.
# Run: bash scripts/test/dev-embed-check.test.sh
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

CHECK="$PWD/scripts/dev-embed-check.sh"
fail=0
pass() { echo "ok - $1"; }
die() { echo "not ok - $1"; fail=1; }

proj=$(mktemp -d); gdir=$(mktemp -d)
trap 'rm -rf "$proj" "$gdir"' EXIT
mkdir -p "$proj/.claude"; echo '{"source":"x"}' > "$proj/.claude/.dev-toolchain.json"

run() { ( cd "$proj" && DEV_GLOBAL_DIR="$gdir" bash "$CHECK" 2>&1 ); }

# scenario 1: no global dev → informational, no warning
out=$(run); echo "$out" | grep -qi 'no global' && pass "no-global → informational" || die "no-global msg: $out"

# scenario 2: stale global dev (no capability marker) → warn
mkdir -p "$gdir/skills/dev"; printf '# Dev\n' > "$gdir/skills/dev/SKILL.md"
out=$(run); echo "$out" | grep -qi 'warning' && pass "stale global → warns" || die "stale msg: $out"

# scenario 3: embed-aware global dev → ok, no warning
printf '<!-- dev-embed-aware -->\n' >> "$gdir/skills/dev/SKILL.md"
out=$(run); echo "$out" | grep -qi '^ok' && pass "embed-aware → ok" || die "embed-aware msg: $out"

# scenario 4: not an embedded project → no-op
nonproj=$(mktemp -d)
out=$( cd "$nonproj" && DEV_GLOBAL_DIR="$gdir" bash "$CHECK" 2>&1 ); rm -rf "$nonproj"
echo "$out" | grep -qi 'not an embedded' && pass "non-embedded → no-op" || die "non-embedded msg: $out"

(( fail == 0 )) && echo "dev-embed-check.test: OK"
exit $fail
