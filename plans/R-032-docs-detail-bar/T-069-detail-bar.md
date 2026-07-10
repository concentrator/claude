task: T-069
type: feat

# feat/detail-bar - force detail in the feature-doc template (R-032)

T-069 of `plans/R-032-docs-detail-bar/`. Strengthen the `layout.md § Docs`
template so a first-pass doc reaches its quality bar: a full-input-surface
parameter table with provenance, real tested examples, and a sharpened
quality bar. Settled: provenance vocabulary is verified / from-spec /
unverified; the template carries a concrete parameter table, not prose only.

Acceptance criteria: see `requirements.md` (template forces full input
surface, provenance markers, real examples with output, sharpened quality
bar; project-local extension noted).

- [ ] `layout.md § Docs`: rework the template's interfaces section into a full-input-surface parameter table - columns name, type/shape, required, default, allowed values, constraints, failure behavior, and provenance (verified / from-spec / unverified) - covering every input, wired or not; add a note that an explicit "unverified" replaces silence.
- [ ] `layout.md § Docs`: require real tested examples (executed, shown with output, cite the source such as a test run or recorded transcript, secrets as placeholders, never invented); sharpen the quality bar to "compose a correct working invocation with the full input set from the doc + references alone - if it needs the source, the doc fails"; note a project may extend the bar via `.claude/rules/feature-docs.md`.
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
