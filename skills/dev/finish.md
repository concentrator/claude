# Finishing a Development Branch

Close out a DEV branch - invoked by the closing routine
(`branch-plan.md`) after the mandatory final commit.

## 1. Verify

- `plans/R-XXX-<slug>/<task-id>-<slug>.md` (root-relative): every `[ ]`
  is `[x]`; findings file triaged.
- Bookkeeping marks landed in the closing commits (`branch-plan.md
  § Closing routine`; untracked: `companions/untracked-claude.md`).
- Close review per `branch-plan.md § Closing routine`.
- Fresh test + lint green; failing → stop and report.

## 2. Report outcome, verify, then present options

Three ordered steps - the verify is a distinct, blocking step, never folded
into the options or glossed past:

1. **Outcome** - what the branch produced vs the task's acceptance
   criteria.
2. **Verify** - offer the action the diff content calls for: code →
   run it live; rules or process prose → dry-run the changed rule
   against a real case; tests → the suite run is the verification;
   data or config → run the work product and show the results. Present
   this and wait.
3. **Options** - only then present delivery: push and open a CI-gated MR/PR
   to origin / keep / discard.

MR/PR opens only on explicit choice - never automatically.

## 3. Execute

**Push + MR/PR** - `git push -u origin <branch>`, then open a CI-gated
MR/PR via the declared change-request command (`companions/declarations.md
§ Declared commands`; no declared host → push and print the URL). Merge
per `git-workflow.md § Trunk`. After opening it, **stay on the branch** - do not
switch to the default branch while the MR/PR is open, so the reviewer sees
the branch's files; the switch to default is §4, after merge.

**Keep** - report branch name. Nothing closes.

**Discard** - list branch, commits, plan state; require typing
`discard`. Then checkout default, `git branch -D`. The task stays `[ ]`;
ask whether to keep the plan.

## 4. Post-merge (after the branch merges)

Detect the merge via the declared state-check command
(`companions/toolchain.md § State check`; no declared host → confirm
the merge with the user), then:

1. Sync the default branch (`git checkout <default>`, `git pull`); the
   R's tasks now all `[x]` with no closure recorded → ship the closure
   via a plan MR/PR (`plan.md § Approval and closure`).
2. Promote any durable fact the closed task's artifacts established
   (`plan.md § Archival`); the files move only when the initiative
   closes, and that move ships on the closure's plan MR/PR.
3. Delete the merged branch (local; remote too if pushed).

Bookkeeping landed with the merge (`branch-plan.md § Closing routine`;
untracked mode: `companions/untracked-claude.md`); late closures:
`plan.md § Approval and closure`.
