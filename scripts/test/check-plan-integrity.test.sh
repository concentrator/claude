#!/usr/bin/env bash
# Tests scripts/ci/check-plan-integrity.sh - the Tier-1 plan referential
# integrity gate. Each case runs the real check in a throwaway git repo, so
# this test source never trips the gate it exercises.
# Run: bash scripts/test/check-plan-integrity.test.sh
set -uo pipefail
# Overridable so a mutated copy can be run against these cases, confirming
# each one fails when the behavior it guards breaks.
CHECK="${CHECK:-$(git rev-parse --show-toplevel)/scripts/ci/check-plan-integrity.sh}"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

run_in() { ( cd "$1" && bash "$CHECK" 2>&1 ); }
ok_in()  { ( cd "$1" && bash "$CHECK" >/dev/null 2>&1 ); }

# A fixture repo declaring `./`, so the gate reads its root-level plans/
# (absent declaration resolves to dev/ - scripts/ci/resolve-root.sh).
mkrepo() {
  local d; d=$(mktemp -d); git -C "$d" init -q
  mkdir -p "$d/plans"; printf -- '- DEV artifacts root: ./\n' > "$d/CLAUDE.md"
  printf '%s' "$d"
}
add() { git -C "$1" add -A; }   # the check reads git ls-files, not the worktree

# 1. a well-formed initiative: composite task id, resolving branch plan
d=$(mkrepo); mkdir -p "$d/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/plans/R-001-x/tasks.md"
printf -- 'task: R001-T001\ntype: doc\n' > "$d/plans/R-001-x/R001-T001-thing.md"
add "$d"
ok_in "$d" && pass "well-formed plans pass" || die "well-formed plans wrongly flagged"
rm -rf "$d"

# 2. legacy bare ids stay valid (plan.md § ID format: frozen, never reissued)
d=$(mkrepo); mkdir -p "$d/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/plans/ROADMAP.md"
printf -- '- [ ] T-014 (R-001) [feat]: thing\n' > "$d/plans/R-001-x/tasks.md"
printf -- 'task: T-014\ntype: feat\n' > "$d/plans/R-001-x/T-014-thing.md"
add "$d"
ok_in "$d" && pass "legacy bare ids pass" || die "legacy bare ids wrongly flagged"
rm -rf "$d"

# 3. a tasks.md under an R-dir the roadmap never lists
d=$(mkrepo); mkdir -p "$d/plans/R-002-y"
printf -- '- [ ] R-001: thing.\n' > "$d/plans/ROADMAP.md"
printf -- '- [ ] **R002-T001 [doc]**: thing\n' > "$d/plans/R-002-y/tasks.md"
add "$d"
grep -q 'R-002 not in ROADMAP' <<<"$(run_in "$d")" \
  && pass "unlisted R-dir caught" || die "unlisted R-dir missed"
rm -rf "$d"

# 4. a composite id whose initiative prefix contradicts its directory
d=$(mkrepo); mkdir -p "$d/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n- [ ] R-002: other.\n' > "$d/plans/ROADMAP.md"
printf -- '- [ ] **R002-T001 [doc]**: misfiled\n' > "$d/plans/R-001-x/tasks.md"
add "$d"
grep -q 'R002-T001 in .* but its dir is R-001' <<<"$(run_in "$d")" \
  && pass "misfiled task id caught" || die "misfiled task id missed"
rm -rf "$d"

# 5. the same id in two initiatives
d=$(mkrepo); mkdir -p "$d/plans/R-001-x" "$d/plans/R-002-y"
printf -- '- [ ] R-001: thing.\n- [ ] R-002: other.\n' > "$d/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/plans/R-001-x/tasks.md"
printf -- '- [ ] **R001-T001 [doc]**: clash\n' > "$d/plans/R-002-y/tasks.md"
add "$d"
grep -q 'duplicate T-id' <<<"$(run_in "$d")" \
  && pass "duplicate id caught" || die "duplicate id missed"
rm -rf "$d"

# 6. a branch plan whose task: resolves nowhere
d=$(mkrepo); mkdir -p "$d/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/plans/R-001-x/tasks.md"
printf -- 'task: R001-T009\ntype: doc\n' > "$d/plans/R-001-x/R001-T009-orphan.md"
add "$d"
grep -q 'task: R001-T009 not in any tasks.md' <<<"$(run_in "$d")" \
  && pass "orphan branch plan caught" || die "orphan branch plan missed"
rm -rf "$d"

