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
- [ ] The post-merge sync checks out the default branch and pulls only when
  `git status --porcelain` prints nothing; otherwise it stays on the merged
  branch, fast-forwards the local default from origin without switching,
  names the dirty paths and leaves the local branch delete for the user.
  Approach: `skills/dev/finish.md § 4` steps 1 and 4, then `Bash(git fetch:*)`
  in `companions/auto-permissions.template.json` and `seat-permissions.md`.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
