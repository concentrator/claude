# R040-T021 findings

## Setting check

Read 2026-08-30: `code.claude.com/docs/en/env-vars.md`,
`tools-reference.md § Output limits`, `hooks.md § PostToolUse decision
control`, `settings.md` (the `env` map, `settings-reference#env`).

- `BASH_MAX_OUTPUT_LENGTH` - characters of Bash output read back into a
  result; default 30,000, ceiling 150,000. A valid result past the
  window goes to a file in the session directory with a short preview;
  a failure past 10,000 characters is cut to a head-and-tail excerpt.
  Settable below the default through the `env` map of `settings.json`.
  A blunt cap: it cuts the tail, where a test runner's verdict line
  sits, and does nothing for the output under the window, which is
  where the measured burn is.
- `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` - token cap on file reads;
  no default stated. Same shape of cut.
- `PostToolUse` hook, `hookSpecificOutput.updatedToolOutput` - replaces
  a tool's output before Claude sees it; the value must match the
  tool's output shape (`stdout`, `stderr`, `interrupted`, `isImage` for
  Bash). The one mechanism that can trim selectively - keep a gate's
  last line, drop a pre-push transcript - and a new hook component
  with its test, not a setting.
- Compaction: `autoCompactWindow` is already budgeted
  (`scripts/ci/check-settings.sh`); `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`
  only compacts earlier.

Verdict: no setting adopted. Nothing in the settings caps output
without cutting what a step needs; the rule carries the whole burden.
A trimming `PostToolUse` hook is the one instrument found and is
proposed as a backlog line, not built here.