# 7. a depends-on naming a task that does not exist
d=$(mkrepo); mkdir -p "$d/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/plans/R-001-x/tasks.md"
printf -- 'task: R001-T001\ndepends-on: R001-T008\n' > "$d/plans/R-001-x/R001-T001-thing.md"
add "$d"
grep -q 'depends-on R001-T008 not in any tasks.md' <<<"$(run_in "$d")" \
  && pass "dangling depends-on caught" || die "dangling depends-on missed"
rm -rf "$d"

# 8. an archived initiative is checked too, against the same roadmap
d=$(mkrepo); mkdir -p "$d/plans/archive/R-003-z"
printf -- '- [ ] R-001: thing.\n' > "$d/plans/ROADMAP.md"
printf -- '- [x] **R003-T001 [doc]**: closed\n' > "$d/plans/archive/R-003-z/tasks.md"
add "$d"
grep -q 'R-003 not in ROADMAP' <<<"$(run_in "$d")" \
  && pass "archived R still checked" || die "archived R skipped"
rm -rf "$d"

# 9. root seam: no ROADMAP under the resolved root -> loud failure, not OK
d=$(mkrepo)
add "$d"
out=$(run_in "$d")
grep -q 'ROADMAP.md not found' <<<"$out" && ! ok_in "$d" \
  && pass "missing ROADMAP fails loudly" || die "missing ROADMAP passed vacuously"
rm -rf "$d"

# 10. root seam: the guard names the resolved root, so a misdeclared root is
# diagnosable rather than silently empty
d=$(mktemp -d); git -C "$d" init -q; mkdir -p "$d/sub/plans"
printf -- '- DEV artifacts root: ./sub/\n' > "$d/CLAUDE.md"
printf -- 'placeholder\n' > "$d/sub/plans/keep.md"
add "$d"
grep -q "resolved artifacts root: 'sub'" <<<"$(run_in "$d")" \
  && pass "guard names the resolved root" || die "guard hid the resolved root"
rm -rf "$d"

# 11. root seam: attribution strips the root, not the first R-id in the path.
# A nested root whose own directory looks like an R-dir must not be read as
# the owning initiative of the plans inside it.
d=$(mktemp -d); git -C "$d" init -q; mkdir -p "$d/R-999-root/plans/R-001-x"
printf -- '- DEV artifacts root: ./R-999-root/\n' > "$d/CLAUDE.md"
printf -- '- [ ] R-001: thing.\n' > "$d/R-999-root/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/R-999-root/plans/R-001-x/tasks.md"
printf -- 'task: R001-T001\ntype: doc\n' > "$d/R-999-root/plans/R-001-x/R001-T001-thing.md"
add "$d"
ok_in "$d" && pass "nested root attributed to the inner R" \
  || die "nested root misattributed: $(run_in "$d")"
rm -rf "$d"

# 12. the same nested root still reports a genuine mismatch inside it
d=$(mktemp -d); git -C "$d" init -q; mkdir -p "$d/R-999-root/plans/R-001-x"
printf -- '- DEV artifacts root: ./R-999-root/\n' > "$d/CLAUDE.md"
printf -- '- [ ] R-001: thing.\n- [ ] R-002: other.\n' > "$d/R-999-root/plans/ROADMAP.md"
printf -- '- [ ] **R002-T001 [doc]**: misfiled\n' > "$d/R-999-root/plans/R-001-x/tasks.md"
add "$d"
grep -q 'but its dir is R-001' <<<"$(run_in "$d")" \
  && pass "nested root still catches mismatch" || die "nested root hid a mismatch"
rm -rf "$d"

# 13. root seam: absent declaration resolves to dev/, so plans/ at the repo
# root is not the gate's tree
d=$(mktemp -d); git -C "$d" init -q; mkdir -p "$d/plans/R-002-y" "$d/dev/plans/R-001-x"
printf -- '- [ ] R-001: thing.\n' > "$d/dev/plans/ROADMAP.md"
printf -- '- [ ] **R001-T001 [doc]**: thing\n' > "$d/dev/plans/R-001-x/tasks.md"
printf -- '- [ ] **R002-T001 [doc]**: outside the root\n' > "$d/plans/R-002-y/tasks.md"
printf -- '- [ ] R-009: unlisted.\n' > "$d/plans/ROADMAP.md"
add "$d"
ok_in "$d" && pass "default root ignores outside-root plans" \
  || die "default root read the wrong tree: $(run_in "$d")"
rm -rf "$d"

(( fail == 0 )) && echo "check-plan-integrity.test: OK"
exit $fail
