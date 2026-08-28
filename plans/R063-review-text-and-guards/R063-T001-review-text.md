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
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose row: `code-reviewer`), Tier-2 compliance review over
  the diff, `bash scripts/ci/run-all.sh` green, cleanup, mark plan
  complete, commit.
