# Dev docs

Bring the current project's `.claude/docs/` feature docs onto the doc-first
convention, or refresh them. Invoked by `/dev docs` (`SKILL.md`). The same
procedure `migrate` runs on first adoption, here run standalone on any
project and re-runnable: where docs already exist it is a refresh (audit
for code-drift and convention-conformance, rebuild or re-align the ones
the user picks).

## Steps

1. **Pre-flight.** `.claude/docs/` is the docs home (`layout.md § Docs`); the
   granularity model lives in `CLAUDE.md § Conventions`. If the project has no
   docs layer yet, this bootstraps it.
2. **Run** `companions/docs-adoption.md`: audit -> align-existing offer
   (docs built to a prior convention grade WARN; offer to restructure them
   to the framework and re-verify) -> user-prioritized build ->
   verification gate -> workflow correction.
3. **Deliver.** The new or updated docs, the `.claude/docs/index.md` entries,
   and any recorded conventions go via a short-lived branch + PR
   (`git-workflow.md`). Issues surfaced by the audit become tasks / R-stubs
   per the procedure.
