---
task: R088-T009
type: doc
mode: normal
---

- [ ] `release.md` agrees with `git-workflow.md § Releases`: step 8 tags with
  the `-m "X.Y.Z"` message `§ Releases` gives, `§ Releases` rules out a
  long-lived release branch rather than step 3's, and the release plan's
  archive move rides the release branch, after the merge landing on the
  guarded default branch. Approach: step 10's offer joins step 5, `plan.md
  § Archival` saying "with the release"; step 10 is last, so none renumbers.
- [ ] A release-plan entry's `[x]` rides with its task's mark: the final
  commit, or for a batch member the batch branch at `run.md § Batch close`
  4. Approach: `branch-plan.md § Batches` drops release marking from the
  close-out MR/PR and the final item's batch note names both marks;
  `release.md` step 1 and `templates.md § Release plan` say the same, the
  latter's "auto" mode reading as the batch-scoped run.
- [ ] Under `release-routine: yes`, `start.md` seeds `CHANGELOG.md` with the
  `## [Unreleased]` heading `release.md`'s pre-condition requires and the
  doc writer's entries go under, and seeds no release plan: `templates.md
  § Release plan` has `/dev plan release` write the first once a task has
  closed. Approach: the release-routine sentence of `start.md § 3`.
- [ ] `branch-plan.md § Header` shows the header between `---` lines, the
  YAML frontmatter every branch plan opens with. Approach: an opening and a
  closing `---` around the § Header block, its comments unchanged.
- [ ] `run.md § Boundary verification` 4 checks the committer signature only
  on commits made on a host that runs supervised delivery, the only commits
  `declarations.md § Supervision signature` gives one; elsewhere plan boxes
  and diff confinement complete the check. Approach: the check's last
  sentence, citing that section.
- [ ] `run.md § Batch close` 2 names the seat that commits the fixes: a fresh
  implementer per fix, dispatched naming its `## Review` entry as `§ Close`
  2's are, the entry in the report of the member whose code the fix changes,
  the last in batch order for several. Approach: that step, then the § Seats
  implementer row naming both closes; where judgment calls queue stays as is.
- [ ] Commit and MR/PR attribution is the user's `attribution` setting's:
  `dev-instructions.md § Writing` states the no-trailer intent as that
  setting's (`commit` and `pr` empty) rather than as a rule over the
  harness (requirement outcome 1), and `git-workflow.md § MR/PR messages`
  cites it for its "Generated with" bullet. Approach: those two sentences.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- none

## Proven

- none
