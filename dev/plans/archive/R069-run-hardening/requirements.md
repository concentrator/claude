---
approved: 2026-09-01
status: done 2026-09-01
kind: doc
---

# R069: Supervised-run hardening

Shaped from the R040-T026 two-project run
(`R040-T026-two-project-run.findings.md § The run`): the run
delivered, but every listed failure was absorbed by operator judgment
rather than by a written rule, so the next run re-pays for each
lesson.

## Current state

`supervise.md` and `companions/supervisor-runbook.md` describe the
seats and the channel but not its failure modes. Prompt-clearing has
no declared owner, so operator and supervisor race to answer the same
prompt and only ad-hoc pending-guards prevent a stray keystroke. A
worker hold that raises no permission prompt - a free-form question, a
held dialog - matches no watcher pattern and surfaces only if someone
notices the token counter has gone flat. Ledger entries carried
composed timestamps until an in-run correction. The operator's merge
evidence recipe assumes `glab mr view` reports the pipeline; it
returned `pipeline: null` twice. A worker reaching its context floor
before the finish stage got its ship ruling by direct pane injection
with the boundary restated - a trick, not a rule. Channel traps
observed in the run - permission dialogs mislabeling read-only
commands, composer placeholder text rendering as typed input,
nondeterministic auto-mode classifier denials, digest-based watchers
breaking on any edit to their own command - live only in the run
findings. The supervisor seat's partial gating (some verbs auto-allow,
so some commits land promptless) is recorded nowhere a pre-flight
would surface it.

## Desired state

The two files carry the run's lessons as rules and recipes:

- **Prompt ownership.** In-bounds worker prompts are the supervisor's
  to clear; the operator intervenes only after a stated stall window,
  and every clearing send - either seat - re-verifies the prompt is
  still pending immediately before sending. One-time approval only;
  persistent-rule and mode-switch options are never chosen.
- **Stall detection.** Beside the pane-watch recipe, a flat-activity
  alarm: token or output counters unchanged past a stated window mean
  a hold the patterns missed - inspect the panes directly instead of
  waiting.
- **Ledger timestamps.** A ledger entry's timestamp is read from the
  clock (`date -u`) at write time, never composed or carried forward.
- **Merge evidence.** The operator's state-check names the fallback:
  where the MR view omits the pipeline, evidence is a direct
  pipelines-endpoint read with ref and sha matched to the MR head.
- **Context re-brief.** A worker approaching auto-compact before the
  finish stage is re-briefed (per `handoff.md`) with the stop boundary
  restated, so the boundary survives compaction by rule rather than
  by an operator injection timed to luck.
- **Channel traps.** The runbook names the observed traps and the
  response to each: adjudicate a permission dialog on its command
  line, never its label; composer placeholder text is never input;
  an identical previously-allowed command denied by the classifier
  gets one identical retry; a watch command is frozen verbatim for
  the life of its watch.
- **Gating pre-flight.** Host readiness names which verbs auto-allow
  in each seat, so promptless actions are a known quantity before the
  first dispatch, not a discovery during one.

## Invariants

- Seat boundaries are untouched: ship and merge stay operator-only,
  deny decisions stay operator-only, the supervisor never relays a
  ship as its own approval.
- No new tooling: rules and recipes only, run with existing commands.
- `supervise.md` and the runbook keep their current division - seat
  contract in one, operating recipes in the other; a rule lands once
  and the other file cites it.

## Scope

- `skills/dev/supervise.md`: prompt ownership, ledger timestamps,
  context re-brief.
- `skills/dev/companions/supervisor-runbook.md`: stall detection,
  merge-evidence fallback, channel traps, gating pre-flight, and the
  operator half of prompt ownership.

Out of scope: any change to worker-side skills, settings templates or
scripts; the auto-mode classifier's behavior; the R040 backlog's
PostToolUse trim hook.

## Acceptance criteria

- [x] Each Desired-state item is stated exactly once across the two
  files, with the other file citing rather than restating it
  (grep for the rule's key terms finds one defining home).
- [x] Every rule traces to a named failure in
  `R040-T026-two-project-run.findings.md`; no rule ships for a hazard
  the run did not observe.
- [x] The runbook's recipes stay executable as written: any command a
  rule adds or amends names its target by the project-carrying
  session name.
- [x] Tier-1 gate green; no file exceeds the 300-line skill cap.
