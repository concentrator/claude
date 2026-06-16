#!/usr/bin/env bash
# Tier-1 ledger gate (MAINTENANCE.md § Ledger): a Tier-2 review must
# certify the delivered content. Pass iff maintenance.json holds a
# `concerns_clear: true` entry whose SHA is an ancestor of HEAD and
# whose `<sha>..HEAD` diff touches only maintenance.json — i.e. the
# review covered exactly the delivered tree (the stamp commit aside).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

ok=0
while IFS= read -r sha; do
  [ -z "$sha" ] && continue
  git cat-file -e "${sha}^{commit}" 2>/dev/null || continue
  git merge-base --is-ancestor "$sha" HEAD 2>/dev/null || continue
  changed=$(git diff --name-only "$sha" HEAD)
  if [ -z "$changed" ] || [ "$changed" = "maintenance.json" ]; then ok=1; break; fi
done < <(jq -r 'to_entries[] | select(.value.concerns_clear==true) | .key' maintenance.json 2>/dev/null)

if (( ok == 1 )); then echo "check-ledger: OK"; exit 0; fi
echo "LEDGER: no concerns_clear entry certifies HEAD's content tip"
exit 1
