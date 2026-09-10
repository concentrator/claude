#!/usr/bin/env bash
# Tier-1 accretion gate (R-041, R-043): living plan artifacts state the
# present (rules/writing-artifacts.md § State the present). Flags dated
# supersession / amendment / status markers in tracked plan files under
# the plans tree the root CLAUDE.md § Layout declares - the full ISO
# date is the discriminator: an undated terminal outcome ("mooted by
# R-021") is present state, a dated one ("superseded 2026-07-07") is
# hand-rolled version control that belongs to git history. A bare year
# never matches - alone it reads as a count, a key length, or an id. The
# separator tolerates bounded punctuation ("Superseded: 2026-07-07") but
# not sentence terminators.
# The rule is blind to markdown, so prose documenting the gate describes
# a marker rather than quoting one - code spans are not exempt, or real
# accretion could hide inside one. plans/archive/ is
# frozen history and exempt. The status fields need no exemption:
# `approved:` carries a state (`pending` / `yes`) rather than a date,
# and `status: done` is retired, surviving only in the exempt archive
# (`skills/dev/plan.md § Approval and closure`).
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

P=$(sed -n 's/^- Plans: *//p' CLAUDE.md 2>/dev/null | head -1 || true)
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
