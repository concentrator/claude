---
approved: 2026-08-28
kind: fix
---

# R063: Tier-2 review text and guard fail-closed

Shaped from the findings the fp-remedy R001 close reviews raised
against this repository's review checklist and hook guards.

## Current state

`MAINTENANCE.md § Tier-2 AI review` carries clauses a reviewer cannot
run as written: "a `feat` or `fix` commit carries its test" names a
commit type no subject carries; Doc-sync row 1 reads a correctly
unchanged target as a miss; the Compliance bullet counts the plan's own
final unchecked box as a finding; dead prose is bound under Cleanup
while its three-gate test hangs off Compliance; `### Prune dead prose`
and the `§ Doc-sync pairs` table sit far from the bullets that invoke
them; rows 2 and 6 and the lead-in's second sentence restate rules
owned elsewhere.

`settings.json` registers the two `PreToolUse` guards by the relative
path `.claude/hooks/<name>.sh`, so after any `cd` both fail with "not
found" and the call proceeds unguarded. `hooks/dev-secrets-guard.sh`
sources `secret-patterns.sh` with `|| exit 0`, so a missing library
also passes the call. Neither path reports its own absence.

## Desired state

Every clause of the review section is runnable per commit or per
branch. "Never restated" is read maximally: any echo of a rule's text
is a restatement, so a concern names the rule and cites its owning
document without repeating what it says; each concern owns its test
and its prune step in place. Both guards run
from any working directory and fail closed, with one stderr line, when
their script or library is missing.

## Invariants

- The review section keeps its six concerns and the Tier-1 gates pass.
- A guard never blocks a call for a reason it does not print.

## Scope

- `MAINTENANCE.md § Tier-2 AI review`, `§ Doc-sync pairs`.
- `settings.json` hook registration; `hooks/dev-secrets-guard.sh`.
- The fp-remedy copy of the review section follows by its own MR.

## Acceptance criteria

- [ ] The test-carrying clause names the unit it binds (a
  behavior-changing commit) and cites `skills/dev/feat.md` and `fix.md`.
- [ ] Doc-sync row 1 states the already-satisfied outcome.
- [ ] The Compliance bullet excludes the plan item that runs the review.
- [ ] Dead prose has one owning concern, its test and prune step beside
  the bullet.
- [ ] Rows 2 and 6 and the lead-in sentence are cut or cite their owner.
- [ ] No bullet or row repeats the text of a rule another document
  owns; a `git grep` for each owned rule's key phrase hits only its
  owner.
- [ ] Hook paths resolve from any working directory (a test runs a
  guarded call after `cd` into a subdirectory).
- [ ] A missing `secret-patterns.sh` fails the call with one stderr line.

## Constraints

- `MAINTENANCE.md` stays under its word cap (`scripts/ci/check-caps.sh`).

## References

- fp-remedy `dev/plans/archive/R001-foundations/` findings of T002,
  T003 and T008.
