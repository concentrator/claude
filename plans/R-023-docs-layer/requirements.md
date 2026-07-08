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
  current. The granularity model (feature / page / section / block) is a
  per-project choice recorded in `CLAUDE.md § Conventions` and applied
  consistently.
- A doc lifecycle: read the relevant docs at plan time (doc-informed
  planning), then a hard reconcile at branch close - a new feature writes
  the doc for what shipped, a fix/refactor reconciles the existing doc. TDD
  stays the code-level spec; the doc is not written before each code piece.
- Quality bar: a fresh agent reads only the doc and implements the feature
  correctly.

## Non-goals

Deferred - spin into stubs only if the lean core proves useful:

- A per-project CLAUDE.md doc-lookup table routing to the right doc.
- Audit-first docs adoption in `migrate` (crawl / PASS / WARN / FAIL).
- doc-to-code fresh-agent spec-check verification.
- Documenting `~/.claude`'s own skills as `docs/`.

## User experience

- Planning: read the relevant `.claude/docs/` to inform the plan (nothing to
  read yet for a brand-new feature).
- Building / modifying: implement with TDD; at branch close, write the doc
  (new feature) or reconcile it (fix/refactor) so it matches shipped code.
- Reading later: the doc is the current source of truth for the feature's
  behavior.

## Acceptance criteria

- [ ] `layout.md` defines the `.claude/docs/` artifact class: location,
  purpose, the docs (internal) vs references (external, read-only) boundary,
  what a feature doc contains, and the granularity-is-a-recorded-convention
  rule (`CLAUDE.md § Conventions`).
- [ ] Planning reads the relevant docs; the closing routine writes (new
  feature) or reconciles (fix/refactor) the feature doc to match shipped
  code - a hard step before delivery. The mode files note docs are read at
  plan and written/reconciled at close, not per-commit.
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

None - granularity (per-project, recorded in `CLAUDE.md § Conventions`) and
lifecycle (read at plan, write/reconcile at close) settled in the detail
round.

## References

- The `docs/` half of the original R-023 stub; `references/` (external)
  already exists (`layout.md`). Deferred pieces are future-stub candidates.
  Reuses the execution mode files + `branch-plan` closing routine.
