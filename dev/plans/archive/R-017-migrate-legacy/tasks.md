# R-017 tasks

Task index for this initiative. Items:
`T-001 (R-001) [feat|fix|refactor]: description` - format and closure:
`rules/planning.md § Levels`. Cross-R index: `plans/ROADMAP.md`.
Acceptance-criterion numbers (AC#) reference `requirements.md`.

## Open

- [x] T-036 (R-017) [fix]: legacy/non-canonical handling in
  `migrating-to-dev` - case-independent legacy detection (don't treat a
  lowercase/`REQ-XXX`/flat-tasks `.claude/` as current-schema
  Already-DEV), the Inventory gap-check run in every mode, and guided
  canonicalization with per-step approval (uppercase
  `REQUIREMENTS.md`/`DESIGN.md`/`ROADMAP.md`; `REQ-XXX`→R-rooted; flat
  `tasks.md`→per-R `tasks.md`). Canonicalization procedure in a companion
  file to keep `SKILL.md` ≤300. (AC1–AC5)
