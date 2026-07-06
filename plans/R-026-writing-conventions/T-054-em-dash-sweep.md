task: T-054
type: refactor

# refactor/em-dash-sweep - convert em dashes to hyphens (R-026)

T-054 of `plans/R-026-writing-conventions/`. Convert all 1043 em dashes to
hyphens across every tracked file (code + prose), by area so `main` stays
green and each commit is a reviewable mechanical change. Transform: replace
each em dash (`U+2014`) with a hyphen (`-`); a spaced em dash becomes a
spaced hyphen. En dashes (`U+2013`, numeric ranges) are left untouched. This
clears the tree for the T-055 gate.

Acceptance criteria: see `requirements.md` (no em dash remains in any tracked
file: 1043 to 0).

- [x] Sweep `rules/`, `CLAUDE.md`, and top-level docs (`REQUIREMENTS.md`, `DESIGN.md`, `README.md`, `MAINTENANCE.md`) - `perl -CSD` replacing `U+2014` with `-` on each tracked file in scope; caps still pass (word counts unchanged).
- [x] Sweep `skills/dev/` (SKILL.md + companions).
- [x] Sweep the other `skills/` (writing-skills, test-driven-development, systematic-debugging, verification-before-completion, receiving-code-review, dispatching-parallel-agents).
- [x] Sweep `plans/` (ROADMAP + every `R-XXX-<slug>/`).
- [x] Sweep `scripts/` + `hooks/` (em dashes in code comments).
- [x] Verify zero em dashes remain (`git grep` for `U+2014` returns nothing); `agents/` straggler caught + swept here; tables and arrows (`→`) survived; mark plan complete, commit.
