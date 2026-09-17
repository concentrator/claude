#!/usr/bin/env bash
# Tier-1 plan-text gate: ROADMAP entries, requirements.md and tasks.md stay
# short and stable (skills/dev/templates.md). Fails on URLs and markdown
# links, ISO dates, #NNN refs, commit hashes, ids of another initiative,
# and size: requirements.md over 40 lines, a task or roadmap entry over 3.
# A task report's checkbox needs an Evidence: line (observed|test|contract).
# Initiatives numbered below FROM are legacy and skipped.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

# FROM is the per-project tuning point: the first initiative held to the gate.
FROM='R081'

P=$(sed -n 's/^- Plans: *//p' CLAUDE.md 2>/dev/null | head -1 || true)
P=${P:-dev/plans}
P=${P%/}
from=$((10#${FROM#R}))
fail=0

scan() { # file own-id mode(req|tasks|roadmap)
  awk -v f="$1" -v own="$2" -v mode="$3" -v from="$from" '
    function bad(n, why) { printf "PLAN-TEXT: %s:%d: %s\n", f, n, why; hit = 1 }
    function check(n, s,   t, id) {
      if (s ~ /https?:\/\// || s ~ /\]\(/) bad(n, "link")
      if (s ~ /20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]/) bad(n, "date")
      if (s ~ /(^|[^A-Za-z0-9&])#[0-9]+/) bad(n, "#NNN ref")
      t = s
      while (match(t, /[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]+/)) {
        id = substr(t, RSTART, RLENGTH)
        if (id ~ /[0-9]/ && id ~ /[a-f]/) { bad(n, "commit hash"); break }
        t = substr(t, RSTART + RLENGTH)
      }
      t = s
      while (match(t, /R-?[0-9][0-9][0-9]/)) {
        id = substr(t, RSTART, RLENGTH); sub(/-/, "", id)
        if (id != own) { bad(n, "id of another initiative: " id); break }
        t = substr(t, RSTART + RLENGTH)
      }
    }
    function close_entry() { if (start && len > 3) bad(start, "entry over 3 lines"); start = 0 }
    mode == "roadmap" {
      if ($0 ~ /^- \[[ x]\] R-?[0-9][0-9][0-9]/) {
        close_entry(); match($0, /R-?[0-9][0-9][0-9]/)
        own = substr($0, RSTART, RLENGTH); sub(/-/, "", own)
        active = (substr(own, 2) + 0 >= from); len = 0
        if (active) start = NR
      } else if ($0 !~ /^      / && $0 !~ /^  [^ ]/) { close_entry(); active = 0 }
      if (active) { len++; check(NR, $0) }
      next
    }
    mode == "tasks" {
      if ($0 ~ /^- \[/) { close_entry(); start = NR; len = 0 }
      else if ($0 !~ /^  /) close_entry()
      if (start) len++
    }
    { check(NR, $0) }
    END {
      close_entry()
      if (mode == "req" && NR > 40) bad(NR, "requirements.md over 40 lines")
      exit hit
    }' "$1" || fail=1
}

[ -f "$P/ROADMAP.md" ] && scan "$P/ROADMAP.md" "" roadmap
while IFS= read -r d; do
  base=${d##*/}; id=${base%%-*}
  [[ $id =~ ^R[0-9]{3}$ ]] || continue
  (( 10#${id#R} >= from )) || continue
  [ -f "$d/requirements.md" ] && scan "$d/requirements.md" "$id" req
  [ -f "$d/tasks.md" ] && scan "$d/tasks.md" "$id" tasks
  for r in "$d"/*.report.md; do
    [ -f "$r" ] || continue
    awk -v f="$r" '
      function close_box() { if (box && !ev) { printf "PLAN-TEXT: %s:%d: finding without Evidence: observed|test|contract\n", f, box; hit = 1 } box = 0 }
      /^- \[[ x]\]/ { close_box(); box = NR; ev = 0; next }
      box && /^  +Evidence: (observed|test|contract) / { ev = 1; next }
      box && !/^  / { close_box() }
      END { close_box(); exit hit }' "$r" || fail=1
  done
done < <(git ls-files "$P" | sed -n "s#^\($P/R[0-9][0-9][0-9]-[^/]*\)/.*#\1#p" | sort -u)

[ "$fail" -eq 0 ] && echo "check-plan-text: OK"
exit "$fail"
