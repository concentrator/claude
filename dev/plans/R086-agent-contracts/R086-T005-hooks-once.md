---
task: R086-T005
type: fix
mode: normal
---

- [ ] A `--project` install skips each hook entry - event and matcher - that
  `$HOME/.claude/settings.json` already runs as `~/.claude/hooks/<name>` or
  its expanded path, still copies the file and prints the skip; with that
  file absent or unparsable, and on a global install, every hook registers.
  Approach: `scripts/install-dev.sh` step 3, then a skip case in
  `install-dev.test.sh`; it and `install-dev-minimal.test.sh` set a temp `HOME`.
- [ ] A re-run of a `--project` install removes the target's own entry for a
  hook entry the global settings now run, leaving its other hooks and keys.
  Approach: the same filter in `scripts/install-dev.sh` step 3, then a case
  in `install-dev.test.sh` installing under an empty `HOME` and again with a
  global settings file.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
