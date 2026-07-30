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
   product and show the results. Present this and wait.
3. **Options** - only then present delivery: push and open a CI-gated MR/PR
   to origin / keep / discard.

MR/PR opens only on explicit choice - never automatically.

## 3. Execute

**Push + MR/PR** - `git push -u origin <branch>`, then open a CI-gated
MR/PR via the declared change-request command (`companions/toolchain.md
§ Declared commands`; no declared host → push and print the URL). Merge
per `git-workflow.md § Trunk`. After opening it, **stay on the branch** - do not
switch to the default branch while the MR/PR is open, so the reviewer sees
the branch's files; the switch to default is §4, after merge.

**Keep** - report branch name. Nothing closes.

**Discard** - list branch, commits, plan state; require typing
`discard`. Then checkout default, `git branch -D`. `T-XXX` stays `[ ]`;
ask whether to keep the plan.

## 4. Post-merge (after the branch merges)

Detect the merge via the declared state-check command
(`companions/toolchain.md § State check`; no declared host → confirm
the merge with the user), then:

1. Sync the default branch (`git checkout <default>`, `git pull`); the
   R's tasks now all `[x]` with no closure recorded → ship the closure
   via a plan MR/PR (`plan.md § Approval and closure`).
2. Delete the merged branch (local; remote too if pushed).

Bookkeeping landed with the merge (`branch-plan.md § Closing routine`);
untracked mode makes the marks now, in the working tree
(`companions/untracked-claude.md`); late closures:
`plan.md § Approval and closure`.
