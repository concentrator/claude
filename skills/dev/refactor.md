# Doing a Refactor

Iteration for one refactor task from its branch plan. Behavior preserved.

## Pre-requisite

Baseline tests green. If any fail before refactoring starts, fix that
first as a separate task.

## Pass

1. **Safe step** - small, behavior-preserving change.
2. **DRY / purity check** - duplicated functionality removed? Side
   effects isolated?

Finish every pass per `branch-plan.md § Commit cadence`. If a step
breaks tests and the fix isn't immediate, revert and try smaller.

Scope discoveries: `branch-plan.md § Scope discoveries`.
