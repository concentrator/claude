#!/usr/bin/env bash
# dev-precompact-state.sh - PreCompact hook (R040-T019). Compaction keeps
# the conversation's summary but not the tree's exact state, so a session
# resuming mid-branch has to rediscover what is committed, what is not,
# and where the plan stands. This hook appends a `tree` block to the
# session's state file just before compaction; hooks/dev-branch-state.sh
# names that file on the next prompt, so the resumed session re-briefs
# from the tree, never the summary (skills/dev/handoff.md owns the file's
# format and the hand-off block the session itself writes). Display only,
# never a decision. Silent outside a git repo; every read fails open.
# `--path` prints the session file's path for the same stdin and writes
# nothing: the one home of the path, used by dev-branch-state.sh.
set -uo pipefail

path_only=0; [ "${1:-}" = "--path" ] && path_only=1
input=$(cat 2>/dev/null || true)
sid=
trigger=unknown
if command -v jq >/dev/null 2>&1 && [ -n "$input" ]; then
  sid=$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null)
  trigger=$(printf '%s' "$input" | jq -r '.compaction_trigger // "unknown"' 2>/dev/null)
fi

# Root: the project root the harness names, else the repo above the cwd.
root=${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}
[ -n "$root" ] || exit 0
git -C "$root" rev-parse --show-toplevel >/dev/null 2>&1 || exit 0

# Session dir: <artifacts root>/session under the repo (resolve-root.sh
# reads the CLAUDE.md declaration; absent -> dev). DEV_STATE_DIR overrides.
if [ -n "${DEV_STATE_DIR:-}" ]; then
  dir=$DEV_STATE_DIR
else
  resolver="$(cd "$(dirname "$0")/.." && pwd)/scripts/ci/resolve-root.sh"
  art=$(cd "$root" && bash "$resolver" 2>/dev/null) || art=dev
  dir="$root/${art:+$art/}session"
fi

# One file per session; without a session id, one per repository.
key=${sid:-$(printf '%s' "$root" | cksum | cut -d' ' -f1)}
out="$dir/$key.md"
[ "$path_only" -eq 1 ] && { printf '%s\n' "$out"; exit 0; }

# Read the tree before touching it, so the record is about the work.
branch=$(git -C "$root" rev-parse --abbrev-ref HEAD 2>/dev/null)
status=$(git -C "$root" status --porcelain 2>/dev/null | paste -sd ';' - | sed 's/;/; /g')
commits=$(git -C "$root" log --oneline -5 2>/dev/null | paste -sd ';' - | sed 's/;/; /g')
# Branch plans keep one checkbox per commit; the first unticked box in any
# plan this branch touched is where the work resumes.
base=$(git -C "$root" merge-base HEAD origin/main 2>/dev/null || echo HEAD)
plans=$(git -C "$root" diff --name-only "$base" HEAD 2>/dev/null \
  | grep -E '(^|/)plans/.*\.md$' | grep -v '/archive/' \
  | while IFS= read -r f; do
      [ -f "$root/$f" ] || continue
      hit=$(grep -n -m1 '^- \[ \]' "$root/$f")
      [ -n "$hit" ] && printf -- '- plan: %s line %s: %s\n' "$f" "${hit%%:*}" "${hit#*:}"
    done)

mkdir -p "$dir" 2>/dev/null || exit 0
header=1; [ -f "$out" ] && header=0   # decided before >> creates the file
{
  [ "$header" -eq 1 ] && printf '# session %s\n' "$key"
  printf '\n## tree %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf -- '- trigger: %s\n' "$trigger"
  printf -- '- repo: %s\n' "$root"
  printf -- '- branch: %s\n' "${branch:-unknown}"
  printf -- '- status: %s\n' "${status:-clean}"
  printf -- '- commits: %s\n' "${commits:-none}"
  [ -n "$plans" ] && printf '%s\n' "$plans"
} >> "$out" 2>/dev/null || exit 0

printf 'session-state: %s\n' "$out"
exit 0
