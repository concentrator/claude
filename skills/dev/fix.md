# Fixing a Bug

Iteration loop for one bug-fix task from its branch plan.

## Pass

1. **Reproduce** - write a failing test that exhibits the bug. Run it;
   confirm it fails for the right reason.
2. **Diagnose** - root cause, not symptom. Invoke `systematic-debugging`
   if non-obvious.
3. **Fix** - minimal change to make the test pass.

Finish every pass per `branch-plan.md § Commit cadence`. Docs delta: a
fix that changes documented behavior updates `README.md`.

Scope discoveries: `branch-plan.md § Scope discoveries`.
