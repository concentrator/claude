task: T-028
type: refactor

# refactor/two-round-plan — two-round planning + right-sized tasks (R-016)

T-028 of `plans/R-016-lean-dev-workflow/requirements.md` (AC1, AC2). One
coherent branch: collapse `/dev plan` from three rounds to two and add
the right-sized-task heuristic. The R→T→branch artifacts persist; only
the planning rounds collapse.

**Sequencing principle.** Rules first (`planning.md`,
`planning-templates.md` describe the target two-round model + heuristic),
then the `/dev plan` surface (`dev`) and the two affected skills
(`brainstorming`, `writing-plans`) are repointed to match — so round
terminology is consistent at every commit and `run-all` stays green.

**Word-cap watch.** `brainstorming` and `writing-plans` sit near the
300-word body cap; their edits must be ~word-neutral (offset additions by
trimming). If the heuristic example won't fit `writing-plans`, keep it in
`planning.md` and reference it. Run `wc -w` before each skill commit.

- [x] Add the right-sized-task heuristic to `rules/planning.md § Levels`
  (Tasks bullet): a task is a coherent multi-commit deliverable, not a
  single edit; commit-sized items belong in the branch-plan checklist —
  with one concrete example.
- [x] State the two-round model in `rules/planning.md`: `/dev plan R`
  shapes (requirements + draft task list, one approval gate, deferrable);
  `/dev plan R-XXX` details (tasks + their branch plans); artifacts
  persist, rounds collapse 3→2.
- [x] Align `rules/planning.md § Adjusting existing plans` and any "next
  planning round" wording to the two-round model.
- [x] Add a deferrable "Draft tasks" subsection to the `kind:` templates
  in `rules/planning-templates.md § Per-initiative`. (Implemented as a
  pointer to the alongside `tasks.md`, not an embedded section — see
  findings.)
- [ ] Update `skills/dev/SKILL.md` `/dev plan` table: `R` → requirements +
  draft task list (one gate, deferrable); `R-XXX` → tasks + branch plans.
  Verify ≤400-word orchestrator cap.
- [ ] Update `skills/brainstorming/SKILL.md`: `/dev plan R` produces
  requirements + a draft task list under one approval gate (deferrable for
  large/uncertain R); keep the single-checkpoint invariant explicit.
  Verify ≤300-word cap.
- [ ] Update `skills/writing-plans/SKILL.md`: `/dev plan R-XXX` produces
  tasks + their branch plans (the details round); fold the
  right-sized-task heuristic into the decomposition step. Verify ≤300-word
  cap.
- [ ] Complete the branch: re-review docs across all commits (round
  terminology aligned; single approval gate stated; AC1/AC2 met), cleanup,
  confirm `bash scripts/ci/run-all.sh` green, triage the findings file,
  mark the plan complete, commit.
