# R088 tasks - Native first

Why: rules that override Claude Code's defaults cost turns, dispatches and tokens a native feature would save.

## Open

- [x] **R088-T001 [mnt]**: simple fixes - align each rule that overrides a native
  default with a setting, a one-line edit or a deletion, and fix the stale
  names the audit found.

- [ ] **R088-T002 [mnt]**: compaction without hand-off notes or a ledger, one CI
  wait that notifies pass or fail, explanations in their existing homes,
  review cost under the project's control, and the weekly audit routine.

- [ ] **R088-T003 [doc]**: docs rails - a table mapping paths to the doc files a
  change must update, a check that enforces it, and present-tense docs.

- [ ] **R088-T004 [mnt]**: two-step planning - requirements and design, then the
  task list with a plan per task; a small change ships in one MR/PR.

- [ ] **R088-T005 [mnt]**: permissions on native modes, settings and hooks, with
  the auto-mode classifier configured and the pre-flight cut to what binds.

- [ ] **R088-T006 [mnt]**: framework install - files copied onto a machine, the
  user's files and settings never overwritten, the repository no longer the
  user's config directory.

- [ ] **R088-T007 [mnt]**: a saved workflow runs the seats, continuing a seat for
  its follow-ups, and each seat loads only the text its step needs.

- `/dev migrate` does not add the `comments:` convention line to an existing project's `CLAUDE.md § Conventions`.
- The durable-id rule allows citing an MR/PR number, but the plan-text gate still rejects `#NNN` in ROADMAP and `tasks.md`.
- Brainstorm's approach choice, start's clarifying and quality questions, and finish's no-host merge confirmation still ask in plain text, not through AskUserQuestion.
- The dispatching-parallel-agents skill still shows `Task(...)` examples; the tool is Agent.
- `CLAUDE.local.md` has no `permissions.ask` rule, so its rule keeps a propose-and-wait step.
- The README keeps inline comma-runs the docs gate did not list: its opening and several layout rows.
- The README no longer says what the guards block.
- The full test tier runs locally right before CI runs it.
