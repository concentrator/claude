---
task: R045-T003
type: feat
depends-on: R045-T002
---

# R045-T003 - the adoption path onto the declared root

- [x] `companions/root-migration.md`, the move plan: inventory the
      project's `.claude/`-resident artifacts (`plans/`, `docs/`) and
      every in-project reference to them, and report the full move and
      rewrite list before touching anything.
- [x] `companions/root-migration.md`, execution: `git mv` onto the
      declared root, rewrite the listed references, backfill the
      `CLAUDE.md § Agent toolchain` declaration, deliver via MR/PR.
- [x] `migrate.md`: root-aware routing - the "Fresh - no
      `.claude/plans/`" classifier probes the declared root too, and a
      `.claude/`-layout project routes through `root-migration.md`.
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit; closing R-045's
      last open task, run the R-closure check with per-criterion
      evidence, including the headless artifact write in an
      adopter-shaped fixture.
