---
paths:
  - "**/REQUIREMENTS.md"
  - "**/plans/R-*/requirements.md"
  - "**/plans/release-v*.md"
---

# Planning templates

## Foundational `.claude/REQUIREMENTS.md`

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

## Per-initiative `plans/R-XXX-<slug>/requirements.md`

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

### `kind: feat`

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

### `kind: bug`

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

### `kind: refactor`

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

## Release plan `release-vX.Y.Z.md`

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
