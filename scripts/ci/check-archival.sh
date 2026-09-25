#!/usr/bin/env bash
# Tier-1 archival gate (skills/dev/plan.md § Archival): a closed
# initiative leaves the plans tree the root CLAUDE.md § Layout declares
# in the delivery that closes it. A non-archive <plans>/*/requirements.md
# whose frontmatter carries `status: done` fails until the dir moves to
# <plans>/archive/; `archival: deferred - <reason>` exempts it and the
# reason is printed.
# Reads the working tree: the gate judges the state a delivery would
# leave, not history.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

P=$(sed -n 's/^- Plans: *//p' CLAUDE.md 2>/dev/null | head -1 || true)
P=${P:-dev/plans}
P=${P%/}

fail=0
for f in "$P"/*/requirements.md; do
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
  echo "ARCHIVAL: $r is closed (status: done) but not archived - git mv $P/$r $P/archive/ in the closing delivery"
  fail=1
done

# A task list with every task [x] under a live initiative dir: the last
# task closed without the closure check (plan.md § Approval and closure).
for t in "$P"/*/tasks.md; do
  [[ -f "$t" ]] || continue
  d=$(dirname "$t"); r=$(basename "$d")
  id=$(sed -E 's/^(R-?[0-9]{3}).*/\1/' <<<"$r")
  grep -q '^- \[x\] \*\*' "$t" || continue
  grep -q '^- \[ \] \*\*' "$t" && continue
  fm=$(sed -n '2,${/^---$/q;p;}' "$d/requirements.md" 2>/dev/null)
  grep -q '^archival: deferred - .' <<<"$fm" && continue
  if grep -qE "^- \[x\] ${id}:" "$P/ROADMAP.md" 2>/dev/null; then
    echo "ARCHIVAL: $r is closed in ROADMAP but not archived - git mv $P/$r $P/archive/ in the closing delivery"
  else
    echo "ARCHIVAL: $r has every task closed but the initiative open - run the closure check, then mark it [x] in ROADMAP and git mv $P/$r $P/archive/ (plan.md § Approval and closure)"
  fi
  fail=1
done

(( fail == 0 )) && echo "check-archival: OK"
exit $fail
