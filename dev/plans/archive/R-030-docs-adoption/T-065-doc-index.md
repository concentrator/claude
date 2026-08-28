task: T-065
type: feat

# feat/doc-index - the docs index + CLAUDE.md pointer (R-030)

T-065 of `plans/R-030-docs-adoption/`. Define a docs index: a catalog in
`.claude/docs/` mapping feature/area to its doc, consulted before coding to
find the right one. Project `CLAUDE.md § Conventions` carries a one-line
pointer to it, keeping CLAUDE.md lean (its 200-line cap). Depends on R-023's
`.claude/docs/` artifact (merged).

Acceptance criteria: see `requirements.md` (docs index convention defined -
catalog in `.claude/docs/`, a one-line `CLAUDE.md § Conventions` pointer, how
maintained, how the agent routes with it before coding).

- [x] `layout.md § Docs`: define the docs index - a catalog in `.claude/docs/` (one entry per doc: path + a one-line "covers X"), consulted before coding to find the feature's doc, kept current as docs are added.
- [x] The `CLAUDE.md` pointer: `layout.md § Docs` states project `CLAUDE.md § Conventions` carries a one-line reference to the index; note that `start.md` seeds it and `migrate.md § 4` (CLAUDE.md alignment) backfills it.
- [x] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
