---
approved: 2026-07-22
kind: refactor
---

# R-035: Atomic branch-close bookkeeping

## Current state

Manual mode defers task bookkeeping to a per-branch close-out PR
(`finish.md § 4`): after a task branch merges, a `plan/tXXX-close` branch
marks `T-XXX` `[x]` in the parent `tasks.md` (and runs the R closure on
the last task). Every task costs an extra PR + CI round - 4 of the 10 PRs
in the R-033/R-034 run were bookkeeping - and between the two merges
`main` shows merged work with an unmarked task. Auto mode already marks
member tasks atomically on the batch branch (`branch-plan.md § Batches`).

## Desired state

The task branch's mandatory final commit carries its own bookkeeping:
`T-XXX` `[x]` in the parent `tasks.md`; when the branch completes the R's
last open task, also the closure check (per-criterion evidence +
`status: done` stamp), the ROADMAP `[x]`, and the release-plan marking.
The marks reach `main` atomically with the merge; a rejected or discarded
branch takes them with it. Post-merge bookkeeping shrinks to syncing the
default branch and deleting the merged branch. A close-out PR remains
only for run-dependent closure criteria (verifiable only by a later
event, `plan.md § Approval and closure`) - R-level and rare.

## Invariants

- A task shows `[x]` on `main` only when its work is on `main` - atomic
  rather than delayed, never earlier.
- The two R-closure conditions (`plan.md § Approval and closure`) are
  unchanged.
- The batch/auto-mode flow is unchanged (already atomic).
- Trunk protection and CI gates are unchanged.

## Scope

`skills/dev/finish.md` (§ 4 rework), `skills/dev/branch-plan.md` (closing
routine final commit, § Releases), `skills/dev/plan.md` (closure timing
wording). The change removes instructions; `branch-plan.md` (at its
1500-word cap) ends net smaller with no compensating trims.

## Acceptance criteria

- [ ] `finish.md`: bookkeeping rides the branch's mandatory final commit;
  post-merge is sync + branch deletion; a close-out PR only for
  run-dependent closure criteria.
- [ ] `branch-plan.md`: closing routine and § Releases state atomic
  marking; the file is net smaller than before the change.
- [ ] `plan.md § Approval and closure` timing is consistent; no reference
  to a per-task close-out PR remains outside the run-dependent case.
- [ ] Manual and auto mode share one atomic-marking semantics, stated
  once and referenced (DRY).
- [ ] Full Tier-1 gate green; ships via `skills/dev/`.

## Constraints

- DRY with `branch-plan.md § Batches` - one semantics, not two wordings.
- Self-hosting; trunk-based delivery (`git-workflow.md`).

## Open questions

- none

## References

- `branch-plan.md § Batches` - the atomic-marking precedent (auto mode).
- R-029 - retired the committed-stamp ledger; no separate bookkeeping
  artifact.
- R-024 - the finish confirmation gates this change must preserve.
