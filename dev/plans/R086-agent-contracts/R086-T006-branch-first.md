---
task: R086-T006
type: mnt
mode: normal
---

- [ ] Every change, VIBE or DEV, cuts its working branch before the first
  edit to a tracked path, never after edits made on the default branch;
  VIBE's wait holds back the MR/PR and the merge, not the branch.
  Approach: a bullet in `skills/dev/git-workflow.md § Trunk`, then the VIBE
  paragraph of its `§ Delivery cadence`.
- [ ] On the default branch, resolved as the branch guard resolves it, the
  branch-state line adds that the first edit needs a working branch, cut
  with `git switch -c <prefix>/<slug>`; any other branch's line is unchanged.
  Approach: `hooks/dev-branch-state.sh`, each case pinned in
  `scripts/test/dev-branch-state.test.sh`.
- [ ] The branch guard's refusals of an edit and of a commit on the default
  branch name `git switch -c <prefix>/<slug>` and the prefixes
  `git-workflow.md § Trunk` allows; what the guard refuses is unchanged.
  Approach: the two edit and one commit `deny` reasons in
  `hooks/dev-branch-guard.sh`, each pinned in
  `scripts/test/dev-branch-guard.test.sh`.
- [ ] The post-merge sync checks out the default branch and pulls only when
  `git status --porcelain` prints nothing; otherwise it stays on the merged
  branch, fast-forwards the local default with `git fetch origin
  <default>:<default>` and names the dirty paths.
  Approach: `skills/dev/finish.md § 4` step 1, then `Bash(git fetch:*)` in
  `companions/auto-permissions.template.json` and `seat-permissions.md`.
- [ ] The merge command only merges, `.claude/CLAUDE.md` declaring `gh pr
  merge <n> --merge`, and the sync deletes the origin branch and, once off
  it, the local one; on a dirty tree git refuses to delete the checked-out
  branch, so the sync names it for the user.
  Approach: `.claude/CLAUDE.md § Agent toolchain`, then `finish.md § 4`
  step 4.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
