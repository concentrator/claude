task: R063-T001
type: doc

# Review text: one owner for dead prose, the reading of never restated

`MAINTENANCE.md § Tier-2 AI review` is the file's own review; the
Routine below it is what other projects copy, so this task changes
only how this repository is reviewed.

## Commits

- [ ] Fold `### Prune dead prose` into the Cleanup bullet: dead prose
  is Cleanup's, defined by the three gates stated in that bullet;
  Compliance loses the sentence that claimed the gates. Word count
  stays within the general cap (`scripts/ci/check-caps.sh`).
- [ ] The Cross-file integrity bullet states the maximal reading: any
  echo of a rule's text is a restatement, so a concern names a rule and
  cites its owning document without repeating it; `rules/claude-md.md
  § Size and structure` "No duplication" is the cited owner.
- [ ] `skills/dev/layout.md` line 17: `MAINTENANCE.md` is written by
  the project at `/dev start` or `/dev migrate` time; the "seeded from
  template" claim goes, since no script or skill copies the file.
  `start.md` and `migrate.md` are read to confirm what they say, and
  amended only if they claim the copy.
- [ ] `skills/dev/git-workflow.md § Merge policy` states the order:
  read the state check (`companions/toolchain.md § State check`) until
  it reports success, then merge; a state with no pipeline yet, or one
  queued or running, keeps the poll going and is never read as success;
  a merge called before success fails (GitLab answers 405); an MR/PR the
  check already reports merged is reported as merged, not merged again.
  The state check returns the pipeline's current state, so a poll that
  starts after the pipeline finished merges on its first read.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose row: `code-reviewer`), Tier-2 compliance review over
  the diff, `bash scripts/ci/run-all.sh` green, cleanup, mark plan
  complete, commit.
