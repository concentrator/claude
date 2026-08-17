---
approved: 2026-08-17
kind: feat
---

# R-050: Context budget

## Motivation

`REQUIREMENTS.md § Goals` names reducing token cost as a standing goal.
R-005 took the verification half of it - how many checks run. This is
the other half: how long a token stays resident once it enters the
context window.

A measurement over the ten most recent sessions established the shape
(shaping-time evidence over that corpus, not a criterion; R050-T001
ships the tool that recomputes it):

- Roughly seven tokens in ten were cache reads, not new material. The
  bill tracks context size multiplied by session length, not the size
  of any single document or tool result.
- The last quarter of a session's tool calls cost about two fifths of
  that session's total, and the ratio held across every long session
  measured.
- Repeated reads of the same file were negligible. Deduplication is
  therefore not the lever; residency is.

Sessions ran to the full million-token window because the harness
compacts near the model's limit, and on a million-token model that
limit arrives long after the cost does.

## Goals

- Bound the working context so a trivial tool step stops re-billing the
  whole window.
- Make the delivery unit the session unit, so context dies with the
  work it served.
- Remove context-resident waste that outlives its usefulness: inline
  heredocs and banner chains, doc reloads inside a unit, subagents that
  run long.
- Make the effect checkable on demand rather than by impression.

## Non-goals

- A custom context manager. `autoCompactWindow` is the enforcement;
  this initiative's own code is advisory and observational.
- Changing verification depth, model routing, or reasoning effort.
  R-005 and `companions/verification-policy.md` own those.
- Shipping the hooks to adopters. `install-dev.sh` is untouched; rule
  text reaches adopters through `skills/dev/` as it already does.

## User experience

The delivery unit and the session boundary coincide, per mode:

| Mode | Delivery unit | Session boundary |
|---|---|---|
| `/dev code` | task, or branch where that is larger | the `finish.md § 3` option executes |
| `/dev auto` | batch | `auto.md § Checkpoint` resolves |
| `/dev supervise`, worker | batch | the same checkpoint |
| `/dev supervise`, supervisor | declared scope | unchanged: the supervisor spans sessions, per `supervise.md § Monitor` |

Auto-compaction fires at the configured window. The governor hook notes
a threshold crossing and never blocks. Opening a new unit inside a
session that still holds the previous one produces a note, not a
refusal.

Compaction is safe against plan state because the plan file on disk is
the record: `branch-plan.md § Body` holds that marks record what
happened, so a compacted session recovers by re-reading the plan.

## Acceptance criteria

- [ ] `settings.json` carries an `autoCompactWindow` value, and the
      measurement tool reports a maximum context below it for a session
      produced after the change.
- [ ] The measurement tool reports per-session billed context with a
      source attribution whose total equals the billed total it
      measured, and its `scripts/test/` case fails on a known-bad
      input.
- [ ] The governor hook emits advisory output at each threshold and
      emits no decision field on any path; its test asserts the
      emission and the absence.
- [ ] Every mode file names its delivery unit and its session boundary,
      and no two contradict each other (single home, R-039). The
      supervisor's spanning behaviour is stated where `supervise.md
      § Monitor` implies it today.
- [ ] `companions/implementer-prompt.md` states a tool-call budget and
      requires an explicit file list, and a stamped plan still clears
      `companions/verification-policy.md § Comprehension check`
      afterwards.
- [ ] `rules/shell.md` exists; the shell hook warns on a composite over
      its budget and stays silent on a legitimate compound command. The
      test proves the check bites by failing it on a known instance
      first (`companions/verification-policy.md § Verification
      modality`).
- [ ] Tier-1 green: `bash scripts/ci/run-all.sh`.

## Constraints

- Advisory only. No hook in this initiative blocks a tool call or the
  agentic loop: a headless `/dev auto` worker must never stall on a
  governor decision with no operator present.
- Hooks stay in `~/.claude`. `install-dev.sh` and the adopter hook set
  are out of scope.
- The hook schema supplies what the design needs: `PostToolBatch`,
  `UserPromptSubmit`, and `PreToolUse` each carry `transcript_path`,
  and `PostToolBatch` carries `agent_id` when it fires inside a
  subagent, which is how the subagent tier is keyed.

## Open questions

- Script language for the measurement tool. `scripts/` is shell today,
  and the work is arithmetic over JSONL usage records. Resolve in the
  detail round.
- Whether the shipped window value holds. Land it, re-measure with the
  tool, and adjust with the number as the evidence.

## References

R-005 (agentic verification cost), R-039 (single-home the /dev system),
R-040 (supervisor bounds), `REQUIREMENTS.md § Open questions`
(measurable success criteria).
