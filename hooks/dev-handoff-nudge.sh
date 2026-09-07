#!/usr/bin/env bash
# dev-handoff-nudge.sh - Stop hook (R074). The PreCompact tree block
# records the repo's state, but the intent half of the session file (the
# hand-off block: done/next/open/rulings) only the session can write,
# and near the compaction point it rarely does. When context fill is at
# or above the warning threshold (dev-context-fill.sh owns the number)
# and the session file's last tree block is newer than its last hand-off
# block, this hook refuses the turn end once with a reason naming the
# file and the format; writing the hand-off clears the condition, so the
# nudge self-limits without state of its own. A reminder, never a gate:
# the harness overrides after repeated blocks, and every read failure
# exits 0 silent (fail open).
set -uo pipefail

command -v jq >/dev/null 2>&1 || exit 0
input=$(cat 2>/dev/null || true)
dir=$(dirname "$0")

fill=$(printf '%s' "$input" | bash "$dir/dev-context-fill.sh" 2>/dev/null)
[ -n "$fill" ] || exit 0

session=$(printf '%s' "$input" | bash "$dir/dev-precompact-state.sh" --path 2>/dev/null)
[ -n "$session" ] && [ -f "$session" ] || exit 0

# Stale: the last tree block sits after the last hand-off block; a file
# with no hand-off is stale, no tree at all is fresh.
tree=$(grep -n '^## tree ' "$session" 2>/dev/null | tail -1 | cut -d: -f1)
[ -n "$tree" ] || exit 0
hand=$(grep -n '^## hand-off' "$session" 2>/dev/null | tail -1 | cut -d: -f1)
if [ -z "$hand" ] || [ "$tree" -gt "$hand" ]; then
  jq -nc --arg r "context ${fill}% and the session state is stale: append the hand-off block to $session (skills/dev/handoff.md § Writing the note), then stop" \
    '{ok: false, reason: $r}'
fi
exit 0
