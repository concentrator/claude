task: R061-T002
type: doc
depends-on: R061-T001

# R061-T002 - State the unified id shape

Branch `doc/id-shape-docs`. Prose only; `plan.md` must stay within the
1500-word cap (`scripts/ci/check-caps.sh`), so the § ID format rewrite
replaces the three per-level bullets rather than adding to them. Gate:
`bash scripts/ci/run-all.sh`.

- [x] `plan.md § ID format` becomes the one home: the shape
      (`R<NNN>`, `R<NNN>-T<NNN>`, `R<NNN>-B<NNN>`; one hyphen between
      components, none inside), the next-free-id rule, and the legacy
      shapes (`R-NNN`, `T-NNN`, `B-NNN`, `R<NNN>-B-NNN`) frozen and never
      reissued. Respell the examples in § Levels, § Where things live,
      § Directory conventions and the file's opening line
      (`R<NNN>-<slug>/`); the id-format bullet in § ID format about
      `REQ-XXX` stays.
- [x] `branch-plan.md § Batches` and `§ Rails` (`R<NNN>-B<NNN>.md`,
      `batch/R<NNN>-B<NNN>`, `pre-R<NNN>-B<NNN>`), `git-workflow.md
      § Trunk` (batch prefix form), `write-plan.md`, `templates.md`,
      `layout.md` tree - examples respelled, legacy mentions labelled
      `legacy`.
- [x] Remaining `skills/dev/` files and `companions/` naming a shape
      (`brainstorm.md`, `auto.md`, `supervise.md`, `finish.md`,
      `migrate.md`, `SKILL.md` router rows, `legacy-migration.md`,
      `report-template.md`, `root-migration.md`, `supervisor-runbook.md`,
      `tbd-migration.md`, `toolchain.md`); `SKILL.md` body stays within
      400 words.
- [ ] Root docs: `README.md`, `REQUIREMENTS.md § Planning discipline`,
      `DESIGN.md` tree-map, `MAINTENANCE.md`, `agents/code-reviewer.md`;
      then the acceptance grep (`requirements.md § Acceptance
      criteria`, second item) returns only `legacy`-labelled lines.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
      release-plan entry.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit; closing the R's
      last open task runs the closure check (`plan.md § Approval and
      closure`).
