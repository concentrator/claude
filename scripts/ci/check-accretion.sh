#!/usr/bin/env bash
# Tier-1 accretion gate (R-041): living plan artifacts state the present
# (writing.md § State the present). Flags dated supersession / amendment /
# status markers in tracked plans/**/*.md - the date is the discriminator:
# an undated terminal outcome ("mooted by R-021") is present state, a dated
# one ("superseded 2026-07-07") is hand-rolled version control that belongs
# to git history. plans/archive/ is frozen history and exempt, as are the
# frontmatter fields the plan artifacts mandate (`approved:`,
# `status: done`, `agentic: approved`).
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0
PAT='(superseded|retracted|settled|corrected|approved|shaped|done|absorbed|mooted|retired|updated|added) 20[0-9]{2}'

while IFS= read -r f; do
  hits=$(grep -inE "$PAT" "$f" | grep -vE '^[0-9]+:(approved|status|agentic):' || true)
  if [ -n "$hits" ]; then
    while IFS= read -r h; do echo "ACCRETION: $f:$h"; done <<<"$hits"
    fail=1
  fi
done < <(git ls-files 'plans/*.md' 'plans/**/*.md' | sort -u | grep -v '^plans/archive/')

(( fail == 0 )) && echo "check-accretion: OK"
exit $fail
