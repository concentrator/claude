#!/usr/bin/env bash
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
CHECK="$(cd "$(dirname "${BASH_SOURCE[0]}")/../ci" && pwd)/check-todos.sh"
[ -f "$CHECK" ] || { echo "not ok - $CHECK not found"; exit 1; }
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }
tmproot=$(mktemp -d); trap 'rm -rf "$tmproot"' EXIT
TD=TO; TD="${TD}DO"
FX=FIX; FX="${FX}ME"
X3=XX; X3="${X3}X"

commit_in() {
  git -C "$1" add -A
  git -C "$1" -c user.email=t@t -c user.name=t -c commit.gpgsign=false commit -qm "$2"
}
mkrepo() { local d; d=$(TMPDIR=$tmproot mktemp -d); git -C "$d" init -q -b "${1:-main}"; printf '%s' "$d"; }
branched() {
  local d; d=$(mkrepo)
  mkdir -p "$d/scripts/ci" "$d/.githooks" "$d/docs"
  printf '# %s old\n' "$TD" > "$d/scripts/old.sh"
  printf '# %s old\nplain\n' "$FX" > "$d/scripts/touched.sh"
  printf 'plain\n' > "$d/.githooks/pre-push"
  printf 'plain\n' > "$d/scripts/ci/check-todos.sh"
  printf 'plain\n' > "$d/docs/notes.md"
  commit_in "$d" base; git -C "$d" checkout -q -b feat
  printf '%s' "$d"
}
run() { out=$(cd "$1" && bash "$CHECK" 2>&1); rc=$?; }
passes() { [ "$rc" -eq 0 ] && [[ "$out" == *"check-todos: OK"* ]] && pass "$1" || die "$1: rc=$rc [$out]"; }
fails_at() { [ "$rc" -ne 0 ] && [[ "$out" == *"$2"* ]] && pass "$1" || die "$1: rc=$rc [$out]"; }

d=$(branched); printf 'more\n' >> "$d/scripts/touched.sh"; commit_in "$d" grow
run "$d"; passes "an old hit in an untouched and a touched file passes"

d=$(branched); printf '# %s new\n' "$FX" >> "$d/.githooks/pre-push"; commit_in "$d" grow
run "$d"; fails_at "an added hit fails at its line" ".githooks/pre-push:2:# $FX new"

d=$(branched); printf '# %s u\n' "$TD" > "$d/scripts/new.sh"
run "$d"; fails_at "an untracked hit fails" "scripts/new.sh:1:# $TD u"

d=$(branched)
printf '%s new\n' "$TD" >> "$d/docs/notes.md"
printf '# R-%s id\n' "$X3" >> "$d/scripts/touched.sh"
printf '# %s self\n' "$X3" >> "$d/scripts/ci/check-todos.sh"
commit_in "$d" grow
run "$d"; passes "an added hit outside scope, a placeholder id and the gate itself pass"

d=$(mkrepo trunk); mkdir -p "$d/scripts"; printf '# %s old\n' "$TD" > "$d/scripts/old.sh"; commit_in "$d" c1
run "$d"; fails_at "no base: an old tracked hit fails" "scripts/old.sh:1:# $TD old"

d=$(mkrepo); mkdir -p "$d/scripts"; printf '# %s staged\n' "$TD" > "$d/scripts/s.sh"; git -C "$d" add -A
run "$d"; fails_at "unborn repo: a staged hit fails" "scripts/s.sh:1:# $TD staged"

[ "$fail" -eq 0 ] && echo "check-todos.test: OK"
exit "$fail"
