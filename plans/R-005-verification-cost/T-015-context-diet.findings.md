# T-015 context-diet — findings

## Measurements

`/context` isolates an always-loaded **Memory files** category that is
independent of conversation length, so it is the comparison metric for
criterion 5. The headline total is session-dependent (it includes
conversation messages) and is recorded only for reference.

### Baseline (2026-06-13, before any rule edit)

Captured on `refactor/context-diet` with rules unedited (working tree
equals `main`).

| Category | Tokens |
|---|---|
| Total context (session-polluted: 18.5k of it is messages) | 45.8k |
| Memory files (always-loaded) | 8.7k |

Memory-files breakdown:

| File | Tokens | Path-scoped by this branch? |
|---|---|---|
| CLAUDE.md | 1.4k | no (stays always-loaded) |
| rules/planning.md | 3.2k | yes |
| rules/project-layout.md | 1.3k | yes |
| rules/branch-plan.md | 2.7k | yes |

Path-scopable planning-rule baseline: **7.2k** (3.2 + 1.3 + 2.7).

`wc -w` of the three targets:

| File | Words |
|---|---|
| rules/planning.md | 1080 |
| rules/branch-plan.md | 1075 |
| rules/project-layout.md | 353 |

`planning.md § Templates` = 362 of planning.md's 1080 words (extraction target).

### After (rerun after all rule edits — see plan item 6)

_Pending._

## Load-behavior verification

_Pending — see plan item 4._

## Triage

_Pending — branch close._
