task: R055-T002
type: mnt
branch: plan/r049-r054-archive  # planning artifacts move via plan MR/PR (task text); overrides the tag prefix

# R055-T002 - Archive the R-049 and R-054 backlog

- [x] Promotion check over `plans/R-049-vendored-gate-hygiene/` and
  `plans/R-054-allowlist-prune/` (`plan.md § Archival`), then `git mv`
  both directories to `plans/archive/`
- [x] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [x] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
