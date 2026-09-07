#!/usr/bin/env bash
# dev-context-fill.sh - context-fill helper (R074). No hook event carries
# context fill, but every hook's input names the transcript, whose last
# usage record is the window the last API call read (the sum
# scripts/context-cost.py bills). This helper turns that into an integer
# percent of the project's autoCompactWindow and prints it only at or
# above the warning threshold (default 80, DEV_FILL_WARN_PCT overrides),
# so callers compose warnings without token values or arithmetic of
# their own. Not a hook itself: called by hooks with their stdin JSON.
# Display only, never a decision; silent and exit 0 on any read, parse,
# or lookup failure (fail open).
set -uo pipefail

command -v jq >/dev/null 2>&1 || exit 0
input=$(cat 2>/dev/null || true)
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
[ -n "$transcript" ] && [ -f "$transcript" ] || exit 0

# Last usage record wins: fromjson? skips unparseable lines, and a line
# without message.usage contributes nothing.
sum=$(jq -R 'fromjson? | .message.usage? | objects
  | (.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)' \
  "$transcript" 2>/dev/null | tail -1)
case "$sum" in ''|*[!0-9]*) exit 0 ;; esac

# Window: project tier first, user-global tier else (the harness's own
# precedence for the setting).
root=${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}
window=
[ -n "$root" ] && [ -f "$root/.claude/settings.json" ] \
  && window=$(jq -r '.autoCompactWindow // empty' "$root/.claude/settings.json" 2>/dev/null)
[ -n "$window" ] \
  || window=$(jq -r '.autoCompactWindow // empty' "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json" 2>/dev/null)
case "$window" in ''|0|*[!0-9]*) exit 0 ;; esac

threshold=${DEV_FILL_WARN_PCT:-80}
case "$threshold" in ''|*[!0-9]*) threshold=80 ;; esac

pct=$(( sum * 100 / window ))
[ "$pct" -ge "$threshold" ] && printf '%s\n' "$pct"
exit 0
