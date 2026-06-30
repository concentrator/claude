#!/usr/bin/env bash
# Tests for scripts/vendor-toolchain.sh — vendors the portable DEV core
# into a target project's .claude/. Run: bash scripts/test/vendor-toolchain.test.sh
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

VENDOR="scripts/vendor-toolchain.sh"
fail=0
pass() { echo "ok - $1"; }
die() { echo "not ok - $1"; fail=1; }

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# --- run the vendor once into a fresh target ---
D="$tmp/proj/.claude"
if bash "$VENDOR" "$tmp/proj" >/dev/null 2>&1; then
  [ -d "$D" ] && pass "creates <target>/.claude" || die "no .claude created"
else
  die "vendor exits nonzero"
fi

# --- copy + prune (manifest-driven) ---
[ -f "$D/rules/planning.md" ]   && pass "portable rule copied"      || die "missing rules/planning.md"
[ -f "$D/skills/dev/SKILL.md" ] && pass "portable skill copied"     || die "missing skills/dev"
[ ! -e "$D/rules/js.md" ]       && pass "excludes js.md"            || die "js.md leaked"
[ ! -e "$D/skills/wallarm-triggers" ] && pass "excludes wallarm-*"  || die "wallarm-* leaked"

# --- path rewrite: ~/.claude/ -> .claude/ (example file protected) ---
EXAMPLE='skills/writing-skills/examples/CLAUDE_MD_TESTING.md'
resid=$(grep -rl '~/\.claude/' "$D" --exclude='CLAUDE_MD_TESTING.md' 2>/dev/null || true)
[ -z "$resid" ] && pass "no residual ~/.claude refs" \
  || die "residual ~/.claude in: $(echo "$resid" | tr '\n' ' ')"
grep -q '~/\.claude/' "$D/$EXAMPLE" && pass "example protected from rewrite" \
  || die "example refs were rewritten"

(( fail == 0 )) && echo "vendor-toolchain.test: OK"
exit $fail
