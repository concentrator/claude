task: R060-T002
type: feat

# R060-T002 - Own the milestone plan's archival offer

Branch `feat/milestone-archive`. Prose only; `plan.md` sits at the
1500-word cap (`scripts/ci/check-caps.sh`), so the trigger replaces the
current archival clause instead of adding a sentence. Gate:
`bash scripts/ci/run-all.sh`.

- [x] `plan.md § Archival`: the clause "milestone plans when the
      milestone completes" becomes the owned trigger - `/dev plan
      milestone <id>` offers the file for `plans/archive/` once every
      entry's task is `[x]`, as `release` does for the release plan
      (`release.md` step 12); `templates.md § Milestone plan` preamble
      names the same trigger in one line. Word count stays ≤ 1500.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
      release-plan entry.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit; as R-060's last
      open task, run the closure check (`plan.md § Approval and
      closure`) and stamp `requirements.md`.
