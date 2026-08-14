#!/usr/bin/env bash
# Tier-1 batch-anchor gate (R-044): a batch rollback anchor - the
# pre-R<NNN>-B-<MMM> tag pre-flight sets - must not outlive its batch;
# accept deletes it (skills/dev/branch-plan.md § Rails). A batch is
# closed once its B-<MMM>.report.md reaches the trunk via the accepted
# batch MR/PR, so the gate judges the trunk's tree, never the worktree:
# reject, halt, and the accept push itself all hold the tag while a
# report exists somewhere, and none of them is stale. A pre-* tag that
# is not a well-formed composite anchor naming an initiative present on
# the trunk fails as unresolvable. Plan paths resolve against the
# declared artifacts root (resolve-root.sh).
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
top="$(git rev-parse --show-toplevel)" \
  || { echo "BATCH-TAGS: not inside a git repo"; exit 1; }
cd "$top"

# Anchors are local-only (§ Rails: never pushed); a CI runner or shallow
# clone cannot see them, so report the blindness rather than a hollow
# OK. CI must be truthy - a workstation exporting CI=false still enforces.
case "${CI:-}" in
  ''|0|false) ;;
  *) echo "check-batch-tags: SKIP (tags not visible)"; exit 0 ;;
esac
if [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
  echo "check-batch-tags: SKIP (tags not visible)"
  exit 0
fi

ROOT="$(bash "$SCRIPT_DIR/resolve-root.sh")" \
  || { echo "BATCH-TAGS: resolve-root.sh failed"; exit 1; }
P="${ROOT:+$ROOT/}plans"

# The trunk: origin's default branch, else local main, else HEAD (a
# remote-less repo is its own trunk).
if trunk="$(git symbolic-ref -q --short refs/remotes/origin/HEAD)"; then :
elif git show-ref -q --verify refs/heads/main; then trunk=main
else trunk=HEAD; fi
tree="$(git ls-tree -r --name-only "$trunk" -- "$P" 2>/dev/null || true)"

fail=0
while IFS= read -r tag; do
  if [[ "$tag" =~ ^pre-R([0-9]{3})-B-([0-9]{3})$ ]]; then
    nnn="${BASH_REMATCH[1]}"; mmm="${BASH_REMATCH[2]}"
    report="$(grep -E -m1 "^$P/(archive/)?R-$nnn-[^/]+/batches/B-$mmm\.report\.md$" <<<"$tree" || true)"
    if [ -n "$report" ]; then
      echo "BATCH-TAGS: $tag outlived its batch - $trunk carries $report; § Rails deletes the anchor at accept"
      fail=1
    elif ! grep -qE "^$P/(archive/)?R-$nnn-" <<<"$tree"; then
      echo "BATCH-TAGS: $tag names no initiative R-$nnn on $trunk - unresolvable"
      fail=1
    fi
  else
    echo "BATCH-TAGS: $tag is not a composite batch anchor (pre-R<NNN>-B-<MMM>) - unresolvable"
    fail=1
  fi
done < <(git tag -l 'pre-*')

(( fail == 0 )) && echo "check-batch-tags: OK"
exit $fail
