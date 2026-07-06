#!/usr/bin/env bash
# Tests scripts/ci/check-code-size.sh - file/function line limits on tracked
# code, with a per-path override allowlist. Each case runs the real check in a
# throwaway git repo. Run: bash scripts/test/check-code-size.test.sh
set -uo pipefail
CHECK="$(git rev-parse --show-toplevel)/scripts/ci/check-code-size.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# Run the check inside repo dir $1; returns the check's exit code.
check_in() { ( cd "$1" && bash "$CHECK" >/dev/null 2>&1 ); }
mkrepo()   { local d; d=$(mktemp -d); git -C "$d" init -q; mkdir -p "$d/scripts/ci"; printf '%s' "$d"; }

# 1. code file > 300 lines -> fail
d=$(mkrepo)
yes 'echo x' | head -301 > "$d/big.sh"; git -C "$d" add -A
check_in "$d" && die "oversized file not caught" || pass "oversized file caught"
rm -rf "$d"

# 2. shell function > 50 lines -> fail
d=$(mkrepo)
{ echo 'huge() {'; yes '  echo y' | head -60; echo '}'; } > "$d/f.sh"; git -C "$d" add -A
check_in "$d" && die "oversized shell function not caught" || pass "oversized shell function caught"
rm -rf "$d"

# 3. within limits (small file, 40-line function) -> pass
d=$(mkrepo)
{ echo 'ok() {'; yes '  echo y' | head -40; echo '}'; } > "$d/f.sh"; git -C "$d" add -A
check_in "$d" && pass "within-limits passes" || die "within-limits wrongly failed"
rm -rf "$d"

# 4. js function > 50 in a < 300-line file -> pass (js function-length is out of scope)
d=$(mkrepo)
{ echo 'function huge() {'; yes '  y();' | head -60; echo '}'; } > "$d/g.js"; git -C "$d" add -A
check_in "$d" && pass "js function-length not flagged (documented boundary)" || die "js function wrongly flagged"
rm -rf "$d"

# 5. allowlisted oversized file -> pass
d=$(mkrepo)
yes 'echo x' | head -301 > "$d/big.sh"
printf 'big.sh  # legacy, refactor later\n' > "$d/scripts/ci/code-size-allow.txt"
git -C "$d" add -A
check_in "$d" && pass "allowlisted oversized file passes" || die "allowlist not honored"
rm -rf "$d"

(( fail == 0 )) && echo "check-code-size.test: OK"
exit $fail
