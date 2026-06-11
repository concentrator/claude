# Planning rules

Four-level hierarchy for DEV mode.

## Levels

1. **Requirements** — source of motivation, goals, acceptance criteria.
   - `.claude/REQUIREMENTS.md` — project foundational, persistent.
   - `.claude/plans/REQ-001.md`, `REQ-002.md`, ... — per-initiative
     (new feature, bug, or any work the foundational requirements don't
     already cover).
2. **Roadmap** — `.claude/ROADMAP.md`. Business-level features over
   time. Items: `R-001 (REQ-002): description`. Checkbox closes only
   when all child tasks are `[x]`.
3. **Tasks** — `.claude/TASKS.md`. Concrete units of work. Items:
   `T-001 (R-001) [feat]: description` — the tag in brackets
   (`[feat] | [fix] | [refactor]`) declares task type and determines the
   branch prefix. Checkbox closes only when the task's branch is merged.
4. **Branch plan** — `.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md`.
   Checkboxes per commit. Header: `task: T-001`. Checkbox closes at
   commit time. See `branch-plan.md`.

## ID format

- Requirements: `REQ-001`, `REQ-002`, ...
- Roadmap: `R-001`, `R-002`, ...
- Tasks: `T-001`, `T-002`, ...
- Batches: `B-001`, `B-002`, ... (execution grouping, not a level —
  see `branch-plan.md § Agentic execution`)
- One-indexed, three digits, monotonic.

## Referential integrity

- Roadmap items reference exactly one parent requirement.
- Tasks reference exactly one parent roadmap item.
- Branch plans reference exactly one parent task (via header).
- Each parent must be **open** (`[ ]`) at the time the child is created.
- Commits inside a branch plan need no external refs.
- This applies to findings promotion too: a finding becomes a `T-XXX`
  only under a fitting open `R-XXX`. If none exists, promote it to a
  `REQ-XXX` instead (next planning round spawns R → T). Never create a
  task with a closed, missing, or unrelated parent.

## Where things live

| File | Location |
|---|---|
| `REQUIREMENTS.md` (foundational) | `.claude/` |
| `DESIGN.md` | `.claude/` |
| `ROADMAP.md`, `TASKS.md` | `.claude/` |
| `REQ-XXX.md` | `.claude/plans/` |
| `T-XXX-<slug>.md` (branch plans) | `.claude/plans/R-XXX-<slug>/` |
| `T-XXX-<slug>.findings.md` | beside its branch plan |
| `B-XXX.md` (execution batches) | `.claude/plans/batches/` |
| `release-vX.Y.Z.md` | `.claude/plans/` |

## Directory conventions

- One plan directory per roadmap entry: `plans/R-XXX-<slug>/`, created
  lazily by `writing-plans` with the first child branch plan. Slug
  derives from the roadmap entry subject, is fixed at creation, and is
  never renamed on roadmap rewording.
- Branch plans are task-id-prefixed (`T-XXX-<slug>.md`); findings sit
  beside as `T-XXX-<slug>.findings.md`. Branch names stay
  `<prefix>/<slug>` — no id in git refs.
- `plans/batches/` is created with the first batch manifest.

## Where plans live in git

Requirements, design, roadmap, tasks, REQ-XXX, branch plans, and release
plans commit directly to `main` — they are documentation, visible across
all branches. Explicit exception to the no-commit-to-main rule, alongside
initial project scaffold.

## Cross-plan dependencies

A branch plan may declare `depends-on: T-012` in its header. `/dev code`
refuses to start the branch until the dependency is merged.

## Adjusting existing plans

- **REQ-XXX** body: `/dev plan REQ-XXX` to extend.
- **Branch plan (`<slug>`)**: `/dev plan <slug>` to add commits after
  the final.
- **Roadmap items, tasks** (single-line entries): direct file edit.
- Never rewrite history retroactively.

## Approval

`.claude/REQUIREMENTS.md` and per-initiative `REQ-XXX.md` carry an
`approved:` field in YAML frontmatter. New: `approved: pending`. After
user confirmation: `approved: YYYY-MM-DD`. Nothing downstream proceeds
while `approved: pending`.

## Archival

Plans and requirements are not physically moved when closed. Closed items
are marked `[x]`. Git history preserves the work. Manual cleanup is
possible but optional.

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

### Per-initiative `REQ-XXX.md`

All variants share the frontmatter. Body sections depend on `kind:`.

Frontmatter:

```
---
approved: pending
kind: feat | bug | refactor
---

# REQ-001: <short title>
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
## References            — related REQ-/R-/T-XXX
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
