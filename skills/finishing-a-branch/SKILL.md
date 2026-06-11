---
name: finishing-a-branch
description: Use when a branch plan is complete and tests pass.
---

# Finishing a Development Branch

Close out a DEV branch. Invoked by the closing routine
(`~/.claude/rules/branch-plan.md`) after the mandatory final commit.

## 1. Verify

- `.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md`: every `[ ]` is `[x]`;
  findings file triaged.
- Fresh test + lint run, green. Failing → stop, report, don't proceed.

## 2. Present options

Exactly four, no elaboration:

1. Merge to <default-branch> locally
2. Push and create MR/PR
3. Keep the branch as-is
4. Discard this work

## 3. Execute

**Merge locally** — checkout default branch, pull, merge, rerun tests on
the result. Green → bookkeeping (§4). Red → stop, report, ask.

**Push + MR/PR** — `git push -u origin <branch>`, create MR/PR
(`glab`/`gh`: summary + test plan). Bookkeeping is deferred — `T-XXX`
stays `[ ]` until the MR merges; run §4 then (re-invoke this skill or
catch it on the next `/dev` from the default branch).

**Keep** — report branch name. Nothing closes.

**Discard** — list branch, commits, and plan state; require the user to
type `discard`. Then checkout default branch, `git branch -D`. `T-XXX`
stays `[ ]`; ask whether to keep or delete the branch plan file.

## 4. Post-merge bookkeeping (on default branch)

1. Mark `T-XXX` `[x]` in `.claude/TASKS.md`.
2. If all tasks under the parent `R-XXX` are now `[x]`, mark `R-XXX`
   `[x]` in `ROADMAP.md`.
3. If `.claude/plans/release-<version>.md` lists this branch, mark it
   `[x]`.
4. Commit plan updates to the default branch (allowed exception),
   single-line message, e.g. `Close T-014`.
5. Delete the merged branch (local; remote too if pushed).

Then propose next: an open task from `TASKS.md`, or `/dev plan`.
