task: T-029
type: refactor
depends-on: T-028

# refactor/right-sized-delivery — size-scaled close + caps (R-016)

T-029 of `plans/R-016-lean-dev-workflow/requirements.md` (AC3–AC7). Builds
the right-sized-delivery layer on T-028's two-round planning: size-scaled
close review, in-scope findings triage, coupled-task grouping, larger caps
under the short-lived governor. Ships in the same batch, after T-028.

**Sequencing principle.** `branch-plan.md` (the canonical home) is reworded
first, then the `git-workflow.md` cross-reference, then the skills are
repointed to it — so the close policy and caps have one source and
`run-all` stays green at every commit.

**Word-cap watch.** `finishing-a-branch` is at ~297/300 words; it gets a
one-line pointer to `branch-plan.md § Closing routine`, never a duplicate
of the policy — offset by trimming if needed.

- [x] Rewrite `rules/branch-plan.md § Closing routine` step 1: replace the
  unconditional `/simplify` with the size-scaled close-review policy —
  refactor → `/simplify`; single feature/bugfix → `/code-review`;
  mixed-purpose or >9 commits → both; define `≤9 commits = small` and the
  "mixed-purpose" test (more than one task tag on the branch).
- [x] Rewrite `rules/branch-plan.md § Closing routine` step 6 (findings
  triage): resolve findings in-branch by default; promote to a new task /
  R stub only when the finding belongs to a completely different component
  — state that as the explicit test; keep the existing promote/discard
  routes as the secondary path.
- [x] Align `rules/branch-plan.md § Mid-execution rules › Scope
  discoveries` non-blocker text to the in-branch-by-default disposition.
- [x] Rewrite `rules/branch-plan.md § Size cap`: medium branch ~20 commits;
  restate warn-at-15 / split-at-20; subordinate the count to the
  short-lived governor (merge within ~2 days, ≤3 active; no big-bang).
- [x] Update `rules/branch-plan.md § Agentic execution › Batches`: batch
  soft-cap ~25 → ~30; promote coupled-task grouping to the manual-mode
  default for interdependent work (reconcile with the existing line, no
  duplicate).
- [x] Cite the single short-lived / no-big-bang governor in
  `rules/git-workflow.md § Coherent delivery` / `§ Delivery cadence` so the
  `branch-plan.md` caps reference it rather than restating a number.
- [x] Add a one-line pointer in `skills/finishing-a-branch/SKILL.md` to the
  close-review policy in `branch-plan.md § Closing routine` (no
  duplication); keep ≤300 words.
- [ ] Update `skills/writing-plans/SKILL.md § Soft cap` to reference the
  medium-branch ~20 cap + the governor, consistent with `branch-plan.md`;
  keep ≤300 words.
- [ ] Verify `scripts/ci/check-plan-integrity.sh` needs no change (it
  validates only R/T/dir referential integrity; no task-line grammar
  changes here) — confirm via the script; edit only if a grep no longer
  matches.
- [ ] Self-migration audit (AC7): confirm no open plan carries orphaned
  3-round / commit-sized artifacts under the new model (repo-wide, only
  T-028/T-029 are open tasks; other open Rs are requirements-only) and no
  untriaged findings; edit any non-conforming artifact (expected: none).
- [ ] Invariants verification (AC6): confirm the reworded rules preserve
  the approval gate, traceability, `main` releasability, and the CI gate
  (the one-line-per-criterion evidence is recorded at R-016 closure, not
  here).
- [ ] Complete the branch: re-review docs across all commits, cleanup,
  verify skill word caps (`wc -w`), triage the findings file, mark the
  plan complete, commit.
