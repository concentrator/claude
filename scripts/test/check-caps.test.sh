#!/usr/bin/env bash
# Tests scripts/ci/check-caps.sh - the Tier-1 size gate, mode-file tier:
# a skills/dev/*.md mode file holds to 300 lines and 80 characters a line,
# table rows exempt. Each case runs the real check in a throwaway git repo.
# Run: bash scripts/test/check-caps.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
CHECK="$(cd "$(dirname "${BASH_SOURCE[0]}")/../ci" && pwd)/check-caps.sh"
[ -f "$CHECK" ] || { echo "not ok - $CHECK not found"; exit 1; }
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

check_in()  { ( cd "$1" && bash "$CHECK" >/dev/null 2>&1 ); }
report_in() { ( cd "$1" && bash "$CHECK" 2>&1 ) || true; }
# The check reads CLAUDE.md and DESIGN.md unconditionally, so every fixture
# carries a compliant pair beside its mode file.
mkrepo() {
  local d; d=$(mktemp -d); git -C "$d" init -q
  mkdir -p "$d/skills/dev"
  printf '# x\n' > "$d/CLAUDE.md"; printf 'x\n' > "$d/DESIGN.md"
  printf '%s' "$d"
}
lines() { local n=$1; local i; for ((i = 1; i <= n; i++)); do echo "line $i"; done; }
w80=$(printf 'w%.0s' $(seq 1 80))

# 1. 301 lines -> caught, the count named
d=$(mkrepo); lines 301 > "$d/skills/dev/x.md"; git -C "$d" add -A
report_in "$d" | grep -q 'skills/dev/x.md 301 lines > 300' && pass "301 lines caught with the count" || die "301 lines not caught: $(report_in "$d")"
rm -rf "$d"

# 2. an 81-character prose line -> caught, the line number named
d=$(mkrepo); { echo "short"; echo "${w80}x"; } > "$d/skills/dev/x.md"; git -C "$d" add -A
report_in "$d" | grep -q 'skills/dev/x.md line 2: 81 characters > 80' && pass "81-character line caught with its number" || die "81-character line not caught: $(report_in "$d")"
rm -rf "$d"

# 3. an 81-character table row -> exempt, pass
d=$(mkrepo); { echo "short"; echo "| ${w80}"; } > "$d/skills/dev/x.md"; git -C "$d" add -A
check_in "$d" && pass "table row exempt from the length ceiling" || die "table row wrongly caught: $(report_in "$d")"
rm -rf "$d"

# 4. 300 lines of 80 characters -> pass
d=$(mkrepo); for ((i = 1; i <= 300; i++)); do echo "$w80"; done > "$d/skills/dev/x.md"; git -C "$d" add -A
check_in "$d" && pass "compliant mode file passes" || die "compliant file caught: $(report_in "$d")"
rm -rf "$d"

# 5. 80 characters that are more than 80 bytes -> pass (characters, not bytes)
d=$(mkrepo); printf '%s\n' "$(printf '→%.0s' $(seq 1 80))" > "$d/skills/dev/x.md"; git -C "$d" add -A
check_in "$d" && pass "multibyte line measured in characters" || die "multibyte line wrongly caught: $(report_in "$d")"
rm -rf "$d"

# 6. SKILL.md and companions are outside the tier
d=$(mkrepo); mkdir -p "$d/skills/dev/companions"
lines 301 > "$d/skills/dev/companions/c.md"; git -C "$d" add -A
check_in "$d" && pass "companion outside the tier" || die "companion wrongly caught: $(report_in "$d")"
rm -rf "$d"

[ "$fail" -eq 0 ] && echo "check-caps.test: OK"
exit "$fail"
