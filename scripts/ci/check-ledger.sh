#!/usr/bin/env bash
# Tier-1 ledger gate (MAINTENANCE.md § Ledger): a Tier-2 review must
# certify the delivered content. Pass iff maintenance.jsonl holds a
# `concerns_clear` line whose `.sha` is an ancestor of HEAD and whose
# `<sha>..HEAD` diff touches only maintenance.jsonl - i.e. the review
# covered exactly the delivered tree (the stamp commit aside).
# Append-only JSONL (union-merged), so concurrent PR stamps never
# conflict; this scans every line and passes on the first match.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

ok=0
while IFS= read -r line; do
  [ -z "$line" ] && continue
  echo "$line" | jq -e '.concerns_clear == true' >/dev/null 2>&1 || continue
  sha=$(echo "$line" | jq -r '.sha' 2>/dev/null) || continue
  [ -n "$sha" ] && [ "$sha" != "null" ] || continue
  git cat-file -e "${sha}^{commit}" 2>/dev/null || continue
  git merge-base --is-ancestor "$sha" HEAD 2>/dev/null || continue
  changed=$(git diff --name-only "$sha" HEAD)
  if [ -z "$changed" ] || [ "$changed" = "maintenance.jsonl" ]; then ok=1; break; fi
done < maintenance.jsonl

if (( ok == 1 )); then echo "check-ledger: OK"; exit 0; fi
echo "LEDGER: no concerns_clear entry certifies HEAD's content tip"
exit 1
