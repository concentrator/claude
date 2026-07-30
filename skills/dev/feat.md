# Adding a Feature

Strict TDD iteration for one feature task from its branch plan.

## Pass (red → green → refactor)

1. **Red** - write a failing test for the next behavior slice. Run it;
   confirm it fails for the right reason.
2. **Green** - minimal implementation to make the test pass.
3. **Refactor** - clean up code and tests; coverage stays green.

Finish every pass per `branch-plan.md § Commit cadence`.

## Code reuse

Before writing new helpers, grep for existing functions with the same
purpose.

Scope discoveries: `branch-plan.md § Scope discoveries`.
