---
approved: 2026-07-08
kind: refactor
---

# R-029: Retire the Tier-2 ledger

## Current state

The Tier-2 review is enforced by a committed stamp
(`maintenance.d/<sha>.json`) gated by `scripts/ci/check-ledger.sh`. The stamp
is self-attested by the authoring agent - the same actor that writes the code
writes the stamp - so it is a weak forcing function; it duplicates a SHA git
already tracks; and it generated its own maintenance load (R-027's conflict
fix, R-028's prune task). Every PR carries an extra stamp commit.

## Desired state

The five-concern Tier-2 review stays a mandatory branch-close step, but the
committed stamp, the `check-ledger` gate, and the `maintenance.d/` store are
removed. No per-PR stamp commit; no ledger to conflict or accumulate.

## Invariants

- The five Tier-2 concerns (compliance, cross-file integrity, cleanup,
  reference freshness, writing) are still reviewed before every merge.
- The rest of the Tier-1 mechanical gate is unchanged.

## Scope

- `scripts/ci/check-ledger.sh`, `scripts/test/check-ledger.test.sh`,
  `maintenance.d/` - deleted.
- `scripts/ci/run-all.sh` - the ledger check dropped from the loop.
- `MAINTENANCE.md` - remove the Ledger section; reframe the Tier-2 review as a
  close-routine step.
- `skills/dev/branch-plan.md`, `skills/dev/finish.md` - the Tier-2 review
  becomes an explicit close step; the stamp-at-delivery practice removed.
- `DESIGN.md` - self-enforcement section, tree-map, infrastructure line.
- `.github/workflows/ci.yml` - fetch-depth (nothing else needs full history).
- `plans/R-028-enforcement-hygiene/` - amended to T-060 only (T-061 moot).

## Acceptance criteria

- [ ] `check-ledger.sh`, its test, and `maintenance.d/` are gone;
  `run-all.sh` runs no ledger check; the Tier-1 gate passes with no stamp.
- [ ] No PR requires a stamp commit (close/delivery no longer stamps).
- [ ] The branch-close routine names the Tier-2 five-concern review as a
  mandatory step; `MAINTENANCE.md` documents it there (no ledger).
- [ ] `DESIGN.md` self-enforcement section + tree-map reflect the removal.
- [ ] R-028 reduced to T-060; T-061 dropped.
- [ ] Full Tier-1 gate green.

## Constraints

- Self-hosting; trunk-based delivery (`git-workflow.md`).
- Keep the review's substance - drop only the recording and gating, not the
  five concerns.

## Open questions

- Does the Tier-2 review fold into the existing close code-review step or stay
  a separate named checklist step (lean: separate - the concerns differ from
  a code review)? Settle in detail.
- `ci.yml` fetch-depth: reduce to 1 or leave 0? Settle in detail.

## References

- Reverses R-027 (ledger conflict fix) and R-010's ledger portion;
  supersedes R-028's T-061. Rationale: a self-attested stamp is a weak
  forcing function generating disproportionate maintenance.
