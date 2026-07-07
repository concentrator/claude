#!/usr/bin/env bash
# dev-branch-guard.sh - PreToolUse hook (R-021, refined R-024).
# Refuses repo-mutating tool calls that would land on the trunk (main/master)
# so all work goes through a branch (git-workflow trunk rule). Reads the
# tool-call JSON on stdin; emits a PreToolUse "deny" decision when the write
# or commit actually targets the trunk. Silent (allow) otherwise, and outside
# any git repo. Judges the real target, not the session cwd branch plus a
# substring: a gitignored-path write, a compound `checkout -b && commit`, and
# a `git -C <branch-repo> commit` are all allowed; a `git -C <main-repo>
# commit` from a branch cwd is still denied. Fails open.
set -uo pipefail

input=$(cat)

deny() {
  # permissionDecisionReason must be JSON-encoded (handles quotes/newlines).
  local reason
  reason=$(printf '%s' "$1" | jq -Rs .)
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":%s}}\n' "$reason"
  exit 0
}

is_trunk() { case "$1" in main | master) return 0 ;; *) return 1 ;; esac; }

tool=$(printf '%s' "$input" | jq -r '.tool_name // ""')
case "$tool" in
  Write | Edit | NotebookEdit)
    # A file mutation targets the cwd repo's working tree.
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
    [ -n "$branch" ] || exit 0
    is_trunk "$branch" || exit 0   # on a working branch → allow
    # A write to a gitignored path never touches the tracked trunk - allow it.
    path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // ""')
    if [ -n "$path" ] && git check-ignore -q -- "$path" 2>/dev/null; then exit 0; fi
    deny "branch-guard: refusing $tool on '$branch'. Create a working branch first - never edit the trunk (git-workflow)." ;;
  Bash)
    cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
    # Only guard commands that actually commit. Match `git commit` and
    # `git -C <path> commit`, with a boundary so plumbing (git commit-tree/
    # -graph) is left alone.
    committing=0
    case "$cmd" in
      *"git commit "* | *"git commit") committing=1 ;;
    esac
    if [[ "$cmd" =~ git[[:space:]]+-C[[:space:]]+[^[:space:]]+[[:space:]]+commit([[:space:]]|$) ]]; then committing=1; fi
    [ "$committing" = 1 ] || exit 0

    # Compound: if the command creates/switches to a branch before the commit,
    # the commit lands off the trunk - allow.
    before="${cmd%%commit*}"
    case "$before" in
      *"git checkout -b "* | *"git switch -c "*) exit 0 ;;
    esac

    # Judge the repo the commit targets: honor an explicit `git -C <path>`.
    dir="."
    if [[ "$cmd" =~ git[[:space:]]+-C[[:space:]]+([^[:space:]]+) ]]; then dir="${BASH_REMATCH[1]}"; fi
    branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
    is_trunk "$branch" && deny "branch-guard: refusing 'git commit' on '$branch'. Create a working branch first (git-workflow)." ;;
esac

exit 0
