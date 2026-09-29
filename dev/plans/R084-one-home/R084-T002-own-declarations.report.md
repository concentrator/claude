# R084-T002 report

## Implementer
### Divergences
- Item 1: `migrate.md § 5` now names both instruction files for the
  `--project` install's plan-text gate append. It is the only place in
  `migrate.md` that names the root file, and the approach lists
  `migrate.md`, so the prose moves in this commit and item 4 brings the
  installer in line with it.
- Item 1: generic `CLAUDE.md § <section>` citations in `agents/`,
  `run.md`, `handoff.md`, `git-workflow.md` and `seat-permissions.md`
  stay as they are. They do not say the root file, and both files are
  named `CLAUDE.md`. Script comments that say the root file go with
  items 2-4, which edit those scripts.
- Item 2: the header comments of `check-accretion`, `check-archival`,
  `check-batch-tags` and `check-plan-integrity` that named the root
  file now cite `companions/declarations.md`, in place of the
  `plan.md § Where things live` citation where the last two carried
  one. `check-stray` has no self-test and the `check-plan-text` one
  declares no tree, so neither gains a case.

## Review
