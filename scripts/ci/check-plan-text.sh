#!/usr/bin/env bash
# Tier-1 plan-text gate: ROADMAP entries, requirements.md and tasks.md stay
# short and stable (skills/dev/templates.md). Fails on URLs and markdown
# links, ISO dates, #NNN refs, commit hashes, ids of another initiative,
# and size: requirements.md over 40 lines, a task or roadmap entry over 3,
# a tasks.md backlog line over 1, a branch plan checkbox item over 6.
# A task report's checkbox needs an Evidence: line (observed|test|contract);
# an added *.findings.md fails, findings go to the task report.
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

scan() { # file own-id mode(req|tasks|roadmap|plan)
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
    BEGIN { max = mode == "plan" ? 6 : 3 }
    function close_entry() { if (start && len > max) bad(start, (mode == "plan" ? "item" : "entry") " over " max " lines"); start = 0 }
    mode == "roadmap" {
      if ($0 ~ /^- \[[ x]\] R-?[0-9][0-9][0-9]/) {
        close_entry(); match($0, /R-?[0-9][0-9][0-9]/)
        own = substr($0, RSTART, RLENGTH); sub(/-/, "", own)
        active = 1; len = 0; start = NR
      } else if ($0 !~ /^      / && $0 !~ /^  [^ ]/) { close_entry(); active = 0 }
      if (active) { len++; check(NR, $0) }
      next
    }
    mode == "tasks" || mode == "plan" {
      if ($0 ~ /^- \[/) { close_entry(); start = NR; len = 0 }
      else if ($0 !~ /^  /) close_entry()
      if (start) len++
    }
    mode == "plan" { next }
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

backlog() { # file
  awk -v f="$1" '
    function over() { if (!told) printf "PLAN-TEXT: %s:%d: backlog line over 1 line\n", f, at; told = 1; hit = 1 }
    /^- \[/ { task = 1; ctx = ""; ub = 0; next }
    task && /^  / { next }
    { task = 0 }
    !/[^ \t]/ { ctx = ""; next }
    /^(#|Why:)/ { ctx = /^Why:/ ? "why" : ""; ub = 0; next }
    ctx == "why" { next }
    (ctx == "line" && !/^[-*] /) || (ub && /^[ \t]/) { over(); ctx = "line"; next }
    { at = NR; told = 0; ub = /^[-*] /; ctx = "line" }
    END { exit hit }' "$1" || fail=1
}

while IFS=$'\t' read -r st f to; do
  f=${to:-$f}
  [ -f "$f" ] || continue
  rel=${f#"$P"/}
  case $rel in archive/*) continue ;; ROADMAP.md) scan "$f" "" roadmap; continue ;; esac
  [[ $st == A && $rel == *.findings.md ]] && { echo "PLAN-TEXT: $f: findings file: use the task report"; fail=1; continue; }
  [[ $rel =~ ^R-?([0-9]{3})-[^/]*/([^/]+)$ ]] || continue
  id=R${BASH_REMATCH[1]}
  case ${BASH_REMATCH[2]} in
    requirements.md) scan "$f" "$id" req ;;
    tasks.md) scan "$f" "$id" tasks; backlog "$f" ;;
    *.report.md) report "$f" ;;
    *.md) scan "$f" "$id" plan ;;
  esac
done < <({ git diff --name-status -M "$base" -- "$P"; git ls-files --others --exclude-standard -- "$P" | awk '{ print "A\t" $0 }'; } | sort -u)

[ "$fail" -eq 0 ] && echo "check-plan-text: OK"
exit "$fail"
