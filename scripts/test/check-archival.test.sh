#!/usr/bin/env bash
# Tests scripts/ci/check-archival.sh - the Tier-1 archival gate. Each
# case runs the real check in a throwaway git repo, so this test source
# never trips the gate it exercises. Every violation case asserts both
# the report text and a nonzero exit, so a gate that reports without
# blocking fails the suite.
# Run: bash scripts/test/check-archival.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
# Overridable so a mutated copy can be run against these cases,
# confirming each report site has a case that fails when it breaks.
CHECK="${CHECK:-$(git rev-parse --show-toplevel)/scripts/ci/check-archival.sh}"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

run_in() { ( cd "$1" && bash "$CHECK" 2>&1 ); }
ok_in()  { ( cd "$1" && bash "$CHECK" >/dev/null 2>&1 ); }

# $1 = fixture repo, $2 = expected report substring. The gate must both
# report it and exit nonzero.
fails_with() {
  local out; out=$(run_in "$1")
  ok_in "$1" && return 1
  grep -q "$2" <<<"$out"
}

# A fixture repo; the check reads the working tree, no add needed.
mkrepo() {
  local d; d=$(mktemp -d); git -C "$d" init -q
  mkdir -p "$d/dev/plans"
  printf '%s' "$d"
}

# An initiative dir with the given frontmatter status line.
mkr() { # $1=repo $2=dirpath $3=status line
  mkdir -p "$1/dev/plans/$2"
  printf -- '---\napproved: 2026-09-01\n%s\nkind: feat\n---\n\n# R\n' \
    "$3" > "$1/dev/plans/$2/requirements.md"
}

# 1. an open initiative passes
d=$(mkrepo); mkr "$d" R001-x 'status: open'
ok_in "$d" && pass "open initiative passes" || die "open initiative wrongly flagged"
rm -rf "$d"

# 2. a closed initiative still outside archive/ fails, naming it
d=$(mkrepo); mkr "$d" R001-x 'status: done 2026-09-01'
fails_with "$d" 'R001-x' \
  && pass "done-unarchived caught" || die "done-unarchived missed"
rm -rf "$d"

# 3. the failure line states the remedy
d=$(mkrepo); mkr "$d" R001-x 'status: done 2026-09-01'
fails_with "$d" 'archive' \
  && pass "remedy named" || die "remedy not named"
rm -rf "$d"

# 4. a closed initiative under archive/ is exempt
d=$(mkrepo); mkr "$d" archive/R001-x 'status: done 2026-09-01'
ok_in "$d" && pass "archived initiative exempt" || die "archived initiative wrongly flagged"
rm -rf "$d"

# 5. a deferred closure is exempt and the reason is printed
d=$(mkrepo); mkr "$d" R001-x 'status: done 2026-09-01
archival: deferred - docs remediation owns the disposition'
out=$(run_in "$d")
if ok_in "$d" && grep -q 'docs remediation owns the disposition' <<<"$out"; then
  pass "deferred closure exempt, reason printed"
else
  die "deferred closure mishandled"
fi
rm -rf "$d"

# 6. a defer marker with no reason fails
d=$(mkrepo); mkr "$d" R001-x 'status: done 2026-09-01
archival: deferred'
fails_with "$d" 'reason' \
  && pass "reasonless deferral caught" || die "reasonless deferral missed"
rm -rf "$d"

# 7. frontmatter with no closing --- fails loudly
d=$(mkrepo); mkdir -p "$d/dev/plans/R001-x"
printf -- '---\nstatus: done 2026-09-01\n' > "$d/dev/plans/R001-x/requirements.md"
fails_with "$d" 'frontmatter' \
  && pass "malformed frontmatter caught" || die "malformed frontmatter missed"
rm -rf "$d"

(( fail == 0 )) && echo "check-archival.test: OK"
exit $fail
