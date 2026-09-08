---
task: R080-T004
type: mnt
depends-on: R080-T003
supervised: approved
---

# R080-T004: doc-writer seat

Branch: `mnt/doc-writer`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 3 and 4.

Docs stop being the implementer's job. After the worker's commits land
on a branch, the flow dispatches a doc writer with the diff, the plan
item and the existing docs, and none of the implementer's context; it
writes every doc the branch ships on the same branch and exits through
the verification gate.

- [ ] `companions/doc-writer-prompt.md`: the dispatch template - inputs
  (branch diff against `main`, the plan item, `docs/` and the project's
  CHANGELOG and README as they stand), the job (every doc the branch
  ships - `docs/` with its index, CHANGELOG, README - brought to the
  shipped code under `companions/documentation.md`, the plan item read
  for decisions and never cited), the exit (dispatch the verification
  gate over every touched doc, fix WRONG and UNPROVEN, commit the docs
  on the branch, report), and the report format with the implementer's
  statuses. The seat is a subagent of the runner, in its checkout.
- [ ] `run.md`: the doc-writer step on every branch, after the
  branch's last implementer commit and before the close review, and
  again after applied review fixes that change behavior; the runner
  dispatches it. `companions/supervisor-runbook.md § Modes` gains the
  seat's row: a dispatched subagent, `acceptEdits` like the
  implementer.
- [ ] `companions/implementer-prompt.md` drops its docs step and the
  docs clause of `## Conventions`; the docs-delta clauses of `fix.md`
  and `refactor.md` go the same way; `write-plan.md` step 3 no longer
  asks a commit item to name the docs it touches;
  `branch-plan.md § Commit cadence` point 2 (docs, CHANGELOG and
  README alike), `§ Doc-before-commit` and `§ Closing routine` 7
  re-point to the seat - the reconcile of 7 is the doc writer's second
  dispatch after applied fixes - and `companions/verification-policy.md
  § Close folding` says folding never skips the doc-writer pass.
- [ ] `layout.md § Docs` and `companions/documentation.md
  § Verification gate` name the doc writer as the author the gate is
  independent of.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
