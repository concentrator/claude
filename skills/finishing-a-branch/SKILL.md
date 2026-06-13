---
name: finishing-a-branch
description: Use when a branch plan is complete and tests pass.
---

# Finishing a Development Branch

Close out a DEV branch — invoked by the closing routine
(`~/.claude/rules/branch-plan.md`) after the mandatory final commit.

## 1. Verify

- `.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md`: every `[ ]` is `[x]`;
  findings file triaged.
- Fresh test + lint green; failing → stop and report.

## 2. Present options

Exactly four, no elaboration:

1. Merge to <default-branch> locally
2. Push and create MR/PR
3. Keep the branch as-is
4. Discard this work

## 3. Execute

**Merge locally** — checkout default branch, pull, merge, rerun tests
on the result. Green → §4. Red → stop, report, ask.

**Push + MR/PR** — `git push -u origin <branch>`, create MR/PR
(`glab`/`gh`: summary + test plan). Bookkeeping is deferred — `T-XXX`
stays `[ ]` until the MR merges; run §4 then.

**Keep** — report branch name. Nothing closes.

**Discard** — list branch, commits, and plan state; require the user to
type `discard`. Then checkout default branch, `git branch -D`. `T-XXX`
stays `[ ]`; ask whether to keep the plan file.

## 4. Post-merge bookkeeping (on default branch)

Auto mode: step 1 runs in the batch close phase on `batch/B-XXX`
(branch-plan.md § Batches); after the batch MR merges, run steps 2–5
(step 5: batch branch; member refs went at accept).

1. Mark `T-XXX` `[x]` in `.claude/plans/TASKS.md`.
2. If the parent `R-XXX`'s tasks are all `[x]`, run the closure check
   (`planning.md § Approval and closure`): verified → mark `R-XXX`
   `[x]` in `plans/ROADMAP.md`; pending criteria → report, R stays
   open.
3. If `.claude/plans/release-<version>.md` lists this branch, mark it
   `[x]`.
4. Commit plan updates to the default branch (allowed exception),
   e.g. `Close T-014`.
5. Delete the merged branch (local; remote too if pushed).

Next: an open task from `plans/TASKS.md`, or `/dev plan`.
