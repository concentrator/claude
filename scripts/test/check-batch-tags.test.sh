#!/usr/bin/env bash
# Tests scripts/ci/check-batch-tags.sh - the Tier-1 batch-anchor gate.
# Each case runs the real check in a throwaway git repo whose local tags
# and plans/ tree stand in for the states the gate judges. Detection
# cases run with CI unset so the gate's own environment never skips them.
# Run: bash scripts/test/check-batch-tags.test.sh
set -uo pipefail
CHECK="$(git rev-parse --show-toplevel)/scripts/ci/check-batch-tags.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

check_in() { ( cd "$1" && env -u CI bash "$CHECK" >/dev/null 2>&1 ); }
out_in()   { ( cd "$1" && env -u CI bash "$CHECK" 2>&1 ); }
# Fixtures declare `./` so the gate scans their root-level plans/; the
# initial commit gives tags a target.
mkrepo() {
  local d; d=$(mktemp -d); git -C "$d" init -q
  mkdir -p "$d/plans"
  printf -- '- DEV artifacts root: ./\n' > "$d/CLAUDE.md"
  git -C "$d" add -A
  git -C "$d" -c user.email=t@t -c user.name=t commit -qm init
  printf '%s' "$d"
}

# 1. anchor whose batch has a report -> fail, naming tag, initiative, report
d=$(mkrepo); mkdir -p "$d/plans/R-042-pocs/batches"
printf 'report\n' > "$d/plans/R-042-pocs/batches/B-001.report.md"
git -C "$d" tag pre-R042-B-001
check_in "$d" && die "stale anchor not caught" || pass "stale anchor caught"
out=$(out_in "$d")
grep -q 'pre-R042-B-001' <<<"$out" && grep -q 'R-042' <<<"$out" \
  && grep -q 'B-001\.report\.md' <<<"$out" \
  && pass "failure names tag, initiative, report" \
  || die "failure output incomplete: $out"; rm -rf "$d"

# 2. report under plans/archive/ -> still a closed batch, fail
d=$(mkrepo); mkdir -p "$d/plans/archive/R-005-cost/batches"
printf 'report\n' > "$d/plans/archive/R-005-cost/batches/B-001.report.md"
git -C "$d" tag pre-R005-B-001
check_in "$d" && die "archived-report anchor not caught" \
  || pass "archived-report anchor caught"; rm -rf "$d"

# 3. live anchor - manifest exists, no report -> pass
d=$(mkrepo); mkdir -p "$d/plans/R-042-pocs/batches"
printf -- '# B-001\n' > "$d/plans/R-042-pocs/batches/B-001.md"
git -C "$d" tag pre-R042-B-001
check_in "$d" && pass "live anchor passes" || die "live anchor wrongly flagged"
rm -rf "$d"

# 4. tag-free tree -> pass with the OK line
d=$(mkrepo)
out=$(out_in "$d"); rc=$?
[ $rc -eq 0 ] && grep -q 'check-batch-tags: OK' <<<"$out" \
  && pass "clean tree passes with OK" || die "clean tree not OK: $out"
rm -rf "$d"

# 5. $CI set -> skip line and exit 0 even over a stale anchor, never OK
d=$(mkrepo); mkdir -p "$d/plans/R-042-pocs/batches"
printf 'report\n' > "$d/plans/R-042-pocs/batches/B-001.report.md"
git -C "$d" tag pre-R042-B-001
out=$( ( cd "$d" && env CI=1 bash "$CHECK" 2>&1 ) ); rc=$?
[ $rc -eq 0 ] && grep -q 'check-batch-tags: SKIP (tags not visible)' <<<"$out" \
  && ! grep -q 'check-batch-tags: OK' <<<"$out" \
  && pass "CI env skips loudly" || die "CI env did not skip: $out"; rm -rf "$d"

# 6. shallow clone -> the same skip line, exit 0
src=$(mkrepo); d=$(mktemp -d); rm -rf "$d"
git clone -q --depth 1 "file://$src" "$d"
out=$(out_in "$d"); rc=$?
[ $rc -eq 0 ] && grep -q 'check-batch-tags: SKIP (tags not visible)' <<<"$out" \
  && pass "shallow clone skips loudly" || die "shallow clone did not skip: $out"
rm -rf "$src" "$d"

# 7. legacy flat pre-B-* tag -> unresolvable, fail even with no report
d=$(mkrepo); mkdir -p "$d/plans/R-042-pocs/batches"
printf -- '# B-001\n' > "$d/plans/R-042-pocs/batches/B-001.md"
git -C "$d" tag pre-B-001
out=$(out_in "$d"); rc=$?
[ $rc -ne 0 ] && grep -q 'pre-B-001' <<<"$out" \
  && pass "legacy flat tag caught" || die "legacy flat tag not caught: $out"
rm -rf "$d"

(( fail == 0 )) && echo "check-batch-tags.test: OK"
exit $fail
