#!/usr/bin/env bash
# dev-branch-state.sh - UserPromptSubmit hook (R-052). Prints one line of
# ambient git state - the current branch plus working-tree counts - so a
# session knows where a write or commit would land without asking (the
# __git_ps1 idea: ambient display, not a remembered check). Display only,
# never a decision. Silent outside a git repo; a failed status read
# degrades to "clean" (fail open). The line ends with the session's
# state file (R040-T019), whether or not it exists yet, so a session knows
# where hand-off notes go and where a compaction's tree block landed.
# Near the compaction point the line also carries the context fill and
# the hand-off instruction (R074: dev-context-fill.sh owns the number).
set -uo pipefail

input=$(cat 2>/dev/null || true)   # the prompt JSON: only session_id is used

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
session=$(printf '%s' "$input" | bash "$(dirname "$0")/dev-precompact-state.sh" --path 2>/dev/null)
# The helper prints only at or above the threshold, and the instruction
# needs a destination, so the warning appears only with a session path.
fill=$(printf '%s' "$input" | bash "$(dirname "$0")/dev-context-fill.sh" 2>/dev/null)
warn=
[ -n "$fill" ] && [ -n "$session" ] && warn=" | context ${fill}% - append the hand-off block to $session"
printf 'branch-state: %s | %s%s%s\n' "$branch" "${state:-clean}" "${session:+ | session-state: $session}" "$warn"
exit 0
