# R-061 tasks - Unified plan ids

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R061-T###`, counter scoped to this initiative).

## Open

- [ ] **R061-T001 [mnt]**: teach the gates the unified shape -
  `check-plan-integrity.sh` resolves `R<NNN>` initiatives, `R<NNN>-<slug>`
  directories and `R<NNN>-B<NNN>` batch files beside the legacy shapes;
  `check-batch-tags.sh` judges `batch/R<NNN>-B<NNN>` and
  `pre-R<NNN>-B<NNN>` beside `R<NNN>-B-XXX`; both test scripts gain
  new-shape and mixed-tree fixtures.
- [ ] **R061-T002 [doc]**: state the unified shape - rewrite
  `plan.md § ID format` as the one home (new shape, legacy shapes
  frozen), then respell every example and placeholder in the files
  listed in `requirements.md § Scope` so no tracked file outside
  `plans/` shows a legacy shape unlabelled. Depends on R061-T001.
