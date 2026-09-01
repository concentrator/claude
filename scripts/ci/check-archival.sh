#!/usr/bin/env bash
# Tier-1 archival gate (skills/dev/plan.md § Archival): a closed
# initiative leaves dev/plans/ in the delivery that closes it. A
# non-archive dev/plans/*/requirements.md whose frontmatter carries
# `status: done` fails until the dir moves to dev/plans/archive/;
# `archival: deferred - <reason>` exempts it and the reason is printed.
# Reads the working tree: the gate judges the state a delivery would
# leave, not history.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0
for f in dev/plans/*/requirements.md; do
  [[ -f "$f" ]] || continue
  head -1 "$f" | grep -qx -- '---' || continue   # no frontmatter
  r=$(basename "$(dirname "$f")")
  # grep drains its input: -q would exit early and SIGPIPE tail under
  # pipefail on a file larger than the pipe buffer.
  if ! tail -n +2 "$f" | grep -x -- '---' >/dev/null; then
    echo "ARCHIVAL: $f frontmatter has no closing --- - fix it before its status can be read"
    fail=1; continue
  fi
  fm=$(sed -n '2,${/^---$/q;p;}' "$f")
  grep -q '^status: done\( \|$\)' <<<"$fm" || continue
  if grep -q '^archival: deferred' <<<"$fm"; then
    reason=$(sed -n 's/^archival: deferred - //p' <<<"$fm" | head -1)
    if [[ -n "$reason" ]]; then
      echo "check-archival: $r deferred - $reason"
      continue
    fi
    echo "ARCHIVAL: $r defers archival without a reason - write 'archival: deferred - <reason>'"
    fail=1; continue
  fi
  echo "ARCHIVAL: $r is closed (status: done) but not archived - git mv dev/plans/$r dev/plans/archive/ in the closing delivery"
  fail=1
done

(( fail == 0 )) && echo "check-archival: OK"
exit $fail
