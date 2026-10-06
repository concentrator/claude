---
task: R086-T005
type: fix
mode: normal
---

- [x] A project copy of the branch or secrets guard, run from outside
  `$HOME/.claude/hooks`, exits silent when `$HOME/.claude/settings.json` runs
  it as `~/.claude/hooks/<name>` or its expanded path for PreToolUse under a
  matcher covering the call's tool; it acts when that file is absent or
  unparsable or the check's helper is missing. Approach: a sourced
  `hooks/dev-hook-once.sh` the installer copies, both hooks, tests on a temp `HOME`.
- [x] The branch-state, hand-off nudge and session-brief hooks run the same
  check for UserPromptSubmit, Stop and SessionStart, the last matched on the
  start's source, so each hook acts once; the installer registers every hook
  as today. Approach: the three hooks in `hooks/`, then a case in each test
  running a copy outside a temp `HOME`, silent when its settings run the hook.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
