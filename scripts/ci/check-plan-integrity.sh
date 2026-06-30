#!/usr/bin/env bash
# Tier-1 plan referential integrity (rules/planning.md):
#  - every task in a per-R tasks.md names the R that owns its dir,
#    and that R exists in ROADMAP.md
#  - T-ids are unique across all per-R tasks.md (global + monotonic)
#  - every branch plan's `task:` / `depends-on:` resolve to a known task
#  - every branch plan sits under an R-dir that exists in ROADMAP.md
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

ROOT="${CLAUDE_ROOT:-.}"   # "." self-hosting (default); ".claude" embedded

fail=0
report() { echo "PLAN: $1"; fail=1; }
has() { grep -qxF "$1" <<<"$2"; }

roadmap_rs=$(grep -oE 'R-[0-9]{3}' "$ROOT/plans/ROADMAP.md" | sort -u || true)

# Each per-R tasks.md: every task names the owning dir's R (in ROADMAP)
all_ts=""
while IFS= read -r f; do
  [ -n "$f" ] || continue
  owner=$(grep -oE 'R-[0-9]{3}' <<<"$f" | head -1)
  has "$owner" "$roadmap_rs" || report "$f under $owner not in ROADMAP.md"
  while IFS= read -r line; do
    t=$(grep -oE 'T-[0-9]{3}' <<<"$line" | head -1 || true)
    r=$(grep -oE 'R-[0-9]{3}' <<<"$line" | head -1 || true)
    [ -n "$r" ] || { report "$t in $f has no parent R"; continue; }
    [ "$r" = "$owner" ] || report "$t in $f names $r but its dir is $owner"
    all_ts+="$t"$'\n'
  done < <(grep -E '^- \[[ x]\] T-[0-9]{3}' "$f")
done < <(git ls-files "$ROOT/plans/R-*/tasks.md")

task_ts=$(printf '%s' "$all_ts" | grep -E 'T-[0-9]{3}' | sort -u || true)

# T-ids unique across all tasks.md (global ids, no R-scoped reuse)
dups=$(printf '%s' "$all_ts" | grep -E 'T-[0-9]{3}' | sort | uniq -d || true)
[ -z "$dups" ] || report "duplicate T-id(s) across tasks.md: $(echo $dups)"

# Each branch plan: R-dir exists, task:/depends-on: resolve to a task
while IFS= read -r f; do
  rdir=$(echo "$f" | grep -oE 'R-[0-9]{3}' | head -1 || true)
  has "$rdir" "$roadmap_rs" || report "$f under $rdir not in ROADMAP.md"
  tid=$(sed -n 's/^task: *//p' "$f" | head -1)
  [ -n "$tid" ] && { has "$tid" "$task_ts" || report "$f task: $tid not in any tasks.md"; }
  for dep in $(sed -n 's/^depends-on: *//p' "$f" | grep -oE 'T-[0-9]{3}'); do
    has "$dep" "$task_ts" || report "$f depends-on $dep not in any tasks.md"
  done
done < <(git ls-files "$ROOT/plans" | grep -E '/T-[0-9]{3}-[^/]+\.md$' | grep -v '\.findings\.md$')

(( fail == 0 )) && echo "check-plan-integrity: OK"
exit $fail
