# R-050 tasks - Context budget

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R050-T###`, counter scoped to this initiative).

## Open

- [x] **R050-T001 [feat]**: context-cost measurement tool plus its
  `scripts/test/` case. Reports per-session billed context and its
  attribution by source from the transcript's usage records. Establishes
  the baseline and makes the criteria below checkable on demand.
- [ ] **R050-T002 [mnt]**: set `autoCompactWindow` in `settings.json`, and
  record the context budget in `DESIGN.md § Self-enforcement` beside the
  two existing tiers. `depends-on: R050-T001, R050-T007`
- [ ] **R050-T003 [feat]**: `hooks/dev-context-governor.sh` - advisory
  threshold notes on `PostToolBatch` for the main loop and for subagents
  (keyed on `agent_id`), and a new-unit note on `UserPromptSubmit`;
  `settings.json` registration and a script test.
  `depends-on: R050-T001`
- [ ] **R050-T004 [doc]**: session boundary and doc-load discipline - the
  delivery unit per mode into `branch-plan.md`, `finish.md`, `auto.md`
  and `supervise.md`; one doc-load phase per unit, sectional reads over
  whole-file reads, and reports and findings read at triage rather than
  during execution.
- [ ] **R050-T005 [doc]**: subagent dispatch budget - a tool-call budget
  and an explicit file list in `companions/implementer-prompt.md`, with a
  cross-reference to the governor's subagent tier.
  `depends-on: R050-T003`
- [ ] **R050-T006 [feat]**: shell-composite budget - an advisory
  `hooks/dev-shell-budget.sh` carrying the convention in its message,
  plus its test and a threshold calibrated against the corpus. Runs
  last; the trim candidate if the initiative runs long.
  `depends-on: R050-T001`
- [ ] **R050-T007 [doc]**: `DESIGN.md` headroom for the initiative -
  the file sits two words under its cap while T002, T003 and T006 each
  need room in it. Trims restatement of facts owned elsewhere (R-039),
  targeting 920 words. Runs first; T002 waits on it.
