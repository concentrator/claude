# Finishing a Development Branch

Close out a DEV branch - invoked by the closing routine
(`branch-plan.md`) after the mandatory final commit.

## 1. Verify

- `.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md`: every `[ ]` is `[x]`;
  findings file triaged.
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
the branch's files; the switch to default is §4, after merge. `T-XXX` stays
`[ ]` until merge; run §4 then.

**Keep** - report branch name. Nothing closes.

**Discard** - list branch, commits, plan state; require typing
`discard`. Then checkout default, `git branch -D`. `T-XXX` stays `[ ]`;
ask whether to keep the plan.

## 4. Post-merge bookkeeping (after the branch merges)

Do this on a close-out branch, not the default branch (the branch-guard
refuses commits there):

1. Sync the default branch (`git checkout <default>`, `git pull`), then
   create a close-out plan branch (`plan/t<NNN>-close`).
2. Mark `T-XXX` `[x]` in the parent R's `tasks.md`.
3. If the R's tasks are all `[x]`, run the closure check
   (`plan.md § Approval and closure`): verified → `R-XXX` `[x]` in
   `ROADMAP.md`; else R stays open.
4. If `.claude/plans/release-<version>.md` lists this branch, mark `[x]`.
5. Deliver the plan updates via the close-out plan MR/PR to origin, e.g.
   `Close T-014` - never a direct push.
6. Delete the merged branch (local; remote too if pushed).

Auto mode marks member tasks at batch close on `batch/B-XXX`
(branch-plan.md § Batches); steps 3–6 run as this close-out PR after the
batch merges.
