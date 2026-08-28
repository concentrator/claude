---
approved: 2026-06-30
kind: refactor
status: done 2026-06-30
---

# R-016: Lean DEV planning & delivery

## Current state

Planning runs three rounds (R requirements → tasks → branch plan), each
its own command, review, and plan PR - more ceremony than most
initiatives warrant. In delivery, tasks map 1:1 to branches and are
commit-sized, so a typical branch is ~5 commits of which ~3 are
housekeeping (simplify, doc re-review, mandatory final commit); the
close routine + MR overhead often ships more doc churn than code.
Findings are routinely promoted to new tasks as "out of branch scope"
because the scope is too small to absorb them - multiplying tasks and
slowing delivery.

## Desired state

- **Two planning rounds.** `/dev plan R` *shapes* - requirements **and**
  a draft task list in one round, approved together under a single gate.
  Bundling is the default but deferrable: for a large/uncertain
  initiative, approve requirements and defer tasks to `/dev plan R-XXX`.
  `/dev plan R-XXX` *details* - tasks **and** their branch plans. The
  R→T→branch artifacts remain; only the rounds collapse 3→2.
- **Right-sized tasks** - a task is a coherent, multi-commit deliverable,
  not a single edit; commit-sized items live in the branch-plan
  checklist.
- **Close review scaled to branch size:**
  - Refactor (no behavior change) → `/simplify`.
  - Single feature or single bugfix → `/code-review`.
  - Mixed-purpose **or** >9 commits → `/simplify` + `/code-review`.
  - `≤9 commits = small`.
- **Findings absorbed in scope** - resolve within the branch by default;
  promote to a new task / R stub only when the finding belongs to a
  completely different component.
- **Coupled tasks ship together** - grouping interdependent tasks into
  one branch/batch is the manual-mode default, not the exception.
- **Right-sized caps** - medium branch ~20 commits; batch soft-cap ~30.
  Commit count is a proxy subordinate to the short-lived governor: a
  branch/batch must still merge within ~2 days, ≤3 active. No big-bang
  merges.

## Invariants (must NOT change)

- **Single approval gate** - requirements still require explicit approval
  before implementation; bundling keeps one clear checkpoint.
- **Traceability** - every commit→task→R→requirement; the artifacts
  persist.
- **`main` always releasable** - bigger branches stay short-lived (≤ ~2
  days, ≤3 active); large initiatives still use batching / feature flags
  / branch-by-abstraction.
- **CI gate** - Tier-1 mechanical checks + Tier-2 review still gate every
  PR.

## Scope

- `rules/planning.md`, `rules/branch-plan.md` (closing routine, size
  caps, findings triage), `rules/planning-templates.md`.
- `skills/dev` (the `/dev plan` surface + routing), `skills/brainstorming`,
  `skills/writing-plans`, `skills/finishing-a-branch`.
- Possibly `scripts/ci/check-plan-integrity.sh` (if the task/branch-plan
  relationship guidance changes).
- Self-migration of this repo's open plans (re-shape R-015's deferred
  tasks under the new model).

## Acceptance criteria

- [x] Shaping takes two rounds: `/dev plan R` → approved requirements +
  a draft task list (default; deferrable for a large/uncertain R);
  `/dev plan R-XXX` → tasks + branch plans. Approval remains a single
  explicit checkpoint. - `planning.md § Planning rounds` + the `dev`
  `/dev plan` table (T-028).
- [x] `planning.md`/`writing-plans` define a right-sized-task heuristic
  (a multi-commit coherent deliverable) with an example; commit-sized
  items are branch-plan checklist entries, not tasks. - `planning.md
  § Levels` heuristic + example; `writing-plans` decompose step (T-028).
- [x] `branch-plan.md`'s closing routine encodes the close-review policy:
  refactor → `/simplify`; single feature/bugfix → `/code-review`;
  mixed-or->9-commits → both; `≤9 = small`. - `branch-plan.md § Closing
  routine` step 1 (T-029).
- [x] The findings-triage rule resolves in-branch findings by default and
  promotes only cross-component findings; the rule states the test. -
  `branch-plan.md § Closing routine` step 6 + `§ Scope discoveries`
  (T-029).
- [x] Manual mode documents grouping coupled tasks into one branch/batch
  as the default for interdependent work. - `branch-plan.md § Batches`
  (T-029).
- [x] Size caps updated - medium branch ~20, batch soft-cap ~30 -
  subordinate to the ≤2-day / ≤3-active governor; "no big-bang merges"
  preserved. - `branch-plan.md § Size cap`/`§ Batches` + `git-workflow.md
  § Delivery cadence` governor (T-029).
- [x] Invariants (approval gate, traceability, releasability, CI gate)
  demonstrably preserved. - `§ Approval and closure` + CI gate unchanged;
  close-review consistency sweep + full gate green (T-029 verification).
- [x] This repo's open plans migrated to the new model (no orphaned
  3-round artifacts). - audit: only T-028/T-029 were open; nothing
  orphaned (T-029).

## Constraints

- Changes the workflow the repo runs on itself - must self-migrate
  cleanly (precedent: R-003, R-014).
- Must land before R-015 implementation, so the embedded toolchain
  vendors the leaned workflow rather than the current one.
- Stay within trunk-based delivery (`git-workflow.md`).
- R-007 (per-batch complexity dial - auto-mode verification) stays a
  separate initiative; keep it consistent with this manual close policy.

## Open questions

- How "mixed-purpose" is determined for the close-review policy (more
  than one task on the branch, or more than one task tag) - settle in
  branch planning.
- Whether `finishing-a-branch` auto-applies the close-review policy or
  prompts the user - design detail.

## References

- R-003 (flattened 4→3 planning levels), R-011 (delivery cadence),
  R-007 (per-batch complexity dial - overlapping ceremony-scaling).
- Granularity target: tasks as multi-commit, acceptance-criterion-mapped,
  dependency-ordered deliverables - each a self-contained capability/fix,
  not a single edit.
