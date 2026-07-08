#!/usr/bin/env bash
# Tier-1 ledger gate (MAINTENANCE.md § Ledger): a Tier-2 review must
# certify the delivered content. Pass iff the per-commit store
# `maintenance.d/` holds a `concerns_clear` stamp whose `.sha` is an
# ancestor of HEAD and whose `<sha>..HEAD` diff touches only `maintenance.d/`
# - i.e. the review covered exactly the delivered tree (the stamp commit
# aside). One file per stamp (`maintenance.d/<content-tip-sha>.json`), so
# concurrent PR stamps land on distinct paths and never conflict; this scans
# every file and passes on the first match.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
shopt -s nullglob
ok=0
for f in maintenance.d/*.json; do
  jq -e '.concerns_clear == true' "$f" >/dev/null 2>&1 || continue
  sha=$(jq -r '.sha' "$f" 2>/dev/null) || continue
  [ -n "$sha" ] && [ "$sha" != "null" ] || continue
  git cat-file -e "${sha}^{commit}" 2>/dev/null || continue
  git merge-base --is-ancestor "$sha" HEAD 2>/dev/null || continue
  changed=$(git diff --name-only "$sha" HEAD)
  # Pass iff the sha..HEAD diff touches only the ledger store.
  if [ -z "$changed" ] || ! printf '%s\n' "$changed" | grep -qvE '^maintenance\.d/'; then
    ok=1; break
  fi
done
if (( ok == 1 )); then echo "check-ledger: OK"; exit 0; fi
echo "LEDGER: no concerns_clear entry certifies HEAD's content tip"
exit 1
