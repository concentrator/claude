# Finishing a Development Branch

Close out a DEV branch - invoked by the closing routine
(`branch-plan.md`) after the mandatory final commit.

## 1. Verify

- `.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md`: every `[ ]` is `[x]`;
  findings file triaged.
- Bookkeeping marks present in the final commit (`branch-plan.md
  § Closing routine`; untracked mode defers them to §4 -
  `companions/untracked-claude.md`).
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

1. Sync the default branch (`git checkout <default>`, `git pull`); the
   R's tasks now all `[x]` with no closure recorded → ship the closure
   via a plan PR (`plan.md § Approval and closure`).
2. Delete the merged branch (local; remote too if pushed).

Bookkeeping landed with the merge (`branch-plan.md § Closing routine`);
untracked mode makes the marks now, in the working tree
(`companions/untracked-claude.md`). Exception: run-dependent R closure
ships later via its own plan MR/PR (`plan.md § Approval and closure`).
