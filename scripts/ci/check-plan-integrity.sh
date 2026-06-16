#!/usr/bin/env bash
# Tier-1 plan referential integrity (rules/planning.md):
#  - every TASKS.md task names a parent R that exists in ROADMAP.md
#  - every branch plan's `task:` / `depends-on:` resolve to a TASKS task
#  - every branch plan sits under an R-dir that exists in ROADMAP.md
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0
report() { echo "PLAN: $1"; fail=1; }
has() { grep -qxF "$1" <<<"$2"; }

roadmap_rs=$(grep -oE 'R-[0-9]{3}' plans/ROADMAP.md | sort -u)
task_ts=$(grep -oE 'T-[0-9]{3}' plans/TASKS.md | sort -u)

# Each TASKS task's parent R exists in ROADMAP
while IFS= read -r line; do
  t=$(grep -oE 'T-[0-9]{3}' <<<"$line" | head -1)
  r=$(grep -oE 'R-[0-9]{3}' <<<"$line" | head -1)
  [ -n "$r" ] || { report "$t has no parent R in TASKS.md"; continue; }
  has "$r" "$roadmap_rs" || report "$t parent $r not in ROADMAP.md"
done < <(grep -E '^- \[[ x]\] T-[0-9]{3}' plans/TASKS.md)

# Each branch plan: R-dir exists, task:/depends-on: resolve
while IFS= read -r f; do
  rdir=$(echo "$f" | grep -oE 'R-[0-9]{3}')
  has "$rdir" "$roadmap_rs" || report "$f under $rdir not in ROADMAP.md"
  tid=$(sed -n 's/^task: *//p' "$f" | head -1)
  [ -n "$tid" ] && { has "$tid" "$task_ts" || report "$f task: $tid not in TASKS.md"; }
  for dep in $(sed -n 's/^depends-on: *//p' "$f" | grep -oE 'T-[0-9]{3}'); do
    has "$dep" "$task_ts" || report "$f depends-on $dep not in TASKS.md"
  done
done < <(git ls-files plans | grep -E '/T-[0-9]{3}-[^/]+\.md$' | grep -v '\.findings\.md$')

(( fail == 0 )) && echo "check-plan-integrity: OK"
exit $fail
