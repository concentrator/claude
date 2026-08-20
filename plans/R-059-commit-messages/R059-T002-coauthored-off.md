task: R059-T002
type: mnt
depends-on: R059-T001

# R059-T002 - Turn the Co-Authored-By default off

- [ ] Set `"includeCoAuthoredBy": false` in the tracked user-global
  `settings.json`, so the harness stops appending the trailer the
  rule bans; `jq -e '.includeCoAuthoredBy == false'` passes and
  `check-settings` stays green
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [ ] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
