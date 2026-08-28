---
approved: 2026-08-11
kind: feat
status: done 2026-08-14
---

# R-044: Batch rollback-anchor identity

## Motivation

Batch ids are scoped per initiative (`branch-plan.md § Batches` - the
counter is scoped to the initiative), so every initiative has a
`B-001`. The rollback anchor that pre-flight creates for it is a git
tag named `pre-B-XXX`, and git tags are one flat namespace.

Both consequences have been observed. An anchor left behind by R-005's
accepted batch blocked R-042's first batch months later, and two
initiatives holding open batches cannot both keep an anchor. The
cleanup that would have prevented the first case is written down
(`branch-plan.md § Rails` - accept deletes the batch's anchor) but
nothing verifies it.

## Goals

- The anchor carries its initiative, matching the composite-id
  convention already used for tasks (`R042-T001`): `pre-R042-B-001`.
  Collision between initiatives becomes impossible by construction.
- A gate catches an anchor that outlived its batch: a tag whose batch
  already has a report, which `§ Rails` requires to have been deleted
  at accept.
- The gate states where it can run. Anchors are local-only - agents
  never push tags, and CI checks out shallow - so it enforces locally
  and reports a skip in CI rather than passing silently.

## Non-goals

- Renaming batch ids, manifests, report filenames, the batch branch, or
  the `/dev auto` argument. The tag is the only global namespace.
- Retiring the anchor in favour of `git merge-base`.
- Migrating existing anchors: none remain.
- Vendoring the check for adopters - rides R-043 (backlog line in its
  `tasks.md`).

## User experience

- Pre-flight creates `pre-R042-B-001`. A collision names the owning
  initiative rather than failing opaquely.
- Accept deletes that same name (`branch-plan.md § Rails`).
- A stale anchor fails the local gate, naming the tag, its initiative,
  and the report that proves the batch closed.
- Where tags are not visible, the gate reports a skip line.

## Acceptance criteria

- [x] An anchor's name identifies the initiative of the batch it
      anchors, and two initiatives can hold first-batch anchors at once
      (composite `pre-R<NNN>-B-<MMM>` at pre-flight and accept, PR #288;
      names are initiative-scoped by construction)
- [x] A tag whose batch has a report fails the gate locally
      (`check-batch-tags.sh` judges the trunk's tree; test cases "stale
      anchor caught" and "archived-report anchor caught", PR #289)
- [x] The gate reports a skip, not an OK, when no tags are visible
      (SKIP line under truthy `$CI` or a shallow clone, named in the
      `run-all.sh` verdict; skip test cases, PR #289)
- [x] `auto.md` and `branch-plan.md` state the composite form, and no
      doc still shows the flat `pre-B-XXX` (PR #288; tracked-tree grep
      finds `pre-B-` only in this R's own artifacts and ROADMAP entry)
- [x] Tier-1 green (`tier1` check green on PR #289; local
      `run-all: ALL OK`)

## Constraints

- Anchor names stay valid git refnames.
- One gate entry point: `scripts/ci/run-all.sh`.
- Anchors are never pushed (`branch-plan.md § Rails`).

## Open questions

None.

## References

- R-040: the supervised run where the collision surfaced.
- R-042: the initiative it blocked.
- R-004: preserves the anchor as a rail.
