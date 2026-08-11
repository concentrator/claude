# Dev docs

Bring the current project's `docs/` feature docs (root-relative:
`plan.md § Where things live`) onto the doc-first
convention, or refresh them. Invoked by `/dev docs` (`SKILL.md`). The same
procedure `migrate` runs on first adoption, here run standalone on any
project and re-runnable: where docs already exist it is a refresh (audit,
then rebuild or re-align the ones the user picks).

## Steps

1. **Pre-flight.** `docs/` is the docs home (`layout.md § Docs`); the
   granularity model lives in `CLAUDE.md § Conventions`. If the project has no
   docs layer yet, this bootstraps it.
2. **Run** `companions/docs-adoption.md`: audit -> user-prioritized build /
   re-align -> verification gate -> workflow correction.
3. **Deliver.** The new or updated docs, the `docs/index.md` entries,
   and any recorded conventions go via a short-lived branch + MR/PR
   (`git-workflow.md`). Issues surfaced by the audit become tasks / R-stubs
   per the procedure.
