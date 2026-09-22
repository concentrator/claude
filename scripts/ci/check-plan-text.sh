#!/usr/bin/env bash
# Tier-1 plan-text gate: ROADMAP entries, requirements.md and tasks.md stay
# short and stable (skills/dev/templates.md). Fails on URLs and markdown
# links, ISO dates, #NNN refs, commit hashes, ids of another initiative,
# and size: requirements.md over 40 lines, a task or roadmap entry over 3.
# A task report's checkbox needs an Evidence: line (observed|test|contract).
# Only the plan files a branch changes against its merge-base with the
# default branch are checked, working tree included, archive excluded.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

P=$(sed -n 's/^- Plans: *//p' CLAUDE.md 2>/dev/null | head -1 || true)
P=${P:-dev/plans}
P=${P%/}
fail=0

base=
for ref in origin/main origin/master main master; do
  base=$(git merge-base HEAD "$ref" 2>/dev/null) && break
  base=
done
[ -n "$base" ] || { echo "check-plan-text: SKIP (no default branch)"; exit 0; }

scan() { # file own-id mode(req|tasks|roadmap)
  awk -v f="$1" -v own="$2" -v mode="$3" '
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
        active = 1; len = 0; start = NR
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

report() { # file
  awk -v f="$1" '
    function close_box() { if (box && !ev) { printf "PLAN-TEXT: %s:%d: finding without Evidence: observed|test|contract\n", f, box; hit = 1 } box = 0 }
    /^- \[[ x]\]/ { close_box(); box = NR; ev = 0; next }
    box && /^  +Evidence: (observed|test|contract) / { ev = 1; next }
    box && !/^  / { close_box() }
    END { close_box(); exit hit }' "$1" || fail=1
}

while IFS= read -r f; do
  [ -f "$f" ] || continue
  rel=${f#"$P"/}
  case $rel in archive/*) continue ;; ROADMAP.md) scan "$f" "" roadmap; continue ;; esac
  [[ $rel =~ ^R-?([0-9]{3})-[^/]*/([^/]+)$ ]] || continue
  id=R${BASH_REMATCH[1]}
  case ${BASH_REMATCH[2]} in
    requirements.md) scan "$f" "$id" req ;;
    tasks.md) scan "$f" "$id" tasks ;;
    *.report.md) report "$f" ;;
  esac
done < <({ git diff --name-only "$base" -- "$P"; git ls-files --others --exclude-standard -- "$P"; } | sort -u)

[ "$fail" -eq 0 ] && echo "check-plan-text: OK"
exit "$fail"
