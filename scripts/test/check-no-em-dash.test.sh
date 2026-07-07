#!/usr/bin/env bash
# Tests scripts/ci/check-no-em-dash.sh - the Tier-1 no-em-dash gate. The
# em-dash char is built at runtime (printf), so this tracked test source
# never contains a literal one that the gate would then flag. Each case runs
# the real check in a throwaway git repo. Run: bash scripts/test/check-no-em-dash.test.sh
set -uo pipefail
CHECK="$(git rev-parse --show-toplevel)/scripts/ci/check-no-em-dash.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

EM=$(printf '\xe2\x80\x94')   # U+2014, assembled at runtime
check_in() { ( cd "$1" && bash "$CHECK" >/dev/null 2>&1 ); }
mkrepo()   { local d; d=$(mktemp -d); git -C "$d" init -q; printf '%s' "$d"; }

# 1. em dash in a .md file -> fail
d=$(mkrepo); printf 'a %s b\n' "$EM" > "$d/f.md"; git -C "$d" add -A
check_in "$d" && die "md em dash not caught" || pass "md em dash caught"; rm -rf "$d"

# 2. em dash in a .sh file (no code exemption) -> fail
d=$(mkrepo); printf '# note %s here\n' "$EM" > "$d/s.sh"; git -C "$d" add -A
check_in "$d" && die "sh em dash not caught" || pass "sh em dash caught"; rm -rf "$d"

# 3. clean tree (hyphens only) -> pass
d=$(mkrepo); printf 'clean - hyphen only\n' > "$d/f.md"; git -C "$d" add -A
check_in "$d" && pass "clean tree passes" || die "clean tree wrongly failed"; rm -rf "$d"

# 4. binary file containing the bytes -> skipped (grep -I) -> pass
d=$(mkrepo); printf 'bin\x00%s\x00\n' "$EM" > "$d/b.bin"; git -C "$d" add -A
check_in "$d" && pass "binary file skipped" || die "binary file wrongly flagged"; rm -rf "$d"

(( fail == 0 )) && echo "check-no-em-dash.test: OK"
exit $fail
