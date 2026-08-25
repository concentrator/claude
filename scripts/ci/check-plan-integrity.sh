#!/usr/bin/env bash
# Tier-1 plan referential integrity (skills/dev/plan.md):
#  - every task in a per-R tasks.md names the R that owns its dir
#    (legacy `T-XXX (R-XXX)` tag or composite `R###-T###` prefix),
#    and that R exists in ROADMAP.md. Initiatives are keyed by their
#    digits, so the unified `R###` and legacy `R-###` spellings of one
#    id - in ROADMAP.md, a dir name, or a task id - match each other
#  - task ids are unique across all tasks.md (legacy global T-XXX ids
#    frozen; composite ids unique by their initiative-scoped counter)
#  - every branch plan's `task:` / `depends-on:` resolve to a known task
#  - every branch plan sits under an R-dir that exists in ROADMAP.md
# Plan paths resolve against the declared artifacts root (resolve-root.sh).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(git rev-parse --show-toplevel)"

ROOT="$(bash "$SCRIPT_DIR/resolve-root.sh")"
P="${ROOT:+$ROOT/}plans"
[[ -f "$P/ROADMAP.md" ]] \
  || { echo "PLAN: $P/ROADMAP.md not found (resolved artifacts root: '${ROOT:-.}')"; exit 1; }

fail=0
report() { echo "PLAN: $1"; fail=1; }
has() { grep -qxF "$1" <<<"$2"; }
# Initiative key: the digits of an `R###` or `R-###` spelling.
rkey() { grep -oE 'R-?[0-9]{3}' <<<"$1" | head -1 | tr -d '-'; }

# Entry lines only: an id mentioned in prose does not list an initiative.
roadmap_rs=$(sed -nE 's/^- \[[ x]\] (R-?[0-9]{3}).*/\1/p' "$P/ROADMAP.md" \
  | tr -d '-' | sort -u || true)

# Each per-R tasks.md: every task names the owning dir's R (in ROADMAP)
all_ts=""
while IFS= read -r f; do
  [ -n "$f" ] || continue
  owner=$(grep -oE 'R-?[0-9]{3}' <<<"${f#"$P"/}" | head -1)
  has "$(rkey "$owner")" "$roadmap_rs" || report "$f under $owner not in ROADMAP.md"
  while IFS= read -r line; do
    t=$(grep -oE 'T-[0-9]{3}' <<<"$line" | head -1 || true)
    r=$(grep -oE '\(R-?[0-9]{3}\)' <<<"$line" | head -1 | tr -d '()' || true)
    [ -n "$r" ] || { report "$t in $f has no parent R"; continue; }
    [ "$(rkey "$r")" = "$(rkey "$owner")" ] || report "$t in $f names $r but its dir is $owner"
    all_ts+="$t"$'\n'
  done < <(grep -E '^- \[[ x]\] T-[0-9]{3}' "$f")
  while IFS= read -r line; do
    cid=$(grep -oE 'R[0-9]{3}-T[0-9]{3}' <<<"$line" | head -1)
    [ "$(rkey "$cid")" = "$(rkey "$owner")" ] || report "$cid in $f but its dir is $owner"
    all_ts+="$cid"$'\n'
  done < <(grep -E '^- \[[ x]\] (\*\*)?R[0-9]{3}-T[0-9]{3}' "$f")
done < <(git ls-files "$P/R-*/tasks.md" "$P/R[0-9]*/tasks.md" \
                      "$P/archive/R-*/tasks.md" "$P/archive/R[0-9]*/tasks.md")

task_ts=$(printf '%s' "$all_ts" | grep -E '^(T-[0-9]{3}|R[0-9]{3}-T[0-9]{3})$' | sort -u || true)

# T-ids unique across all tasks.md (global ids, no R-scoped reuse)
dups=$(printf '%s' "$all_ts" | grep -E '^(T-[0-9]{3}|R[0-9]{3}-T[0-9]{3})$' | sort | uniq -d || true)
[ -z "$dups" ] || report "duplicate T-id(s) across tasks.md: $(echo $dups)"

# Each branch plan: R-dir exists, task:/depends-on: resolve to a task
while IFS= read -r f; do
  rdir=$(grep -oE 'R-?[0-9]{3}' <<<"${f#"$P"/}" | head -1 || true)
  has "$(rkey "$rdir")" "$roadmap_rs" || report "$f under $rdir not in ROADMAP.md"
  tid=$(sed -n 's/^task: *//p' "$f" | head -1)
  [ -n "$tid" ] && { has "$tid" "$task_ts" || report "$f task: $tid not in any tasks.md"; }
  deps=$(sed -n 's/^depends-on: *//p' "$f")
  for dep in $(grep -oE 'R[0-9]{3}-T[0-9]{3}' <<<"$deps"); do
    has "$dep" "$task_ts" || report "$f depends-on $dep not in any tasks.md"
  done
  for dep in $(sed -E 's/R[0-9]{3}-T[0-9]{3}//g' <<<"$deps" | grep -oE 'T-[0-9]{3}'); do
    has "$dep" "$task_ts" || report "$f depends-on $dep not in any tasks.md"
  done
done < <(git ls-files "$P" | grep -E '/(T-[0-9]{3}|R[0-9]{3}-T[0-9]{3})-[^/]+\.md$' | grep -v '\.findings\.md$')

(( fail == 0 )) && echo "check-plan-integrity: OK"
exit $fail
