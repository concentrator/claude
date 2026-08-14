#!/usr/bin/env bash
# Tier-1 batch-ref gate (R-044, R-048): the batch refs the DEV flow
# creates - the pre-R<NNN>-B-XXX rollback tag and the batch/R<NNN>-B-XXX
# integration branch - must not outlive their batch: accept deletes the
# tag, post-merge cleanup the branch (skills/dev/branch-plan.md
# § Rails). A batch is closed once its B-XXX.report.md reaches the
# trunk via the accepted batch MR/PR, so the gate judges the trunk's
# tree, never the worktree: reject, halt, and the accept push itself
# all hold refs while a report exists somewhere, and none of them is
# stale. A pre-* tag or batch/* branch that is not a well-formed
# composite ref naming an initiative present on the trunk fails as
# unresolvable. Plan paths resolve against the declared artifacts root
# (resolve-root.sh).
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
top="$(git rev-parse --show-toplevel)" \
  || { echo "BATCH-TAGS: not inside a git repo"; exit 1; }
cd "$top"

# Batch refs are local-only until accept (§ Rails); a CI runner or
# shallow clone cannot see them, so report the blindness rather than a
# hollow OK. CI must be truthy - a workstation exporting CI=false still
# enforces.
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
# Judge one batch-namespace ref: $1 = the ref as shown, $2 = its
# composite remainder (expected R<NNN>-B-XXX).
judge() {
  local ref="$1" rest="$2" nnn mmm report
  if [[ "$rest" =~ ^R([0-9]{3})-B-([0-9]{3})$ ]]; then
    nnn="${BASH_REMATCH[1]}"; mmm="${BASH_REMATCH[2]}"
    report="$(grep -E -m1 "^$P/(archive/)?R-$nnn-[^/]+/batches/B-$mmm\.report\.md$" <<<"$tree" || true)"
    if [ -n "$report" ]; then
      echo "BATCH-TAGS: $ref outlived its batch - $trunk carries $report; § Rails retires the ref"
      fail=1
    elif ! grep -qE "^$P/(archive/)?R-$nnn-" <<<"$tree"; then
      echo "BATCH-TAGS: $ref names no initiative R-$nnn on $trunk - unresolvable"
      fail=1
    fi
  else
    echo "BATCH-TAGS: $ref is not a composite batch ref (R<NNN>-B-XXX after the prefix) - unresolvable"
    fail=1
  fi
}

while IFS= read -r tag; do
  judge "$tag" "${tag#pre-}"
done < <(git tag -l 'pre-*')

while IFS= read -r ref; do
  judge "$ref" "${ref##*batch/}"
done < <(git for-each-ref --format='%(refname:short)' \
           'refs/heads/batch/*' 'refs/remotes/*/batch/*')

(( fail == 0 )) && echo "check-batch-tags: OK"
exit $fail
