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

Exactly three, no elaboration:

1. Push and open a CI-gated PR to origin
2. Keep the branch as-is
3. Discard this work

## 3. Execute

**Push + PR** — `git push -u origin <branch>`, open a CI-gated PR to
origin (`glab`/`gh`: summary + test plan); no host CLI → push and print
the PR-creation URL. Always a PR — never a local merge or direct push.
Merge per `git-workflow.md § Trunk`: `plan/` PRs auto-merge on green,
code PRs await the user's review. Bookkeeping is deferred: `T-XXX` stays
`[ ]` until the PR merges; run §4 then.

**Keep** — report branch name. Nothing closes.

**Discard** — list branch, commits, and plan state; require typing
`discard`. Then checkout default branch, `git branch -D`. `T-XXX`
stays `[ ]`; ask whether to keep the plan file.

## 4. Post-merge bookkeeping (on default branch)

Auto mode: step 1 runs in the batch close phase (branch-plan.md
§ Batches); after the batch PR merges, run steps 2–5.

1. Mark `T-XXX` `[x]` in the parent R's
   `.claude/plans/R-XXX-<slug>/tasks.md`.
2. If the parent `R-XXX`'s tasks are all `[x]`, run the closure check
   (`planning.md § Approval and closure`): verified → mark `R-XXX`
   `[x]` in `ROADMAP.md`; pending → R stays open.
3. If `.claude/plans/release-<version>.md` lists this branch, mark it
   `[x]`.
4. Deliver the plan updates via a short-lived close-out doc PR to origin
   (`planning.md`), e.g. `Close T-014` — never a direct push.
5. Delete the merged branch (local; remote too if pushed).

Next: an open task, or `/dev plan`.
