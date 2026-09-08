---
task: R080-T004
type: mnt
depends-on: R080-T003
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
  (branch diff against trunk, the plan item, `docs/` and the project's
  CHANGELOG and README as they stand), the job (docs to the shipped
  code under `companions/documentation.md`, the plan item read for
  decisions and never cited), the exit (dispatch the verification gate
  over every touched doc, fix WRONG and UNPROVEN, report), and the
  report format.
- [ ] `run.md`: the doc-writer step after the branch's last
  implementer commit and before the close review, on the same branch;
  `companions/supervisor-runbook.md § Modes` gains the seat's row.
- [ ] `companions/implementer-prompt.md` drops its docs step and the
  docs clause of `## Conventions`; `write-plan.md` step 3 no longer
  asks a commit item to name the docs it touches;
  `branch-plan.md § Commit cadence` point 2, `§ Doc-before-commit` and
  `§ Closing routine` 7 re-point to the seat, and
  `companions/verification-policy.md § Close folding` says which
  branches the doc-writer pass still runs on.
- [ ] `layout.md § Docs` and `companions/documentation.md
  § Verification gate` name the doc writer as the author the gate is
  independent of.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
