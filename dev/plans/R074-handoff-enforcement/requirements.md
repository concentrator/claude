---
approved: pending
kind: feat
---

# R074: Session-state hand-off enforcement

## Motivation

The session file (`skills/dev/handoff.md`) carries two halves of the
state a compaction loses: the `tree` block the PreCompact hook writes,
and the `hand-off` block (intent: done/next/open/rulings) only the
session can write. The tree half works; the intent half is never
written: measured 2026-09-07 across the four session files with
compactions (this repository and aikido), 65 `tree` blocks, zero
`hand-off` blocks. Every re-brief therefore recovers intent from the
compaction summary alone - the one source `handoff.md § Reading it
back` says never to trust.

The boundary rules cannot fix this: auto-compaction fires without
warning, and PreCompact is side-effect only - it cannot make the model
write. Verified 2026-09-07 against `code.claude.com/docs/en/hooks-guide.md`
and `context-window.md`: no hook event or input field carries context
fill and no "approaching compaction" notification exists; every hook
receives `transcript_path`; a `Stop` hook returning `ok: false` with a
reason sends the model back for another turn (the harness overrides
after 8 consecutive blocks); `UserPromptSubmit` hook output reaches
the model each prompt. The transcript's per-message `usage` records
are undocumented but observed: `scripts/context-cost.py` computes all
its numbers from them, and its test pins the fields. Auto-compaction
fires about 11% of the window early (observed buffer at a 300k
window), so a warning threshold must sit below that point.

## Goals

- **Fill computation**: a hook-side helper reads the last `usage`
  record from the hook input's `transcript_path` and computes fill
  against the project's `autoCompactWindow`. Threshold: 80% of the
  window, overridable by an environment variable for tests (the
  `DEV_STATE_DIR` pattern). Every read fails open.
- **Prompt-line warning**: above the threshold,
  `hooks/dev-branch-state.sh` extends its one line with the fill and
  the instruction, e.g.
  `context 82% - append the hand-off block to <session-state path>`.
- **Stop-hook nudge**: a new hook on `Stop` returns `ok: false` with a
  one-line reason citing `handoff.md § Writing the note` exactly when
  both hold: fill is at or above the threshold, and the session file's
  last `tree` block is newer than its last `hand-off` block (a file
  with no `hand-off` counts as stale). Writing the hand-off clears the
  condition, so the nudge self-limits without state.
- **Shipped**: `install-dev.sh` registers the Stop hook and carries
  the extended `dev-branch-state.sh` to adopters, idempotently, like
  the hooks they extend.

## Non-goals

- Blocking or influencing compaction itself, or changing what the
  PreCompact tree block records - it stays the floor.
- Hard enforcement: the 8-block Stop override is accepted; the nudge
  is a reminder, not a gate.
- Exact context accounting: the last usage record is an estimate and
  suffices; no attempt to reproduce the harness's own arithmetic.
- Output trimming (`PostToolUse`) - a separate backlog concern.

## User experience

- Interactive session below the threshold: nothing changes.
- Interactive session above it: the `branch-state:` line the user and
  model already see carries the fill and the session-file path.
- Autonomous turn above it with a stale hand-off: the turn end is
  refused once with a reason naming the file and format; the session
  appends the block and stops normally.
- Any parse failure (absent transcript, unknown schema, missing
  `autoCompactWindow`): both hooks behave as below-threshold.

## Acceptance criteria

- [ ] With a synthesized transcript at or above the threshold and a
  session file whose last `tree` block is newer than its last
  `hand-off`, the branch-state line carries the fill warning and the
  session-file path; below the threshold, or with a fresh `hand-off`,
  the line is unchanged and stays one line (hook self-test).
- [ ] The Stop hook returns `ok: false` with a reason citing
  `handoff.md` exactly when fill >= threshold and the hand-off is
  stale, each condition asserted both ways; `ok: true` on a malformed
  or absent transcript, absent `autoCompactWindow`, or outside a git
  repository (fail open), each asserted.
- [ ] The threshold is 80% of the project's `autoCompactWindow` and an
  environment override changes it; the self-test's transcript fixture
  pins the `usage` fields the helper reads, failing loudly when the
  schema drifts.
- [ ] `install-dev.sh --project` registers both hooks idempotently and
  `install-dev.test.sh` asserts the registration and the re-install
  dedupe.
- [ ] Tier-1 gate green (`bash scripts/ci/run-all.sh`, script tests
  included).

## Constraints

- The branch-state line stays a single line
  (`scripts/test/dev-branch-state.test.sh` pins it).
- Hooks print no token values and read the transcript only; the
  fail-open discipline of the existing hooks applies throughout.
- The Stop hook nudges only while the condition holds; no state files
  beyond the session file it already reads.

## Open questions

None.

## References

- R-040 (archived) - owned the session-state work; its PreCompact hook
  and `handoff.md` define the file this initiative enforces.
- `R040-T021-context-burn.findings.md` - the setting check that ruled
  out native mechanisms.
- `scripts/context-cost.py` and its test - the transcript `usage`
  schema in observed use.
