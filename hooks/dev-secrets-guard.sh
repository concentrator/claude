#!/usr/bin/env bash
# dev-secrets-guard.sh - PreToolUse hook; manual: skills/dev/companions/secrets.md.
# Denies secret-shaped content entering tracked files or commits. Reads the
# tool-call JSON on stdin; emits a PreToolUse "deny" when a Write/Edit to a
# non-gitignored path, or a git add/commit, carries a secret pattern. Allows
# a gitignored path (e.g. a local .env), clean content, and any line marked
# `secrets-guard: allow`. Fails closed - one stderr line, then deny - when
# secret-patterns.sh beside it is missing or fails to source; fails open
# (exit 0, no decision) on a missing jq or malformed input.
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

# has_secret() lives in secret-patterns.sh beside this hook (one home).
# Without it the guard cannot judge, and a silent allow would pass every
# secret, so this one path fails closed and says why.
if ! . "$(dirname "${BASH_SOURCE[0]}")/secret-patterns.sh" 2>/dev/null; then
  msg="dev-secrets-guard: secret-patterns.sh missing beside the hook; denying"
  echo "$msg" >&2
  deny "$msg"
fi

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
