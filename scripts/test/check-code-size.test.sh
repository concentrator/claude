#!/usr/bin/env bash
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
CHECK="$(cd "$(dirname "${BASH_SOURCE[0]}")/../ci" && pwd)/check-code-size.sh"
[ -f "$CHECK" ] || { echo "not ok - $CHECK not found"; exit 1; }
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }
tmproot=$(mktemp -d); trap 'rm -rf "$tmproot"' EXIT

commit_in() {
  git -C "$1" add -A
  git -C "$1" -c user.email=t@t -c user.name=t -c commit.gpgsign=false commit -qm "$2"
}
mkrepo() { local d; d=$(TMPDIR=$tmproot mktemp -d); git -C "$d" init -q -b "${1:-main}"; echo seed > "$d/seed.txt"; printf '%s' "$d"; }
based() { commit_in "$1" base; git -C "$1" checkout -q -b feat; }
lines() { local i; for ((i = 1; i <= $1; i++)); do echo ": $i"; done; }
fn() { local i; echo "$1() {"; for ((i = 3; i <= $2; i++)); do echo "  : $i"; done; echo "}"; }
run() { out=$(cd "$1" && bash "$CHECK" 2>&1); rc=$?; }
passes() { [ "$rc" -eq 0 ] && [[ "$out" == *"check-code-size: OK"* ]] && pass "$1" || die "$1: rc=$rc [$out]"; }
fails_at() { [ "$rc" -ne 0 ] && [[ "$out" == *"$2"* ]] && pass "$1" || die "$1: rc=$rc [$out]"; }

d=$(mkrepo); lines 310 > "$d/old.sh"; lines 310 > "$d/grow.sh"; based "$d"
lines 10 >> "$d/grow.sh"; commit_in "$d" grow
run "$d"; passes "files over the cap at the base may grow"

d=$(mkrepo); lines 290 > "$d/a.sh"; based "$d"; lines 20 >> "$d/a.sh"; commit_in "$d" grow
run "$d"; fails_at "a file taken past the cap fails" "CODE-SIZE: a.sh is 310 lines > 300"

d=$(mkrepo); based "$d"; lines 301 > "$d/new.js"; commit_in "$d" add; lines 301 > "$d/untracked.sh"
run "$d"; fails_at "a file added over the cap fails" "CODE-SIZE: new.js is 301 lines > 300"
fails_at "an untracked file over the cap fails" "CODE-SIZE: untracked.sh is 301 lines > 300"

d=$(mkrepo); lines 310 > "$d/a.sh"; based "$d"; git -C "$d" mv a.sh b.sh; commit_in "$d" move
run "$d"; passes "a renamed file over the cap passes"

d=$(mkrepo); fn f 60 > "$d/a.sh"; based "$d"
{ fn f 70; fn g 5; } > "$d/a.sh"; commit_in "$d" grow
run "$d"; passes "a function over the cap at the base may grow"

d=$(mkrepo); { fn f 50; fn g 5; } > "$d/a.sh"; based "$d"
{ fn f 51; fn g 53; } > "$d/a.sh"; commit_in "$d" grow
run "$d"; fails_at "a function taken past the cap fails" "CODE-SIZE: a.sh: function f() is 51 lines > 50"
fails_at "a function grown over the cap fails" "CODE-SIZE: a.sh: function g() is 53 lines > 50"

d=$(mkrepo); fn f 60 > "$d/a.sh"; based "$d"; { fn f 60; fn h 53; } > "$d/a.sh"; commit_in "$d" add
run "$d"; fails_at "a function added over the cap fails" "CODE-SIZE: a.sh: function h() is 53 lines > 50"
[[ "$out" != *"function f"* ]] && pass "an old oversize function stays unreported" \
  || die "old oversize function reported: [$out]"

d=$(mkrepo); based "$d"; mkdir -p "$d/hooks"; lines 400 > "$d/hooks/dev-branch-guard.sh"; commit_in "$d" add
run "$d"; passes "an allowlisted path passes"

d=$(mkrepo trunk); lines 310 > "$d/old.sh"; commit_in "$d" c1
run "$d"; fails_at "no base: an old file over the cap fails" "CODE-SIZE: old.sh is 310 lines > 300"

d=$(mkrepo); lines 301 > "$d/a.sh"; fn f 53 > "$d/b.sh"; git -C "$d" add -A
run "$d"; fails_at "unborn repo: a staged file over the cap fails" "CODE-SIZE: a.sh is 301 lines > 300"
fails_at "unborn repo: a staged function over the cap fails" "CODE-SIZE: b.sh: function f() is 53 lines > 50"

d=$(mkrepo); lines 300 > "$d/a.sh"; git -C "$d" add -A
run "$d"; passes "unborn repo: a file at the cap passes"

[ "$fail" -eq 0 ] && echo "check-code-size.test: OK"
exit "$fail"
