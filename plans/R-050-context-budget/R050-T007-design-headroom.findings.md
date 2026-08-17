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
| Tier-1 mechanics: where the checks run and what blocks | none - `scripts/test/run-all.sh` names its callers but not the gating design | keep |
| Tier-1 check enumeration | `scripts/ci/run-all.sh` registers them, but `MAINTENANCE.md § Doc-sync pairs` names this section as a required target when a check changes | keep - a declared home, not an accident |
| Tier-2 concern set, enumerated there and nowhere else | `MAINTENANCE.md § Tier-2 AI review`; the sentence is itself a single-home declaration | keep |
| `pull_request` trigger never re-judges bootstrap history | the workflow holds the trigger, not the rationale | keep |
| PreToolUse hooks add a pre-emptive guard | none - a third guard layer is architecture | keep |
| The branch guard judges the real target, not the cwd branch (10 words) | `hooks/dev-branch-guard.sh` header states it with the full rule | trim |

## Sections not audited

`§ Components`, `§ Self-hosting layout` and `§ Invariants` are already
pointer-shaped or hold facts with no other home. `§ Tree-map` is an
inventory; its comments were trimmed under the tree-map upkeep carve-out
in R050-T001 and are not revisited here.

## Outcome

Three trims, 102 words replaced by pointers, landing `DESIGN.md` at 925.

## Headroom verification

The estimate is not the acceptance. Drafts of all three pending entries
were applied as a scratch edit and measured together:

- T002's context-budget paragraph in `§ Self-enforcement`
- T003's `dev-context-governor.sh` tree-map line and hook mention
- T006's `dev-shell-budget.sh` tree-map line and hook mention

With all three present `DESIGN.md` measures 992 words and `check-caps`
passes, leaving 8 words of margin. The scratch was reverted; the drafts
are illustrative, and each task writes its own wording.

The branch stops at 925 rather than the 920 the plan named. The five
words are not worth the cut: the candidates left are tree-map comments
that carry information, and the verification above already establishes
what 920 was a proxy for.
