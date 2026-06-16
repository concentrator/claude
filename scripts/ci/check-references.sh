#!/usr/bin/env bash
# Tier-1 reference freshness: fail on expired `<!-- expires: YYYY-MM-DD -->`
# markers (strictly before today) across tracked markdown.
# Dead *paths* are a Tier-2 AI-review concern (MAINTENANCE.md), not a
# mechanical check — lazy dirs, skill-relative paths, and the
# self-hosting `.claude/` indirection make path resolution a judgment
# call that produces false positives in CI.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0
today=$(date +%F)
while IFS= read -r m; do
  [ -z "$m" ] && continue
  d=$(echo "$m" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
  [[ "$d" < "$today" ]] && { echo "EXPIRED: $m (today $today)"; fail=1; }
done < <(grep -rhoE '<!-- expires: [0-9]{4}-[0-9]{2}-[0-9]{2} -->' $(git ls-files '*.md') 2>/dev/null || true)

(( fail == 0 )) && echo "check-references: OK"
exit $fail
