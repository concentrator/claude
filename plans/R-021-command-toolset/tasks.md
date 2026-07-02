# R-021 tasks

Draft task list (shape round). Ordering/dependencies pinned in the detail
round (`/dev plan R-021`). Phases A–E per the initiative requirements.

**Gate:** the detail round first produces `manifest.md` (every skill +
every rule classified move-to-`dev/` vs stay-global) for explicit
approval; T-040–T-042 execute strictly per it (requirements § Transform
manifest).

- [ ] T-039 (R-021) [feat]: Command router + branch-guard hook — `commands/dev.md` with `$DEV_DIR` resolution + dispatch skeleton, `hooks/dev-branch-guard.sh`, `settings.json` registration; lands dormant alongside existing skills. (Phase A)
- [ ] T-040 (R-021) [refactor]: Relocate manifest-marked rules → `dev/` mode files — per the approved manifest (provisionally `planning`, `branch-plan`, `planning-templates`, `project-layout`; strip `paths:`, refs → `$DEV_DIR`-relative); git-workflow rationale → `dev/git-workflow.md`. (Phase A)
- [ ] T-041 (R-021) [refactor]: Relocate DEV sub-skills → `dev/` mode files — per the approved manifest (provisionally `adding-a-feature`, `fixing-a-bug`, `doing-a-refactor`, `writing-plans`, `finishing-a-branch`, `release`, `delegating-to-agents`) + companions. (Phase A)
- [ ] T-042 (R-021) [refactor]: Relocate assigned general + adoption skills → `dev/` mode files — per the approved manifest (provisionally `brainstorming`, `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `receiving-code-review`, `dispatching-parallel-agents`, `migrating-to-dev`, `starting-a-project`) + companions. (Phase A)
- [ ] T-043 (R-021) [feat]: CI rework for mode files — `check-caps` mode-file caps; `check-stray` + `DESIGN.md` tree-map include `dev/`, `commands/`, `hooks/`; full gate green. (Phase A)
- [ ] T-044 (R-021) [refactor]: Cut over `/dev` to the command — route through command + mode files; dogfood every flow; old skills remain fallback. (Phase B)
- [ ] T-045 (R-021) [refactor]: Remove superseded skills/rules — delete the relocated DEV rules + sub-skills; keep `skill-creator`, `writing-skills`, `wallarm-*`, personal rules. (Phase C)
- [ ] T-046 (R-021) [refactor]: Retire R-015 machinery — remove vendor/embed/drift scripts + tests + `CLAUDE_ROOT`; ROADMAP mark R-015 superseded, reconcile R-018/R-019/R-020. (Phase D)
- [ ] T-047 (R-021) [feat]: Distribution — `scripts/install-dev.sh` (copy toolset + idempotent hook registration) + README section for contributor install. (Phase E)
