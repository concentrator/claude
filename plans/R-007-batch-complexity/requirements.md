---
approved: pending
kind: feat
---

# R-007: Per-batch complexity level

> Stub — seed captured during R-006 brainstorming; shape via
> `/dev plan R-007`.

## Motivation

The verification routine (R-005) is tuned for cost on a single default
profile. Critical / high-responsibility work wants more rigor than the
optimized default, without dialing every commit individually.

## Goals

- A per-batch **complexity level**, set in the batch manifest — two
  levels only (YAGNI): **normal** (default) and **high**.
- The level is a master dial over the R-005 verification levers:
  - **normal** = the optimized routine (mechanical spec-check skip on,
    close-folding on, per-role model routing).
  - **high** = rigor restored — no mechanical skip, no close-folding,
    top model across roles, session effort raised, stricter loop rules
    (lower halt threshold, optional multi-vote verify).
- Composes with R-006's batch-as-universal-delivery-unit (complexity is
  a property of the batch) and subsumes the per-item `(judgment-heavy)`
  tag for whole-batch criticality.

## Non-goals

- More than two levels.
- Per-commit complexity (the `(judgment-heavy)` item tag covers that).

## Constraints

- Depends on R-006 (defines the batch as the delivery unit the level
  attaches to); sequence after it.
- Lives in `verification-policy.md` (R-005's domain).

## Open questions

- Does `high` raise `effortLevel` session-wide, or stay session-fixed
  with only model + loop rules changing?
- Interaction with R-004 (parallel batches) if both land.

## References

- R-005 (the levers this dials), R-006 (the batch unit), this session's
  brainstorming.
