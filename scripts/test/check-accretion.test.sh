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
# Fixtures declare `./` so the gate scans their root-level plans/
# (absent declaration resolves to dev/ - scripts/ci/resolve-root.sh).
mkrepo()   { local d; d=$(mktemp -d); git -C "$d" init -q; mkdir -p "$d/plans"; printf -- '- DEV artifacts root: ./\n' > "$d/CLAUDE.md"; printf '%s' "$d"; }

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

# 7. bounded punctuation separator -> fail
d=$(mkrepo); printf -- 'Superseded: 2026-07-07 by the new flow.\n' > "$d/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && die "colon separator not caught" || pass "colon separator caught"; rm -rf "$d"

# 8. resolved / shipped vocabulary -> fail with 2 hits
d=$(mkrepo); printf -- 'Resolved 2026-08-05 by the operator.\nv0.1.0 shipped 2026-06-01.\n' > "$d/plans/ROADMAP.md"
git -C "$d" add -A
out=$(cd "$d" && bash "$CHECK" 2>&1); c=$(grep -c ACCRETION <<<"$out" || true)
[ "$c" = "2" ] && pass "resolved + shipped caught" || die "resolved/shipped missed ($c of 2)"; rm -rf "$d"

# 9. sentence terminator does not bridge -> pass
d=$(mkrepo); printf -- 'Harvest is done. 2026 corpus follows.\n' > "$d/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && pass "terminator stays clean" || die "terminator wrongly bridged"; rm -rf "$d"

# 10. exempt field's trailing clause is scanned -> fail
d=$(mkrepo); mkdir -p "$d/plans/R-001-x"
printf -- '---\nstatus: done 2026-08-09; re-baselined 2026-05-05\n---\n' > "$d/plans/R-001-x/requirements.md"
git -C "$d" add -A
check_in "$d" && die "exempt-line remainder not scanned" || pass "exempt-line remainder scanned"; rm -rf "$d"

# 11. declared-root seam: absent declaration resolves to dev/ - a
# violation under dev/plans/ is caught, the same text outside it is not
d=$(mktemp -d); git -C "$d" init -q; mkdir -p "$d/plans" "$d/dev/plans"
printf -- 'Superseded: 2026-07-07 outside the root.\n' > "$d/plans/ROADMAP.md"
printf -- 'clean\n' > "$d/dev/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && pass "outside-root text exempt under default root" || die "outside-root text wrongly flagged"
printf -- 'Superseded: 2026-07-07 in the root.\n' > "$d/dev/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && die "default-root violation not caught" || pass "default-root violation caught"; rm -rf "$d"

# 12. trailing whitespace in the declaration is trimmed, gate still bites
d=$(mktemp -d); git -C "$d" init -q; mkdir -p "$d/plans"
printf -- '- DEV artifacts root: ./ \n' > "$d/CLAUDE.md"
printf -- 'Superseded: 2026-07-07 by the new flow.\n' > "$d/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && die "trailing-space declaration disabled the gate" || pass "trailing-space declaration trimmed"; rm -rf "$d"

# 13. ./-prefixed nested root: archive stays exempt, live files still scanned
d=$(mktemp -d); git -C "$d" init -q; mkdir -p "$d/sub/plans/archive/R-001-x"
printf -- '- DEV artifacts root: ./sub/\n' > "$d/CLAUDE.md"
printf -- 'superseded 2026-07-07 by R-021\n' > "$d/sub/plans/archive/R-001-x/tasks.md"
printf -- 'clean\n' > "$d/sub/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && pass "./-prefixed root: archive exempt" || die "./-prefixed root wrongly flagged archive"
printf -- 'Superseded: 2026-07-07 live.\n' > "$d/sub/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && die "./-prefixed root violation not caught" || pass "./-prefixed root violation caught"; rm -rf "$d"

# 14. a marker verb with a bare year and no full date -> not a dated
# marker (a year alone reads as a count, a key length, an id), pass
d=$(mkrepo); printf -- 'Roadmap approved 2026 targets next.\n' > "$d/plans/ROADMAP.md"
git -C "$d" add -A
check_in "$d" && pass "bare year passes" || die "bare year wrongly flagged"; rm -rf "$d"

# 15. recall verbs with full dates -> fail with 2 hits
d=$(mkrepo); printf -- 'Supersedes 2026-07-07 the old flow.\nDeferred 2026-03-02 to the next round.\n' > "$d/plans/ROADMAP.md"
git -C "$d" add -A
out=$(cd "$d" && bash "$CHECK" 2>&1); c=$(grep -c ACCRETION <<<"$out" || true)
[ "$c" = "2" ] && pass "supersedes + deferred caught" || die "recall verbs missed ($c of 2)"; rm -rf "$d"

# 16. non-ASCII filename (git quotes it under default core.quotePath) ->
# still scanned: a violation inside is caught, and the same name under
# archive/ stays exempt
d=$(mkrepo); printf -- 'Superseded: 2026-07-07 by the new flow.\n' > "$d/plans/план.md"
git -C "$d" add -A
check_in "$d" && die "quoted filename silently skipped" || pass "quoted filename scanned"
mkdir -p "$d/plans/archive"; git -C "$d" mv plans/план.md plans/archive/план.md
check_in "$d" && pass "quoted archive filename exempt" \
  || die "quoted archive filename wrongly flagged"; rm -rf "$d"

# 17. no tracked plan files under the resolved root -> loud failure, not OK
d=$(mktemp -d); git -C "$d" init -q
printf -- '- DEV artifacts root: ./\n' > "$d/CLAUDE.md"
git -C "$d" add -A
out=$(cd "$d" && bash "$CHECK" 2>&1); rc=$?
[ $rc -ne 0 ] && grep -q 'no tracked plan files' <<<"$out" \
  && pass "empty resolution fails loudly" || die "empty resolution passed vacuously"; rm -rf "$d"

(( fail == 0 )) && echo "check-accretion.test: OK"
exit $fail
