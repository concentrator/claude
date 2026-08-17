# R050-T007 findings - DESIGN.md single-home audit

Decision evidence for this branch's trims. Each row names the file that
owns the fact, so a trim cites an owner rather than a word count. A fact
with no other home stays however long it is.

`DESIGN.md` measured 998 words at branch start, against its 1000-word cap
(`skills/dev/layout.md`).

## § Git & delivery model

| Sentence | Owner | Verdict |
|---|---|---|
| Trunk mechanics: protected trunk, short-lived branch, CI-gated PR, no long-lived branches (26 words) | `skills/dev/git-workflow.md § Trunk` states all four | pointer - keep the architectural claim, drop the restated mechanics |
| Batch mechanics: batch as unit, lone task is a batch of one, `batch/R<NNN>-B-XXX`, which mode does what (66 words) | `skills/dev/branch-plan.md § Agentic execution` states all of it, near-verbatim | pointer - keep that the batch is the unit and mode is orthogonal, drop the mechanics |
| Standard: Trunk-Based Development / GitHub Flow, tag-on-trunk, feature flags, host enforcement (28 words) | none - naming the standard a design follows is `DESIGN.md`'s own job (`skills/dev/brainstorm.md § Rules`) | keep |

## § Self-enforcement

| Sentence | Owner | Verdict |
|---|---|---|
| Two tiers gate every change; CI built here, hooks ship to adopters | none - the layering is the architecture | keep |
| Tier-1 mechanics: where the checks run and what blocks | none - `scripts/ci/run-all.sh` is the gate but documents its callers, not the gating design | keep |
| Tier-1 check enumeration | `scripts/ci/run-all.sh` registers them, but `MAINTENANCE.md § Doc-sync pairs` names this section as a required target when a check changes | keep - a declared home, not an accident |
| Tier-2 concern set, enumerated there and nowhere else | `MAINTENANCE.md § Tier-2 AI review`; the sentence is itself a single-home declaration | keep |
| `pull_request` trigger never re-judges bootstrap history | the workflow holds the trigger, not the rationale | keep |
| PreToolUse hooks add a pre-emptive guard | none - a third guard layer is architecture | keep |
| The branch guard judges the real target, not the cwd branch (10 words) | `hooks/dev-branch-guard.sh` header states it with the full rule | trim |

## Sections not audited

`§ Components`, `§ Self-hosting layout` and `§ Invariants` are already
pointer-shaped or hold facts with no other home. `§ Tree-map` is an
inventory. Its comments were trimmed once under the tree-map upkeep
carve-out in R050-T001; the close review took two more that restated
their own filename.

## Outcome

Three trims, 102 words replaced by pointers, plus two dead tree-map
comments cut at close review. `DESIGN.md` lands at 920, the target.

## Headroom verification

The estimate is not the acceptance. Drafts of all three pending entries
were applied as a scratch edit and measured together:

- T002's context-budget paragraph in `§ Self-enforcement`
- T003's `dev-context-governor.sh` tree-map line and hook mention
- T006's `dev-shell-budget.sh` tree-map line and hook mention

With all three present `check-caps` passes. The scratch was reverted.

The drafts came to 67 words against the 80 the plan budgets, so this
check alone does not clear the budget: it measures one wording, not the
worst case. The 920 target is what covers the gap, and the branch meets
it, leaving 80 words for T002, T003 and T006 to spend as they see fit.
