# R063: Tier-2 review text and guard fail-closed - tasks

- [x] R063-T001 [doc]: `MAINTENANCE.md § Tier-2 AI review` owns dead
  prose in one concern with its gates in place and states the maximal
  reading of "never restated"; `layout.md` stops claiming a seeded
  `MAINTENANCE.md`; `git-workflow.md § Merge policy` states the
  state-check-then-merge order
- [x] R063-T002 [fix]: `install-dev.sh` registers project-tier hooks
  by `$CLAUDE_PROJECT_DIR`; `dev-secrets-guard.sh` fails closed on a
  missing library; fp-remedy re-installed
- [x] R063-T003 [doc]: `finish.md § 3` names the delivery routine
  **Ship** (gate, push, MR/PR, poll to green, merge approval, merge,
  post-merge) with `ship / discard` as the close options, and
  `/dev ship` enters it from the router; depends-on: R063-T001
