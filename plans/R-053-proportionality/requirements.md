---
approved: 2026-08-19
kind: mnt
status: done 2026-08-21
---

# R-053: Proportional engineering

## Current state

The machinery outweighs what it guards: the hooks, measurement tool
and installer carry roughly three times their weight in checks and
tests, the heaviest tests attach to the most meta components, and the
four newest initiatives before this one are all about the machinery
itself (shaping evidence: the suite review in this R's shape round).
Each defect in process tooling spawns an initiative that ships more
tooling, and managing the checks consumes most of the effort they
were meant to save.

## Desired state

Proportionality is a planning rule, not a new gate: one observed
failure earns one fix and one test. Depth beyond that - mutant cases,
unfixed-copy comparisons, vendored-copy assertions - is reserved for
the guards that protect real work. The existing suite is trimmed to
the same standard. Nothing new ships to enforce any of this.

## Invariants

- `dev-secrets-guard` and `dev-branch-guard` keep their full test
  depth.
- Every remaining check test proves its check bites.
- Supervise mode and worktree use are untouched; the three-variable
  scrub stays in every test.
- No check or hook changes behavior; only test weight changes.

## Scope

`skills/dev/plan.md` and `brainstorm.md` (rule text); `scripts/test/`
(trims); `scripts/install-dev.sh` and its test reconciled. Nothing
under `scripts/ci/` or `hooks/` changes.

## Acceptance criteria

- [x] The planning rules state the proportionality rule: one observed
      failure earns one fix and one test; deeper proofs are reserved
      for the two guards; hardening against a hazard that has never
      fired needs explicit user approval; the shape round asks what
      can be deleted before adding (R053-T001, PR #343;
      `plan.md § Proportionality`, `brainstorm.md § Rules`).
- [x] `check-no-em-dash` and `check-code-size` have no test files and
      still run in Tier-1 (R053-T002, PR #344; both stay in the
      `scripts/ci/run-all.sh` loop).
- [x] Every remaining check test has one passing and one biting case;
      meta depth beyond that is gone: isolation reduced to the static
      scrub sweep plus one canary per invocation path, context-cost
      mutant cases removed (R053-T003; the four check tests each carry
      both cases, `isolation.test.sh` and `context-cost.test.sh`
      trimmed on this branch).
- [x] Tier-1 and the test suite green:
      `bash scripts/ci/run-all.sh`, `bash scripts/test/run-all.sh`
      (local `ALL OK` for both; each delivery PR merged on a green
      `tier1` check).

## Constraints

- No new hook, gate, or check ships from this initiative.
- A deleted test leaves `install-dev.sh` and its assertions coherent.

## Open questions

None.

## References

R-050 (context cost of the machinery) and R-051 (the suite's own
defect) - the two initiatives this rule would have trimmed at shape
time.
