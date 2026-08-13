---
task: R046-T004
type: refactor
---

# R046-T004 - declaration syntax gets its own companion

Branch: `refactor/declaration-companion`.

- [x] New `companions/declarations.md`: the three
      `CLAUDE.md § Agent toolchain` keys - declared commands, supervisor
      bounds, artifacts root - moved from `toolchain.md`, one section
      each, wording unchanged.
- [x] `companions/toolchain.md` keeps push, MR/PR, and state-check
      mechanics; the moved sections become a pointer to the new
      companion. Shipped in the same commit as the item above: a move
      split across two commits would duplicate the content in between,
      against `writing.md § One home per finding`.
- [x] Repoint every inbound reference found by grep - `git-workflow.md`,
      `supervise.md`, `plan.md`, `start.md`, `root-migration.md`,
      `finish.md`, `migrate.md`. `auto.md` and `finish.md § 4` keep
      pointing at `toolchain.md`: they cite push and state-check
      mechanics, which stayed. R-040's completed branch plans keep their
      citations - marks and plan text record what happened
      (`plan.md § Adjusting existing plans`).
- [x] Governed files, approved before editing: `CLAUDE.md § Agent
      toolchain` repointed, and `rules/claude-md.md` gained a
      declaration-syntax pointer beside its push-permission one. That
      rule file is governed too (`MAINTENANCE.md § Repair`), which the
      plan had not anticipated.
- [x] `DESIGN.md`'s tree-map names declaration syntax among the
      companions - the doc-sync pair table's "companion added" row.
- [x] Close-review fix: `toolchain.md`'s header named `SKILL.md` as a
      reader, which never referenced it; it now names the actual readers
      (`finish`, `auto`, `declarations.md`).
- [x] Mark and commit `R046-T004 [x]` in the R's `tasks.md` - the item
      every plan carries since R046-T003; this plan predates it.
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit. This closes the R's
      last open task, so the commit carries the initiative closure -
      every criterion verified with evidence, `status: done`, ROADMAP
      `[x]` (`plan.md § Approval and closure`).
