#!/usr/bin/env bash
# Tests scripts/ci/check-plan-integrity.sh - the Tier-1 plan referential
# integrity gate. Each case runs the real check in a throwaway git repo, so
# this test source never trips the gate it exercises. Every violation case
# asserts both the report text and a nonzero exit, so a gate that reports
# without blocking fails the suite.
# Run: bash scripts/test/check-plan-integrity.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
# Overridable so a mutated copy can be run against these cases, confirming
# each report site has a case that fails when it breaks.
CHECK="${CHECK:-$(git rev-parse --show-toplevel)/scripts/ci/check-plan-integrity.sh}"
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

# A fixture repo with the fixed dev/plans/ home.
mkrepo() {
  local d; d=$(mktemp -d); git -C "$d" init -q
  mkdir -p "$d/dev/plans"
  printf '%s' "$d"
}
add() { git -C "$1" add -A; }   # the check reads git ls-files, not the worktree

# 1. a well-formed initiative: composite task id, resolving branch plan
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/dev/plans/R-001-x/tasks.md"
printf -- 'task: R001-T001\ntype: doc\n' > "$d/dev/plans/R-001-x/R001-T001-thing.md"
add "$d"
ok_in "$d" && pass "well-formed plans pass" || die "well-formed plans wrongly flagged"
rm -rf "$d"

# 2. legacy bare ids stay valid (plan.md § ID format: frozen, never reissued)
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] T-014 (R-001) [feat]: thing\n' > "$d/dev/plans/R-001-x/tasks.md"
printf -- 'task: T-014\ntype: feat\n' > "$d/dev/plans/R-001-x/T-014-thing.md"
add "$d"
ok_in "$d" && pass "legacy bare ids pass" || die "legacy bare ids wrongly flagged"
rm -rf "$d"

# 3. a tasks.md under an R-dir the roadmap never lists
d=$(mkrepo); mkdir -p "$d/dev/plans/R-002-y"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R002-T001 [doc]**: thing\n' > "$d/dev/plans/R-002-y/tasks.md"
add "$d"
fails_with "$d" 'R-002 not in ROADMAP' \
  && pass "unlisted R-dir caught" || die "unlisted R-dir missed"
rm -rf "$d"

# 4. a composite id whose initiative prefix contradicts its directory
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n- [ ] R-002: other.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R002-T001 [doc]**: misfiled\n' > "$d/dev/plans/R-001-x/tasks.md"
add "$d"
fails_with "$d" 'R002-T001 in .* but its dir is R-001' \
  && pass "misfiled composite id caught" || die "misfiled composite id missed"
rm -rf "$d"

# 5. a legacy id naming a different initiative than its directory
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n- [ ] R-002: other.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] T-014 (R-002) [feat]: misfiled\n' > "$d/dev/plans/R-001-x/tasks.md"
add "$d"
fails_with "$d" 'T-014 in .* names R-002 but its dir is R-001' \
  && pass "misfiled legacy id caught" || die "misfiled legacy id missed"
rm -rf "$d"

# 6. a legacy task line with no parent initiative at all
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] T-014 [feat]: parentless\n' > "$d/dev/plans/R-001-x/tasks.md"
add "$d"
fails_with "$d" 'has no parent R' \
  && pass "parentless legacy task caught" || die "parentless legacy task missed"
rm -rf "$d"

# 7. the same id in two initiatives
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x" "$d/dev/plans/R-002-y"
printf -- '- [ ] R-001: thing.\n- [ ] R-002: other.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/dev/plans/R-001-x/tasks.md"
printf -- '- [ ] **R001-T001 [doc]**: clash\n' > "$d/dev/plans/R-002-y/tasks.md"
add "$d"
fails_with "$d" 'duplicate T-id' \
  && pass "duplicate id caught" || die "duplicate id missed"
rm -rf "$d"

# 8. a branch plan whose task: resolves nowhere
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/dev/plans/R-001-x/tasks.md"
printf -- 'task: R001-T009\ntype: doc\n' > "$d/dev/plans/R-001-x/R001-T009-orphan.md"
add "$d"
fails_with "$d" 'task: R001-T009 not in any tasks.md' \
  && pass "orphan branch plan caught" || die "orphan branch plan missed"
rm -rf "$d"

# 9. a branch plan sitting under an R-dir the roadmap never lists. Its task:
# resolves against another initiative's index, isolating the dir check.
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x" "$d/dev/plans/R-002-y"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/dev/plans/R-001-x/tasks.md"
printf -- 'task: R001-T001\ntype: doc\n' > "$d/dev/plans/R-002-y/R001-T001-stray.md"
add "$d"
fails_with "$d" 'stray.md under R-002 not in ROADMAP' \
  && pass "branch plan under unlisted R caught" || die "branch plan dir check missed"
rm -rf "$d"

# 10. a composite depends-on naming a task that does not exist
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/dev/plans/R-001-x/tasks.md"
printf -- 'task: R001-T001\ndepends-on: R001-T008\n' > "$d/dev/plans/R-001-x/R001-T001-thing.md"
add "$d"
fails_with "$d" 'depends-on R001-T008 not in any tasks.md' \
  && pass "dangling composite depends-on caught" || die "dangling composite depends-on missed"
rm -rf "$d"

# 11. a legacy depends-on naming a task that does not exist
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] T-014 (R-001) [feat]: thing\n' > "$d/dev/plans/R-001-x/tasks.md"
printf -- 'task: T-014\ndepends-on: T-099\n' > "$d/dev/plans/R-001-x/T-014-thing.md"
add "$d"
fails_with "$d" 'depends-on T-099 not in any tasks.md' \
  && pass "dangling legacy depends-on caught" || die "dangling legacy depends-on missed"
