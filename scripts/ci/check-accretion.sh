#!/usr/bin/env bash
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

P=$(sed -n 's/^- Plans: *//p' CLAUDE.md .claude/CLAUDE.md 2>/dev/null | head -1 || true)
P=${P:-dev/plans}
P=${P%/}
# quotePath off: a non-ASCII filename must arrive verbatim, not quoted,
# or the read below silently skips it.
files=$(git -c core.quotePath=false ls-files "$P/*.md")
[ -n "$files" ] || { echo "ACCRETION: no tracked plan files under '$P'"; exit 1; }
fail=0
# MARKERS is the per-project tuning point - each corpus accretes in its
# own verbs. Tune this list only; the date rule in PAT stays fixed.
MARKERS='supersede[sd]|retracted|settled|corrected|approved|shaped|done|absorbed|mooted|retired|updated|added|amended|re-?baselined|resolved|shipped|delivered|restored|revised|deferred|completed?'
PAT="\b($MARKERS)[[:space:]:,(-]{1,3}20[0-9]{2}-[0-9]{2}-[0-9]{2}"

while IFS= read -r f; do
  case "$f" in "$P/archive/"*) continue ;; esac
  hits=$(grep -n '' "$f" | grep -iE "$PAT" || true)
  if [ -n "$hits" ]; then
    while IFS= read -r h; do echo "ACCRETION: $f:$h"; done <<<"$hits"
    fail=1
  fi
done <<<"$files"

(( fail == 0 )) && echo "check-accretion: OK"
exit $fail
