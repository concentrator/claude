#!/usr/bin/env bash
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
HELPER="$(cd "$(dirname "${BASH_SOURCE[0]}")/../ci" && pwd)/branch-diff.sh"
[ -f "$HELPER" ] || { echo "not ok - $HELPER not found"; exit 1; }
. "$HELPER"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }
tmproot=$(mktemp -d); trap 'rm -rf "$tmproot"' EXIT
export LC_ALL=C

commit_in() {
  git -C "$1" add -A
  git -C "$1" -c user.email=t@t -c user.name=t -c commit.gpgsign=false commit -qm "$2"
}
mkrepo() { local d; d=$(TMPDIR=$tmproot mktemp -d); git -C "$d" init -q -b "${1:-main}"; printf '%s' "$d"; }
in_repo() { local d=$1; shift; ( cd "$d" && "$@" ); }
same() {
  local name=$1 want=$2 got=$3
  [ "$(printf '%s\n' "$got" | sort)" = "$(printf '%s\n' "$want" | sort)" ] \
    && pass "$name" || die "$name: got [$got] want [$want]"
}

d=$(mkrepo)
printf 'x\n' > "$d/a.txt"; git -C "$d" add -A
out=$(in_repo "$d" branch_base); rc=$?
[ "$rc" -ne 0 ] && [ -z "$out" ] && pass "unborn repo has no base" || die "unborn base: rc=$rc [$out]"

d=$(mkrepo trunk); printf 'x\n' > "$d/a.txt"; commit_in "$d" c1
out=$(in_repo "$d" branch_base); rc=$?
[ "$rc" -ne 0 ] && [ -z "$out" ] && pass "trunk-only repo has no base" || die "trunk base: rc=$rc [$out]"

d=$(mkrepo); printf 'x\n' > "$d/a.txt"; commit_in "$d" c0; c0=$(git -C "$d" rev-parse HEAD)
printf 'y\n' >> "$d/a.txt"; commit_in "$d" c1; c1=$(git -C "$d" rev-parse HEAD)
same "on main the base is HEAD" "$c1" "$(in_repo "$d" branch_base)"
same "on main with a clean tree nothing is added" "" "$(in_repo "$d" branch_added "$c1")"
git -C "$d" checkout -q -b feat; printf 'z\n' >> "$d/a.txt"; commit_in "$d" c2
same "main gives the merge-base" "$c1" "$(in_repo "$d" branch_base)"
git -C "$d" update-ref refs/remotes/origin/master "$c0"
same "origin/master before main" "$c0" "$(in_repo "$d" branch_base)"
git -C "$d" update-ref refs/remotes/origin/master "$c1"
git -C "$d" update-ref refs/remotes/origin/main "$c0"
same "origin/main before origin/master" "$c0" "$(in_repo "$d" branch_base)"

d=$(mkrepo master); printf 'x\n' > "$d/a.txt"; commit_in "$d" c1; c1=$(git -C "$d" rev-parse HEAD)
git -C "$d" checkout -q -b feat; printf 'y\n' >> "$d/a.txt"; commit_in "$d" c2
same "master gives the merge-base" "$c1" "$(in_repo "$d" branch_base)"

d=$(mkrepo); git -C "$d" config diff.renames false
printf 'a\nb\nc\n' > "$d/keep.txt"; printf 'm1\nm2\nm3\n' > "$d/move.txt"
printf 'g\n' > "$d/gone.txt"; printf 's\n' > "$d/same.txt"; printf 'ignored.txt\n' > "$d/.gitignore"
commit_in "$d" base; base=$(git -C "$d" rev-parse HEAD)
git -C "$d" checkout -q -b feat
printf 'd\n' >> "$d/keep.txt"
git -C "$d" mv move.txt moved.txt; printf 'm4\n' >> "$d/moved.txt"
git -C "$d" rm -q gone.txt
printf 'x\0y\n' > "$d/bin.dat"
printf 'sp\n' > "$d/with space.txt"; printf 'e\n' > "$d/é.txt"
printf '++ x\n+++ x\n--- x\n@@ y\n' > "$d/tricky.txt"
commit_in "$d" branch
printf 'st\n' > "$d/staged.txt"; git -C "$d" add staged.txt
printf 'u\n' > "$d/untracked.txt"; printf 'i\n' > "$d/ignored.txt"
T=$'\t'

