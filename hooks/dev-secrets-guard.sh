#!/usr/bin/env bash
# dev-secrets-guard.sh - PreToolUse hook (R-022).
# Denies secret-shaped content entering tracked files or commits. Reads the
# tool-call JSON on stdin; emits a PreToolUse "deny" when a Write/Edit to a
# non-gitignored path, or a git add/commit, carries a secret pattern. Allows
# a gitignored path (e.g. a local .env), clean content, and any line marked
# `secrets-guard: allow`. Fails open (exit 0, no decision) on any internal
# error - jq missing, malformed input, or git unavailable.
set -uo pipefail

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
  printf '%s' "$body" | grep -Eq '(-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}|gh[posr]_[A-Za-z0-9]{36}|xox[baprs]-[0-9A-Za-z-]{10,}|AIza[0-9A-Za-z_-]{35})' && return 0
  printf '%s' "$body" | grep -Eiq '(secret|token|passwd|password|api[_-]?key)[^a-z0-9]{1,4}[a-z0-9/+_-]{16,}' && return 0
  return 1
}

tool=$(printf '%s' "$input" | jq -r '.tool_name // ""') || exit 0

case "$tool" in
  Write | Edit | NotebookEdit)
    path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // ""')
    content=$(printf '%s' "$input" | jq -r '.tool_input.content // .tool_input.new_string // .tool_input.new_source // ""')
    [ -n "$path" ] && git check-ignore -q "$path" 2>/dev/null && exit 0   # gitignored -> allow
    printf '%s' "$content" | has_secret && \
      deny "secrets-guard: refusing $tool to '$path' - content matches a secret pattern. Keep secrets in a gitignored .env, or mark the line 'secrets-guard: allow' if it is provably not a live credential."
    ;;
  Bash)
    cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
    case "$cmd" in
      *"git commit "* | *"git commit")
        git diff --cached 2>/dev/null | has_secret && \
          deny "secrets-guard: refusing 'git commit' - staged content matches a secret pattern. Unstage it and move the secret to a gitignored .env, or mark the line 'secrets-guard: allow'." ;;
      *"git add "*)
        { git diff HEAD 2>/dev/null; git ls-files --others --exclude-standard -z 2>/dev/null | xargs -0 cat 2>/dev/null; } | has_secret && \
          deny "secrets-guard: refusing 'git add' - a file to be staged matches a secret pattern. Move the secret to a gitignored .env, or mark the line 'secrets-guard: allow'." ;;
    esac ;;
esac

exit 0
