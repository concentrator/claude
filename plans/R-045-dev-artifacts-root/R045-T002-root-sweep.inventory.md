# R045-T002 inventory - the root sweep

Two lists. § Adopter move set feeds `migrate` (R045-T003): what a
`.claude/`-layout project moves onto its declared root. § System-source
rewrites is this branch's work list: every DEV system-source reference
that assumes a fixed `.claude/` artifact prefix, each entry carried
out here or deferred with its reason.

## Adopter move set

`git mv` from `.claude/` to `<root>/`, references rewritten to match:

- `.claude/plans/` -> `<root>/plans/` (ROADMAP.md, release plans,
  `R-XXX-<slug>/` dirs with requirements/tasks/branch plans/findings/
  `batches/`, `archive/`, `visual-artifacts/`)
- `.claude/docs/` -> `<root>/docs/` (feature docs + `index.md`; the
  `CLAUDE.md § Conventions` index pointer is rewritten, not moved)

Stays under `.claude/` (config, guarded): `REQUIREMENTS.md`,
`DESIGN.md`, `MAINTENANCE.md`, `settings*.json`, `skills/`, `rules/`,
`commands/`, `agents/`, `hooks/`, `references/`, `adr/`.

## System-source rewrites

Worked by this branch unless marked deferred.

- [ ] `skills/dev/branch-plan.md` - branch-plan path, `.claude/docs/`
  (twice), batches path, release-plan path
- [ ] `skills/dev/write-plan.md` - branch-plan path, `.claude/docs/`
  (twice)
- [ ] `skills/dev/finish.md` - branch-plan path in § 1
- [ ] `skills/dev/docs.md` - `.claude/docs/`, `.claude/docs/index.md`
- [ ] `skills/dev/release.md` - release-plan paths, ROADMAP path,
  archive path
- [ ] `skills/dev/auto.md` - report/batch artifact wording
  (`.claude/settings.local.json` stays: config)
- [ ] `skills/dev/supervise.md` - artifact wording
  (`.claude/supervisor.md` stays: config)
- [ ] `skills/dev/SKILL.md`, `brainstorm.md`, `changelog.md`,
  `git-workflow.md` - artifact filename mentions
- [ ] `skills/dev/companions/documentation.md` - `.claude/docs/`
- [ ] `skills/dev/companions/docs-adoption.md` - `.claude/docs/`,
  index path (`.claude/rules/feature-docs.md` stays: config)
- [ ] `skills/dev/companions/report-template.md` - report path
- [ ] `skills/dev/templates.md` - per-initiative requirements path,
  release-plan filename (`.claude/REQUIREMENTS.md` stays: config)
- [ ] `skills/dev/companions/visual-companion.md` - session-dir paths,
  `.gitignore` advice
- [ ] `skills/dev/companions/implementer-prompt.md` - edit-permission
  rule restated over the artifacts root
- [ ] `skills/dev/companions/tbd-migration.md` - ROADMAP trigger
  predicate, archive path, structural-diff wording
- [ ] `skills/dev/companions/legacy-migration.md` - flat tasks split
  and branch-plan relocation paths
- [ ] `skills/dev/companions/untracked-claude.md` - detection
  predicate and `.gitignore` recipe cover the artifacts root
- [ ] `agents/code-reviewer.md` - plan-dir path; stale
  `plans/batches/B-XXX.md` (batches are per-R)
- [ ] `skills/dev/companions/auto-permissions.template.json` -
  `Read/Edit/Write(//__PROJECT_DIR__/.claude/plans/**)` globs resolve
  the declared root (logic)
- [ ] `skills/dev/companions/scripts/start-server.sh` - `SESSION_DIR`
  under the declared root (logic); `stop-server.sh` comment
- [ ] `skills/dev/start.md` - scaffold onto the declared root; ask +
  record the declaration (behavior change, not text substitution)
- [ ] `scripts/ci/check-plan-integrity.sh` - resolve the declared
  root (logic; this repo declares `./`)
- [ ] `scripts/ci/check-accretion.sh` + `scripts/test/
  check-accretion.test.sh` - same seam + fixture paths
- [ ] `scripts/ci/check-references.sh` - header comment amended (no
  behavior change by design: path checking stays a Tier-2 concern)
- [ ] Vendor transform (R-015 embed path) - carry the declaration
  through to embedded copies; adjust its test
- Deferred: `skills/dev/migrate.md` and its routing predicate - owned
  by R045-T003, which builds the adoption path around them
- Deferred: this repo's own `DESIGN.md`/`README.md`/`REQUIREMENTS.md`/
  `MAINTENANCE.md` repo-root artifact mentions - correct under the
  declared `./` root; nothing relocates (R-045 non-goal)