same "added lines with their line numbers" "keep.txt${T}4${T}d
moved.txt${T}4${T}m4
with space.txt${T}1${T}sp
é.txt${T}1${T}e
tricky.txt${T}1${T}++ x
tricky.txt${T}2${T}+++ x
tricky.txt${T}3${T}--- x
tricky.txt${T}4${T}@@ y
staged.txt${T}1${T}st
untracked.txt${T}1${T}u" "$(in_repo "$d" branch_added "$base")"

same "a pathspec narrows the added lines" "keep.txt${T}4${T}d" \
  "$(in_repo "$d" branch_added "$base" ':(literal)keep.txt')"
same "a rename under both paths gives only the appended line" "moved.txt${T}4${T}m4" \
  "$(in_repo "$d" branch_added "$base" ':(literal)moved.txt' ':(literal)move.txt')"

same "changed paths with their base paths" "M${T}keep.txt${T}keep.txt
M${T}moved.txt${T}move.txt
A${T}bin.dat
A${T}with space.txt
A${T}é.txt
A${T}tricky.txt
A${T}staged.txt
A${T}untracked.txt" "$(in_repo "$d" branch_changed "$base")"

n=$(mkrepo); printf 'a\nb' > "$n/grown.txt"; printf 'a\nb' > "$n/edited.txt"
commit_in "$n" base; nb=$(git -C "$n" rev-parse HEAD)
git -C "$n" checkout -q -b feat
printf '\nc\n' >> "$n/grown.txt"; printf 'a\nB\n' > "$n/edited.txt"
same "a last line that only gains its newline is not added" "grown.txt${T}3${T}c
edited.txt${T}2${T}B" "$(in_repo "$n" branch_added "$nb")"

u=$(mkrepo)
printf 'x\ny\n' > "$u/a.txt"; printf 'x\0y\n' > "$u/bin.dat"; git -C "$u" add -A
printf 'u\n' > "$u/untracked.txt"
same "no base: every line of the tracked tree" "a.txt${T}1${T}x
a.txt${T}2${T}y" "$(in_repo "$u" branch_added "")"
same "no base: every tracked path is added" "A${T}a.txt
A${T}bin.dat" "$(in_repo "$u" branch_changed "")"

for mode in "-euo pipefail" "-uo pipefail"; do
  out=$(bash -c 'set '"$mode"'
    set -o > "$2/before"; f=$-
    . "$1"
    set -o > "$2/after"
    [ "$f" = "$-" ] && cmp -s "$2/before" "$2/after" || { echo changed; exit 1; }
    cd "$3"; base=$(branch_base) || base=
    branch_added "$base" > /dev/null; branch_changed "$base" > /dev/null
    cd "$4"; base=$(branch_base) || base=
    branch_added "$base" > /dev/null; branch_changed "$base" > /dev/null
    echo reached' _ "$HELPER" "$tmproot" "$d" "$u")
  same "set $mode: sourcing keeps the shell mode and the calls return" "reached" "$out"
done

gate() {
  printf '%s\n' '#!/usr/bin/env bash' "set $1" \
    'h="$(dirname "${BASH_SOURCE[0]}")/branch-diff.sh"' \
    '{ [ -r "$h" ] && . "$h"; } \' \
    '  || { echo "gate: cannot load branch-diff.sh"; exit 1; }' \
    'cd "$(git rev-parse --show-toplevel)"' \
    'base=$(branch_base) || base=' \
    'branch_added "$base" > /dev/null' \
    'echo "gate: OK"'
}
for mode in "-euo pipefail" "-uo pipefail"; do
  g=$(mkrepo); mkdir -p "$g/scripts/ci" "$g/sub"
  gate "$mode" > "$g/scripts/ci/gate.sh"; git -C "$g" add -A
  out=$(cd "$g/sub" && bash ../scripts/ci/gate.sh 2>&1); rc=$?
  [ "$rc" -eq 1 ] && [ "$out" = "gate: cannot load branch-diff.sh" ] \
    && pass "set $mode: a gate without the helper fails" || die "set $mode missing helper: rc=$rc [$out]"
  cp "$HELPER" "$g/scripts/ci/branch-diff.sh"
  out=$(cd "$g/sub" && bash ../scripts/ci/gate.sh 2>&1); rc=$?
  [ "$rc" -eq 0 ] && [ "$out" = "gate: OK" ] \
    && pass "set $mode: a gate run from a subdirectory loads the helper" || die "set $mode load: rc=$rc [$out]"
done

[ "$fail" -eq 0 ] && echo "branch-diff.test: OK"
exit "$fail"
