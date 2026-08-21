task: R056-T003
type: doc
depends-on: R056-T001

# R056-T003 - Auto pre-flight reads merged tiers

- [ ] Amend `auto.md § Pre-flight`: permission-rule coverage is judged
  across the merged tiers (user-global `settings.json`, tracked
  project `.claude/settings.json`, any `settings.local.json`); a rule
  a tracked tier already carries is satisfied; only rules no tier
  carries are proposed, still into `settings.local.json`, applied on
  approval
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [ ] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
