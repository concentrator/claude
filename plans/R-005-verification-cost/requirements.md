---
approved: 2026-06-12
kind: refactor
status: done 2026-06-14
---

# R-005: Trim agentic verification cost

## Motivation

`/dev auto` token cost is dominated by the routine, not the model
(Fable raises cost-per-token, not token count). Observed in B-002/B-003:

- Each commit item costs two agents — a fresh implementer (~25–70k) +
  an adversarial spec check (~25–40k). The spec checker re-reads diff,
  source, and reruns tests by design — roughly doubling each commit.
- Each branch close adds a `code-reviewer` pass (~45–60k); each batch
  close a full-diff review (~80–95k).
- B-003: ~800–900k subagent tokens for 12 commits — 2–3 verification
  tokens per implementation token.
- Implementer dispatches carry a fat pasted prompt (plan item + probe
  findings + conventions) because the rails forbid agents reading plan
  files — context duplicated into each dispatch.

Model routing already helps (mechanical work → Sonnet, probes/reviews
→ top tier); the volume is structural.

## Goals

Reduce per-batch token cost without regressing the safety the
verification buys. Candidate levers (highest impact first):

1. Skip the spec check on test-only / mechanical commits; rely on the
   branch-close review to catch drift (~25–35k per such commit).
2. Route models per role: implementers → Opus 4.8 (high effort);
   mechanical commits (per the same deterministic rule as lever 1) →
   Sonnet 4.6; probes → Opus 4.8; judgment-heavy implementers and all
   reviews → Fable 5. Verify per-dispatch effort mechanics (effort may
   be session-level only); encode the table in
   `delegating-to-agents § Models`.
3. For small branches, merge the branch-close review into the batch
   review (the batch reviewer re-covers most of it — visible overlap
   in B-003).
4. Slimmer dispatch prompts: replace the pasted conventions block with
   a pointer to CLAUDE.md sections the agent reads itself (cheaper,
   slightly weaker rails — measure the trade).
5. Context diet for always-loaded rules: extract on-demand sections
   into companion files (e.g. `planning.md § Templates` — only
   `brainstorming`/`writing-plans` consume it), and path-scope the
   planning rules (`planning.md`, `branch-plan.md`,
   `project-layout.md`) so non-planning sessions and dispatches skip
   them. Every dispatch pays a ~28k fixed baseline today (~7.7k of it
   always-loaded rules, B-002/B-003 measured ~24 dispatches/batch);
   prompt caching discounts repeats, so weigh savings at cached rates.
   Measure per-dispatch baseline tokens (`/context`) before/after.

## Non-goals

- Removing adversarial verification wholesale — the distrust is what
  produced 0 merge-reaching spec rejections, 0 halts, real catches.
- Changing what gets verified at the batch checkpoint (the report).

## Invariants

- No regression in merge-reaching defect rate. Establish a baseline
  from B-002/B-003 (0 spec rejections reached merge; findings caught)
  and compare the first batch run under the trimmed routine.
- Each lever is independently toggleable and independently measurable.

## Acceptance criteria

- [x] A "verification depth" policy is defined in `delegating-to-agents`:
      which commit classes get a spec check, which model tier per role,
      when branch-close folds into batch-close.
      — `skills/delegating-to-agents/verification-policy.md` (T-012/T-013).
- [x] Mechanical/test-only commits skip the spec check by a stated,
      checkable rule (not agent judgment).
      — `verification-policy.md §§ Mechanical commits, Spec-check skip`;
      predicate exercised 11× in B-001.
- [x] A batch run under the trimmed routine reports its token cost and
      its defect outcomes against the B-002/B-003 baseline in the batch
      report (new "cost" line).
      — `plans/R-005-verification-cost/batches/B-001.report.md § Cost`.
- [x] No increase in defects reaching the batch MR vs baseline.
      — B-001: 0 spec rejections reached merge (baseline 0).
- [x] Per-dispatch fixed baseline measurably reduced (`/context`
      before/after recorded); planning rules load only in sessions
      that touch planning artifacts.
      — T-015: always-on memory 8.7k → 1.4k; path-scoping verified
      across four fresh-session cases (T-015 findings).

## Constraints

- Overlaps REQ-005's close-phase rework (lever 3 touches the same
  branch-close/batch-close boundary). Sequence after REQ-005 so this
  builds on the settled close phase, or coordinate the edits.
- Per-class spec-check skipping needs a deterministic "mechanical"
  definition — reuse the model-selection heuristic
  (`delegating-to-agents § Model selection`: 1–2 files, complete spec).

## Open questions

- Is "mechanical commit" detectable from the plan item text alone, or
  does it need the implementer's file-count report first?
- Lever 4 (pointer vs pasted conventions): does rail strength actually
  drop measurably, or do agents reliably read the pointer?

## References

- Token analysis from B-002/B-003 (this session).
- `skills/delegating-to-agents/SKILL.md` (per-commit + close phases),
  `implementer-prompt.md` / `spec-reviewer-prompt.md` (dispatch size).
- REQ-005 — overlapping close-phase scope; sequence after.
