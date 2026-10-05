#!/usr/bin/env bash

branch_base() {
  local ref b
  for ref in origin/main origin/master main master; do
    b=$(git merge-base HEAD "$ref" 2>/dev/null) && { printf '%s\n' "$b"; return 0; }
  done
  return 1
}

branch_git() {
  git -c core.quotePath=false -c diff.mnemonicPrefix=false -c diff.noprefix=false "$@"
}

branch_whole() {
  local f
  while IFS= read -r -d '' f; do
    [ -f "$f" ] && [ ! -L "$f" ] || continue
    grep -Iq . "$f" 2>/dev/null || continue
    F=$f awk '{ print ENVIRON["F"] "\t" NR "\t" $0 }' < "$f"
  done
}

branch_added() {
  local base=$1; shift
  if [ -z "$base" ]; then
    branch_git ls-files -z -- "$@" | branch_whole
    return
  fi
  branch_git diff --no-color --no-ext-diff --no-textconv -M -U0 \
      --src-prefix=a/ --dst-prefix=b/ "$base" -- "$@" | awk '
    /^diff --git / { hunk = 0; f = ""; gone = 0; nonl = 0; next }
    !hunk && /^\+\+\+ / {
      f = substr($0, 5); sub(/\t$/, "", f)
      if (f == "/dev/null") f = ""; else sub(/^b\//, "", f)
      next
    }
    /^@@ / {
      hunk = 1; match($0, / \+[0-9]+/)
      n = substr($0, RSTART + 2, RLENGTH - 2) + 0
      next
    }
    hunk && /^-/ { gone = 1; last = substr($0, 2); next }
    hunk && /^\\/ { if (gone) { nonl = 1; kept = last }; next }
    hunk && /^\+/ && f != "" {
      gone = 0
      if (nonl && substr($0, 2) == kept) { nonl = 0; n++; next }
      print f "\t" n "\t" substr($0, 2); n++
    }'
  branch_git ls-files -z --others --exclude-standard -- "$@" | branch_whole
}

branch_changed() {
  local base=$1; shift
  if [ -z "$base" ]; then
    branch_git ls-files -- "$@" | awk '{ print "A\t" $0 }'
    return
  fi
  branch_git diff --name-status --no-ext-diff -M "$base" -- "$@" | awk -F '\t' '
    $1 ~ /^D/ { next }
    $1 ~ /^[RC]/ { print "M\t" $3 "\t" $2; next }
    $1 ~ /^A/ { print "A\t" $2; next }
    { print "M\t" $2 "\t" $2 }'
  branch_git ls-files --others --exclude-standard -- "$@" | awk '{ print "A\t" $0 }'
}
