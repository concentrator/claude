#!/usr/bin/env bash
# dev-branch-state.sh - UserPromptSubmit hook (R-052). Prints one line of
# ambient git state - the current branch plus working-tree counts - so a
# session knows where a write or commit would land without asking (the
# __git_ps1 idea: ambient display, not a remembered check). Display only,
# never a decision. Silent outside a git repo; on any error it prints
# nothing (fail open).
set -uo pipefail

cat >/dev/null 2>&1 || true   # the prompt JSON on stdin is not used

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
[ -n "$branch" ] || exit 0

changed=0 untracked=0
while IFS= read -r line; do
  [ -n "$line" ] || continue
  case "$line" in '??'*) untracked=$((untracked + 1)) ;; *) changed=$((changed + 1)) ;; esac
done < <(git status --porcelain 2>/dev/null)

state=
[ "$changed" -gt 0 ] && state="$changed changed"
[ "$untracked" -gt 0 ] && state="${state:+$state, }$untracked untracked"
printf 'branch-state: %s | %s\n' "$branch" "${state:-clean}"
exit 0
