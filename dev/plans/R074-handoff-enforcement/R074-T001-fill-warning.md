task: R074-T001
type: feat
supervised: approved 2026-09-07

# R074-T001: fill computation and the prompt-line warning

The transcript-reading helper and the `branch-state:` line extension
(`requirements.md § Goals`, first two bullets).

- [ ] `hooks/dev-context-fill.sh`: reads the hook input JSON on stdin,
  takes the last `message.usage` record from its `transcript_path`
  (`input_tokens` + `cache_creation_input_tokens` +
  `cache_read_input_tokens`, the fields `scripts/context-cost.py`
  reads), computes fill against `autoCompactWindow` (project
  `.claude/settings.json` first, user-global `settings.json` else) and
  prints the integer percent only at or above the threshold (default
  80, `DEV_FILL_WARN_PCT` overrides); silent and exit 0 on any read,
  parse, or lookup failure. With it
  `scripts/test/dev-context-fill.test.sh`: a transcript fixture
  pinning the three `usage` fields (loud failure on schema drift),
  above/below threshold, the override, and each fail-open path
  (absent transcript, malformed JSON, absent window).
- [ ] `hooks/dev-branch-state.sh`: when the helper prints, the one
  line gains `| context <pct>% - append the hand-off block to
  <session path>`; `scripts/test/dev-branch-state.test.sh` gains the
  above-threshold form (override + fixture transcript), the unchanged
  below-threshold form, and re-asserts the one-line contract.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup.
