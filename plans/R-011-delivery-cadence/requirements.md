---
approved: 2026-06-19
kind: feat
---

# R-011: Delivery cadence — coherent units, not atomic MRs

## Motivation

Branches/MRs are being created and merged per atomic edit — the
wallarm-api-js TBD migration delivered three one-change MRs (source-spec
move, toolchain note, MAINTENANCE seed) that were really one coherent
unit. The rules imply coherence ("coherent delivery", "batch = unit of
delivery", "small batches") but state no delivery *cadence*, so the agent
delivers reflexively — noisy, over-atomic history and premature merges.

## Goals

- One branch = one coherent unit of work (topic/session), never one
  atomic edit; no MR-per-change.
- VIBE cadence: apply changes, then wait — no reflexive branch→MR→merge;
  deliver at a work boundary, confirming the merge first.
- Topic-switch detection: an edit unrelated to the current branch's topic
  → the agent flags it and asks whether to deliver the current branch
  first (merge stays the user's call).
- DEV inherits the coherent-unit principle; its task/batch boundaries +
  finishing-a-branch / auto-merge gates govern timing (unchanged).
- `tbd-migration` delivers its structure-reconcile fixes as one MR.

## Non-goals

- Rewriting already-merged history (wallarm `!42`/`!43`/`!44` stand).
- Changing DEV's task/batch delivery gates (it only inherits the principle).
- Loosening short-lived / ≤3-active / merge-within-a-day (cadence sits
  inside those bounds).
- Touching the auto-merge policy (`plan/` PRs) or the ledger.

## User experience

- **VIBE:** request → agent applies the change on a working branch →
  stops (no MR). Related edits accumulate. On a switch signal (or "wrap
  up"), the agent asks "merge the current branch first?" and delivers on
  confirmation.
- **Unrelated edit mid-branch:** agent flags "this is unrelated to
  <current topic> — merge the current branch first, then start fresh?"
- **DEV:** delivery unchanged; the principle reinforces that a branch
  carries its task/batch, not stray edits.

## Acceptance criteria

- [ ] `git-workflow.md` states the coherent-unit rule (one branch = one
      unit, never one atomic edit; no MR-per-change).
- [ ] VIBE cadence documented (apply → wait → deliver at a boundary,
      confirm merge first).
- [ ] Topic-switch behavior documented (unrelated edit → flag + ask to
      deliver current branch first).
- [ ] DEV explicitly inherits the principle without changing its gates.
- [ ] `tbd-migration` companion delivers structure-reconcile as one MR.
- [ ] Cadence stays within short-lived / ≤3-active / merge-within-a-day.

## Constraints

- Global rules stay host-neutral.
- No change to the auto-merge policy or the ledger.
- Skill word caps hold.

## Open questions

- VIBE cadence text home — `CLAUDE.md § Session Workflow` vs
  `git-workflow.md` (lean git-workflow + a CLAUDE pointer if needed)?

## References

- This session: wallarm-api-js `!42`/`!43`/`!44` (atomic-MR grounding).
- `git-workflow.md § Trunk` / coherent delivery; `branch-plan.md
  § Agentic execution` (batch = unit of delivery).
- R-009 (`tbd-migration`, which produced the atomic MRs).
