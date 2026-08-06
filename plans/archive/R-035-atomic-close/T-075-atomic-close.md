task: T-075
type: refactor

# refactor/atomic-close - bookkeeping rides the final commit (R-035)

T-075 of `plans/R-035-atomic-close/`. Manual mode's per-task close-out PR
folds into the branch itself: the mandatory final commit carries the task
`[x]` (and, on the R's last task, the closure check, ROADMAP `[x]`, and
release marking), landing atomically with the merge - the semantics auto
mode already has (`branch-plan.md § Batches`). Post-merge shrinks to sync
+ delete; a close-out PR survives only for run-dependent closure criteria.

Acceptance criteria: see `requirements.md` (final commit carries the
marks; post-merge = sync + delete; run-dependent exception; one DRY
semantics with § Batches; `branch-plan.md` net smaller; Tier-1 green).

- [x] `branch-plan.md`: the closing routine's mandatory final commit includes the task `[x]` in the parent `tasks.md` and, when it closes the R's last open task, the closure check + ROADMAP + release marks; § Releases drops "only after merged" for rides-the-branch wording; reference § Batches for the shared semantics. Net fewer words.
- [x] `finish.md`: § 1 verify covers the bookkeeping marks pre-delivery; § 4 shrinks to sync + delete (+ the run-dependent-closure close-out exception); drop the `plan/t<NNN>-close` steps.
- [x] `plan.md § Approval and closure`: closure runs on the last task's branch pre-merge; run-dependent criteria keep the R open and close via a later PR (wording aligned, no per-task close-out reference).
- [x] Scope discovery: `companions/untracked-claude.md` § What changes still described the old § 4 close-out; reworded to working-tree marks at close.
- [x] Close-review fix: one canonical marks rule (step 7) - scope it for auto mode, gate ROADMAP on the check verdict, define the batch close-out PR (`plan/r<NNN>-close`), drop restatements in § Batches / § Releases.
- [x] Close-review fix: `finish.md` § 1/§ 4 and `untracked-claude.md` reference the marks rule instead of re-listing it; untracked marks move post-merge (restores reject-safety).
- [x] Close-review fix: `plan.md` - the check judges `tasks.md` re-read from `main`; racing or run-dependent closures fall back to a follow-up plan PR.
- [x] Complete the branch: re-review docs across all commits, cleanup, mark plan complete, commit.
