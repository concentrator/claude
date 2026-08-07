---
approved: 2026-08-07
kind: feat
---

# R-042: Planning-round PoCs

## Motivation

A complicated task's plan can carry unverified feasibility assumptions;
the comprehension gate catches ambiguity, not wrongness. A time-boxed
throwaway spike during planning grounds the plan in observed behavior -
the precondition for solo-implementable plans (R-040), and useful in
manual DEV immediately.

## Goals

- A shape or detail round may run a **time-boxed spike** in a worktree
  when a task's approach carries an unproven assumption; its findings
  are recorded where probe findings already live (the R's
  requirements or the branch plan's cited findings), and the spike
  code is always discarded - never merged, never cited as
  implementation.

## Non-goals

- Reusing PoC code; new artifact types; spikes during execution
  (that's a blocker, `branch-plan.md § Scope discoveries`).

## Acceptance criteria

- [ ] `plan.md` (rounds) and `write-plan.md` (step 3, probe rule) name
      the spike provision: when to spike, the time box, where findings
      land, and the discard rule.
- [ ] A branch plan may cite spike findings the same way it cites
      probe findings today.

## References

`write-plan.md § Steps` (the probe rule this extends), R-040.
