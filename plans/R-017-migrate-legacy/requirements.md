---
approved: 2026-07-01
kind: bug
---

# R-017: migrating-to-dev legacy/non-canonical detection

## Observed behavior

`migrating-to-dev` on a legacy/non-canonical `.claude/` (lowercase
`design.md`/`requirements.md`/`roadmap.md`, four-level `REQ-XXX` roadmap,
flat `tasks.md`) detects "Already-DEV" via the case-insensitive presence
of `.claude/plans/ROADMAP.md` (a lowercase `roadmap.md` matches on macOS),
runs the TBD/archival path, and **skips the Inventory gap-check** (steps
1–8) — so the stale schema is neither reported nor upgraded. (Seen
adopting the wallarm skills repo.)

## Expected behavior

- Mode detection distinguishes a current-schema DEV project from a
  legacy/non-canonical `.claude/`, independent of filename case.
- The Inventory gap-check (cross-check vs `project-layout.md`) runs in
  **every** mode, reporting deviations (filename case, retired `REQ-XXX`,
  flat tasks).
- A legacy schema is **canonicalized with per-step approval**: uppercase
  `REQUIREMENTS.md`/`DESIGN.md`/`ROADMAP.md`; `REQ-XXX` four-level →
  R-rooted entries; flat `tasks.md` → per-R `tasks.md`.
- An already-canonical current-schema project reports conformant, no
  changes.

## Reproduction steps

1. A project with lowercase `.claude/plans/roadmap.md` (case-insensitive
   FS), a `REQ-XXX` roadmap, and lowercase `design.md`/`requirements.md`.
2. Run `/migrating-to-dev`.
3. → routes to Already-DEV/TBD, archives some artifacts, leaves the
   lowercase names + `REQ-XXX` schema in place.

## Impact

Re-migrating or adopting a legacy/hand-rolled `.claude/` silently leaves
it non-canonical; downstream tooling and embedding (R-015) assume the
canonical layout. Medium — affects adopters with a pre-existing `.claude/`.

## Acceptance criteria

- [ ] Detection identifies a legacy/non-canonical `.claude/` (lowercase
  foundational files, `REQ-XXX`, flat tasks), not just "ROADMAP.md
  present," independent of case.
- [ ] The Inventory gap-check runs in every mode and reports each
  deviation vs `project-layout.md`.
- [ ] `migrating-to-dev` canonicalizes a legacy schema with per-step
  approval (uppercase files; `REQ-XXX`→R-rooted; flat→per-R tasks);
  irreversible steps stay advisory per the existing TBD discipline.
- [ ] An already-canonical project reports conformant with no changes;
  the Fresh and Already-DEV-pre-TBD paths still work (regression).
- [ ] `migrating-to-dev/SKILL.md` stays ≤300 words (canonicalization
  procedure in a companion file).

## Constraints

- `skills/migrating-to-dev/SKILL.md` is at 293/300 — the canonicalization
  procedure lives in a companion file.
- Advisory for irreversible/host steps (existing `tbd-migration` discipline).

## Open questions

- Companion file: extend `tbd-migration.md` or add a new `legacy-migration.md`?
- Robustly detecting case-only deviations on a case-insensitive filesystem
  (e.g. `git ls-files` exact case vs on-disk).

## References

- R-003 (flattened four-level → R-rooted), `planning.md § Archival`
  (`REQ-XXX` retired), `rules/project-layout.md`, R-015 (embedding assumes
  the canonical layout).
