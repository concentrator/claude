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

- [x] `settings.json`: set `autoCompactWindow` to 200000 beside the
      existing `autoCompactEnabled`. Verification here is the Tier-1
      gate plus a settings parse, not the context observation, which
      the branch cannot yet make.
- [x] `DESIGN.md`: a sibling `## Context budget` section, following the
      one-section-per-concern pattern of `## Planning model` and
      `## Git & delivery model`. `§ Self-enforcement` is the wrong home:
      it opens "Two tiers gate every change into `main`", and a bound on
      a running session gates no change. State what the control is, and
      that the harness enforces it while this initiative's hooks
      observe. The compaction-safety derivation stays in
      `requirements.md`, which owns it and whose cited source carries
      only its premise; the number stays in `settings.json`.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
