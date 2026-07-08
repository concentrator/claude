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

- A CLAUDE.md doc-lookup table: a per-project index mapping feature/area to
  its `.claude/docs/<...>` path, consulted before coding. Kept current as
  docs are added.
- A `migrate` docs-adoption step: audit all features for doc coverage
  (fresh-agent spec-check grading PASS / WARN / FAIL / TODO), produce a
  report + a docs backlog (tasks / R-stubs), build docs now for a prioritized
  subset with the rest backfilled on-touch, then correct the workflow (wire
  the doc-first cycle + the lookup table into the project).

## Non-goals

- A full big-bang docs build for a legacy codebase - the audit is complete,
  the build is staged and prioritized.
- The `docs/` artifact class and the doc-first cycle themselves (R-023).

## User experience

- Steady state: before coding a feature, consult the CLAUDE.md lookup table
  and open the doc.
- Adoption: the `migrate` docs step reports coverage, builds the critical
  docs, seeds the backlog, and leaves the project on the doc-first cycle with
  a populated lookup table.

## Acceptance criteria

- [ ] A CLAUDE.md doc-lookup table convention is defined: format, placement
  in the project CLAUDE.md, how it is maintained, and how the agent routes
  with it before coding.
- [ ] `migrate` gains a docs-adoption step: audit (fresh-agent spec-check per
  feature into a PASS / WARN / FAIL / TODO report), a docs backlog, a
  prioritized build now with the rest deferred on-touch, and workflow
  correction (doc-first cycle + lookup table wired in).
- [ ] The audit reuses the `dispatching-parallel-agents` fresh-agent
  spec-check (the verification piece deferred from R-023, applied here).
- [ ] Ships to adopters (`migrate.md` + the CLAUDE.md convention, already
  distributed).

## Constraints

- Depends on R-023's core (the `docs/` artifact + doc-first cycle) being
  merged - sequence after R-023.
- Audit complete, build staged and prioritized.
- Self-hosting; trunk-based delivery (`git-workflow.md`).

## Open questions

- Prioritization heuristic for "build now" - churn, criticality, or
  entrypoints. Settle in detail.
- Lookup-table format: a markdown table in CLAUDE.md vs a separate index
  file referenced by CLAUDE.md. Settle in detail.
- How a "feature" is identified in an arbitrary codebase (audit
  granularity). Settle in detail.

## References

- Realizes the three pieces R-023 deferred: the CLAUDE.md lookup table, the
  `migrate` docs audit, and the doc-to-code fresh-agent verification (folded
  into the audit). Depends on R-023.
