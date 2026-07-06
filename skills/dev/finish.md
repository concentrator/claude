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

**Push + MR/PR** — `git push -u origin <branch>`, then open a CI-gated
MR/PR to origin by running the change-request command declared in CLAUDE.md
`## Agent toolchain` (`companions/toolchain.md`) - `gh pr create` / `glab
mr create` when the project only names the host (summary + test plan); no
declared host → push and print the URL. Never a local merge or direct push. Merge per
`git-workflow.md § Trunk`. `T-XXX` stays `[ ]` until merge; run §4 then.

**Keep** — report branch name. Nothing closes.

**Discard** — list branch, commits, plan state; require typing
`discard`. Then checkout default, `git branch -D`. `T-XXX` stays `[ ]`;
ask whether to keep the plan.

## 4. Post-merge bookkeeping (on default branch)

Auto mode: step 1 runs at batch close (branch-plan.md § Batches); run
steps 2–5 after the batch MR/PR merges.

1. Mark `T-XXX` `[x]` in the parent R's `tasks.md`.
2. If the R's tasks are all `[x]`, run the closure check
   (`plan.md § Approval and closure`): verified → `R-XXX` `[x]` in
   `ROADMAP.md`; else R stays open.
3. If `.claude/plans/release-<version>.md` lists this branch, mark `[x]`.
4. Deliver the plan updates via a close-out plan MR/PR to origin, e.g.
   `Close T-014` — never a direct push.
5. Delete the merged branch (local; remote too if pushed).
