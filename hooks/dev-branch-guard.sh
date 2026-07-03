#!/usr/bin/env bash
# dev-branch-guard.sh — PreToolUse hook (R-021).
# Refuses repo-mutating tool calls on the trunk (main/master) so all work
# goes through a branch (git-workflow trunk rule). Reads the tool-call JSON
# on stdin; emits a PreToolUse "deny" decision when the current branch is
# main/master and the tool would mutate files or commit. Silent (allow)
# otherwise, and outside any git repo.
set -uo pipefail

input=$(cat)

# Outside a git repo → nothing to guard.
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
[ -n "$branch" ] || exit 0
case "$branch" in
  main | master) ;;
  *) exit 0 ;;   # on a working branch → allow
esac

deny() {
  # permissionDecisionReason must be JSON-encoded (handles quotes/newlines).
  local reason
  reason=$(printf '%s' "$1" | jq -Rs .)
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":%s}}\n' "$reason"
  exit 0
}

tool=$(printf '%s' "$input" | jq -r '.tool_name // ""')
case "$tool" in
  Write | Edit | NotebookEdit)
    deny "branch-guard: refusing $tool on '$branch'. Create a working branch first — never edit the trunk (git-workflow)." ;;
  Bash)
    cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
    # Word-boundary match so plumbing (git commit-tree/-graph) isn't blocked.
    case "$cmd" in
      *"git commit "* | *"git commit")
        deny "branch-guard: refusing 'git commit' on '$branch'. Create a working branch first (git-workflow)." ;;
    esac ;;
esac

exit 0
