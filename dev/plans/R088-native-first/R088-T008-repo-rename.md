---
task: R088-T008
type: mnt
mode: normal
---

- [x] USER: rename the GitHub repository `concentrator/claude` to
  `claude-dev`, point this clone's `origin` at its new URL, and rename the
  repository in the `~/.claude/settings.json` `autoMode` entries, before the
  task branch is pushed. Approach: the user's commands, from wording the
  runner drafts (`gh repo rename`, `git remote set-url`), then `claude
  auto-mode config` shows the new name.
- [x] `config-clone` clones `git@github.com:concentrator/claude-dev.git` by
  default and its dry run names that remote. Approach: the default in
  `scripts/worker-workspace.sh`, then the dry-run check in its test pinning
  `concentrator/claude-dev`; a tree grep finds no other name, the probe
  record `docs/reports/gh-pr-checks-watch.md` and task reports keeping the
  name their runs observed.
- [x] USER: what runs outside this machine follows the rename: each worker
  host's clone points `origin` at the new URL and its copied settings name
  `claude-dev`, and the weekly audit routine's repository reads
  `concentrator/claude-dev`, re-selected if not. Approach: the user's
  commands and routine settings, from wording the runner drafts.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- none

## Proven

- none
