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
body()     { yes '  echo y' | head -"$1"; }   # $1 indented body lines

# 1. code file > 300 lines -> fail
d=$(mkrepo); yes 'echo x' | head -301 > "$d/big.sh"; git -C "$d" add -A
check_in "$d" && die "oversized file not caught" || pass "oversized file caught"; rm -rf "$d"

# 2. shell function > 50, canonical `name() {` -> fail
d=$(mkrepo); { echo 'huge() {'; body 60; echo '}'; } > "$d/f.sh"; git -C "$d" add -A
check_in "$d" && die "canonical function not caught" || pass "canonical function caught"; rm -rf "$d"

# 3. within limits (40-line function) -> pass
d=$(mkrepo); { echo 'ok() {'; body 40; echo '}'; } > "$d/f.sh"; git -C "$d" add -A
check_in "$d" && pass "within-limits passes" || die "within-limits wrongly failed"; rm -rf "$d"

# 4. js function > 50 in a < 300-line file -> pass (js function-length out of scope)
d=$(mkrepo); { echo 'function huge() {'; body 60; echo '}'; } > "$d/g.js"; git -C "$d" add -A
check_in "$d" && pass "js function-length not flagged" || die "js function wrongly flagged"; rm -rf "$d"

# 5. allowlisted oversized file -> pass
d=$(mkrepo); yes 'echo x' | head -301 > "$d/big.sh"
printf 'big.sh  # legacy\n' > "$d/scripts/ci/code-size-allow.txt"; git -C "$d" add -A
check_in "$d" && pass "allowlisted file passes" || die "allowlist not honored"; rm -rf "$d"

# 6. trailing comment on the opener -> fail
d=$(mkrepo); { echo 'huge() {  # does stuff'; body 60; echo '}'; } > "$d/f.sh"; git -C "$d" add -A
check_in "$d" && die "trailing-comment opener not caught" || pass "trailing-comment opener caught"; rm -rf "$d"

# 7. `function name() {` combined form -> fail
d=$(mkrepo); { echo 'function huge() {'; body 60; echo '}'; } > "$d/f.sh"; git -C "$d" add -A
check_in "$d" && die "function-keyword form not caught" || pass "function-keyword form caught"; rm -rf "$d"

# 8. `function name {` (no parens) -> fail
d=$(mkrepo); { echo 'function huge {'; body 60; echo '}'; } > "$d/f.sh"; git -C "$d" add -A
check_in "$d" && die "function no-parens form not caught" || pass "function no-parens form caught"; rm -rf "$d"

# 9. indented function, close at the opener's indent -> fail
d=$(mkrepo); { echo '  inner() {'; yes '    echo y' | head -60; echo '  }'; } > "$d/f.sh"; git -C "$d" add -A
check_in "$d" && die "indented function not caught" || pass "indented function caught"; rm -rf "$d"

# 10. file of 301 lines with NO trailing newline -> fail (off-by-one guard)
d=$(mkrepo); { yes 'echo x' | head -300; printf 'echo last'; } > "$d/big.sh"; git -C "$d" add -A
check_in "$d" && die "no-newline 301-line file not caught" || pass "no-newline file caught"; rm -rf "$d"

# 11b. one-liner function with a trailing comment -> not flagged
d=$(mkrepo); { echo 'ol() { echo hi; }  # helper'; yes 'echo x' | head -10; } > "$d/f.sh"; git -C "$d" add -A
check_in "$d" && pass "one-liner with trailing comment not flagged" || die "one-liner mis-detected"; rm -rf "$d"

# 11. allowlist whose last line has no trailing newline -> exemption still honored
d=$(mkrepo); yes 'echo x' | head -400 > "$d/big.sh"
printf 'big.sh' > "$d/scripts/ci/code-size-allow.txt"   # no trailing newline
git -C "$d" add -A
check_in "$d" && pass "allowlist last line without newline honored" || die "allowlist last line dropped"; rm -rf "$d"

(( fail == 0 )) && echo "check-code-size.test: OK"
exit $fail
