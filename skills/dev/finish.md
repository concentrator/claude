# Finishing a Development Branch

Close out a DEV branch - invoked by the closing routine
(`branch-plan.md`) after the mandatory final commit.

## 1. Verify

- `dev/plans/R<NNN>-<slug>/<task-id>-<slug>.md`: every `[ ]`
  is `[x]`; findings file triaged.
- Bookkeeping marks landed in the closing commits (`branch-plan.md
  § Closing routine`; untracked: `companions/untracked-claude.md`).
- Close review per `branch-plan.md § Closing routine`.
- Fresh `Test (full)` + lint green (`companions/declarations.md
  § Declared commands`) - the branch's one full local run; failing →
  stop and report.

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
3. **Options** - only then present delivery: **ship / discard**. No
   answer keeps the branch as it is, and the report says "kept, not
   shipped".

MR/PR opens only on explicit choice - never automatically.

## 3. Execute

**Ship** - the one path from a landed branch (every planned commit in,
nothing uncommitted) to a merged MR/PR. `/dev ship` enters it directly;
on the default branch, or with uncommitted changes, it stops with an
error naming that condition.

1. Gate: the Tier-1 runner `ci/run-all.sh` (installed per
   `start.md § 4`) plus the declared lint and `Test (full)` commands -
   already satisfied by a § 1 run with no commit after it. CI on the
   MR/PR is the authority; a local failure stops Ship and is reported.
2. `git push -u origin <branch>`, then open a CI-gated MR/PR via the
   declared change-request command (`companions/declarations.md
   § Declared commands`; no declared host → push and print the URL).
   **Stay on the branch** - do not switch to the default branch while
   the MR/PR is open, so the reviewer sees the branch's files; the
   switch to default is §4, after merge.
3. Poll to green (`git-workflow.md § Merge order`).
4. Report the MR/PR number and pipeline state in one line and ask for
   merge approval. A `plan/` branch skips the ask (`plan.md
   § Planning rounds`, `git-workflow.md § Merge policy`).
5. On approval, merge via the declared merge command, then §4.

Ship ends with one line: MR/PR number and final state - merged, open
awaiting approval, or kept.

**Discard** - list branch, commits, plan state; require typing
`discard`. Then checkout default, `git branch -D`. The task stays `[ ]`;
ask whether to keep the plan.

## 4. Post-merge (after the branch merges)

Detect the merge via the declared state-check command
(`companions/toolchain.md § State check`; no declared host → confirm
the merge with the user), then:

1. Sync the default branch (`git checkout <default>`, `git pull`).
2. Promote any durable fact the closed task's artifacts established
   (`plan.md § Archival`).
3. When the merge closed the initiative, verify the archive move
   landed with it (`plan.md § Archival`; Tier-1 `check-archival`).
   A follow-up plan MR/PR carrying the move and closure remains only
   for a late closure already on the trunk - tasks all `[x]` with the
   closure unrecorded and the closure check verifying (`plan.md
   § Approval and closure`).
4. Delete the merged branch (local; remote too if pushed).

Bookkeeping landed with the merge (`branch-plan.md § Closing routine`;
untracked mode: `companions/untracked-claude.md`); late closures:
`plan.md § Approval and closure`. Post-merge done, the session's unit
ends (`branch-plan.md § Session boundary`).
