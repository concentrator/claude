# R-021 tasks

Phases A–E per the initiative requirements. **Phase A (T-039–T-043) is
complete** — the DEV content is staged in `skills/dev/` as dormant
companions; `/dev` still runs on the live skills/rules until cut-over (T-044).

**Gate:** `manifest.md` (approved 2026-07-03) classifies every skill +
rule as move-to-`skills/dev/` / stay-global / bundled; T-040–T-042 executed
strictly per it.

- [x] T-039 (R-021) [feat]: Branch-guard hook — `hooks/dev-branch-guard.sh` (PreToolUse; refuse writes on main/master) + `settings.json` registration; `dev` stays the skill router. (Phase A)
- [x] T-040 (R-021) [refactor]: Relocate rules → `skills/dev/` companions (per `manifest.md`) — `planning`→`plan.md`, `branch-plan`, `planning-templates`→`templates.md`, `project-layout`→`layout.md`, `changelog`; git-workflow copy → `skills/dev/git-workflow.md`. (Phase A)
- [x] T-041 (R-021) [refactor]: Relocate DEV sub-skills → `skills/dev/` companions (per `manifest.md`) — `feat`, `fix`, `refactor`, `write-plan`, `finish`, `release`, `auto` + companions. (Phase A)
- [x] T-042 (R-021) [refactor]: Relocate `brainstorming`→`brainstorm.md` + adoption skills (`migrating-to-dev`→`migrate.md`, `starting-a-project`→`start.md`) + companions; strip embed/vendor instructions from migrate/start, inline the CLAUDE.md slice into migrate. (Phase A)
- [x] T-043 (R-021) [feat]: CI rework — `check-caps` caps `skills/dev/` companions (1500w); DESIGN tree-map note. (Phase A)
- [ ] T-044 (R-021) [refactor]: Cut over — rewire the `dev` skill router to read the `skills/dev/` companions instead of the standalone skills/rules; dogfood every flow; originals remain as fallback. (Phase B)
- [ ] T-045 (R-021) [refactor]: Remove superseded — delete the relocated DEV rules + sub-skills; keep `skill-creator`, `writing-skills`, `wallarm-*`, personal rules. (Phase C)
- [ ] T-046 (R-021) [refactor]: Retire R-015 machinery — remove vendor/embed/drift scripts + tests + `CLAUDE_ROOT`; ROADMAP mark R-015 superseded, reconcile R-018/R-019/R-020. (Phase D)
- [ ] T-047 (R-021) [feat]: Distribution — `scripts/install-dev.sh` copies the toolset (`skills/dev/`, hook + `settings.json` reg, + the 5 bundled dependency skills; idempotent) + README. (Phase E)
