# R-016 tasks

Task index for this initiative. Items:
`T-001 (R-001) [feat|fix|refactor]: description` — format and closure:
`rules/planning.md § Levels`. Cross-R index: `plans/ROADMAP.md`.
Acceptance-criterion numbers (AC#) reference `requirements.md`.

Both tasks restructure the same workflow docs (`planning.md`,
`branch-plan.md`, the `dev` skill) and are coherent only once both land,
so they ship as **one batch**, sequenced T-028 → T-029.

## Open

- [ ] **T-028 (R-016) [refactor]**: Two-round planning + right-sized-task
  heuristic — collapse `/dev plan` from three rounds to two: `/dev plan R`
  *shapes* (requirements **and** a draft task list, deferrable, under one
  approval gate) and `/dev plan R-XXX` *details* (tasks **and** their
  branch plans). Add the right-sized-task heuristic (a task = a
  multi-commit coherent deliverable, not a single edit) with an example;
  commit-sized items are branch-plan checklist entries. Touches
  `skills/dev` (the `/dev plan` surface + routing), `skills/brainstorming`,
  `skills/writing-plans`, `rules/planning.md`, `rules/planning-templates.md`.
  Preserve the single explicit approval checkpoint. (AC1, AC2)
- [ ] **T-029 (R-016) [refactor]**: Right-sized delivery — encode the
  size-scaled close-review policy in `rules/branch-plan.md` (closing
  routine) + `skills/finishing-a-branch`: refactor → `/simplify`; single
  feature/bugfix → `/code-review`; mixed-purpose **or** >9 commits →
  both; `≤9 = small`. Rewrite the findings-triage rule (resolve in-branch
  by default; promote to a new task / R stub only when the finding
  belongs to a completely different component). Document coupled-task
  grouping as the manual-mode default. Update the size caps (medium
  branch ~20, batch soft-cap ~30) subordinate to the short-lived governor
  (merge within ~2 days, ≤3 active; no big-bang merges); adjust
  `scripts/ci/check-plan-integrity.sh` if the task/branch-plan guidance
  changes. Closeout: self-migrate this repo's open plans to the new model
  (no orphaned 3-round artifacts); confirm invariants — approval gate,
  traceability, releasability, CI gate — hold. (AC3, AC4, AC5, AC6, AC7)
  `depends-on: T-028`
