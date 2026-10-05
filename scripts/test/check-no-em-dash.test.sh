#!/usr/bin/env bash
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
CHECK="$(cd "$(dirname "${BASH_SOURCE[0]}")/../ci" && pwd)/check-no-em-dash.sh"
[ -f "$CHECK" ] || { echo "not ok - $CHECK not found"; exit 1; }
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }
tmproot=$(mktemp -d); trap 'rm -rf "$tmproot"' EXIT
em=$(printf '\xe2\x80\x94')

commit_in() {
  git -C "$1" add -A
  git -C "$1" -c user.email=t@t -c user.name=t -c commit.gpgsign=false commit -qm "$2"
}
mkrepo() { local d; d=$(TMPDIR=$tmproot mktemp -d); git -C "$d" init -q -b "${1:-main}"; printf '%s' "$d"; }
branched() {
  local d; d=$(mkrepo)
  printf 'old %s dash\n' "$em" > "$d/old.md"
  printf 'a %s b\nplain\n' "$em" > "$d/touched.md"
  commit_in "$d" base; git -C "$d" checkout -q -b feat
  printf '%s' "$d"
}
run() { out=$(cd "$1" && bash "$CHECK" 2>&1); rc=$?; }
passes() { [ "$rc" -eq 0 ] && [[ "$out" == *"check-no-em-dash: OK"* ]] && pass "$1" || die "$1: rc=$rc [$out]"; }
fails_at() { [ "$rc" -ne 0 ] && [[ "$out" == *"$2"* ]] && pass "$1" || die "$1: rc=$rc [$out]"; }

d=$(branched); printf 'more\n' >> "$d/touched.md"; commit_in "$d" grow
run "$d"; passes "an old hit in an untouched and a touched file passes"

d=$(branched); printf 'new %s line\n' "$em" >> "$d/touched.md"; commit_in "$d" grow
run "$d"; fails_at "an added hit fails at its line" "touched.md:3:new"

d=$(branched); printf 'u %s\n' "$em" > "$d/untracked.md"
run "$d"; fails_at "an untracked hit fails" "untracked.md:1:u"

d=$(mkrepo trunk); printf 'old %s\n' "$em" > "$d/old.md"; commit_in "$d" c1
run "$d"; fails_at "no base: an old tracked hit fails" "old.md:1:old"

d=$(mkrepo); printf 'staged %s\n' "$em" > "$d/s.md"; git -C "$d" add -A
run "$d"; fails_at "unborn repo: a staged hit fails" "s.md:1:staged"

d=$(mkrepo); printf 'clean\n' > "$d/s.md"; git -C "$d" add -A
run "$d"; passes "unborn repo: a clean tree passes"

[ "$fail" -eq 0 ] && echo "check-no-em-dash.test: OK"
exit "$fail"
