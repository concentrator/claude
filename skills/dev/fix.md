# Fixing a Bug

The implementer seat's loop for one bug-fix item, run per dispatch
(`run.md § Dispatch per item`).

## Pass

1. **Reproduce** - write a failing test that exhibits the bug. Run it;
   confirm it fails for the right reason.
2. **Diagnose** - root cause, not symptom. Invoke `systematic-debugging`
   if non-obvious.
3. **Fix** - minimal change to make the test pass.

An item with a probe claim runs a probe before step 1 and a second
after it (`agents/dev-implementer.md § Steps` 2).

Finish every pass per `branch-plan.md § Commit cadence`.

Scope discoveries: `branch-plan.md § Scope discoveries`.
