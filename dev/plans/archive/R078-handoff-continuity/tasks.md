# R078: Hand-off continuity - tasks

- [x] R078-T001 [feat]: the `SessionStart` re-brief hook - inject the
  session file's last `## hand-off` block on compact/resume starts,
  fail open everywhere, registered by the installer in both scopes,
  self-test and install-test coverage
- [x] R078-T002 [mnt]: the `notes` key - `handoff.md` gains it, the
  nudge reason names it, the nudge self-test asserts the reason
