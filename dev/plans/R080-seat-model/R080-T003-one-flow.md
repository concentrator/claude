---
task: R080-T003
type: mnt
architecture-changing: true
depends-on: R080-T002
supervised: approved
---

# R080-T003: one runner

Branch: `mnt/one-flow`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 1 and 4,
`§ Invariants`.

`/dev code`, `/dev auto` and `/dev supervise` become one runner,
`/dev run <scope>`: planned work as dispatched seats under a supervisor
seat the project declares as human or AI; the session never implements
itself. `/dev docs` retires with them. Every seat is an agent started
for one item and shut down at its exit, reading a fixed input set. The
stamp pair retires: readiness is the cold read T002 placed at the
planner's exit.

- [ ] `companions/declarations.md § Supervisor bounds`: the
  `## Supervision` block declares `Supervisor: human | AI` beside the
  bounds line. Human: the user's own interactive session holds the
  supervisor seat - it dispatches the seats, and the user answers,
  clears and merges. AI: a supervising session dispatches and merges
  within bounds, and the user gets the always-ask list only, which
  reaches the user under either. `rules/claude-md.md § Agent toolchain
  declaration` names the new line; this repository's `CLAUDE.md
  § Supervision` declares `Supervisor: AI`.
- [ ] `run.md` replaces `auto.md`, `supervise.md`, `docs.md` and the
  `/dev code` section of `SKILL.md`: resolve (scope - a task, a batch
  or an initiative - bounds, ledger), pre-flight, dispatch per item,
  question resolution, close, boundary verification, merge or ask,
  checkpoint - one sequence, with the answer, clear and merge steps
  marked as the user's own under `Supervisor: human`. `feat.md`,
  `fix.md` and `refactor.md` become the implementer's per-item loop
  the dispatch selects by tag; `finish.md` is the close step `run.md`
  invokes and the report of a task-scoped run, with `/dev ship` kept
  for a landed branch; under `Supervisor: AI` the merge-or-ask step
  of `run.md` replaces the ship question of `finish.md § 2-3`, which
  stays the human-mode surface. `SKILL.md § Surface` lists `/dev run
  <scope>` in place of the four rows. Every file the acceptance grep
  (`CLAUDE.md`, `rules/`, `skills/`, `scripts/`, `README.md`,
  `DESIGN.md`) finds citing a retired runner or stamp cites `run.md`
  instead - `plan.md`, `handoff.md`, `git-workflow.md`,
  `companions/toolchain.md`, `companions/report-template.md`,
  `companions/docs-adoption.md`, `companions/verification-policy.md`,
  `companions/gitignore.template`, `scripts/install-dev.sh`,
  `scripts/worker-workspace.sh` among them.
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
  fixed inputs and a one-item lifetime; `§ Decisions` gains a bullet
  on why the stamps went, no ADR file.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
