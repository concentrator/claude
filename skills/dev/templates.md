# Planning templates

Requirement docs at every level state desired behavior - forward-looking,
present-tense, normative - never a history of shipped work. The R/T plan
hierarchy records who did what when; `REQUIREMENTS.md` records what must
remain true, unlinked from initiative ids.

## Foundational `.claude/REQUIREMENTS.md`

```
---
approved: pending
---

# Project requirements

## Vision           - one paragraph
## Goals            - top-level (3–7)
## Non-goals        - explicit out-of-scope
## Audience         - primary / secondary users
## Success criteria - how we'll know it worked
## Constraints      - technical / organizational / time
## Open questions
```

## Per-initiative `plans/R<NNN>-<slug>/requirements.md`

In rules, skills, and docs, write it path-qualified wherever bare
`requirements.md` could be read against root `REQUIREMENTS.md`.

All variants share the frontmatter. Body sections depend on `kind:`.
The title names the parent R - the file has no id of its own.

The shape round emits a draft `tasks.md` alongside this file, same
gate (`plan.md § Planning rounds`).

Frontmatter:

```
---
approved: pending
kind: feat | bug | refactor | doc | test | mnt
---

# R001: <short title>
```

### `kind: feat`

```
## Motivation
## Goals
## Non-goals
## User experience       - flows, surfaces, edge cases
## Acceptance criteria   - testable behaviors (checkboxes)
## Constraints
## Open questions
## References            - related initiative and task ids
```

### `kind: bug`

```
## Observed behavior     - what happens now
## Expected behavior     - what should happen
## Reproduction steps
## Impact                - who/how affected, severity
## Acceptance criteria   - testable behaviors confirming the fix
## Constraints
## Open questions
## References
```

### `kind: refactor`

```
## Current state         - pain points, motivation
## Desired state
## Invariants            - what must NOT change (behavior, performance)
## Scope                 - affected modules/files
## Acceptance criteria   - observable confirmation (tests pass, structure conforms)
## Constraints
## Open questions
## References
```

`doc`, `test`, and `mnt` initiatives use the `refactor` body shape; the
three shapes above are the only ones.

The **Acceptance criteria** section is load-bearing across all kinds:
source for manual / automated tests, and the fallback reference when
downstream tasks lack detail.

## Release plan `release-vX.Y.Z.md`

Created by `/dev plan release` (requires ≥1 closed task since the last
release). One checkbox per planned branch; the `[x]` is a closing-routine
bookkeeping mark (`branch-plan.md § Closing routine`; auto and untracked
modes place marks per § Batches / `finish § 4`). The
`release` skill halts while planned entries remain `[ ]` unless the user
confirms dropping them.

```
# Release vX.Y.Z

## Scope     - one-line theme of the release

## Branches  - one checkbox per planned branch
- [ ] feat/<slug> (R008-T001): description
- [ ] fix/<slug> (R008-T002): description

## Notes     - deferred or dropped scope, with reason
```

## Milestone plan `milestone-<id>.md`

Created by `/dev plan milestone <id>` for a milestone spanning several
initiatives (rules: `plan.md § Milestone plans`). Every entry is an
existing task id; waves follow the tasks' `depends-on` edges. Once
every entry is `[x]`, the same command offers the file for
`plans/archive/` (`plan.md § Archival`).

```
# Milestone <id>

## Boundary  - cite the `ROADMAP.md § Milestones` row; never restate it

## Order     - one wave per heading, members runnable in parallel
### Wave 1
- R008-T001 (<slug>): description
- R009-T002 (<slug>): description
### Wave 2
- R008-T003 (<slug>): description - after R008-T001

## Gaps      - work still blocking the milestone, each as a task id

## Notes     - deferred scope, with reason
```
