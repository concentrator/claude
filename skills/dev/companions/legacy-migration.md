# Legacy / non-canonical canonicalization

Upgrade a pre-existing `.claude/` to the current schema
(`layout.md`). Each step: report → approve → apply. Reversible
file moves apply directly; irreversible/host steps stay advisory (like
`tbd-migration.md`).

## Detect (any of)

- Lowercase foundational files (`design.md` / `requirements.md` /
  `roadmap.md`) vs `DESIGN.md` / `REQUIREMENTS.md` / `ROADMAP.md` -
  compare exact case (`git ls-files` is case-exact even on a
  case-insensitive filesystem).
- Four-level `R-XXX (REQ-XXX)` roadmap entries (`REQ-XXX` is retired -
  `plan.md § Archival`).
- A flat `plans/tasks.md` instead of per-R `tasks.md`.
- Cross-references to `~/.claude/rules/...` where an embedded copy is
  intended.

## Canonicalize (per-step approval)

1. Rename foundational files to uppercase via `git mv` so history
   follows. A case-only rename on a case-insensitive filesystem needs the
   two-step form: `git mv design.md tmp && git mv tmp DESIGN.md`.
2. Roadmap: rewrite `R-XXX (REQ-XXX): …` → `R-XXX: …`; fold any
   `REQ-XXX` requirement content into the R's `requirements.md`; drop the
   retired `REQ-XXX` files (git history preserves them).
3. Tasks: split a flat `plans/tasks.md` into per-R
   `R-XXX-<slug>/tasks.md`; relocate branch plans under their R-dir.
4. References: repoint stale `~/.claude/...` paths per the target (global
   vs embedded).
5. Re-run the project gate; commit each category separately (the
   bootstrap exception, `git-workflow.md`).

Already-canonical input → report conformant, no changes.
