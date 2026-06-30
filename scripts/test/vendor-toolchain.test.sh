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

# --- scaffold: a run creates <target>/.claude/ ---
if bash "$VENDOR" "$tmp/proj" >/dev/null 2>&1; then
  [ -d "$tmp/proj/.claude" ] && pass "creates <target>/.claude" \
    || die "no .claude created"
else
  die "vendor exits nonzero"
fi

(( fail == 0 )) && echo "vendor-toolchain.test: OK"
exit $fail
