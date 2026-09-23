---
task: R082-T003
type: mnt
depends-on: R082-T001
mode: normal
---

# R082-T003: report one home

- [x] Findings have one home, the task report (outcome 3); a backlog
  line is one line; a new findings file fails the gate. Approach: drop
  "task entry" from `rules/writing-artifacts.md § One home per finding`;
  `plan.md § Referential integrity` states the one-line backlog line;
  `branch-plan.md § Task report` reads legacy findings files as reports
  and says a new one fails `scripts/ci/check-plan-text.sh`.
- [x] `tasks.md` holds its template and nothing else (outcome 7): the
  title, the `Why:` line, `## Open` with its task entries, and one-line
  backlog lines. No preamble, ordering prose or notes; order is list
  order. Approach: `templates.md § Per-initiative tasks.md`, the
  backlog form written as the R082-T001 gate detects it.
- [x] The task report is created with its branch plan, in the same
  commit (outcome 6). Approach: `write-plan.md` steps 3 and 5,
  `agents/dev-planner.md § Your Job` and `companions/planner-prompt.md`
  have the planner write both files; `branch-plan.md § Task report`
  gives the skeleton; `companions/implementer-prompt.md` drops "where
  one exists".
- [ ] A changed branch plan with no `<task-id>-<slug>.report.md` beside
  it fails the gate `plan without task report` (outcome 6). Approach:
  the plan branch of `scripts/ci/check-plan-text.sh` and its self-test;
  this branch's own plan gets its report in the same commit.
- [ ] A branch plan holds only its header and items within the gate's
  line limit; strict-mode read-first docs, probes, drafts and cold-read
  gap fixes go to the report's `## Planner` (outcome 5). Approach:
  `branch-plan.md § Body`, `§ Modes`; `write-plan.md` steps 3, 6;
  `verification-policy.md § Comprehension check`; `planner-prompt.md`;
  `agents/dev-planner.md`, `dev-cold-reader.md`, `dev-implementer.md § Before You Begin`.
- [ ] Plan text is unchanged during a run (outcome 4): an answer to a
  halted item goes to the report's `## Answers`, naming its item; a redo
  or approved close fix is a `## Review` entry the dispatch names. Approach:
  `run.md § Question resolution`, `§ Dispatch per item` 2, `§ Close` 2,
  `§ Seats`; `branch-plan.md § Plan edits`, `§ Rails`; `implementer-prompt.md`;
  `dev-implementer.md § Plan & Task Report`; `supervisor-runbook.md` step 3.
- [ ] Docs (doc writer): `README.md § Installing the toolset elsewhere`
  names `check-plan-text.sh` among the shipped Tier-1 checks.
- [ ] Complete the branch: cleanup, mark plan complete, mark R082-T003
  `[x]` in `tasks.md`, `bash scripts/ci/run-all.sh` green, commit with
  the resolved task report.
