---
approved: 2026-07-08
kind: feat
---

# R-030: Docs-layer routing & adoption

## Motivation

R-023 defines the `.claude/docs/` layer and doc-first cycle for new feature
work. Two gaps keep it from working at scale. First, with many feature docs
the agent needs to find the right one before coding - a routing index.
Second, existing projects adopting DEV have undocumented code and no
doc-first habit; they need to assess coverage, backfill the important docs,
and correct their workflow. Without these, the docs layer only ever serves
greenfield features and never reaches existing code.

## Goals

- A docs index: a catalog in `.claude/docs/` mapping feature/area to its
  doc, consulted before coding to find the right one; project `CLAUDE.md
  § Conventions` carries a one-line pointer to it (keeping CLAUDE.md lean).
  Kept current as docs are added.
- A `migrate` docs-adoption step: audit the whole project at its
  docs-granularity - grade and reuse any existing docs as build input
  (fresh-agent spec-check, PASS / WARN / FAIL / TODO), backlog the gaps, and
  register any code issues found while probing as fixable tasks. Then build
  `.claude/docs/` for a subset the user prioritizes (build always occurs,
  even from zero docs), the rest on-touch. Then correct the workflow (wire
  the doc-first cycle + the index into the project).

## Non-goals

- A full big-bang docs build for a legacy codebase - the audit is complete,
  the build is staged and prioritized.
- The `docs/` artifact class and the doc-first cycle themselves (R-023).

## User experience

- Steady state: before coding a feature, follow the `CLAUDE.md` pointer to
  the docs index and open the feature's doc.
- Adoption: the `migrate` docs step reports coverage, files code issues as
  tasks, builds the user-prioritized docs (reusing any prior docs), seeds the
  backlog, and leaves the project on the doc-first cycle with a populated
  index.

## Acceptance criteria

- [ ] A docs index convention is defined: a catalog in `.claude/docs/`, a
  one-line `CLAUDE.md § Conventions` pointer to it, how it is maintained, and
  how the agent routes with it before coding.
- [ ] `migrate` gains a docs-adoption step: a whole-project audit at the
  project's docs-granularity (grade existing docs PASS / WARN / FAIL / TODO
  and reuse them as build input), a docs backlog, code issues registered as
  fixable tasks, a user-prioritized build now (always performed) with the
  rest on-touch, and workflow correction (doc-first cycle + index wired in).
- [ ] The audit reuses the `dispatching-parallel-agents` fresh-agent
  spec-check on existing docs (a missing doc is FAIL/TODO, needs no agent) -
  the verification piece deferred from R-023, applied here.
- [ ] Ships to adopters (`migrate.md` + the index/pointer convention, already
  distributed).

## Constraints

- Depends on R-023's core (the `docs/` artifact + doc-first cycle) being
  merged - sequence after R-023.
- Audit is whole-project; build is staged and user-prioritized.
- A "feature" is the project's recorded docs-granularity unit (R-023); the
  audit works at that granularity.
- Self-hosting; trunk-based delivery (`git-workflow.md`).

## Open questions

None - prioritization (ask the user which features matter most), lookup
format (a catalog in `.claude/docs/` + a one-line `CLAUDE.md` pointer), and
feature identity (the project's docs-granularity unit) settled in detail.

## References

- Realizes the three pieces R-023 deferred: the CLAUDE.md lookup table, the
  `migrate` docs audit, and the doc-to-code fresh-agent verification (folded
  into the audit). Depends on R-023.
