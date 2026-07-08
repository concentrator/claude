task: T-063
type: feat

# feat/docs-artifact - the .claude/docs/ artifact class (R-023)

T-063 of `plans/R-023-docs-layer/`. Define the `.claude/docs/` artifact
class in `layout.md`: an internal, kept-current, per-feature documentation
layer sibling to the external read-only `references/`. Includes the
docs-vs-references boundary, the granularity-is-a-recorded-convention rule,
and an inline feature-doc template at the "fresh agent implements correctly"
bar.

Acceptance criteria: see `requirements.md` (layout.md defines location,
purpose, boundary, doc contents, and the granularity-convention rule; a
feature-doc template defines the doc's shape).

- [ ] `layout.md`: add `.claude/docs/` to the Layout tree (beside `references/`, "internal own-code feature docs, kept current") and to Creation policy § Lazy.
- [ ] `layout.md`: add a `§ Docs` section - purpose (internal own-code feature docs between `DESIGN.md` and code), the docs (internal, kept current) vs references (external, read-only) boundary, and the rule that the granularity model (feature / page / section / block) is a per-project choice recorded in `CLAUDE.md § Conventions` and applied consistently.
- [ ] `layout.md § Docs`: add an inline feature-doc template (mirroring the ADR template) - sections for behavior, data model, interfaces, business rules, edge cases - at the bar where a fresh agent reads only the doc and implements correctly.
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
