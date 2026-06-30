#!/usr/bin/env bash
# Tests for vendor-toolchain.sh --update (re-vendor in place).
# Run: bash scripts/test/vendor-update.test.sh
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

VENDOR="$PWD/scripts/vendor-toolchain.sh"
fail=0
pass() { echo "ok - $1"; }
die() { echo "not ok - $1"; fail=1; }

tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
P="$tmp/proj"; D="$P/.claude"

bash "$VENDOR" "$P" >/dev/null 2>&1 || die "initial vendor failed"
# adopter additions after embedding
mkdir -p "$D/skills/my-own"; echo "x" > "$D/skills/my-own/SKILL.md"
printf '\n# adopter edit\n' >> "$D/CLAUDE.md"

# bare re-run still refused
bash "$VENDOR" "$P" >/dev/null 2>&1 && die "bare re-run not refused" || pass "bare re-run refused"

# --update succeeds
bash "$VENDOR" --update "$P" >/dev/null 2>&1 && pass "update succeeds" || die "update failed"
[ ! -e "$D/skills/dev-dev-finishing-a-branch" ] && pass "no double-prefix on update" || die "double-prefixed"
[ -d "$D/skills/dev-finishing-a-branch" ]       && pass "skills re-vendored"          || die "skills missing after update"
[ -f "$D/skills/my-own/SKILL.md" ]              && pass "adopter skill preserved"      || die "adopter skill lost"
grep -q 'adopter edit' "$D/CLAUDE.md"           && pass "adopter CLAUDE.md preserved"  || die "CLAUDE.md clobbered"
[ -f "$D/CLAUDE.md.new" ]                       && pass "fresh backbone offered as .new" || die "no CLAUDE.md.new"
[ -f "$D/.dev-toolchain.json" ]                 && pass "stamp refreshed"              || die "no stamp after update"

(( fail == 0 )) && echo "vendor-update.test: OK"
exit $fail
