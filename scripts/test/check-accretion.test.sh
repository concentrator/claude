#!/usr/bin/env bash
# Tests scripts/ci/check-accretion.sh - the Tier-1 accretion gate. Each
# case runs the real check in a throwaway git repo (the gate scans
# dev/plans/**/*.md only, so this test source never trips it).
# Run: bash scripts/test/check-accretion.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
# Sibling ci/ dir, not the repo root - this pair is vendored by install-dev.sh.
CHECK="$(cd "$(dirname "${BASH_SOURCE[0]}")/../ci" && pwd)/check-accretion.sh"
[ -f "$CHECK" ] || { echo "not ok - $CHECK not found"; exit 1; }
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

check_in() { ( cd "$1" && bash "$CHECK" >/dev/null 2>&1 ); }
hits_in() { ( cd "$1" && bash "$CHECK" 2>&1 ) | grep -c ACCRETION || true; }
# Fixtures carry the fixed dev/plans/ home.
mkrepo()   { local d; d=$(mktemp -d); git -C "$d" init -q; mkdir -p "$d/dev/plans"; printf '%s' "$d"; }

# 1. dated status suffix in a living plan -> fail
d=$(mkrepo); printf -- '- [x] R-001: thing. (approved 2026-06-16)\n' > "$d/dev/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && die "dated suffix not caught" || pass "dated suffix caught"; rm -rf "$d"

# 2. the same text under plans/archive/ -> exempt, pass
d=$(mkrepo); mkdir -p "$d/dev/plans/archive/R-001-x"
printf -- 'superseded 2026-07-07 by R-021\n' > "$d/dev/plans/archive/R-001-x/tasks.md"
git -C "$d" add -A
check_in "$d" && pass "archive exempt" || die "archive wrongly flagged"; rm -rf "$d"

# 3. mandated frontmatter fields (incl. the agentic stamp) -> exempt, pass
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x"
printf -- '---\napproved: 2026-08-06\nkind: chore\nstatus: done 2026-08-06\nagentic: approved 2026-08-09\n---\n\n# R-001\n' \
  > "$d/dev/plans/R-001-x/requirements.md"
git -C "$d" add -A
check_in "$d" && pass "frontmatter exempt" || die "frontmatter wrongly flagged"; rm -rf "$d"

# 4. undated terminal outcome -> present state, pass
d=$(mkrepo); printf -- '- [x] R-019: embed - mooted by R-021 (no vendoring).\n' > "$d/dev/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && pass "undated outcome passes" || die "undated outcome wrongly flagged"; rm -rf "$d"

# 5. inline dated amendment in a living requirements -> fail
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x"
printf -- 'Node figures corrected 2026-08-01 - read before reusing.\n' > "$d/dev/plans/R-001-x/requirements.md"
git -C "$d" add -A
check_in "$d" && die "dated amendment not caught" || pass "dated amendment caught"; rm -rf "$d"

# 6. amended / re-baselined vocabulary (adopter-demonstrated) -> fail
d=$(mkrepo); printf -- 'Amended 2026-07-12: operator UI scope.\nRe-baselined 2026-06-30 to the vision.\n' > "$d/dev/plans/ROADMAP.md"
git -C "$d" add -A
c=$(hits_in "$d")
[ "$c" = "2" ] && pass "amended + re-baselined caught" || die "amended/re-baselined missed ($c of 2)"; rm -rf "$d"

# 7. bounded punctuation separator -> fail
d=$(mkrepo); printf -- 'Superseded: 2026-07-07 by the new flow.\n' > "$d/dev/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && die "colon separator not caught" || pass "colon separator caught"; rm -rf "$d"

# 8. resolved / shipped vocabulary -> fail with 2 hits
d=$(mkrepo); printf -- 'Resolved 2026-08-05 by the operator.\nv0.1.0 shipped 2026-06-01.\n' > "$d/dev/plans/ROADMAP.md"
git -C "$d" add -A
c=$(hits_in "$d")
[ "$c" = "2" ] && pass "resolved + shipped caught" || die "resolved/shipped missed ($c of 2)"; rm -rf "$d"

# 9. sentence terminator does not bridge -> pass
d=$(mkrepo); printf -- 'Harvest is done. 2026-07-07 corpus follows.\n' > "$d/dev/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && pass "terminator stays clean" || die "terminator wrongly bridged"; rm -rf "$d"

# 10. exempt field's trailing clause is scanned -> fail
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x"
printf -- '---\nstatus: done 2026-08-09; re-baselined 2026-05-05\n---\n' > "$d/dev/plans/R-001-x/requirements.md"
git -C "$d" add -A
check_in "$d" && die "exempt-line remainder not scanned" || pass "exempt-line remainder scanned"; rm -rf "$d"

# 11. only dev/plans/ is scanned: a violation there is caught, the same
# text in a root-level plans/ is not
d=$(mkrepo); mkdir -p "$d"/plans
printf -- 'Superseded: 2026-07-07 outside the home.\n' > "$d"/plans/ROADMAP.md
printf -- 'clean\n' > "$d/dev/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && pass "root-level plans/ text exempt" || die "root-level plans/ text wrongly flagged"
printf -- 'Superseded: 2026-07-07 in the home.\n' > "$d/dev/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && die "dev/plans/ violation not caught" || pass "dev/plans/ violation caught"; rm -rf "$d"

# 14. marker verb + bare year (no full date), and a verb embedded in a
# larger word (incomplete, undelivered) -> pass
d=$(mkrepo); printf -- 'Roadmap approved 2026 targets next.\nStill incomplete 2026-07-07 rows remain.\nThe undelivered 2026-07-07 items wait.\n' > "$d/dev/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && pass "bare year and embedded verbs pass" \
  || die "bare year or embedded verb wrongly flagged"; rm -rf "$d"

# 15. recall verbs with full dates, past tense included -> fail with 3 hits
d=$(mkrepo); printf -- 'Supersedes 2026-07-07 the old flow.\nDeferred 2026-03-02 to the next round.\nCompleted 2026-03-03 by ops.\n' > "$d/dev/plans/ROADMAP.md"
git -C "$d" add -A
c=$(hits_in "$d")
[ "$c" = "3" ] && pass "supersedes + deferred + completed caught" \
  || die "recall verbs missed ($c of 3)"; rm -rf "$d"

# 16. non-ASCII filename (git quotes it under default core.quotePath) ->
# still scanned: a violation inside is caught, and the same name under
# archive/ stays exempt
d=$(mkrepo); printf -- 'Superseded: 2026-07-07 by the new flow.\n' > "$d/dev/plans/plán.md"
git -C "$d" add -A
check_in "$d" && die "quoted filename silently skipped" || pass "quoted filename scanned"
mkdir -p "$d/dev/plans/archive"; git -C "$d" mv dev/plans/plán.md dev/plans/archive/plán.md
check_in "$d" && pass "quoted archive filename exempt" \
  || die "quoted archive filename wrongly flagged"; rm -rf "$d"

# 17. no tracked plan files under dev/plans/ -> loud failure, not OK
d=$(mktemp -d); git -C "$d" init -q
printf 'x\n' > "$d/README.md"; git -C "$d" add -A
out=$(cd "$d" && bash "$CHECK" 2>&1); rc=$?
[ $rc -ne 0 ] && grep -q 'no tracked plan files' <<<"$out" \
  && pass "empty home fails loudly" || die "empty home passed vacuously"; rm -rf "$d"

(( fail == 0 )) && echo "check-accretion.test: OK"
exit $fail
