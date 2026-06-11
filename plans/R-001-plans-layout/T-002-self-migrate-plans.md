task: T-002
type: refactor
architecture-changing: true
depends-on: T-001

# refactor/self-migrate-plans — migrate this repo's plans (REQ-002)

Manual mode only (no agentic stamp): moves active plan files including
its own. No other planning activity while this branch is open.

- [x] Create `plans/R-001-plans-layout/`; `git mv` this plan, T-001's,
      and T-003's plans (+ any findings files) in as
      `T-002-…`/`T-001-…`/`T-003-…`; own plan moves first in the
      commit. (T-003's file added at pre-flight — it postdates this
      plan's draft.)
- [x] `git mv plans/roadmap.md roadmap.md` and
      `git mv plans/tasks.md tasks.md` (indexes to root); verify
      REQ-XXX files stay at `plans/` root; `batches/` stays lazy
      (created on first batch).
- [x] Update this repo's descriptive docs to the now-factual state:
      design.md tree-map ("pending T-002" note removed), maintenance.md
      targets, README contents table (roadmap/tasks rows).
- [x] Remove the transition clause (legacy flat-path tolerance) from
      planning.md — new layout is now the only layout in this repo.
      (Adjusted with approval: clause narrowed to adopters-pending
      rather than removed — rules are global and T-003 hasn't run;
      removal moved to T-003's plan.)
- [ ] Complete the branch: re-review docs across all commits, cleanup,
      mark plan complete, commit.
