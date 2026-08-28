---
approved: 2026-08-25
kind: feat
status: done 2026-08-26
---

# R-060: Milestone execution plans

## Motivation

The DEV levels stop at the initiative: a milestone spanning several of them has
no artifact carrying its execution order, and no declared home for its boundary
either. Each member task's order lives in its own initiative's `tasks.md`, so the
cross-initiative sequence exists only as something a session re-derives from
`depends-on` edges whenever it is asked - a derivation that is neither reviewable
nor citable, and that lands differently each time the edges are read.

The gap is closed by naming the artifact rather than by tolerating one. Today
`plan.md § Where things live` is an exclusive list, so such a file has no legal
location, and `/dev plan` has no target that authors one; a session asked for the
sequence therefore either invents a home or answers into the conversation and
loses the answer.

## Goals

- A milestone spanning more than one initiative may carry
  `plans/milestone-<id>.md`, alongside `release-vX.Y.Z.md` as the second
  root-level cross-initiative plan.
- The file records order, never scope. Scope has a declared home of its own: an
  optional `ROADMAP.md § Milestones` map, one row per milestone, each stating the
  boundary in a line and citing its milestone plan where one exists.
- `/dev plan milestone <id>` authors and adjusts it.
- The task graph stays authoritative: the file reads the `depends-on` edges, it
  does not restate or override them.

## Non-goals

- **Not mandatory.** A milestone whose tasks all sit in one initiative is ordered
  by that `tasks.md` and needs no file.
- **Not a scope document.** The milestone's boundary stays in
  `ROADMAP.md § Milestones`, which the file cites (`writing.md § One home per
  number`).
- **Not a work source.** Every entry is an existing task id; a gap the file names
  gets a task, not a note.
- No general escape hatch in the plans root: this widens the exclusive list by
  one named file.

## User experience

`/dev plan milestone M1` emits or adjusts `plans/milestone-M1.md`: the boundary
it serves, the execution order in waves, the gaps still blocking it, and the
scope deferred with its reason. Members of one wave have no edge between them, so
a wave is what can run in parallel.

The milestone's `ROADMAP.md` row then cites the file instead of restating the
sequence, and the file is offered for archival when the milestone completes, as a
release plan is when the release ships.

## Acceptance criteria

- [x] `plan.md § Where things live` lists `milestone-<id>.md` at `<root>/plans/`,
      and `layout.md § Artifacts layout` shows it in the tree. Evidence:
      table row and tree line, commit "Declare the milestone plan artifact".
- [x] `SKILL.md`'s `/dev plan` table routes `milestone <id>` ahead of the
      `<slug>` row, so a bare milestone id never falls through to branch-plan
      adjustment. Evidence: row precedes `<slug>`, commit "Route /dev plan
      milestone <id>".
- [x] `plan.md § Milestone plans` states the rules the Goals and Non-goals above
      fix: optional, order not scope, existing task ids only, and `depends-on`
      authoritative - so an order contradicting the edges is a defect in the
      milestone file. It declares the `ROADMAP.md § Milestones` map in the same
      place, as the boundary's home. Evidence: section's three bullets and lead
      paragraph, commit "State the milestone plan rules".
- [x] `templates.md` carries the milestone-plan template: Boundary, Order in
      waves, Gaps, Notes. Evidence: `templates.md § Milestone plan`, commit
      "Add the milestone plan template".
- [x] `plan.md § Templates` and `plan.md § Archival` name the milestone plan
      beside the release plan. Evidence: both sections, commit "State the
      milestone plan rules".
- [x] `scripts/test/run-all.sh` is green. Evidence: `bash scripts/ci/run-all.sh`
      exit 0 on every branch commit; CI `tier1` on the PR.

## Constraints

- Single home per rule (R-039): the artifact type is declared once in
  `plan.md § Where things live`, mirrored in the `layout.md` tree, and every
  other mention points at it.
- The template is the only place the file's shape is specified; `plan.md` states
  the rules, not the headings.
- Proportional (R-053): a declaration, a router row, a rule section and a
  template. No new subsystem and no state file.

## Open questions

- Should `check-plan-integrity` learn the file - every id resolves to a task, and
  no wave order contradicts a `depends-on` edge? The drift it would catch has
  never been observed, since no milestone plan exists yet, so R-053 puts the call
  with the operator rather than shipping the gate with the artifact.

## References

- `skills/dev/plan.md § Where things live`, `§ Templates`, `§ Archival`;
  `skills/dev/layout.md § Artifacts layout`; `skills/dev/SKILL.md § /dev plan`;
  `skills/dev/templates.md`.
- R-014 - per-initiative task indexes, the level this file sits above.
- R-055 - the archival vehicle a completed milestone's plan travels on.
