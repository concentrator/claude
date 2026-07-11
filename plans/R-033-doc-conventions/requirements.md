---
approved: 2026-07-11
kind: feat
---

# R-033: Standardize documentation conventions (Diataxis)

## Motivation

R-023/030/031/032 gave a project a feature-docs layer (`.claude/docs/`) with
an ad-hoc template. Real use produced a mature, standard-grounded framework -
`plans/documentation-conventions.md` (Diataxis) - governing all docs: typing,
reference skeleton, detail bar, diagrams, formatting, content quality, an
independent-agent verification gate, and provenance. Adopt it as the global
documentation convention, generalized from its infra-flavored origin, with
the feature-docs layer as its Reference application and the verification gate
as the docs completion gate. One framework, the existing layer folds in.

## Goals

- A **global documentation convention** grounded in Diataxis: every doc is
  exactly one of tutorial / how-to / reference / explanation, never mixed;
  reference discipline (describe not instruct, one subject, split by variant);
  the fixed Reference skeleton; a **generalized detail bar** (every element /
  parameter / input of any subject, not just config / logs / ports); inline
  diagrams (C4 for infrastructure, entity/flow for features; mermaid in-repo,
  no external assets); the content-quality bar (self-sufficient, exact,
  actionable, justify-or-drop, no dead ends, DRY); and the provenance ladder
  (verified-by-doing > cited > inferred; version/env noted; recalled facts
  re-checked). Formatting **defers to `writing.md`** - no restating the
  em-dash ban, AI-tell words, or no-repetition rule.
- The **verification gate** (source section 8) as the docs completion gate:
  no doc is complete until an independent agent verifies every factual claim
  against ground truth - the live system for observable facts, the
  authoritative source otherwise. Per-claim verdict VERIFIED / DOCS / WRONG /
  UNPROVEN; the author never self-certifies; WRONG is corrected; UNPROVEN is
  resolved or explicitly marked unverified, never asserted as fact; large
  docs split across parallel reviewers. Replaces R-030's fresh-agent audit
  and R-023's reconcile-at-close for docs.
- **Rework the feature-docs layer as the Reference application**: the
  `layout.md § Docs` template becomes the Reference skeleton; the R-032 detail
  bar folds into the generalized one; `companions/docs-adoption.md`,
  `docs.md` (`/dev docs`), and `migrate` use the framework and the gate.
- **Convention alignment**: the audit grades existing docs for conformance to
  the current framework, not just code-drift. A doc built to a prior
  convention is convention-drifted (WARN); `/dev docs` (and `migrate`) offer
  to align it - restructure to the right Diataxis type + skeleton, fill the
  detail bar - and re-verify it through the gate. Projects with full or
  partial docs under the old convention get a clean upgrade path.

## Non-goals

- Code review - R-025 (the code-review checklist) stays a separate sibling;
  the verification gate here is docs-specific.
- A documentation site, generated output, or tooling.
- Retro-verifying every existing adopter doc: the gate applies to new and
  touched docs going forward, not a mass back-audit.
- Resurrecting a committed-stamp ledger (R-029 retired it): the verification
  gate leaves no separate artifact - version-control history records it.

## User experience

- Writing any doc: pick its Diataxis type; follow the type's shape (Reference
  uses the skeleton + generalized detail bar); formatting per `writing.md`.
- Completing a doc: an independent agent verifies each claim to a
  VERIFIED/DOCS/WRONG/UNPROVEN verdict before it is called done; UNPROVEN
  facts are marked in the doc, never stated as fact.
- Feature docs (`.claude/docs/`) are the Reference application of this
  framework; a project may still extend it via `.claude/rules/feature-docs.md`.

## Acceptance criteria

- [ ] A global documentation convention exists (Diataxis typing, reference
  discipline, Reference skeleton, generalized detail bar, diagrams, content
  quality, provenance; formatting defers to `writing.md`); it ships to
  adopters.
- [ ] The verification gate is defined - independent agent, per-claim
  VERIFIED/DOCS/WRONG/UNPROVEN, no self-certify, UNPROVEN handling, parallel
  split - and wired as the docs completion gate in the branch-close routine,
  `/dev docs`, and `migrate` (via the companion).
- [ ] The feature-docs layer is reworked as the Reference application:
  `layout.md § Docs` uses the skeleton, the detail bar folds in, the audit
  becomes the verification gate; no duplicate or contradictory doc convention
  remains.
- [ ] The audit grades convention-conformance as well as code-drift: a doc
  built to a prior convention is WARN, and `/dev docs` (and `migrate`) offer
  to align it to the framework and re-verify it through the gate.
- [ ] The loose `plans/documentation-conventions.md` source is absorbed into
  the convention and removed.
- [ ] Full Tier-1 gate green; changes ship via `skills/dev/`.

## Constraints

- Grounded in Diataxis (a named standard), not reinvented.
- DRY with `writing.md` (formatting) and the existing docs lifecycle
  (R-023/030/031); no duplicated or contradictory conventions.
- The global convention stays concise and domain-neutral - it generalizes the
  infra-flavored source, it is not a systems-only rule.
- Self-hosting; trunk-based delivery (`git-workflow.md`).

## Open questions

- Home: a `skills/dev/companions/` doc (loaded on demand when writing docs,
  no always-loaded bloat) vs a path-scoped `rules/*.md` vs a global rule.
  The framework is reference material for doc-writing - a companion leans
  right. Settle in detail.
- Verification gate vs the retired ledger (R-029): it is a review, but
  docs-specific and not a committed stamp - keep it artifact-free (VC history
  only). Settle in detail.
- R-025 (code review) relationship: sibling vs a shared "review" umbrella.
  Settle when R-025 is shaped.

## References

- `plans/documentation-conventions.md` - the source framework (Diataxis +
  sections 1-9), to be generalized and absorbed.
- Supersedes/subsumes the docs system R-023 (template + lifecycle), R-030
  (audit/adoption), R-031 (`/dev docs`), R-032 (detail bar). Relates R-025
  (code review). Grounded in Diataxis.
