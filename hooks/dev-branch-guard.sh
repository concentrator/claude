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
#
# This is a best-effort local tripwire against an accidental trunk mutation,
# not a boundary against a crafted evasion - the real gate is host branch
# protection + CI (git-workflow.md § Enforcement). It reads an arbitrary
# shell command by heuristic, so residual gaps (e.g. a quoted `-C "a b"`
# path) fail open toward that gate.
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
    # Only guard commands that actually commit. Match a `git` invocation whose
    # subcommand is `commit`, allowing global options (-c key=val, -C path,
    # --flag) in between. The boundary after `commit` leaves plumbing (git
    # commit-tree / commit-graph) alone.
    if ! [[ "$cmd" =~ (^|[^[:alnum:]-])git([[:space:]]+-[^[:space:]]+([[:space:]]+[^[:space:]-][^[:space:]]*)?)*[[:space:]]+commit([[:space:]]|$) ]]; then
      exit 0
    fi

    # Everything up to the first `commit` - a branch created/switched here
    # first means the commit lands off the trunk.
    before="${cmd%%commit*}"
    before="${before//$'\n'/;}"   # newlines separate commands too, like ;&|
    # Treat `checkout -b` / `switch -c` as a branch-create only when it is an
    # actual command head (start, or after a shell separator) and names a
    # non-trunk branch - not text inside an echo or a commit message. Flags
    # may sit between the verb and -b/-c (e.g. `checkout -q -b`).
    if [[ "$before" =~ (^|[;\&|]+)[[:space:]]*git[[:space:]]+(checkout|switch)([[:space:]]+-[^[:space:]]+)*[[:space:]]+(-b|-c)[[:space:]]+([^[:space:]]+) ]]; then
      is_trunk "${BASH_REMATCH[5]}" || exit 0
    fi

    # Judge the repo the commit targets: the `-C <path>` bound to the commit
    # (the last one before it, via a greedy prefix), else the cwd repo.
    dir="."
    if [[ "$before" =~ .*git[[:space:]]+-C[[:space:]]+([^[:space:]]+) ]]; then dir="${BASH_REMATCH[1]}"; fi
    branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
    is_trunk "$branch" && deny "branch-guard: refusing 'git commit' on '$branch'. Create a working branch first (git-workflow)." ;;
esac

exit 0