rm -rf "$d"

# 12. an archived initiative is checked too, against the same roadmap
d=$(mkrepo); mkdir -p "$d/dev/plans/archive/R-003-z"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [x] **R003-T001 [doc]**: closed\n' > "$d/dev/plans/archive/R-003-z/tasks.md"
add "$d"
fails_with "$d" 'R-003 not in ROADMAP' \
  && pass "archived R still checked" || die "archived R skipped"
rm -rf "$d"

# 13. no ROADMAP under dev/plans/ -> loud failure, not OK
d=$(mkrepo)
add "$d"
fails_with "$d" 'ROADMAP.md not found' \
  && pass "missing ROADMAP fails loudly" || die "missing ROADMAP passed vacuously"
rm -rf "$d"

# 14. a CLAUDE.md still declaring an artifacts root fails with one line
# naming dev/, whatever the declared value
d=$(mkrepo)
printf -- '- DEV artifacts root: ./sub/\n' > "$d/CLAUDE.md"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
add "$d"
fails_with "$d" 'fixed at dev/' \
  && [ "$(run_in "$d" | grep -c 'PLAN:')" -eq 1 ] \
  && pass "leftover declaration fails with one line" || die "leftover declaration: $(run_in "$d")"
rm -rf "$d"

# 15. plans/ at the repo root is not the gate's tree
d=$(mkrepo); mkdir -p "$d"/plans/R-002-y "$d/dev/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/dev/plans/R-001-x/tasks.md"
printf -- '- [ ] **R002-T001 [doc]**: outside the home\n' > "$d"/plans/R-002-y/tasks.md
printf -- '- [ ] R-009: unlisted.\n' > "$d"/plans/ROADMAP.md
add "$d"
ok_in "$d" && pass "root-level plans/ ignored" \
  || die "root-level plans/ read as the home: $(run_in "$d")"
rm -rf "$d"

# 16. unified id shape (plan.md § ID format): `R062` entry, `R062-x/` dir,
# composite task and plan under it
d=$(mkrepo); mkdir -p "$d/dev/plans/R062-x"
printf -- '- [ ] R062: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R062-T001 [doc]**: thing\n' > "$d/dev/plans/R062-x/tasks.md"
printf -- 'task: R062-T001\ntype: doc\n' > "$d/dev/plans/R062-x/R062-T001-thing.md"
add "$d"
ok_in "$d" && pass "unified id shape passes" \
  || die "unified id shape wrongly flagged: $(run_in "$d")"
rm -rf "$d"

# 17. both spellings in one tree: a legacy `R-001` beside a unified `R062`,
# the archive holding one of each, a cross-shape depends-on resolving
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x" "$d/dev/plans/R062-y" \
  "$d/dev/plans/archive/R-003-z" "$d/dev/plans/archive/R050-w"
printf -- '- [ ] R-001: a.\n- [ ] R062: b.\n- [x] R-003: c.\n- [x] R050: d.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/dev/plans/R-001-x/tasks.md"
printf -- '- [ ] **R062-T001 [doc]**: thing\n' > "$d/dev/plans/R062-y/tasks.md"
printf -- 'task: R062-T001\ndepends-on: R001-T001\n' > "$d/dev/plans/R062-y/R062-T001-thing.md"
printf -- '- [x] **R003-T001 [doc]**: closed\n' > "$d/dev/plans/archive/R-003-z/tasks.md"
printf -- '- [x] **R050-T001 [doc]**: closed\n' > "$d/dev/plans/archive/R050-w/tasks.md"
add "$d"
ok_in "$d" && pass "mixed id shapes pass" \
  || die "mixed id shapes wrongly flagged: $(run_in "$d")"
rm -rf "$d"

# 18. a composite id misfiled under a unified-shape dir is still caught
d=$(mkrepo); mkdir -p "$d/dev/plans/R062-x"
printf -- '- [ ] R-001: thing.\n- [ ] R062: other.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: misfiled\n' > "$d/dev/plans/R062-x/tasks.md"
add "$d"
fails_with "$d" 'R001-T001 in .* but its dir is R062' \
  && pass "misfiled id under unified dir caught" || die "misfiled id under unified dir missed"
rm -rf "$d"

# 19. an id mentioned in another entry's prose lists no initiative
d=$(mkrepo); mkdir -p "$d/dev/plans/R062-x"
printf -- '- [ ] R-001: thing, after R062-T001 and pre-R062-B001.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R062-T001 [doc]**: thing\n' > "$d/dev/plans/R062-x/tasks.md"
add "$d"
fails_with "$d" 'R062 not in ROADMAP' \
  && pass "prose mention lists no initiative" || die "prose mention whitelisted an initiative"
rm -rf "$d"

# 20. a legacy task line whose description holds an R-like token but no
# legacy `(R-XXX)` tag is parentless, not misfiled
d=$(mkrepo); mkdir -p "$d/dev/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] T-014 [feat]: see PR393\n' > "$d/dev/plans/R-001-x/tasks.md"
add "$d"
fails_with "$d" 'T-014 in .* has no parent R' \
  && pass "untagged legacy line is parentless" || die "untagged legacy line misread: $(run_in "$d")"
rm -rf "$d"

# 21. a unified-shape dir the roadmap never lists
d=$(mkrepo); mkdir -p "$d/dev/plans/R062-x"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R062-T001 [doc]**: thing\n' > "$d/dev/plans/R062-x/tasks.md"
add "$d"
fails_with "$d" 'R062 not in ROADMAP' \
  && pass "unlisted unified dir caught" || die "unlisted unified dir missed"
rm -rf "$d"

(( fail == 0 )) && echo "check-plan-integrity.test: OK"
exit $fail
