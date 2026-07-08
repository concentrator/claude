---
approved: 2026-07-08
kind: feat
---

# R-023: Feature documentation layer (docs/)

## Motivation

Between `DESIGN.md` (architecture, why) and code (line-level, how) there is
no feature-level layer describing how a specific feature works - its data
model, interfaces, business rules, edge cases - the knowledge an agent needs
to modify it correctly. `references/` already holds external specs
(read-only); there is no home for own-code documentation, so an agent
re-derives a feature's behavior from the code each time, risking regressions.
Primarily serves adopter app projects; `~/.claude`'s own features are
self-documenting prose.

## Goals

- Define a `.claude/docs/` artifact class: per-feature docs on how our own
  code works, sitting between `DESIGN.md` and code. Sibling to
  `.claude/references/` (external, read-only); `docs/` is internal and kept
  current.
- A doc-first step in the execution cycle: write or update the feature's doc
  before implementing, and reconcile doc against code at branch close.
- Quality bar: a fresh agent reads only the doc and implements the feature
  correctly.

## Non-goals

Deferred - spin into stubs only if the lean core proves useful:

- A per-project CLAUDE.md doc-lookup table routing to the right doc.
- Audit-first docs adoption in `migrate` (crawl / PASS / WARN / FAIL).
- doc-to-code fresh-agent spec-check verification.
- Documenting `~/.claude`'s own skills as `docs/`.

## User experience

- Building a feature: write or update `.claude/docs/<feature>.md` (intended
  behavior) first, implement against it, reconcile at close.
- Modifying a feature: read its doc first - the source of truth for
  behavior, kept current with the code.

## Acceptance criteria

- [ ] `layout.md` defines the `.claude/docs/` artifact class: location,
  purpose, the docs (internal) vs references (external, read-only) boundary,
  and what a feature doc contains.
- [ ] The execution mode files (`feat`/`fix`/`refactor`) include a doc-first
  step; the closing routine reconciles doc against code before delivery.
- [ ] A feature-doc template/checklist defines a doc's shape (behavior, data
  model, interfaces, business rules, edge cases) at the "fresh agent
  implements correctly" bar.
- [ ] Ships to adopters (it lives in `layout.md` + the mode files, already
  distributed).

## Constraints

- `.claude/docs/` is opt-in - a project with no code features needs none.
- The self-hosting repo does not add its own `docs/` (skills are
  self-documenting prose).
- Trunk-based delivery (`git-workflow.md`).

## Open questions

- Granularity: one doc per feature vs per module/area. Settle in detail.
- Strictness: doc mandatory before code, or write-alongside with a reconcile
  gate at close. Settle in detail.

## References

- The `docs/` half of the original R-023 stub; `references/` (external)
  already exists (`layout.md`). Deferred pieces are future-stub candidates.
  Reuses the execution mode files + `branch-plan` closing routine.
