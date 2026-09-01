---
approved: 2026-09-01
status: done 2026-09-01
kind: feat
---

# R070: Archival gate

## Motivation

Archival has a rule (`plan.md § Archival`, `finish.md § 4` step 3)
but no enforcement: the move rides a follow-up plan MR/PR that
nothing fails on skipping. Three initiatives closed and none was
archived until a manual sweep found them. A closed initiative
sitting outside `archive/` is invisible debt - the layout misreads
as open work, and the findings-disposition step it gates never runs.

## Goals

- Closing an initiative and archiving it are one delivery: the
  closing branch's final commit carries the archive move, so
  `status: done` and the move land together.
- A mechanical Tier-1 check fails when any
  `dev/plans/*/requirements.md` outside `archive/` carries
  `status: done`, naming the initiative and the remedy.
- A deliberate hold is expressible and visible: a frontmatter
  `archival: deferred - <reason>` line exempts the initiative and
  the check prints the reason instead of failing.

## Non-goals

- No change to what archival means (promotion, the four findings
  endings, the no-citation rule stay as `plan.md § Archival` states
  them).
- No retroactive sweep tooling: the check reports state, the fix is
  a normal branch.
- No enforcement of the findings-disposition quality itself - the
  check reads frontmatter and location only.

## User experience

- Closing routine: the final commit marks the plan complete and
  `git mv`s the initiative directory to
  `dev/plans/archive/R<NNN>-<slug>/`; the branch plan, having moved
  with its directory, records its own completion from the archive
  path.
- `finish.md § 4` step 3 becomes verification: confirm the merge
  landed the move; opening a separate archive MR/PR remains only for
  late closures already on the trunk.
- A run of `bash scripts/ci/run-all.sh` on a tree with a closed,
  unarchived, undeferred initiative fails with one line naming it;
  with a deferred one it prints the deferral and passes.

## Acceptance criteria

- [x] `scripts/ci/check-archival.sh` exists, is registered by the
  `run-all.sh` loop, and fails naming initiative and remedy when a
  non-archive `dev/plans/*/requirements.md` carries `status: done`.
- [x] `archival: deferred - <reason>` in that file's frontmatter
  exempts it; the check prints the reason; a marker without a reason
  fails.
- [x] A self-test covers: clean tree passes, done-unarchived fails,
  deferred passes with the reason printed, reasonless deferral
  fails, malformed frontmatter fails loudly, `archive/` exempt.
- [x] `plan.md § Archival`, `branch-plan.md § Closing routine`, and
  `finish.md § 4` state the one-delivery flow; no text still
  describes the archive move as a routine follow-up MR/PR.
- [x] `DESIGN.md § Self-enforcement` lists the check (Tier-2 doc
  sync row for an added `scripts/ci/` check).

## Constraints

- The check reads git-tracked state only - no network, no dates, no
  environment.
- Bash, mirroring the existing `scripts/ci/check-*.sh` shape and its
  self-test conventions (isolation scrub included).

## Open questions

None.

## References

- R040, R068, R069 - the three closures that accumulated unarchived.
- `plan.md § Archival`, `finish.md § 4`, `branch-plan.md § Closing
  routine`.
