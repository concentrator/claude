---
approved: yes
kind: feat
---

# R078: Hand-off continuity

## Motivation

R074 enforces that the hand-off block exists before compaction; nothing
enforces that it is read after. The resumed session gets only a
`session-state:` path in the branch-state line and may continue from
the built-in summary alone - observed in this repo's own sessions. And
the block's five one-line keys carry pointers and rulings but drop
mid-task facts: hypotheses in play, observations, an explanation the
user gave and the session agreed to - the loss shows up as
post-compaction outcomes contradicting mid-session agreements.

## Goals

- **Notes in the hand-off**: `handoff.md § Writing the note` gains a
  `notes` key - short, precise, factual lines (facts, decisions,
  observations, explanations) that no durable artifact owns, expected
  whenever the note is written mid-task; `none` when empty. The
  hand-off nudge's reason names it so a mid-pass compaction prompts
  for the facts, not just the pointers.
- **Re-brief injection**: a `SessionStart` hook prints the session
  file's last `## hand-off` block on post-compaction and resume
  starts, so the re-brief enters the new context directly instead of
  riding a pointer the model may skip. No file, no block, or any read
  failure: silent exit 0 (fail open).
- **Shipped**: the installer copies and registers the new hook in both
  scopes, like the Stop nudge.

## Non-goals

- No change to the built-in compaction summary - it is internal and
  unhookable; this mechanism runs beside it.
- No multi-line prose hand-offs: notes are additional one-line facts,
  not a narrative - a long hand-off re-creates an unreliable summary
  by hand.
- The `branch-state:` pointer line stays as-is.
- The tree block is untouched - its commits list stays: it pins what
  the repo looked like at the compaction moment, which live git
  history cannot.

## User experience

- Mid-task compaction: the nudge asks for the hand-off including
  notes; the next session starts with the block already in context
  and continues without contradicting what was agreed.
- Fresh session (no prior file): nothing injected, nothing printed.

## Acceptance criteria

- [ ] A post-compaction or resume start with a session file injects
  its last `## hand-off` block; a fresh start, a missing file, or a
  file without the block stays silent, exit 0 (hook self-test).
- [ ] The installer registers the hook on `SessionStart` in project
  and global scope, idempotently (install self-test).
- [ ] `handoff.md` documents the `notes` key and the nudge reason
  names it (nudge self-test asserts the reason).
- [ ] Tier-1 gate green (`bash scripts/ci/run-all.sh`, script tests
  included).

## Constraints

- The injected text is the block verbatim, prefixed with one line
  naming its source file - no summarizing, no reformatting.
- `SessionStart` matcher values (compact, resume) and the injection
  contract (stdout added to context) are verified against the hooks
  documentation at branch-plan time; the exact matcher set is
  branch-plan detail.
- Hook style follows the R074 pair: jq-based input parse, every
  failure path silent exit 0.

## Open questions

None.

## References

- R074 (archived) - the write-side enforcement this completes.
- `hooks/dev-precompact-state.sh`, `hooks/dev-handoff-nudge.sh` - the
  mechanism being extended.
- `skills/dev/handoff.md` - the note format the `notes` key joins.
