#!/usr/bin/env bash
# Tier-1 plan-text gate on the plan files a branch changes, archive excluded:
# ROADMAP entries, requirements.md, tasks.md and branch plans stay short and
# stable (skills/dev/templates.md). Fails on links, ISO dates, #NNN refs,
# commit hashes, ids of another initiative, oversize entries, a task report
# checkbox without an Evidence: line, an added *.findings.md, and a branch
# plan without its task report.
set -uo pipefail
h="$(dirname "${BASH_SOURCE[0]}")/branch-diff.sh"
{ [ -r "$h" ] && . "$h"; } \
  || { echo "check-plan-text: cannot load branch-diff.sh"; exit 1; }
cd "$(git rev-parse --show-toplevel)"

P=$(sed -n 's/^- Plans: *//p' CLAUDE.md .claude/CLAUDE.md 2>/dev/null | head -1 || true)
P=${P:-dev/plans}
P=${P%/}
fail=0

base=$(branch_base) || { echo "check-plan-text: SKIP (no default branch)"; exit 0; }
new=$(mktemp); old=$(mktemp); blob=$(mktemp)
trap 'rm -f "$new" "$old" "$blob"' EXIT

scan() {
  awk -v f="$2" -v own="$3" -v mode="$4" '
    function bad(n, why, key) { printf "PLAN-TEXT: %s:%d: %s\t%s\t%s\n", f, n, why, why, key }
    function check(n, s,   t, id) {
      if (s ~ /https?:\/\// || s ~ /\]\(/) bad(n, "link", s)
      if (s ~ /20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]/) bad(n, "date", s)
      if (s ~ /(^|[^A-Za-z0-9&])#[0-9]+/) bad(n, "#NNN ref", s)
      t = s
      while (match(t, /[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]+/)) {
        id = substr(t, RSTART, RLENGTH)
        if (id ~ /[0-9]/ && id ~ /[a-f]/) { bad(n, "commit hash", s); break }
        t = substr(t, RSTART + RLENGTH)
      }
      t = s
      while (match(t, /R-?[0-9][0-9][0-9]/)) {
        id = substr(t, RSTART, RLENGTH); sub(/-/, "", id)
        if (id != own) { bad(n, "id of another initiative: " id, s); break }
        t = substr(t, RSTART + RLENGTH)
      }
    }
    BEGIN { max = mode == "plan" ? 6 : 3 }
    function open_entry() { start = NR; len = 0; first = $0; sub(/^- \[.\]/, "- [ ]", first) }
    function close_entry() { if (start && len > max) bad(start, (mode == "plan" ? "item" : "entry") " over " max " lines", first); start = 0 }
    mode == "roadmap" {
      if ($0 ~ /^- \[[ x]\] R-?[0-9][0-9][0-9]/) {
        close_entry(); match($0, /R-?[0-9][0-9][0-9]/)
        own = substr($0, RSTART, RLENGTH); sub(/-/, "", own)
        active = 1; open_entry()
      } else if ($0 !~ /^      / && $0 !~ /^  [^ ]/) { close_entry(); active = 0 }
      if (active) { len++; check(NR, $0) }
      next
    }
    mode == "tasks" || mode == "plan" {
      if ($0 ~ /^- \[/) { close_entry(); open_entry() }
      else if ($0 !~ /^  /) close_entry()
      if (start) len++
    }
    mode == "plan" { next }
    { check(NR, $0) }
    END {
      close_entry()
      if (mode == "req" && NR > 40) bad(NR, "requirements.md over 40 lines", "")
    }' "$1"
}

report() {
  awk -v f="$2" '
    function close_box() { if (box && !ev) printf "PLAN-TEXT: %s:%d: finding without Evidence: observed|test|contract\tevidence\t%s\n", f, box, first; box = 0 }
    /^- \[[ x]\]/ { close_box(); box = NR; ev = 0; first = $0; sub(/^- \[.\]/, "- [ ]", first); next }
    box && /^  +Evidence: (observed|test|contract) / { ev = 1; next }
    box && !/^  / { close_box() }
    END { close_box() }' "$1"
}

backlog() {
  awk -v f="$2" '
    function over() { if (!told) printf "PLAN-TEXT: %s:%d: backlog line over 1 line\tbacklog\t%s\n", f, at, first; told = 1 }
    /^- \[/ { task = 1; ctx = ""; ub = 0; next }
    task && /^  / { next }
    { task = 0 }
    !/[^ \t]/ { ctx = ""; next }
    /^(#|Why:)/ { ctx = /^Why:/ ? "why" : ""; ub = 0; next }
    ctx == "why" { next }
    (ctx == "line" && !/^[-*] /) || (ub && /^[ \t]/) { over(); ctx = "line"; next }
    { at = NR; first = $0; told = 0; ub = /^[-*] /; ctx = "line" }' "$1"
}

judge() {
  local fn=$1 f=$2 from=$3 out; shift 3
  "$fn" "$f" "$f" "$@" > "$new"
  : > "$old"
  if [ -n "$from" ] && git show "$base:$from" > "$blob" 2>/dev/null; then "$fn" "$blob" "$f" "$@" > "$old"; fi
  out=$(awk '
    { i = index($0, "\t"); k = substr($0, i + 1) }
    FILENAME == ARGV[1] { seen[k]++; next }
    seen[k] > 0 { seen[k]--; next }
    { print substr($0, 1, i - 1) }' "$old" "$new")
  [ -z "$out" ] || { printf '%s\n' "$out"; fail=1; }
}

had() { git cat-file -e "$base:$1" 2>/dev/null; }

while IFS=$'\t' read -r st f from; do
  [ -f "$f" ] || continue
  rel=${f#"$P"/}
  case $rel in archive/*) continue ;; ROADMAP.md) judge scan "$f" "$from" "" roadmap; continue ;; esac
  [[ $rel == *.findings.md ]] && { [[ $st == A ]] && echo "PLAN-TEXT: $f: findings file: use the task report" && fail=1; continue; }
  [[ $rel =~ ^R-?([0-9]{3})-[^/]*/([^/]+)$ ]] || continue
  id=R${BASH_REMATCH[1]}
  case ${BASH_REMATCH[2]} in
    requirements.md) judge scan "$f" "$from" "$id" req ;;
    tasks.md) judge scan "$f" "$from" "$id" tasks; judge backlog "$f" "$from" ;;
    *.report.md) judge report "$f" "$from" ;;
    *.md) judge scan "$f" "$from" "$id" plan
      [ -f "${f%.md}.report.md" ] || [ -f "${f%.md}.findings.md" ] \
        || { [ -n "$from" ] && ! had "${from%.md}.report.md" && ! had "${from%.md}.findings.md"; } \
        || { echo "PLAN-TEXT: $f: plan without task report"; fail=1; } ;;
  esac
done < <(branch_changed "$base" "$P")

[ "$fail" -eq 0 ] && echo "check-plan-text: OK"
exit "$fail"
