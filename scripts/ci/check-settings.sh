#!/usr/bin/env bash
# Tier-1: the context budget is actually configured. `autoCompactWindow` is
# R-050's enforcement point and every hook around it is advisory by design
# (DESIGN.md § Context budget), so nothing else would notice the budget
# going away: a dropped key, an out-of-range value, or a flipped
# `autoCompactEnabled` all leave sessions unbounded with the rest of the
# gate still green. The window binds only while auto-compaction is on, so
# both keys are checked. The range is the one the settings reference
# documents; the value itself lives in settings.json and nowhere else.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

MIN=100000
MAX=1000000
f=settings.json

[ -f "$f" ] || { echo "check-settings: $f is missing; the context budget has no home"; exit 1; }
jq -e . "$f" >/dev/null 2>&1 || { echo "check-settings: $f does not parse as JSON"; exit 1; }

jq -e '.autoCompactEnabled == true' "$f" >/dev/null 2>&1 \
  || { echo "check-settings: autoCompactEnabled is not true; autoCompactWindow does not bind without it"; exit 1; }

jq -e 'has("autoCompactWindow")' "$f" >/dev/null 2>&1 \
  || { echo "check-settings: autoCompactWindow is absent; the working context is unbounded"; exit 1; }

window=$(jq -r '.autoCompactWindow' "$f")
jq -e --argjson lo "$MIN" --argjson hi "$MAX" \
  '(.autoCompactWindow | type == "number") and .autoCompactWindow >= $lo and .autoCompactWindow <= $hi' \
  "$f" >/dev/null 2>&1 \
  || { echo "check-settings: autoCompactWindow is $window, outside the documented range $MIN to $MAX"; exit 1; }

echo "check-settings: OK"
