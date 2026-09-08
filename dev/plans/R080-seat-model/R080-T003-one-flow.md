---
task: R080-T003
type: mnt
architecture-changing: true
depends-on: R072-T002
---

# R080-T003: one unattended flow

Branch: `mnt/one-flow`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 1 and 4,
`§ Invariants`.

`/dev auto` and `/dev supervise` become one flow, `/dev run`: the worker
engine under a supervisor seat the project declares as human or AI.
Every seat is an agent started for one item and shut down at its exit,
reading a fixed input set. The stamp pair retires: readiness is the
cold read T002 placed at the planner's exit.

- [ ] `companions/declarations.md § Supervisor bounds`: the
  `## Supervision` block declares `Supervisor: human | AI` beside the
  bounds line - human is the user at the keyboard answering the
  worker, AI a supervising session; the always-ask list reaches the
  user under either. The last `Operator mode` wording goes;
  `rules/claude-md.md` names the new line.
- [ ] `run.md` replaces `auto.md` and `supervise.md`: resolve (scope,
  bounds, ledger), pre-flight, dispatch per item, question
  resolution, boundary verification, merge or ask, checkpoint - one
  sequence, with the supervisor's steps marked as the user's own under
  `Supervisor: human`. `SKILL.md § Surface` lists `/dev run [scope]`
  in place of the two rows; `plan.md`, `handoff.md`, `finish.md`,
  `git-workflow.md`, `companions/toolchain.md` and
  `companions/report-template.md` cite it where they cited either.
- [ ] `branch-plan.md § Agentic execution`: `§ Stamps` retires and the
  `agentic:`/`supervised:` header lines with it; `§ Session boundary`
  becomes the seat lifecycle - a seat starts for one item and shuts
  down at its exit, only the branch and the plan item carry over;
  `§ Batches` and `§ Rails` read against `run.md`.
  `scripts/ci/check-accretion.sh` drops the stamp exemption and its
  test the cases that pinned it.
- [ ] `companions/implementer-prompt.md`: the input set is the plan
  item, the initiative's requirements, the docs and the code, stated
  as such; `companions/spec-reviewer-prompt.md`: the plan item plus
  its acceptance criteria, and nothing else, stated as such - the
  reviewer's input list lives here, closing the R's open question.
  `companions/supervisor-runbook.md § Modes` heads its table by seat
  and `§ Two variants` names the human supervisor as the one-machine
  case.
- [ ] `DESIGN.md § Planning model` and `§ Git & delivery model`: the
  seat model - one flow, supervisor declared per project, seats with
  fixed inputs and a one-item lifetime; `§ Decisions` records why the
  stamps went.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
