#!/usr/bin/env bash
# Tier-1 archival gate (skills/dev/plan.md § Archival): a closed
# initiative leaves dev/plans/ in the delivery that closes it. A
# non-archive dev/plans/*/requirements.md whose frontmatter carries
# `status: done` fails until the dir moves to dev/plans/archive/.
# Reads the working tree: the gate judges the state a delivery would
# leave, not history.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0
for f in dev/plans/*/requirements.md; do
  [[ -f "$f" ]] || continue
  head -1 "$f" | grep -qx -- '---' || continue   # no frontmatter
  fm=$(sed -n '2,${/^---$/q;p;}' "$f")
  grep -q '^status: done' <<<"$fm" || continue
  r=$(basename "$(dirname "$f")")
  echo "ARCHIVAL: $r is closed (status: done) but not archived - git mv dev/plans/$r dev/plans/archive/ in the closing delivery"
  fail=1
done

(( fail == 0 )) && echo "check-archival: OK"
exit $fail
