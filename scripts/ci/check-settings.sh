#!/usr/bin/env bash
# Tier-1: the context budget is actually configured and git is granted per
# subcommand. `autoCompactWindow` is
# the enforcement point for the context budget (DESIGN.md § Context budget)
# and every hook around it is advisory by design, so nothing else would
# notice the budget going away: a dropped key, a non-numeric or out-of-range
# value, or a flipped `autoCompactEnabled` all leave sessions unbounded with
# the rest of the gate still green. The window binds only while
# auto-compaction is on, so both keys are checked.
#
# The 100000 to 1000000 bounds are the Claude Code settings reference's, not
# this repo's; they are restated here because the gate has to compare against
# something and no tracked file owns them. The chosen value inside those
# bounds lives in settings.json alone.
#
# A bare `Bash(git:*)` here would already cover every git entry the
# per-project template grants, so on a host carrying this config the
# template's list would decide nothing and its acceptance test could not
# tell a placed file from a missing one.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

MIN=100000
MAX=1000000
f=settings.json

# No jq means this gate cannot judge anything; say so and let the rest of
# the suite run rather than blaming the file (hooks/dev-secrets-guard.sh
# takes the same fail-open line, and run-all.sh reports a named SKIP).
command -v jq >/dev/null 2>&1 || { echo "check-settings: SKIP (jq not available)"; exit 0; }

[ -f "$f" ] || { echo "SETTINGS: $f is missing; the context budget has no home"; exit 1; }

# `type == "object"` rather than `.`: a bare null or false parses as JSON but
# is not a settings file, and a string or array would reach the key lookups
# below and misreport there.
jq -e 'type == "object"' "$f" >/dev/null 2>&1 \
  || { echo "SETTINGS: $f is not a JSON object"; exit 1; }

# One pass: each condition carries its own message, so a failure names the
# condition rather than the first thing that happens to trip.
reason=$(jq -r --argjson lo "$MIN" --argjson hi "$MAX" '
  if .autoCompactEnabled != true then
    "autoCompactEnabled is not true; autoCompactWindow does not bind without it"
  elif (has("autoCompactWindow") | not) then
    "autoCompactWindow is absent; the working context is unbounded"
  elif (.autoCompactWindow | type) != "number" then
    "autoCompactWindow is not a number; it is \(.autoCompactWindow | type)"
  elif .autoCompactWindow < $lo or .autoCompactWindow > $hi then
    "autoCompactWindow is \(.autoCompactWindow), outside the range \($lo) to \($hi)"
  elif ((.permissions.allow // []) | type) != "array" then
    "permissions.allow is not an array; it is \(.permissions.allow | type)"
  elif (.permissions.allow // []) | index("Bash(git:*)") != null then
    "permissions.allow grants a bare Bash(git:*); grant git per subcommand"
  else "" end' "$f")

[ -z "$reason" ] || { echo "SETTINGS: $reason"; exit 1; }
echo "check-settings: OK"
