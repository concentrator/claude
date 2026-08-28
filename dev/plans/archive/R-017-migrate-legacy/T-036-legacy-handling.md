task: T-036
type: fix

# fix/legacy-handling - legacy/non-canonical migration (R-017)

T-036 of `plans/R-017-migrate-legacy/requirements.md` (AC1–AC5). Make
`migrating-to-dev` recognize a legacy/non-canonical `.claude/`, run the
Inventory gap-check in every mode, and guide canonicalization to the
current schema.

**Decisions (approved):**
- Companion is a **new `legacy-migration.md`** (not extending
  `tbd-migration.md`).
- `SKILL.md` is at 293/300 - fit the changes via **analytical pruning**
  (prune-dead-prose gates), canonicalization detail in the companion.

Companion-first so the `SKILL.md` pointer resolves. Commit 2 is a skill
edit (propose + approval at code time).

- [x] Add companion `skills/migrating-to-dev/legacy-migration.md` - the
  guided canonicalization procedure: detect legacy markers (lowercase
  `design.md`/`requirements.md`/`roadmap.md`, four-level `REQ-XXX`, flat
  `tasks.md`); upgrade with per-step approval - rename to uppercase
  `REQUIREMENTS.md`/`DESIGN.md`/`ROADMAP.md`, convert `REQ-XXX`→R-rooted
  entries, split flat `tasks.md`→per-R `tasks.md`; irreversible/host steps
  stay advisory per the `tbd-migration` discipline.
- [x] `skills/migrating-to-dev/SKILL.md`: case-independent legacy
  detection (lowercase foundational files / `REQ-XXX` / flat tasks → a
  **Legacy/non-canonical** mode, not Already-DEV), run the Inventory
  gap-check in **every** mode, and route the Legacy mode to
  `legacy-migration.md`. Analytical-prune to ≤300 (propose cuts +
  changes for approval).
- [x] Complete the branch: confirm an already-canonical project reports
  conformant (no changes) and the Fresh / Already-DEV-pre-TBD paths are
  intact (inspection); caps green; re-review, triage the findings file,
  mark the plan complete, commit.
