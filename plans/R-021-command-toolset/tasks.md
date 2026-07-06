# R-021 tasks

Phases A–E per the initiative requirements. **Phase A (T-039–T-043) is
complete** - the DEV content is staged in `skills/dev/` as dormant
companions; `/dev` still runs on the live skills/rules until cut-over (T-044).

**Gate:** `manifest.md` (approved 2026-07-03) classifies every skill +
rule as move-to-`skills/dev/` / stay-global / bundled; T-040–T-042 executed
strictly per it.

- [x] T-039 (R-021) [feat]: Branch-guard hook - `hooks/dev-branch-guard.sh` (PreToolUse; refuse writes on main/master) + `settings.json` registration; `dev` stays the skill router. (Phase A)
- [x] T-040 (R-021) [refactor]: Relocate rules → `skills/dev/` companions (per `manifest.md`) - `planning`→`plan.md`, `branch-plan`, `planning-templates`→`templates.md`, `project-layout`→`layout.md`, `changelog`; git-workflow copy → `skills/dev/git-workflow.md`. (Phase A)
- [x] T-041 (R-021) [refactor]: Relocate DEV sub-skills → `skills/dev/` companions (per `manifest.md`) - `feat`, `fix`, `refactor`, `write-plan`, `finish`, `release`, `auto` + companions. (Phase A)
- [x] T-042 (R-021) [refactor]: Relocate `brainstorming`→`brainstorm.md` + adoption skills (`migrating-to-dev`→`migrate.md`, `starting-a-project`→`start.md`) + companions; strip embed/vendor instructions from migrate/start, inline the CLAUDE.md slice into migrate. (Phase A)
- [x] T-043 (R-021) [feat]: CI rework - `check-caps` caps `skills/dev/` companions (1500w); DESIGN tree-map note. (Phase A)
- [x] T-044 (R-021) [refactor]: Cut over - rewire the `dev` skill router to read the `skills/dev/` companions instead of the standalone skills/rules; dogfood every flow; originals remain as fallback. (Phase B)
- [x] T-045 (R-021) [refactor]: Remove superseded - delete the relocated DEV rules + sub-skills; keep `skill-creator`, `writing-skills`, `wallarm-*`, personal rules. (Phase C)
- [x] T-046 (R-021) [refactor]: Retire R-015 machinery - remove vendor/embed/drift scripts + tests + `CLAUDE_ROOT`; **unwind the wallarm skills-repo embed** via a separate MR in that repo (remove its `.claude/skills/dev-*`, `.dev-toolchain.json`, `dev-embed-check.sh`, embedded `scripts/ci/`, and vendored DEV rules; preserve the team's own REQUIREMENTS/DESIGN/plans + `skills.md` override; then rely on the global toolset or ship a `.claude/skills/dev/` project copy); ROADMAP mark R-015 superseded, reconcile R-018/R-019/R-020. (Phase D)
- [x] T-047 (R-021) [feat]: Distribution - `scripts/install-dev.sh` copies the toolset (`skills/dev/`, hook + `settings.json` reg, + the 5 bundled dependency skills; idempotent) + README. (Phase E)
- [x] T-048 (R-021) [fix]: migrate/start deliver via branch + PR - the branch-guard hook forbids the bootstrap-exception commit-to-main; fix `skills/dev/migrate.md` (branch + PR; main exists) and `skills/dev/start.md` (narrow: initial commit creates main, then protect, then branches). Broader bootstrap-rule cleanup + start reorder stays R-018. (surfaced dogfooding /dev migrate)
