# R084-T001 report

## Implementer
### Divergences
- Item 1: `finish.md § 3` is retitled from "Execute" to "Ship", since
  Ship is now its only path and Discard sits inside Ship's decision
  step; references cite the section by number, so none break.
- Item 1: the typed `discard` confirmation is kept, scoped to a user's
  discard, since the plan drops the merge-approval ask but names no
  change to the discard confirmation.
- Item 2: the Merge policy says no host is "armed to merge
  automatically" rather than naming auto-merge, so item 5's closing
  `git grep` for auto-merge stays empty on the rule that forbids it.
### Findings
- [ ] `branch-plan.md § Closing routine` 5 cites `finish § 2` for
  manual-testing needs, which now sit in `finish.md § 3`'s verify step;
  no item of this plan names routine 5.
  Evidence: observed `git grep` hit at `skills/dev/branch-plan.md:197`

## Review
