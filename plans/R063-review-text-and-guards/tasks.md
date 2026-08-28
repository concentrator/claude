# R063: Tier-2 review text and guard fail-closed - tasks

- [ ] R063-T001 [doc]: `MAINTENANCE.md § Tier-2 AI review` owns dead
  prose in one concern with its gates in place and states the maximal
  reading of "never restated"; `layout.md` stops claiming a seeded
  `MAINTENANCE.md`; `git-workflow.md § Merge policy` states the
  state-check-then-merge order
- [ ] R063-T002 [fix]: `install-dev.sh` registers project-tier hooks
  by `$CLAUDE_PROJECT_DIR`; `dev-secrets-guard.sh` fails closed on a
  missing library; fp-remedy re-installed
