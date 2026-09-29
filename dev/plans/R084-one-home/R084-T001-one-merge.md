---
task: R084-T001
type: mnt
mode: normal
---

# R084-T001: one merge rule, one decision at branch close

- [x] `finish.md § 3` holds a branch's one decision point: Ship gates,
  pushes and opens the MR/PR unasked, polls it green, runs the live verify,
  then the merging seat merges or discards. Discard closes the MR/PR and
  deletes the branch; no answer leaves the MR/PR open, reported as such.
  Approach: `skills/dev/finish.md` intro, § 2 (outcome only) and § 3; drop
  Options, the merge-approval ask, the `plan/` skip; `/dev ship` enters § 3.
- [x] Who merges has one rule: every MR/PR merges after green, through the
  declared merge command, by the seat the supervision declaration names; no
  prefix merges on its own and no host auto-merge is armed.
  Approach: `git-workflow.md § Trunk` Merge policy cites `declarations.md
  § Supervisor bounds`, which gives that seat `finish.md § 3`'s decision;
  root `CLAUDE.md` "auto-merge delivers" becomes "a merge delivers".
- [x] A run's branch reaches the same one decision: the checkpoint's accept
  opens the MR/PR unasked on a report verifying the acceptance criteria,
  Reject retires into the discard, and § Merge or ask is `finish.md § 3`'s
  verify and decision, taken by the seat the declared bound names.
  Approach: `run.md § Checkpoint`, § Merge or ask (the ship-question
  sentence goes), § Close 5; the Merging row of § Seats stays.
- [x] `branch-plan.md` follows it: § Closing routine 7 and 8 name merge or
  discard; § Rails deletes the rollback tag and member refs at the merge,
  keeps them on a discard, and drops push decisions; § Batches and § Stop
  conditions carry no accept or reject choice.
  Approach: those sections, then the header comment of
  `scripts/ci/check-batch-tags.sh`, which dates tag deletion to accept.
- [x] A plan's MR/PR takes the same decision with no planning exception:
  `plan.md § Planning rounds` and `write-plan.md` step 7 deliver to it.
  Approach: those two; then `git grep -nE` over `skills/dev agents rules
  CLAUDE.md` for auto-merge, `merge --auto`, merge-when, ship question,
  ship / discard, skips the ask, merge approval and Reject finds none.
- [x] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
