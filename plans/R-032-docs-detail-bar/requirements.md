---
approved: 2026-07-10
kind: feat
---

# R-032: Strengthen the feature-doc detail bar

## Motivation

R-023's global feature-doc template (`layout.md § Docs`) names sections
(behavior, data model, interfaces, business rules, edge cases) but does not
force the detail level that makes a doc pass its own quality bar. Building
real docs in `wallarm-api-js` required a much stronger project-local
convention (`.claude/rules/feature-docs.md`) to force completeness: the full
input surface, the provenance of each fact, and real tested examples. Fold
the domain-neutral strengthenings back into the global template so a
first-pass doc reaches the bar without each project reinventing it.

## Goals

- Strengthen `layout.md § Docs` to force:
  - **Full input surface** per interface - every input (wired or not) with
    type/shape, required, default, allowed values, constraints, interactions,
    and failure behavior (what happens when wrong or missing), not just names.
  - **Provenance markers** on facts - verified / from-spec / unverified,
    never silent omission.
  - **Real tested examples with output** - no invented data; cite the source
    (a test run or recorded transcript); secrets as placeholders.
  - **A sharpened quality bar** - compose a correct working invocation with
    the full input set from the doc + references alone; if it needs the
    source, the doc fails.
- Align `companions/docs-adoption.md`: the audit grades to this bar (missing
  failure behavior / provenance / real examples -> WARN drift); the build
  produces to it.
- Acknowledge project-local extension: a project may add a
  `.claude/rules/feature-docs.md` for domain specifics; the audit honors the
  project's bar where present.

## Non-goals

- Domain-specific content (API / route / wire specifics) - stays in a
  project-local rule, not the global template.
- Changing the docs location, lifecycle, or `/dev docs` (R-023/030/031).
- A generated-doc format or tooling.

## User experience

- Building a doc (doc-first cycle or `/dev docs`): the template prompts for
  the full input surface, provenance, and real examples, so a first pass
  reaches the bar.
- Auditing: a doc missing those dimensions grades WARN (drift) and is a
  rebuild candidate.

## Acceptance criteria

- [ ] `layout.md § Docs` template forces the full input surface
  (type/default/allowed/constraints/failure per input, wired or not),
  provenance markers, real tested examples with output, and the sharpened
  quality bar.
- [ ] `companions/docs-adoption.md` audit grades against these dimensions
  (WARN on drift); the build produces to them.
- [ ] The convention notes a project may extend it via a
  `.claude/rules/feature-docs.md`; the audit honors the project's bar.
- [ ] `layout.md` stays within its cap; changes ship to adopters
  (`skills/dev/` files).

## Constraints

- The global template stays domain-neutral and concise - it forces detail
  dimensions, it is not an API-specific rule.
- Self-hosting; trunk-based delivery (`git-workflow.md`).

## Open questions

- Provenance vocabulary: verified / from-spec / unverified vs probed /
  documented / unprobed (wallarm's terms). Pick domain-neutral. Settle in
  detail.
- A short reference example in the template (like the ADR template) vs prose
  requirements only. Settle in detail.

## References

- Grounded in `wallarm-api-js` `.claude/rules/feature-docs.md` +
  `R-004-api-docs-sweep` (the dogfooding). Extends R-023 (template) +
  R-030/R-031 (audit / build / command).
