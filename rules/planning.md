# Planning rules

Three-level hierarchy for DEV mode: `R-XXX → T-XXX → branch plan`.
An initiative is any work foundational `.claude/REQUIREMENTS.md`
doesn't already cover.

## Levels

1. **Roadmap** — `.claude/plans/ROADMAP.md`. Initiative index —
   business-level features over time. Items: `R-001: description`.
   Each entry owns `plans/R-XXX-<slug>/`, whose `requirements.md`
   carries the initiative's motivation, goals, and acceptance
   criteria (template: § Templates). Closure: see § Approval and
   closure.
2. **Tasks** — `.claude/plans/TASKS.md`. Concrete units of work. Items:
   `T-001 (R-001) [feat]: description` — the tag in brackets
   (`[feat] | [fix] | [refactor]`) declares task type and determines the
   branch prefix. Checkbox closes only when the task's branch is merged.
3. **Branch plan** — `.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md`.
   Checkboxes per commit. Header: `task: T-001`. Checkbox closes at
   commit time. See `branch-plan.md`.

## ID format

- Initiatives (roadmap): `R-001`, `R-002`, ...
- Tasks: `T-001`, `T-002`, ...
- Batches: `B-001`, `B-002`, ... (execution grouping, not a level —
  see `branch-plan.md § Agentic execution`)
- One-indexed, three digits, monotonic.
- `REQ-XXX` is retired: requirement content carries its parent's
  R-XXX id (legacy files: § Archival).

## Referential integrity

- Roadmap items are the chain root; each owns exactly one
  `R-XXX-<slug>/` dir with its `requirements.md`.
- Tasks reference exactly one parent roadmap item.
- Branch plans reference exactly one parent task (via header).
- Each parent must be **open** (`[ ]`) at the time the child is created.
- Commits inside a branch plan need no external refs.
- This applies to findings promotion too: a finding becomes a `T-XXX`
  only under a fitting open `R-XXX`. If none exists, create an R stub
  instead — the initiative act per § Directory conventions, shaped
  next planning round. Never create a task with a closed, missing, or
  unrelated parent.

## Where things live

| File | Location |
|---|---|
| `REQUIREMENTS.md` (foundational) | `.claude/` |
| `DESIGN.md` | `.claude/` |
| `ROADMAP.md`, `TASKS.md` | `.claude/plans/` |
| `requirements.md` (per initiative) | `.claude/plans/R-XXX-<slug>/` |
| `T-XXX-<slug>.md` (branch plans) | `.claude/plans/R-XXX-<slug>/` |
| `T-XXX-<slug>.findings.md` | beside its branch plan |
| `B-XXX.md`, `B-XXX.report.md` (batches) | `.claude/plans/R-XXX-<slug>/batches/` |
| `release-vX.Y.Z.md` | `.claude/plans/` |

## Directory conventions

- One plan directory per roadmap entry: `plans/R-XXX-<slug>/`, created
  at initiative time — a new initiative is one act: ROADMAP entry +
  dir + `requirements.md` (`approved: pending`). Slug derives from the
  roadmap entry subject, is fixed at creation, and is never renamed on
  roadmap rewording.
- Branch plans are task-id-prefixed (`T-XXX-<slug>.md`); findings sit
  beside as `T-XXX-<slug>.findings.md`. Branch names stay
  `<prefix>/<slug>` — no id in git refs.
- `R-XXX-<slug>/batches/` is created with the R's first batch
  manifest; batches are scoped to that single R (`branch-plan.md
  § Batches`).

## Where plans live in git

Requirements, design, roadmap, tasks, branch plans, and release plans
commit directly to `main` — they are documentation, visible across all
branches. Explicit exception to the no-commit-to-main rule, alongside
initial project scaffold.

## Cross-plan dependencies

A branch plan may declare `depends-on: T-012` in its header. `/dev code`
refuses to start the branch until the dependency is merged.

## Adjusting existing plans

- **Initiative requirements** (`plans/R-XXX-<slug>/requirements.md`):
  `/dev plan R-XXX` to extend.
