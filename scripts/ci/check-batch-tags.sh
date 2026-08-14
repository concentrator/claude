#!/usr/bin/env bash
# Tier-1 batch-anchor gate (R-044): a batch rollback anchor - the
# pre-R<NNN>-B-<MMM> tag pre-flight sets - must not outlive its batch;
# accept deletes it (skills/dev/branch-plan.md § Rails). Fails on a tag
# whose B-<MMM>.report.md exists under the initiative's batches/ dir
# (live plans/ or plans/archive/), naming tag, initiative, and report.
# Live anchors and tag-free trees pass. Plan paths resolve against the
# declared artifacts root (resolve-root.sh).
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(git rev-parse --show-toplevel)"

# Anchors are local-only (§ Rails: never pushed); a CI runner or shallow
# clone cannot see them, so report the blindness rather than a hollow OK.
if [ -n "${CI:-}" ] || [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
  echo "check-batch-tags: SKIP (tags not visible)"
  exit 0
fi

ROOT="$(bash "$SCRIPT_DIR/resolve-root.sh")" \
  || { echo "BATCH-TAGS: resolve-root.sh failed"; exit 1; }
P="${ROOT:+$ROOT/}plans"

fail=0

# A flat pre-B-* tag names no initiative, so no report can prove its
# batch open or closed - unresolvable, always a failure.
while IFS= read -r tag; do
  [ -n "$tag" ] || continue
  echo "BATCH-TAGS: $tag has no initiative - unresolvable; rename to pre-R<NNN>-${tag#pre-}"
  fail=1
done < <(git tag -l 'pre-B-*')

while IFS= read -r tag; do
  [ -n "$tag" ] || continue
  nnn="${tag:5:3}"; mmm="${tag: -3}"
  while IFS= read -r report; do
    [ -n "$report" ] || continue
    rdir="$(basename "$(dirname "$(dirname "$report")")")"
    echo "BATCH-TAGS: $tag outlived its batch - $rdir has $report; § Rails deletes the anchor at accept"
    fail=1
  done < <(compgen -G "$P/R-$nnn-*/batches/B-$mmm.report.md"; \
           compgen -G "$P/archive/R-$nnn-*/batches/B-$mmm.report.md")
done < <(git tag -l 'pre-R[0-9][0-9][0-9]-B-[0-9][0-9][0-9]')

(( fail == 0 )) && echo "check-batch-tags: OK"
exit $fail
