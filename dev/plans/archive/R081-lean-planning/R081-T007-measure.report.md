# R081-T007 report

## Implementer

### Measurement

R080-T005 (harvest the pilot run) run twice: once under the pre-R081
flow, once under the flow as R081-T001 to T006 left it. Billed context
is `input + cache_creation + cache_read` summed over every call of the
runner session and its seat subagents, the figure
`scripts/context-cost.py` reports.

| | Before | After | Change |
|---|---|---|---|
| Billed context | 88.8M | 14.7M | 6.0x less |
| Output tokens | 229K | 57K | 4.0x less |
| API calls | 1166 | 270 | 4.3x less |
| Seat dispatches | 40 | 11 | 3.6x less |

The after run reached the same close state: plan, two cold reads, four
plan items plus a close fix, a close review with a second verifier, and
a green full tier, stopped before ship.

### Divergences

- The before figure is a time window (the task's base commit to its
  merge), not a per-task total: the window also holds the cap-raise PR
  and a few unrelated commits, so it reads high by a small margin.
- The after run was a fresh clone at the task's base commit, driven
  headless with standing approval in place of the user's turns, so it
  carries none of the before run's deliberation.
- The after run worked against the installed flow files while its
  checkout predates R081-T005, so its seats read the current task
  report duties against a `branch-plan.md` that still names findings
  files. The pairing exists only in this rerun.

### Findings

none
