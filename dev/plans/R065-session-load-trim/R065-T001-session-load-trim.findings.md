# R065-T001 findings

## Session load, words

Loaded in every session of every project (`CLAUDE.md` and its
imports), measured with `wc -w` at the branch base and at close:

| File | Before | After |
|---|---|---|
| `CLAUDE.md` | 392 | 394 |
| `writing.md` | 637 | 227 |
| `delegation.md` | 149 | deleted |
| every session | 1178 | 621 |
| `rules/git-workflow.md` (this repository, always-on) | 90 | deleted |
| `rules/writing-artifacts.md` (on Markdown reads and edits) | - | 466 |

## Rule-to-trigger table, checked

Each row of the branch plan's table resolved to its loading file:

- [x] State the present - `rules/writing-artifacts.md` (grep `^## State the present`: 1); CI cites it: `scripts/ci/check-accretion.sh` (grep `writing-artifacts.md § State the present`: 1)
- [x] One home per finding, Markdown - `rules/writing-artifacts.md` (grep `^## One home per finding`: 1)
- [x] One home per finding, code and data files - `CLAUDE.md` (grep `history or annotation fields`: 1)
- [x] One home per number - `rules/writing-artifacts.md` (grep `^## One home per number`: 1)
- [x] Durable id, Markdown - `rules/writing-artifacts.md` (grep `^## Name things by their durable id`: 1)
- [x] Durable id, commit and MR/PR text - `CLAUDE.md` (grep `cites work by durable id`: 1)
- [x] Bulk edits - `rules/writing-artifacts.md` (grep `^## Bulk edits`: 1)
- [x] Verification-gate pre-authorisation - `skills/dev/companions/documentation.md` (grep `without pausing to confirm`: 1)
- [x] Close-review pre-authorisation and bounds - `skills/dev/branch-plan.md` (grep `pre-authorised, by the session itself`: 1); reviewer conduct: `agents/code-reviewer.md` (grep `never invoke`: 1)
- [x] Wide-search pre-authorisation and limit - `CLAUDE.md` (grep `wide searches`: 1)
- [x] GitHub/PR pin - `CLAUDE.md` (grep `host GitHub`: 1)
