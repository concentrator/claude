---
approved: 2026-06-19
kind: feat
status: done 2026-06-20
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

- [x] `git-workflow.md` states the coherent-unit rule (one branch = one
      unit, never one atomic edit; no MR-per-change).
- [x] VIBE cadence documented (apply → wait → deliver at a boundary,
      confirm merge first).
- [x] Topic-switch behavior documented (unrelated edit → flag + ask to
      deliver current branch first).
- [x] DEV explicitly inherits the principle without changing its gates.
- [x] `tbd-migration` companion delivers structure-reconcile as one MR.
- [x] Cadence stays within short-lived / ≤3-active / merge-within-a-day.

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

## Closure verification (2026-06-20)

One-line evidence per criterion (T-024 merged):

1. `git-workflow.md § Delivery cadence`: one branch = one coherent unit,
   never one atomic edit; no PR-per-change. [T-024]
2. Same section: VIBE apply → wait → deliver at a work boundary, confirm
   merge first. [T-024]
3. Same section: an unrelated edit → flag + ask to deliver the current
   branch first. [T-024]
4. Same section: DEV inherits the principle; task/batch +
   finishing-a-branch / auto-merge gates unchanged. [T-024]
5. `tbd-migration.md § 2 Structure`: moves delivered as one coherent MR
   (not one per file). [T-024]
6. Cadence stated as within short-lived / ≤3-active / merge-within-a-day.
   [T-024]

(`CLAUDE.md § Session Workflow` carries the always-loaded operative
pointer to the full rule.)
