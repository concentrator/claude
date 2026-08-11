# Root migration

Move a `.claude/`-layout project's DEV artifacts onto its declared
artifacts root (`plan.md § Where things live`). Invoked from
`migrate.md` when the inventory finds artifacts under `.claude/`.
Plan first, then execute: nothing moves until the user approves the
reported move list.

## 1. Move plan

Resolve the target root: the `CLAUDE.md § Agent toolchain`
declaration if present, else ask the user (no preference → the
default); keep the answer for the § 2 backfill.

Inventory, then report - touching nothing:

- **Move set** - the `.claude/`-resident artifact trees, listed per
  top-level entry: `.claude/plans/` → `<root>/plans/` (ROADMAP.md,
  release plans, `R-XXX-<slug>/` dirs, `archive/`,
  `visual-artifacts/`) and `.claude/docs/` → `<root>/docs/` (feature
  docs + `index.md`). Config stays under `.claude/`: `REQUIREMENTS.md`,
  `DESIGN.md`, `MAINTENANCE.md`, `settings*.json`, `skills/`,
  `rules/`, `commands/`, `agents/`, `hooks/`, `references/`, `adr/`.
- **Rewrite set** - every in-project reference to a moved path: grep
  the tracked tree (project `CLAUDE.md`, README, docs, project rules
  and skills, CI config, `.gitignore`) for `.claude/plans` and
  `.claude/docs`; list each hit with its replacement.
- **Gaps** - a missing `DEV artifacts root:` declaration; a
  `.gitignore` entry for `<root>/plans/visual-artifacts/` where the
  project uses the visual companion; untracked mode, where the root
  must be gitignored too (`untracked-claude.md § Detection`).

Present the full report; **block on user approval**.
