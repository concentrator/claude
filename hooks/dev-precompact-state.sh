#!/usr/bin/env bash
# dev-precompact-state.sh - PreCompact hook. Compaction keeps the
# conversation's summary but not the tree's exact state, so a session
# that resumes mid-branch has to rediscover what is committed, what is
# not, and where the plan stands. This hook writes that state to a file
# just before compaction; hooks/dev-branch-state.sh points the next
# prompt at the file, so the resumed session re-briefs from the tree
# rather than from memory. Display only, never a decision. Silent
# outside a git repo; every read fails open.
set -uo pipefail

input=$(cat 2>/dev/null || true)
sid=
trigger=unknown
if command -v jq >/dev/null 2>&1 && [ -n "$input" ]; then
  sid=$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null)
  trigger=$(printf '%s' "$input" | jq -r '.trigger // "unknown"' 2>/dev/null)
fi

root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
[ -n "$root" ] || exit 0

# One file per session; without a session id, one per repository.
key=${sid:-$(printf '%s' "$root" | cksum | cut -d' ' -f1)}
dir="${DEV_STATE_DIR:-$HOME/.claude/state/precompact}"
mkdir -p "$dir" 2>/dev/null || exit 0
out="$dir/$key.md"

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
{
  printf '# State before compaction\n\n'
  printf -- '- at: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf -- '- trigger: %s\n' "$trigger"
  printf -- '- repo: %s\n' "$root"
  printf -- '- branch: %s\n\n' "${branch:-unknown}"
  printf '## Uncommitted (git status --porcelain)\n\n```\n'
  git -C "$root" status --porcelain 2>/dev/null
  printf '```\n\n## Last commits\n\n```\n'
  git -C "$root" log --oneline -5 2>/dev/null
  printf '```\n\n## Open plan items\n\n'
  # Branch plans keep one checkbox per commit; the first unticked box in
  # any plan touched on this branch is where the work resumes.
  git -C "$root" diff --name-only "$(git -C "$root" merge-base HEAD origin/main 2>/dev/null || echo HEAD)" HEAD 2>/dev/null \
    | grep -E '(^|/)plans/.*\.md$' | grep -v '/archive/' \
    | while IFS= read -r f; do
        [ -f "$root/$f" ] || continue
        n=$(grep -n -m1 '^- \[ \]' "$root/$f" | cut -d: -f1)
        [ -n "$n" ] && printf -- '- %s: first open item at line %s\n' "$f" "$n"
      done
  printf '\nRe-brief from this file and the tree, not from memory. Delete it once read.\n'
} > "$out" 2>/dev/null || exit 0

printf 'precompact-state: %s\n' "$out"
exit 0
