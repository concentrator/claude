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
- Item 5: the closing `git grep` runs case-sensitive, since
  case-insensitive `Reject` also matches "rejected by the sandbox" in
  `agents/dev-implementer.md`, which is no reject choice; case-sensitive
  it finds none of the listed terms.
### Findings
- [ ] `branch-plan.md § Closing routine` 5 cites `finish § 2` for
  manual-testing needs, which now sit in `finish.md § 3`'s verify step;
  no item of this plan names routine 5.
  Evidence: observed `git grep` hit at `skills/dev/branch-plan.md:197`

## Review
- [ ] `branch-plan.md § Closing routine` 5 cites `finish § 2` for the
  manual-testing needs that now sit in `finish.md § 3` step 4 (Important)
  - `skills/dev/branch-plan.md:197`. Fix: cite `finish.md § 2` for the
  outcome and `finish.md § 3` step 4 for the verify.
  Evidence: contract `skills/dev/finish.md` § 2 holds the outcome only
  and § 3 step 4 is the verify.
- [ ] The migration merge "stays the user's call" because the diff exceeds
  planning artifacts, a contrast the Merge policy no longer draws
  (Important) - `skills/dev/companions/root-migration.md:46-48`. Fix: drop
  the planning-artifacts reason; rest the user-only merge on the always-ask
  list of `companions/declarations.md § Supervisor bounds`.
  Evidence: contract `skills/dev/git-workflow.md § Trunk` Merge policy.
- [ ] The example ruling "plan/ merges on green without a second ask"
  states the retired plan exception (Suggestion) - `skills/dev/handoff.md:41`.
  Fix: an example ruling that describes no merge policy.
  Evidence: observed `git grep` hit at that line.
- [ ] `README.md` says `/dev ship` takes a landed branch "to a merged
  MR/PR"; Ship now ends in merge, discard or an open MR/PR (Suggestion)
  - `README.md:51-52`. Fix: "to its MR/PR decision, merge or discard";
  the doc writer's, at the docs pass.
  Evidence: contract `skills/dev/finish.md § 3` closing line.
