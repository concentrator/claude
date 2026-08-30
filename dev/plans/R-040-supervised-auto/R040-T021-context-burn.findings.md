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

## Re-measure

This session's transcript, sliced at the rule's commit
(2026-08-30T10:47:38Z), `scripts/context-cost.py` per slice; active
minutes count gaps up to ten minutes; tokens added exclude the context
a slice starts with.

| Slice | Calls | Active min | Added/min | Added/call | Bash result/call | Model output/call |
|---|---|---|---|---|---|---|
| Session before 2026-08-30 | 365 | 521 | 1294 | 1848 | 813 | 906 |
| 2026-08-30 before the rule | 99 | 124 | 1186 | 1486 | 822 | 712 |
| After the rule (51 min) | 58 | 51 | 1510 | 1323 | 380 | 874 |

- Bash result tokens per Bash call, the rule's direct target, halved
  (822 → 380).
- Tokens per call fell 11%; tokens per active minute rose, because the
  post-rule window is the close of two tasks (review dispatch,
  reports, PR bodies) at 1.1 calls a minute against 0.8 before.
- Compaction: one, at 11:37, the session's fourth; the previous was at
  20:27 the day before, so the window filled over 15 hours of wall
  clock, mostly before the rule. No interval to compare with the
  baseline's 14 minutes.
- The baseline session (aikido, 6k/min) was never matched here: this
  session ran at 1.2-1.3k/min before the rule, one fifth of the
  baseline, so the rule's effect on a session at the baseline rate is
  unmeasured. A 51-minute window is a smoke test, not a result; the
  next `/dev code` session on a code project is the measure.
