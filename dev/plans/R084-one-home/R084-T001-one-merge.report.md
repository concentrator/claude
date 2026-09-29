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
- Item 3: Reject's ref handling moves into § Merge or ask's discard
  sentence, and the checkpoint's accept names that discard as the one
  way a branch is turned down, so no Reject option is left to cite.
- Item 3: `run.md § Close` 5 runs `finish.md § 1-2` for a task scope
  and leaves its § 3 to § Checkpoint's accept, § Boundary verification
  and § Merge or ask, since running `finish.md` from § 1 would now push,
  open and decide before the checkpoint.
- Item 4: the `check-batch-tags.sh` header also says the report reaches
  the trunk via the merged, not the accepted, batch MR/PR, and lists
  discard where it listed reject, since accept now only opens the
  MR/PR; the later comment that the batch branch reaches origin only at
  accept stays, the checkpoint's accept still being the push.
### Findings
- [ ] `branch-plan.md § Closing routine` 5 cites `finish § 2` for
  manual-testing needs, which now sit in `finish.md § 3`'s verify step;
  no item of this plan names routine 5.
  Evidence: observed `git grep` hit at `skills/dev/branch-plan.md:197`

## Review
