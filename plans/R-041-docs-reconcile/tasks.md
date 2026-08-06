# R-041 tasks - Docs reconcile (this repo)

This initiative's task index. The tag sets the branch prefix; a checkbox
closes only when the task's branch merges. Task ids are composite
(`R041-T###`, counter scoped to this initiative).

## Open

- [x] **R041-T001 [doc]**: archive the stock - create `plans/archive/`,
  move every closed initiative's directory whole and closed tasks'
  artifacts out of the open initiatives (`plan.md § Archival`);
  promote first any fact a living doc still cites. Includes verifying
  `check-plan-integrity` resolves archived paths - extend the check in
  the same branch if the move breaks it.
- [ ] **R041-T002 [doc]**: compaction pass - `ROADMAP.md` (closed
  entries compressed to one-line index items; supersession markers and
  dated suffixes removed) and the open initiatives'
  `requirements.md`/`tasks.md` rewritten to state the present
  (`writing.md § State the present`). `depends-on: R041-T001`
- [ ] **R041-T003 [mnt]**: accretion check in the Tier-1 suite - fail
  on supersession/amendment markers (`SUPERSEDED`, `RETRACTED`,
  `settled`/`corrected` + date, dated amendment headers) in living plan
  artifacts; `archive/` exempt. Exact patterns tuned on the compacted
  corpus. `depends-on: R041-T002`

## Backlog

- `check-plan-integrity` skips composite-id task entries: its task-line
  pattern matches only bare `T-XXX` items, so `R###-T###` entries and
  their branch plans go unvalidated.
