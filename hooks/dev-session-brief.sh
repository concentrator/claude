#!/usr/bin/env bash
# dev-session-brief.sh - SessionStart hook. Compaction keeps the
# conversation's summary but not the tree's exact state, so a session
# resuming mid-branch would rediscover what is committed, what is not and
# where the plan stands. On a compact or resume start (the settings
# matcher filters the reason) this hook reads the tree at that moment and
# injects it as additionalContext: repo, branch, status, recent commits
# and the first open item of each plan the branch touched. Subagent starts
# carry agent_id and need no re-brief. A reminder's delivery, never a
# gate: outside a git repo or on any read failure it exits 0 silent
# (fail open).
set -uo pipefail

command -v jq >/dev/null 2>&1 || exit 0
input=$(cat 2>/dev/null || true)
dir=$(dirname "$0")

printf '%s' "$input" | jq -e . >/dev/null 2>&1 || exit 0
start_source=$(printf '%s' "$input" | jq -r '.source // ""' 2>/dev/null)
. "$dir/dev-hook-once.sh" 2>/dev/null && global_hook_runs "$0" SessionStart "$start_source" && exit 0
[ -n "$(printf '%s' "$input" | jq -r '.agent_id // empty' 2>/dev/null)" ] && exit 0

# Root: the project root the harness names, else the repo above the cwd.
root=${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}
[ -n "$root" ] || exit 0
git -C "$root" rev-parse --show-toplevel >/dev/null 2>&1 || exit 0

branch=$(git -C "$root" rev-parse --abbrev-ref HEAD 2>/dev/null)
status=$(git -C "$root" status --porcelain 2>/dev/null | paste -sd ';' - | sed 's/;/; /g')
commits=$(git -C "$root" log --oneline -5 2>/dev/null | paste -sd ';' - | sed 's/;/; /g')
# Branch plans keep one checkbox per commit; the first unticked box in any
# plan this branch touched is where the work resumes. The tree is the one
# the declaration names, so a plans tree whose name lacks `plans/` still
# fills the plan lines.
plans_dir=$(sed -n 's/^- Plans: *//p' "$root/CLAUDE.md" "$root/.claude/CLAUDE.md" 2>/dev/null | head -1)
plans_dir=${plans_dir:-dev/plans}; plans_dir=${plans_dir%/}
base=HEAD
for ref in origin/main origin/master main master; do
  b=$(git -C "$root" merge-base HEAD "$ref" 2>/dev/null) && { base=$b; break; }
done
plans=$(git -C "$root" diff --name-only "$base" HEAD 2>/dev/null \
  | grep -E "^$plans_dir/.*\.md$" | grep -v '/archive/' \
  | while IFS= read -r f; do
      [ -f "$root/$f" ] || continue
      hit=$(grep -n -m1 '^- \[ \]' "$root/$f")
      [ -n "$hit" ] && printf -- '- plan: %s line %s: %s\n' "$f" "${hit%%:*}" "${hit#*:}"
    done)

brief=$(
  printf 'tree state read at this start:\n'
  printf -- '- repo: %s\n' "$root"
  printf -- '- branch: %s\n' "${branch:-unknown}"
  printf -- '- status: %s\n' "${status:-clean}"
  printf -- '- commits: %s\n' "${commits:-none}"
  [ -z "$plans" ] || printf '%s\n' "$plans"
)

jq -n --arg b "$brief" \
  '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $b}}'
exit 0
