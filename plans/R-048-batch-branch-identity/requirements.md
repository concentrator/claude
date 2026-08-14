---
approved: 2026-08-14
kind: feat
---

# R-048: Batch branch identity

## Motivation

`batch/B-XXX` branch refs are flat while batch ids are scoped per
initiative, so two initiatives' first batches collide on
`batch/B-001` - the same collision R-044 fixed for the rollback
anchor. The branch case is longer-lived: the batch branch is pushed
to origin at checkpoint accept, and `branch-plan.md § Rails` deletes
member branch refs and the anchor at accept but never states when the
batch branch itself goes. R-044 scoped the branch out on the premise
that the tag is the only global namespace; branch refs are equally
flat. Promoted from R044-T001's close review.

## Goals

- The batch branch carries its initiative, matching the anchor form:
  `batch/R042-B-001`. Collision between initiatives becomes
  impossible by construction.
- The rails state the branch's full lifecycle: created at pre-flight,
  pushed at accept, deleted (local and remote) after its MR/PR merges.
- The batch-anchor gate covers branch refs too: a batch branch whose
  report is on the trunk fails as outliving its batch; a flat or
  malformed `batch/*` ref fails as unresolvable - same judgments the
  gate already applies to tags.

## Non-goals

- Renaming batch ids, manifests, report filenames, or the `/dev auto`
  argument - `B-XXX` stays initiative-scoped everywhere but the two
  global ref namespaces (tags: R-044; branches: this R).
- Retiring the batch branch in favour of another integration shape.
- Vendoring the extended gate for adopters - rides R-043.

## User experience

- Pre-flight creates `batch/R042-B-001`; the ref names its initiative
  wherever it appears (push output, PR head, branch lists).
- After the batch MR/PR merges, no `batch/*` ref remains, locally or
  on origin; a leftover fails the local gate naming the branch, its
  initiative, and the report that proves the batch closed.
- The live `batch/B-001` (R-042's open batch) is renamed to
  `batch/R042-B-001` when the gate lands - a local ref action, no
  commit, like the R-044 anchor rename.

## Acceptance criteria

- [ ] A batch branch's name identifies its initiative, and two
      initiatives can hold first-batch branches at once
- [ ] A `batch/*` ref whose batch report is on the trunk fails the
      local gate; a live batch branch passes
- [ ] A flat or malformed `batch/*` ref fails as unresolvable
- [ ] The rails state creation, push-at-accept, and delete-after-merge
      for the batch branch, and no living doc shows the flat
      `batch/B-XXX`
- [ ] Tier-1 green

## Constraints

- Branch names stay valid git refnames; the `batch/` prefix is kept
  (`git-workflow.md § Trunk` exempts it from the slug rule).
- One gate entry point: `scripts/ci/run-all.sh`.

## Open questions

None.

## References

- R-044: the anchor precedent (composite form, trunk-tree gate).
- R-042: owner of the one live batch branch to rename.
