# R084-T004 report

## Implementer
### Divergences
- Item 1: the `## Review` line of the form also opens with its item,
  since the runner writes a mid-run redo there for an item as well as
  the close review's findings; every entry of the form now names its
  item or close step.
- Item 1: the implementer's section names only the dispatch, status and
  verdict of the ledgered events, the ones an implementer holds; the
  full list stays in `branch-plan.md § Task report`.
- Item 2: `Watch:` went with `Tests:`, since its "critical area" was
  not bound to a run; `Showed:` takes the draft's run result, edge cases
  hit included. Result: each probe carries `Source:`, each draft
  `Draft:` and `Showed:`.
- Item 2: the acceptance grep still matches the plan's own item text,
  which leaves with the plan at archive; no other tracked file matches.
- Close: `run.md § Pre-flight` now states that the `--apply` line is
  printed only when every gap is a missing allow rule, and that a gap
  the script cannot apply is a `cannot apply:` line. Result: the rule
  now matches the script.

## Review
- [x] Close review: the rule says statuses and verdicts are the ledger's,
  which records neither; state the exclusion as the rule and cite the
  ledger for a run's events (Critical) - `skills/dev/branch-plan.md:158`,
  `agents/dev-implementer.md:100`
  Evidence: contract `skills/dev/run.md § Ledger`
- [x] Close review: the user's ruling that a report holds no times, its
  commit dating each entry, is only implied; state it (Suggestion) -
  `skills/dev/branch-plan.md:155-157`
  Evidence: contract the user's answer on item 1
- [x] Close review: `Review <n>` implies numbered entries, which are
  bullets; say it is the nth `## Review` entry (Suggestion) -
  `skills/dev/branch-plan.md:156`, `agents/dev-implementer.md:96`
  Evidence: observed the unnumbered `## Review` form
