# R064: Fixed dev/ home - tasks

- [x] R064-T001 [mnt]: this repository moves onto `dev/`: `plans/` →
  `dev/plans/` (archive included), `session/` → `dev/session/`, the
  `./` declaration dropped from `CLAUDE.md` so the default applies,
  the concrete references updated (`README.md`, `DESIGN.md`,
  `MAINTENANCE.md`, `.gitignore`); the resolver still runs, so the
  gate stays green; `check-batch-tags.sh` scopes the trunk's listing
  to its own plans/ directories
- [x] R064-T002 [refactor]: the configurable root leaves the DEV
  system: `resolve-root.sh` and its callers, `__ARTIFACTS_ROOT__`,
  `declarations.md § Artifacts root`, the `<root>/` notation and
  `plan.md § Where things live` replaced by fixed `dev/` paths;
  `root-migration.md` moves a `.claude/`-layout project onto `dev/`;
  a leftover `- DEV artifacts root:` line fails the Tier-1 gate with
  one line; depends-on: R064-T001
