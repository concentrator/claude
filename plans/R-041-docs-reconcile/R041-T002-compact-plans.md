---
task: R041-T002
type: doc
depends-on: R041-T001
---

# R041-T002 - compact the plans corpus to state the present

- [x] Compact `ROADMAP.md` closed entries to one-line index items: dated
      approval/shaped suffixes and narrative dropped (git history
      carries them); terminal outcomes (superseded / mooted by) kept -
      they are the entry's present state.
- [x] Fix the `ROADMAP.md` header's stale `rules/planning.md` pointer
      (the file no longer exists; the live home is
      `skills/dev/plan.md § Approval and closure`) and resolve the
      trailing R-004 sequencing comment - its "after R-005" condition is
      satisfied, so fold anything still operative into R-004's
      requirements and delete the rest.
- [x] State-the-present pass over the open initiatives'
      `requirements.md` + `tasks.md` (R-004, R-007, R-040, R-041):
      dated amendment notes and status suffixes removed; stub markers
      stay (present state).
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
