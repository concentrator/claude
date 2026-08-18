#!/usr/bin/env bash
# Tests scripts/ci/check-batch-tags.sh - the Tier-1 batch-ref gate.
# Each case runs the real check in a throwaway git repo whose local
# tags, batch/* refs, and trunk-committed plans/ tree stand in for the
# states the gate judges. Detection cases run with CI unset so the
# gate's own environment never skips them.
# Run: bash scripts/test/check-batch-tags.test.sh
set -uo pipefail
# Fixtures here are isolated by `git -C`, which does not override GIT_DIR.
# Scrubbed at file scope so every fixture in this file inherits it.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
# Sibling ci/ dir, not the repo root - this pair is vendored by install-dev.sh.
CHECK="$(cd "$(dirname "${BASH_SOURCE[0]}")/../ci" && pwd)/check-batch-tags.sh"
[ -f "$CHECK" ] || { echo "not ok - $CHECK not found"; exit 1; }
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

out_in() { ( cd "$1" && env -u CI bash "$CHECK" 2>&1 ); }
# Fixtures declare `./` so the gate reads their root-level plans/; the
# trunk is pinned to main so trunk resolution is machine-independent.
mkrepo() {
  local d; d=$(mktemp -d); git -C "$d" init -q -b main
  printf -- '- DEV artifacts root: ./\n' > "$d/CLAUDE.md"
  git -C "$d" add -A
  git -C "$d" -c user.email=t@t -c user.name=t commit -qm init
  printf '%s' "$d"
}
commit_in() { git -C "$1" add -A; git -C "$1" -c user.email=t@t -c user.name=t commit -qm "$2"; }
# Batch fixtures: report (stale) or manifest only (live) on the trunk,
# plus the ref the trailing git args create (e.g. `tag pre-R042-B-001`).
mkstale() {
  local d; d=$(mkrepo); mkdir -p "$d/plans/R-042-pocs/batches"
  printf 'report\n' > "$d/plans/R-042-pocs/batches/B-001.report.md"
  commit_in "$d" report; git -C "$d" "$@"
  printf '%s' "$d"
}
mklive() {
  local d; d=$(mkrepo); mkdir -p "$d/plans/R-042-pocs/batches"
  printf -- '# B-001\n' > "$d/plans/R-042-pocs/batches/B-001.md"
  commit_in "$d" manifest; git -C "$d" "$@"
  printf '%s' "$d"
}

# 1. anchor whose report the trunk carries -> fail, naming tag,
#    initiative, report
d=$(mkstale tag pre-R042-B-001)
out=$(out_in "$d"); rc=$?
[ $rc -ne 0 ] && grep -q 'pre-R042-B-001' <<<"$out" && grep -q 'R-042' <<<"$out" \
  && grep -q 'B-001\.report\.md' <<<"$out" \
  && pass "stale anchor caught, naming tag, initiative, report" \
  || die "stale anchor missed or output incomplete: $out"; rm -rf "$d"

# 2. report under plans/archive/ -> still a closed batch, fail
d=$(mkrepo); mkdir -p "$d/plans/archive/R-005-cost/batches"
printf 'report\n' > "$d/plans/archive/R-005-cost/batches/B-001.report.md"
commit_in "$d" report; git -C "$d" tag pre-R005-B-001
out_in "$d" >/dev/null && die "archived-report anchor not caught" \
  || pass "archived-report anchor caught"; rm -rf "$d"

# 3. live anchor - manifest on the trunk, no report -> pass
d=$(mklive tag pre-R042-B-001)
out_in "$d" >/dev/null && pass "live anchor passes" \
  || die "live anchor wrongly flagged"; rm -rf "$d"

# 4. halt state - report written but uncommitted -> not on the trunk, pass
d=$(mklive tag pre-R042-B-001)
printf 'report\n' > "$d/plans/R-042-pocs/batches/B-001.report.md"
out_in "$d" >/dev/null && pass "uncommitted report passes" \
  || die "uncommitted report wrongly flagged"; rm -rf "$d"

# 5. accept push - report committed on the batch branch only, checked
#    out -> trunk still clean, pass
d=$(mklive tag pre-R042-B-001)
git -C "$d" checkout -q -b batch/R042-B-001
printf 'report\n' > "$d/plans/R-042-pocs/batches/B-001.report.md"
commit_in "$d" report
out_in "$d" >/dev/null && pass "batch-branch report passes" \
  || die "batch-branch report wrongly flagged"; rm -rf "$d"

