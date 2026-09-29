---
task: R084-T004
type: mnt
mode: normal
---

# R084-T004: report discipline

- [ ] A task report entry records what was done, when and what came of
  it (outcome 4): it names its item or close step, a divergence also
  gives its result, and dispatches, statuses, prompts, verdicts, merges
  and their times stay the ledger's alone. Approach: the form and rule
  in `branch-plan.md § Task report`, citing `run.md § Ledger`; then the
  form as `agents/dev-implementer.md § Plan & Task Report` states it.
- [ ] `## Planner` records only what the planner ran, as
  `agents/dev-planner.md` already says: each probe's source, call,
  response, errors hit and fix, trap; each draft's snippet and what its
  run showed. `### Read first` and `Tests: <what to cover>` go. Approach:
  `branch-plan.md § Modes`, then `companions/planner-prompt.md` step 1;
  `git grep -i 'read.first\|what to cover'` finds none outside archive.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan
  complete, mark R084-T004 `[x]` in `tasks.md` plus any release-plan
  entry, `bash scripts/ci/run-all.sh` green, commit with the resolved
  task report. (Batch members: the task mark rides the batch branch.)
