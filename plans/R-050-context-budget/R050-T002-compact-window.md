---
task: R050-T002
type: mnt
depends-on: R050-T001, R050-T007
---

# R050-T002 - compaction window

Branch: `mnt/compact-window`.

`autoCompactWindow` is the enforcement for the whole initiative; every
hook R-050 adds is advisory. The setting accepts 100000 to 1000000 and
governs how full the window gets before Claude Code compacts. Left
unset it tracks the model's own limit, which on a million-token model
arrives long after the cost does.

The acceptance criterion this task serves is run-dependent: a maximum
context below the window can only be observed on a session produced
after the change. The criterion is therefore verified later, and R-050
stays open past this branch's merge until it is
(`plan.md § Approval and closure`).

- [ ] `settings.json`: set `autoCompactWindow` to 200000 beside the
      existing `autoCompactEnabled`. Verification here is the Tier-1
      gate plus a settings parse, not the context observation, which
      the branch cannot yet make.
- [ ] `DESIGN.md § Self-enforcement`: record the context budget beside
      the two existing tiers - what the window is, that it is the
      enforcement while the R-050 hooks stay advisory, and that
      compaction is safe against plan state because the plan file on
      disk is the record (`branch-plan.md § Body`).
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
