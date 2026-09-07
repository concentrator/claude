#!/usr/bin/env bash
# dev-session-brief.sh - SessionStart hook (R078). The R074 nudge makes
# the hand-off block exist before compaction, but reading it afterward
# was advisory: the resumed session got only a path pointer it could
# skip. On a compact or resume start (the settings matcher filters the
# reason) this hook injects the session file's last hand-off block
# verbatim as additionalContext, so the re-brief is in front of the
# model instead of behind a pointer. Subagent starts carry agent_id and
# need no re-brief. A reminder's delivery, never a gate: every read
# failure exits 0 silent (fail open).
set -uo pipefail

command -v jq >/dev/null 2>&1 || exit 0
input=$(cat 2>/dev/null || true)
dir=$(dirname "$0")

[ -n "$(printf '%s' "$input" | jq -r '.agent_id // empty' 2>/dev/null)" ] && exit 0

session=$(printf '%s' "$input" | bash "$dir/dev-precompact-state.sh" --path 2>/dev/null)
[ -n "$session" ] && [ -f "$session" ] || exit 0

start=$(grep -n '^## hand-off' "$session" 2>/dev/null | tail -1 | cut -d: -f1)
[ -n "$start" ] || exit 0
# The block runs from its heading to the next heading or EOF.
block=$(sed -n "${start},\$p" "$session" 2>/dev/null | awk 'NR==1 {print; next} /^## / {exit} {print}')
[ -n "$block" ] || exit 0

jq -n --arg f "$session" --arg b "$block" \
  '{hookSpecificOutput: {hookEventName: "SessionStart",
    additionalContext: ("re-brief from \($f) (skills/dev/handoff.md § Reading it back):\n\n" + $b)}}'
exit 0
