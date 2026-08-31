---
task: R069-T001
type: doc
---

Branch: `doc/run-hardening-rules`.

Every rule cites its failure in
`R040-T026-two-project-run.findings.md § The run`; each lands once,
the other file cites it (requirements § Invariants).

## Commits

- [x] `supervise.md`: prompt ownership - in-bounds worker prompts are
  the supervisor's to clear, one-time approval only (never a
  persistent rule or mode switch), and every clearing send re-verifies
  the prompt is still pending immediately before sending; the
  operator's intervention window is the runbook's (cite, don't
  restate).
- [x] `supervise.md § Ledger`: an entry's timestamp is read from the
  clock (`date -u`) at write time, never composed or carried forward.
- [x] `supervise.md`: pre-finish context re-brief - a worker
  approaching auto-compact before the finish stage is re-briefed per
  `handoff.md` with the stop boundary restated, so the boundary
  survives compaction.
- [x] Runbook: stall alarm beside the watch recipes - activity
  counters flat past a stated window mean a hold the prompt patterns
  missed; inspect both panes directly instead of waiting.
- [x] Runbook: merge-evidence fallback in the operator's state-check -
  where the MR view omits the pipeline, evidence is a direct
  pipelines-endpoint read with ref and sha matched to the MR head.
- [x] Runbook: channel traps and the operator half of prompt
  ownership - adjudicate a permission dialog on its command line,
  never its label; composer placeholder text is never input; an
  identical previously-allowed command denied by the classifier gets
  one identical retry; a watch command stays frozen verbatim; the
  operator clears a prompt only after the stall window, with the
  same verify-pending guard.
- [x] Runbook: gating pre-flight - host readiness names which verbs
  auto-allow in each seat before the first dispatch.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
