task: T-070
type: feat
depends-on: T-069

# feat/audit-to-bar - grade and build to the detail bar (R-032)

T-070 of `plans/R-032-docs-detail-bar/`. Align the docs-adoption companion
with the strengthened template (T-069): the audit grades to the bar and the
build produces to it, honoring a project's own `.claude/rules/feature-docs.md`
where present. Depends on T-069 (the strengthened bar).

Acceptance criteria: see `requirements.md` (audit grades to the bar with WARN
on drift; build produces to it; project-local rule honored).

- [x] `companions/docs-adoption.md`: the audit grades existing docs against the strengthened bar - a doc missing the full input surface, provenance markers, or real tested examples is WARN (drift), a rebuild candidate; the build produces docs to that bar. Where a project has a `.claude/rules/feature-docs.md`, grade against it (its bar supersedes the global default).
- [x] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
