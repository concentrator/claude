#!/usr/bin/env bash
# Tests scripts/ci/check-accretion.sh - the Tier-1 accretion gate. Each
# case runs the real check in a throwaway git repo (the gate scans
# plans/**/*.md only, so this test source never trips it).
# Run: bash scripts/test/check-accretion.test.sh
set -uo pipefail
CHECK="$(git rev-parse --show-toplevel)/scripts/ci/check-accretion.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

check_in() { ( cd "$1" && bash "$CHECK" >/dev/null 2>&1 ); }
mkrepo()   { local d; d=$(mktemp -d); git -C "$d" init -q; mkdir -p "$d/plans"; printf '%s' "$d"; }

# 1. dated status suffix in a living plan -> fail
d=$(mkrepo); printf -- '- [x] R-001: thing. (approved 2026-06-16)\n' > "$d/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && die "dated suffix not caught" || pass "dated suffix caught"; rm -rf "$d"

# 2. the same text under plans/archive/ -> exempt, pass
d=$(mkrepo); mkdir -p "$d/plans/archive/R-001-x"
printf -- 'superseded 2026-07-07 by R-021\n' > "$d/plans/archive/R-001-x/tasks.md"
git -C "$d" add -A
check_in "$d" && pass "archive exempt" || die "archive wrongly flagged"; rm -rf "$d"

# 3. mandated frontmatter fields (incl. the agentic stamp) -> exempt, pass
d=$(mkrepo); mkdir -p "$d/plans/R-001-x"
printf -- '---\napproved: 2026-08-06\nkind: chore\nstatus: done 2026-08-06\nagentic: approved 2026-08-09\n---\n\n# R-001\n' \
  > "$d/plans/R-001-x/requirements.md"
git -C "$d" add -A
check_in "$d" && pass "frontmatter exempt" || die "frontmatter wrongly flagged"; rm -rf "$d"

# 4. undated terminal outcome -> present state, pass
d=$(mkrepo); printf -- '- [x] R-019: embed - mooted by R-021 (no vendoring).\n' > "$d/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && pass "undated outcome passes" || die "undated outcome wrongly flagged"; rm -rf "$d"

# 5. inline dated amendment in a living requirements -> fail
d=$(mkrepo); mkdir -p "$d/plans/R-001-x"
printf -- 'Node figures corrected 2026-08-01 - read before reusing.\n' > "$d/plans/R-001-x/requirements.md"
git -C "$d" add -A
check_in "$d" && die "dated amendment not caught" || pass "dated amendment caught"; rm -rf "$d"

# 6. amended / re-baselined vocabulary (adopter-demonstrated) -> fail
d=$(mkrepo); printf -- 'Amended 2026-07-12: operator UI scope.\nRe-baselined 2026-06-30 to the vision.\n' > "$d/plans/ROADMAP.md"
git -C "$d" add -A
out=$(cd "$d" && bash "$CHECK" 2>&1); c=$(grep -c ACCRETION <<<"$out" || true)
[ "$c" = "2" ] && pass "amended + re-baselined caught" || die "amended/re-baselined missed ($c of 2)"; rm -rf "$d"

(( fail == 0 )) && echo "check-accretion.test: OK"
exit $fail
