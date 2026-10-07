---
task: R086-T006
type: mnt
mode: normal
---

- [x] Every change, VIBE or DEV, cuts its working branch before the first
  edit to a tracked path, never after edits made on the default branch;
  VIBE's wait holds back the MR/PR and the merge, not the branch.
  Approach: a bullet in `skills/dev/git-workflow.md § Trunk`, then the VIBE
  paragraph of its `§ Delivery cadence`.
- [ ] On the default branch, resolved as the branch guard resolves it, the
  branch-state line adds that the first edit needs a working branch, cut
  with `git switch -c <prefix>/<slug>`, and cites `git-workflow.md § Trunk`
  for the prefixes, listing none; any other branch's line is unchanged.
  Approach: `hooks/dev-branch-state.sh`, each case pinned in
  `scripts/test/dev-branch-state.test.sh`.
- [ ] The branch guard's refusals of an edit and of a commit on the default
  branch name `git switch -c <prefix>/<slug>` and cite `git-workflow.md
  § Trunk` for the prefixes, listing none; what the guard refuses is
  unchanged.
  Approach: `hooks/dev-branch-guard.sh`, its two edit and one commit `deny`
  reasons each pinned in `scripts/test/dev-branch-guard.test.sh`.
- [ ] The post-merge sync checks out the default branch and pulls only when
  `git status --porcelain` prints nothing; otherwise it stays on the merged
  branch, fast-forwards the local default with `git fetch origin
  <default>:<default>` and names the dirty paths.
  Approach: `skills/dev/finish.md § 4` step 1, then `Bash(git fetch:*)` in
  `companions/auto-permissions.template.json` and `seat-permissions.md`.
- [ ] The merge command only merges, `.claude/CLAUDE.md` declaring `gh pr
  merge <n> --merge`; a project relies on its host deleting a merged
  branch on origin, and the sync deletes only the local one, once off it,
  naming it for the user on a dirty tree, where the sync stays on it.
  Approach: `.claude/CLAUDE.md § Agent toolchain`, `finish.md § 4` step 4,
  then `branch-plan.md § Rails` and `run.md § Checkpoint` batch cleanup.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
