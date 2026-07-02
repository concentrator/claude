# R-021 tasks

Draft task list (shape round). Ordering/dependencies pinned in the detail
round (`/dev plan R-021`). Phases A–E per the initiative requirements.

**Gate:** `manifest.md` (approved 2026-07-03) classifies every skill +
rule as move-to-`dev/` / stay-global / bundled; T-040–T-042 execute
strictly per it (requirements § Transform manifest).

- [ ] T-039 (R-021) [feat]: Command router + branch-guard hook — `commands/dev.md` with `$DEV_DIR` resolution + dispatch skeleton, `hooks/dev-branch-guard.sh`, `settings.json` registration; lands dormant alongside existing skills. (Phase A)
- [ ] T-040 (R-021) [refactor]: Relocate rules → `dev/` mode files (per `manifest.md`) — `planning`→`plan.md`, `branch-plan`, `planning-templates`→`templates.md`, `project-layout`→`layout.md`, `changelog` (strip `paths:`, refs → `$DEV_DIR`-relative); git-workflow rationale → `dev/git-workflow.md`. (Phase A)
- [ ] T-041 (R-021) [refactor]: Relocate DEV sub-skills → `dev/` mode files (per `manifest.md`) — `feat`, `fix`, `refactor`, `write-plan`, `finish`, `release`, `auto` (delegating-to-agents) + companions. (Phase A)
- [ ] T-042 (R-021) [refactor]: Relocate `brainstorming`→`brainstorm.md` + adoption skills (`migrating-to-dev`→`migrate.md`, `starting-a-project`→`start.md`) + companions; strip embed/vendor instructions from migrate/start (→ install/override), inline the CLAUDE.md slice into migrate. (Phase A)
- [ ] T-043 (R-021) [feat]: CI rework for mode files — `check-caps` mode-file caps; `check-stray` + `DESIGN.md` tree-map include `dev/`, `commands/`, `hooks/`; full gate green. (Phase A)
- [ ] T-044 (R-021) [refactor]: Cut over `/dev` to the command — route through command + mode files; dogfood every flow; old skills remain fallback. (Phase B)
- [ ] T-045 (R-021) [refactor]: Remove superseded skills/rules — delete the relocated DEV rules + sub-skills; keep `skill-creator`, `writing-skills`, `wallarm-*`, personal rules. (Phase C)
- [ ] T-046 (R-021) [refactor]: Retire R-015 machinery — remove vendor/embed/drift scripts + tests + `CLAUDE_ROOT`; ROADMAP mark R-015 superseded, reconcile R-018/R-019/R-020. (Phase D)
- [ ] T-047 (R-021) [feat]: Distribution — `scripts/install-dev.sh` copies the toolset (command, `dev/`, hook, `settings.json` reg, + the 5 bundled dependency skills; idempotent hook registration) + README. (Phase E)
