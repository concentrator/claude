#!/usr/bin/env bash
# check-no-em-dash.sh - Tier-1 gate (R-026): no em dash (U+2014) in any
# tracked text file; use a hyphen (writing.md). The em-dash character is
# assembled at runtime (printf), so this script never contains a literal one
# that would match itself. Binary files are skipped (grep -I).
set -uo pipefail
h="$(dirname "${BASH_SOURCE[0]}")/branch-diff.sh"
{ [ -r "$h" ] && . "$h"; } \
  || { echo "check-no-em-dash: cannot load branch-diff.sh"; exit 1; }
cd "$(git rev-parse --show-toplevel)"

em=$(printf '\xe2\x80\x94')   # U+2014

base=$(branch_base) || base=
matches=$(branch_added "$base" | awk -F '\t' -v em="$em" '
  { line = $0; sub(/^[^\t]*\t[^\t]*\t/, "", line) }
  index(line, em) { print $1 ":" $2 ":" line }')
if [ -n "$matches" ]; then
  echo "NO-EM-DASH: em dash (U+2014) found; use a hyphen (writing.md):"
  printf '%s\n' "$matches"
  exit 1
fi

echo "check-no-em-dash: OK"
exit 0
