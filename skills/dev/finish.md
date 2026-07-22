# Finishing a Development Branch

Close out a DEV branch - invoked by the closing routine
(`branch-plan.md`) after the mandatory final commit.

## 1. Verify

- `.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md`: every `[ ]` is `[x]`;
  findings file triaged.
- Bookkeeping marks present in the final commit (task `[x]`; last open
  task of the R → closure check, ROADMAP, release mark -
  `branch-plan.md § Closing routine`).
- Close review per `branch-plan.md § Closing routine`.
- Fresh test + lint green; failing → stop and report.

## 2. Report outcome, verify, then present options

Three ordered steps - the verify is a distinct, blocking step, never folded
into the options or glossed past:

1. **Outcome** - what the branch produced vs the task's acceptance
   criteria.
2. **Verify** - always offer a live run; for data tasks, run the work
   product and show the results. Present this and wait; do not roll it into
   the options.
3. **Options** - only then present delivery: push and open a CI-gated MR/PR
   to origin / keep / discard.

MR/PR opens only on explicit choice - never automatically.

## 3. Execute

**Push + MR/PR** - `git push -u origin <branch>`, then open a CI-gated
MR/PR to origin by running the change-request command declared in CLAUDE.md
`## Agent toolchain` (`companions/toolchain.md`) - `gh pr create` / `glab
mr create` when the project only names the host (summary + test plan); no
declared host → push and print the URL. Never a local merge or direct push. Merge per
`git-workflow.md § Trunk`. After opening it, **stay on the branch** - do not
switch to the default branch while the MR/PR is open, so the reviewer sees
the branch's files; the switch to default is §4, after merge.

**Keep** - report branch name. Nothing closes.

**Discard** - list branch, commits, plan state; require typing
`discard`. Then checkout default, `git branch -D`. `T-XXX` stays `[ ]`;
ask whether to keep the plan.

## 4. Post-merge (after the branch merges)

1. Sync the default branch (`git checkout <default>`, `git pull`).
2. Delete the merged branch (local; remote too if pushed).

The bookkeeping marks landed with the merge - they ride the mandatory
final commit (`branch-plan.md § Closing routine`); under untracked mode
(`companions/untracked-claude.md`) they were made in the working tree at
close. Exception: an R whose closure criteria are run-dependent
(`plan.md § Approval and closure`) closes later via its own plan MR/PR,
when the awaited event verifies them. Auto mode: the batch's R-closure
and release marks ride the post-checkpoint close-out PR
(branch-plan.md § Batches).
