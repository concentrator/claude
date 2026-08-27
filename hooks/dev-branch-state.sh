#!/usr/bin/env bash
# dev-branch-state.sh - UserPromptSubmit hook (R-052). Prints one line of
# ambient git state - the current branch plus working-tree counts - so a
# session knows where a write or commit would land without asking (the
# __git_ps1 idea: ambient display, not a remembered check). Display only,
# never a decision. Silent outside a git repo; a failed status read
# degrades to "clean" (fail open). When hooks/dev-precompact-state.sh has
# left a state file for this session, the line also names it, so a
# session resumed after compaction re-briefs from the tree.
set -uo pipefail

input=$(cat 2>/dev/null || true)
sid=
if command -v jq >/dev/null 2>&1 && [ -n "$input" ]; then
  sid=$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null)
fi

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
root=$(git rev-parse --show-toplevel 2>/dev/null)
dir="${DEV_STATE_DIR:-$HOME/.claude/state/precompact}"
resume=
for key in "$sid" "$(printf '%s' "$root" | cksum | cut -d' ' -f1)"; do
  [ -n "$key" ] && [ -f "$dir/$key.md" ] && { resume="$dir/$key.md"; break; }
done
printf 'branch-state: %s | %s%s\n' "$branch" "${state:-clean}" "${resume:+ | precompact-state: $resume}"
exit 0
