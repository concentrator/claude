#!/usr/bin/env bash
set -uo pipefail
h="$(dirname "${BASH_SOURCE[0]}")/branch-diff.sh"
{ [ -r "$h" ] && . "$h"; } \
  || { echo "check-accretion: cannot load branch-diff.sh"; exit 1; }
cd "$(git rev-parse --show-toplevel)"

P=$(sed -n 's/^- Plans: *//p' CLAUDE.md .claude/CLAUDE.md 2>/dev/null | head -1 || true)
P=${P:-dev/plans}
P=${P%/}
[ -n "$(branch_git ls-files -- "$P/*.md")" ] \
  || { echo "ACCRETION: no tracked plan files under '$P'"; exit 1; }
# MARKERS is the per-project tuning point - each corpus accretes in its
# own verbs. Tune this list only; the date rule in PAT stays fixed.
MARKERS='supersede[sd]|retracted|settled|corrected|approved|shaped|done|absorbed|mooted|retired|updated|added|amended|re-?baselined|resolved|shipped|delivered|restored|revised|deferred|completed?'
PAT="\b($MARKERS)[[:space:]:,(-]{1,3}20[0-9]{2}-[0-9]{2}-[0-9]{2}"

T=$'\t'
base=$(branch_base) || base=
hits=$(branch_added "$base" "$P/*.md" ":(exclude)$P/archive/*" \
  | grep -iE "^[^$T]*$T[0-9]+$T.*$PAT" \
  | awk -F '\t' '{ line = $0; sub(/^[^\t]*\t[^\t]*\t/, "", line); print "ACCRETION: " $1 ":" $2 ":" line }' || true)

[ -z "$hits" ] || { printf '%s\n' "$hits"; exit 1; }
echo "check-accretion: OK"
