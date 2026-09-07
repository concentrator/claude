# R074: Session-state hand-off enforcement - tasks

- [x] R074-T001 [feat]: fill computation and the prompt-line warning -
  the transcript-reading helper (fail-open, env-overridable threshold,
  fixture-pinned `usage` fields), `dev-branch-state.sh` extended with
  the warning, its self-test extended to assert both states and the
  one-line contract
- [ ] R074-T002 [feat]: the Stop-hook nudge - the hook (fill >=
  threshold and stale hand-off => `ok: false` + reason, fail open
  otherwise), settings registration, `install-dev.sh` shipping both
  hooks with `install-dev.test.sh` assertions; `depends-on: R074-T001`
