task: R074-T002
type: feat
depends-on: R074-T001
supervised: approved 2026-09-07

# R074-T002: the Stop-hook nudge, registered and shipped

The turn-end reminder for autonomous sessions and the installer wiring
(`requirements.md § Goals`, last two bullets).

- [x] `hooks/dev-handoff-nudge.sh` (Stop hook): fill from
  `dev-context-fill.sh`; session file from `dev-precompact-state.sh
  --path`; stale means the file's last `## tree` block sits after its
  last `## hand-off` block (no `hand-off` at all counts as stale, no
  file or no `tree` as fresh). Both conditions hold → print
  `{"ok": false, "reason": "..."}` naming the session file and
  `handoff.md § Writing the note`; anything else, and every read
  failure, → exit 0 silent. With it
  `scripts/test/dev-handoff-nudge.test.sh`: the four-cell
  condition matrix, the fail-open paths (absent transcript, absent
  window, outside a git repository), and that a `hand-off` appended
  after the `tree` block clears the nudge.
- [x] Register the hook on `Stop` in `settings.json`; the self-test
  asserts the registration (the `dev-branch-state.test.sh` pattern);
  `skills/dev/handoff.md § Writing the note` gains one line naming the
  warning and the nudge as the reminders that point here.
- [x] `scripts/install-dev.sh`: copy `dev-context-fill.sh` and
  `dev-handoff-nudge.sh` beside the other hooks and register the nudge
  on `Stop` idempotently (a `register_stop_hook` beside
  `register_state_hook`); `scripts/test/install-dev.test.sh` asserts
  both copies, the registration, and the re-install dedupe;
  `README.md` hooks row and the `DESIGN.md` tree-map name the new
  hooks.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, R074 closure check per `plan.md § Approval and closure`
  (criteria verified with one-line evidence, ROADMAP `[x]`, archival
  in the closing delivery), cleanup.
