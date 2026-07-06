#!/usr/bin/env bash
# dev-secrets-guard.sh - PreToolUse hook (R-022).
# Denies secret-shaped content entering tracked files or commits. Reads the
# tool-call JSON on stdin; emits a PreToolUse "deny" when a Write/Edit to a
# non-gitignored path, or a git add/commit, carries a secret pattern. Allows
# a gitignored path (e.g. a local .env), clean content, and any line marked
# `secrets-guard: allow`. Fails open (exit 0, no decision) on any internal
# error - jq missing, malformed input, or git unavailable.
set -uo pipefail
set -f   # no globbing (commit-flag scan word-splits the command)

input=$(cat)
command -v jq >/dev/null 2>&1 || exit 0   # no jq -> fail open

deny() {
  local reason
  reason=$(printf '%s' "$1" | jq -Rs .) || exit 0
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":%s}}\n' "$reason"
  exit 0
}

# Reads content on stdin; returns 0 if it carries a secret, after dropping
# any line that opts out with the `secrets-guard: allow` marker.
has_secret() {
  local body
  body=$(grep -v 'secrets-guard: allow')
  printf '%s' "$body" | grep -Eq '(-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}|gh[posr]_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{22,}|xox[baprs]-[0-9A-Za-z-]{10,}|AIza[0-9A-Za-z_-]{35})' && return 0
  printf '%s' "$body" | grep -Eiq '(secret|token|passwd|password|api[_-]?key)[^a-z0-9]{1,10}[a-z0-9/+_-]{16,}' && return 0
  return 1
}

# Cats untracked, non-ignored, regular files (skips symlinks and files over
# ~1MB) so a `git add` of a new file is scanned without traversing symlinked
# trees or large blobs on every Bash call.
scan_untracked() {
  git ls-files --others --exclude-standard 2>/dev/null | while IFS= read -r f; do
    [ -f "$f" ] && [ ! -L "$f" ] || continue
    [ "$(wc -c < "$f" 2>/dev/null || echo 0)" -le 1000000 ] || continue
    cat "$f" 2>/dev/null
  done
}

# True when the command uses git commit's -a/--all (commits unstaged tracked
# changes too). Long flags like --amend are ignored.
commit_all() {
  local tok
  for tok in $1; do
    case "$tok" in
      --all) return 0 ;;
      --*) : ;;
      -*a*) return 0 ;;
    esac
  done
  return 1
}

tool=$(printf '%s' "$input" | jq -r '.tool_name // ""') || exit 0

case "$tool" in
  Write | Edit | NotebookEdit)
    path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // ""')
    content=$(printf '%s' "$input" | jq -r '.tool_input.content // .tool_input.new_string // .tool_input.new_source // ""')
    [ -n "$path" ] && git check-ignore -q "$path" 2>/dev/null && exit 0   # gitignored -> allow
    printf '%s' "$content" | has_secret && \
      deny "secrets-guard: refusing $tool to '$path' - content matches a secret pattern. Keep secrets in a gitignored .env, or mark the line 'secrets-guard: allow' if it is provably not a live credential."
    ;;
  Bash)
    cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
    scan=""
    # git commit: staged content is authoritative; -a/--all also commits
    # unstaged tracked changes. The command string is scanned too (e.g. a
    # secret pasted into a -m message).
    case "$cmd" in
      *"git commit"*)
        scan="$(git diff --cached 2>/dev/null)
$cmd"
        commit_all "$cmd" && scan="$scan
$(git diff 2>/dev/null)" ;;
    esac
    # git add: scan what would be newly staged (unstaged tracked + untracked
    # files). Independent of the commit arm, so `git add X && git commit` -
    # where nothing is staged yet at hook time - is still caught.
    case "$cmd" in
      *"git add"*)
        scan="$scan
$(git diff 2>/dev/null)
$(scan_untracked)" ;;
    esac
    [ -n "$scan" ] && printf '%s' "$scan" | has_secret && \
      deny "secrets-guard: refusing this git command - content it would add or commit matches a secret pattern. Move the secret to a gitignored .env, or mark the line 'secrets-guard: allow'."
    ;;
esac

exit 0