# 6. legacy flat pre-B-* tag -> unresolvable, fail
d=$(mkrepo); git -C "$d" tag pre-B-001
out=$(out_in "$d"); rc=$?
[ $rc -ne 0 ] && grep -q 'pre-B-001' <<<"$out" \
  && grep -q 'pre-R<NNN>-B-XXX' <<<"$out" \
  && pass "legacy flat tag caught, naming the expected form" \
  || die "legacy flat tag not caught: $out"; rm -rf "$d"

# 7. malformed widths and the literal placeholder -> unresolvable, fail
d=$(mkrepo); git -C "$d" tag pre-R42-B-1; git -C "$d" tag pre-R044-B-XXX
out=$(out_in "$d"); rc=$?
[ $rc -ne 0 ] && grep -q 'pre-R42-B-1' <<<"$out" \
  && grep -q 'pre-R044-B-XXX' <<<"$out" \
  && pass "malformed tags caught" || die "malformed tags not caught: $out"
rm -rf "$d"

# 8. composite anchor naming an initiative absent from the trunk -> fail
d=$(mkrepo); git -C "$d" tag pre-R099-B-001
out_in "$d" >/dev/null && die "unknown-initiative anchor not caught" \
  || pass "unknown-initiative anchor caught"; rm -rf "$d"

# 9. tag-free tree -> pass with the OK line
d=$(mkrepo)
out=$(out_in "$d"); rc=$?
[ $rc -eq 0 ] && grep -q 'check-batch-tags: OK' <<<"$out" \
  && pass "clean tree passes with OK" || die "clean tree not OK: $out"
rm -rf "$d"

# 10. $CI truthy -> skip line and exit 0 even over a stale anchor, never OK
d=$(mkstale tag pre-R042-B-001)
out=$( ( cd "$d" && env CI=1 bash "$CHECK" 2>&1 ) ); rc=$?
[ $rc -eq 0 ] && grep -q 'check-batch-tags: SKIP (batch refs not visible)' <<<"$out" \
  && ! grep -q 'check-batch-tags: OK' <<<"$out" \
  && pass "CI env skips loudly" || die "CI env did not skip: $out"

# 11. CI=false is not CI -> the gate still enforces (same stale fixture)
out=$( ( cd "$d" && env CI=false bash "$CHECK" 2>&1 ) ); rc=$?
[ $rc -ne 0 ] && pass "CI=false still enforces" \
  || die "CI=false wrongly skipped: $out"; rm -rf "$d"

# 12. batch branch whose report the trunk carries -> fail, naming
#     branch and report (repo kept for case 13's clone)
stale=$(mkstale branch batch/R042-B-001)
out=$(out_in "$stale"); rc=$?
[ $rc -ne 0 ] && grep -q 'batch/R042-B-001' <<<"$out" \
  && grep -q 'B-001\.report\.md' <<<"$out" \
  && pass "stale batch branch caught" \
  || die "stale batch branch missed: $out"

# 13. the same staleness seen through a remote-tracking ref -> fail,
#     with the prune remedy named
d=$(mktemp -d); git clone -q "$stale" "$d"
out=$(out_in "$d"); rc=$?
[ $rc -ne 0 ] && grep -q 'batch/R042-B-001' <<<"$out" \
  && grep -q 'fetch --prune' <<<"$out" \
  && pass "remote-tracking batch ref caught with prune remedy" \
  || die "remote-tracking batch ref missed: $out"; rm -rf "$stale" "$d"

# 14. live batch branch - manifest on the trunk, no report -> pass
d=$(mklive branch batch/R042-B-001)
out_in "$d" >/dev/null && pass "live batch branch passes" \
  || die "live batch branch wrongly flagged"; rm -rf "$d"

# 15. flat, malformed, and nested batch branches -> unresolvable, fail
d=$(mkrepo); git -C "$d" branch batch/B-001
git -C "$d" branch batch/R42-B-1; git -C "$d" branch batch/R042/B-001
out=$(out_in "$d"); rc=$?
[ $rc -ne 0 ] && grep -q 'batch/B-001' <<<"$out" \
  && grep -q 'batch/R42-B-1' <<<"$out" \
  && grep -q 'batch/R042/B-001' <<<"$out" \
  && pass "flat, malformed, nested batch branches caught" \
  || die "flat/malformed/nested batch branches not caught: $out"; rm -rf "$d"

# 16. shallow clone -> the same skip line, exit 0
src=$(mkrepo); d=$(mktemp -d)
git clone -q --depth 1 "file://$src" "$d"
out=$(out_in "$d"); rc=$?
[ $rc -eq 0 ] && grep -q 'check-batch-tags: SKIP (batch refs not visible)' <<<"$out" \
  && pass "shallow clone skips loudly" || die "shallow clone did not skip: $out"
rm -rf "$src" "$d"

(( fail == 0 )) && echo "check-batch-tags.test: OK"
exit $fail
