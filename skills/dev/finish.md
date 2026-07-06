# Finishing a Development Branch

Close out a DEV branch — invoked by the closing routine
(`branch-plan.md`) after the mandatory final commit.

## 1. Verify

- `.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md`: every `[ ]` is `[x]`;
  findings file triaged.
- Close review per `branch-plan.md § Closing routine`.
- Fresh test + lint green; failing → stop and report.

## 2. Report outcome and present options

One message: (a) **outcome** — what the branch produced vs criteria;
(b) **live test** — always offer a live run; for
data tasks run the work product and show results; (c) **options**: push
and open a CI-gated MR/PR to origin / keep / discard.

MR/PR opens only on explicit choice — never automatically.

## 3. Execute

**Push + MR/PR** — `git push -u origin <branch>`, open a CI-gated MR/PR
to origin (`glab`/`gh`: summary + test plan); no host CLI → push and
print the URL. Never a local merge or direct push. Merge per
`git-workflow.md § Trunk`. `T-XXX` stays `[ ]` until merge; run §4 then.

**Keep** — report branch name. Nothing closes.

**Discard** — list branch, commits, plan state; require typing
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
