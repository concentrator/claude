#!/usr/bin/env bash
# Tier-1 accretion gate (R-041, R-043): living plan artifacts state the
# present (writing.md § State the present). Flags dated supersession /
# amendment / status markers in tracked plan files under the artifacts
# root (resolve-root.sh) - the full ISO date is the discriminator: an
# undated terminal outcome ("mooted by R-021") is present state, a dated
# one ("superseded 2026-07-07") is hand-rolled version control that
# belongs to git history. A bare year never matches - alone it reads as
# a count, a key length, or an id. The separator tolerates bounded
# punctuation ("Superseded: 2026-07-07") but not sentence terminators.
# The rule is blind to markdown, so prose documenting the gate describes
# a marker rather than quoting one - code spans are not exempt, or real
# accretion could hide inside one. plans/archive/ is
# frozen history and exempt; the mandated frontmatter fields (`approved:`,
# `status: done`, `agentic: approved`) are exempt for the field's own
# value span only - the rest of the line is scanned.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(git rev-parse --show-toplevel)"

ROOT="$(bash "$SCRIPT_DIR/resolve-root.sh")" \
  || { echo "ACCRETION: resolve-root.sh failed"; exit 1; }
P="${ROOT:+$ROOT/}plans"
# quotePath off: a non-ASCII filename must arrive verbatim, not quoted,
# or the read below silently skips it.
files=$(git -c core.quotePath=false ls-files "$P/*.md")
[ -n "$files" ] || { echo "ACCRETION: no tracked plan files under '$P'"; exit 1; }
fail=0
# MARKERS is the per-project tuning point - each corpus accretes in its
# own verbs. Tune this list only; the date rule in PAT stays fixed.
MARKERS='supersede[sd]|retracted|settled|corrected|approved|shaped|done|absorbed|mooted|retired|updated|added|amended|re-?baselined|resolved|shipped|delivered|restored|revised|deferred|completed?'
PAT="\b($MARKERS)[[:space:]:,(-]{1,3}20[0-9]{2}-[0-9]{2}-[0-9]{2}"
EXEMPT_SPAN='s/^([0-9]+:)(approved|status|agentic):[[:space:]]*[a-z]*[[:space:]]*/\1/'

while IFS= read -r f; do
  case "$f" in "$P/archive/"*) continue ;; esac
  hits=$(grep -n '' "$f" | sed -E "$EXEMPT_SPAN" | grep -iE "$PAT" || true)
  if [ -n "$hits" ]; then
    while IFS= read -r h; do echo "ACCRETION: $f:$h"; done <<<"$hits"
    fail=1
  fi
done <<<"$files"

(( fail == 0 )) && echo "check-accretion: OK"
exit $fail
