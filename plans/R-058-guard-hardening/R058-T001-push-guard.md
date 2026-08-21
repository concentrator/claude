task: R058-T001
type: feat
depends-on: R058-T003

# R058-T001 - Push rules in the branch guard

- [ ] Deny a force push in any spelling: a `git push` whose arguments
  carry `-f`, `--force`, `--force-with-lease`, or a `+`-prefixed
  refspec is denied by `dev-branch-guard.sh`'s Bash path, reusing the
  existing command parsing (`-C`/`cd` target resolution, echo-text
  immunity); tests cover each spelling and echo-text non-triggering
- [ ] Deny a push targeting the default branch in any spelling: a
  refspec equal to the default branch or ending `:<default>`, or a
  bare `git push` while the target repo's HEAD is the default branch,
  is denied via the T003 resolver; `git push -u origin <prefix>/*`
  stays allowed; tests cover the refspec forms, the bare-push case,
  and the allowed task-branch push
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [ ] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