- **Branch plan (`<slug>`)**: `/dev plan <slug>` to add commits after
  the final.
- **Roadmap items, tasks** (single-line entries): direct file edit.
- Never rewrite history retroactively.

## Approval and closure

`.claude/REQUIREMENTS.md` and each initiative's
`plans/R-XXX-<slug>/requirements.md` carry an `approved:` field in
YAML frontmatter. New: `approved: pending`. After user confirmation:
`approved: YYYY-MM-DD`. Nothing downstream proceeds while
`approved: pending`.

An R entry closes (`[x]` in ROADMAP) only when **both** hold:

- all child tasks are `[x]`, and
- every acceptance criterion in its `requirements.md` is verified,
  with one-line evidence per criterion, stamped
  `status: done YYYY-MM-DD` in that file's frontmatter.

Run-dependent criteria (verifiable only by a later event) keep the R
open; the relevant event re-triggers verification (e.g. a batch
checkpoint — `branch-plan.md § Batches`).

## Archival

Plans and requirements are not physically moved when closed. Closed items
are marked `[x]`. Git history preserves the work. Manual cleanup is
possible but optional. Legacy `plans/REQ-XXX.md` files from the
four-level era stay at `plans/` root as read-only history.

Exceptions — may be moved to `.claude/plans/archive/` at the user's
option:

- Release plans (`release-vX.Y.Z.md`) after the release ships (offered
  by the `release` skill).
- Pre-DEV legacy artifacts: completed plan files predating the
  project's DEV adoption, with no `task:` chain. Closed DEV plans stay
  in their `R-XXX-<slug>/` dirs.

## Templates

### Foundational `.claude/REQUIREMENTS.md`

```
---
approved: pending
---

# Project requirements

## Vision           — one paragraph
## Goals            — top-level (3–7)
## Non-goals        — explicit out-of-scope
## Audience         — primary / secondary users
## Success criteria — how we'll know it worked
## Constraints      — technical / organizational / time
## Open questions
```

### Per-initiative `plans/R-XXX-<slug>/requirements.md`

In rules, skills, and docs, write it path-qualified wherever bare
`requirements.md` could be read against root `REQUIREMENTS.md`.

All variants share the frontmatter. Body sections depend on `kind:`.
The title names the parent R — the file has no id of its own.

Frontmatter:

```
---
approved: pending
kind: feat | bug | refactor
---

# R-001: <short title>
```

#### `kind: feat`

```
## Motivation
## Goals
## Non-goals
## User experience       — flows, surfaces, edge cases
## Acceptance criteria   — testable behaviors (checkboxes)
## Constraints
## Open questions
## References            — related R-/T-XXX
```

#### `kind: bug`

```
## Observed behavior     — what happens now
## Expected behavior     — what should happen
## Reproduction steps
## Impact                — who/how affected, severity
## Acceptance criteria   — testable behaviors confirming the fix
## Constraints
## Open questions
## References
```

#### `kind: refactor`

```
## Current state         — pain points, motivation
## Desired state
## Invariants            — what must NOT change (behavior, performance)
## Scope                 — affected modules/files
## Acceptance criteria   — observable confirmation (tests pass, structure conforms)
## Constraints
## Open questions
## References
```

The **Acceptance criteria** section is load-bearing across all kinds:
source for manual / automated tests, and the fallback reference when
downstream tasks lack detail.

### Release plan `release-vX.Y.Z.md`

Created by `/dev plan release` (requires ≥1 closed task since the last
release). One checkbox per planned branch; `[x]` only after that branch
is merged to the default branch (set by `finishing-a-branch`). The
`release` skill halts while planned entries remain `[ ]` unless the user
confirms dropping them.

```
# Release vX.Y.Z

## Scope     — one-line theme of the release

## Branches  — one checkbox per planned branch
- [ ] feat/<slug> (T-014): description
- [ ] fix/<slug> (T-015): description

## Notes     — deferred or dropped scope, with reason
```
