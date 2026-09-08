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
  stays the human-mode surface. A seat is a subagent of the runner
  session, dispatched with the Task tool in the runner's checkout and
  inheriting its permission mode; the runbook's peer-worker material
  - the `tmux` worker, adopt before dispatch, one worker at a time,
  prompt clearing over `tmux` - retires with that model, while the
  runner-in-`tmux` material stays for a runner on a remote host. Close
  folding
  (`companions/verification-policy.md § Close folding`) applies to a
  batch-scoped run; a task-scoped run closes in full. `handoff.md`:
  the runner session writes as `supervisor`, a seat writes none since
  it ends at its item, `solo` stays for a session outside a run.
  `companions/docs-adoption.md` cites `migrate.md § 7` for the
  standalone refresh; in-branch doc work is T004's. `SKILL.md
  § Surface` lists `/dev run <scope>` in place of the four rows.
  Every file the acceptance grep
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
  `§ Batches` and `§ Rails` read against `run.md`; the `SKILL.md
  § /dev plan` `batch` row composes the batch only, the readiness
  review retiring with the stamps since the cold read at the planner's
  exit is its successor. `scripts/ci/check-accretion.sh` drops the
  stamp exemption and its test the cases that pinned it.
- [ ] `companions/implementer-prompt.md`: the input set is the task's
  plan, the docs and the code (`requirements.md § Desired state` 4),
  stated as such - never the initiative's requirements;
  `companions/spec-reviewer-prompt.md`: the plan, the initiative's
  acceptance criteria (`requirements.md § Acceptance criteria`, the
  whole list) and the diff, and nothing else, stated as such - the
  implementer's report is not an input, so the report section and its
  distrust framing go, and the convention check against `CLAUDE.md`
  stays as part of reading the code. The reviewer's input list lives
  here, as `requirements.md § Desired state` 4 records. The cold read
  follows the implementer's inputs: `companions/verification-policy.md
  § Comprehension check` and `write-plan.md` step 6 give the reader the
  plan, the docs and the code in place of the commit-item text and
  parent chain, the planning conversation still withheld.
  `companions/supervisor-runbook.md § Modes` heads its table by seat,
  every dispatched seat's mode reading "inherits the runner's" and the
  tool-set column left to T007; `§ Two variants` re-keys by where the
  runner session lives - A on this machine, B on a remote host under
  `tmux` and Remote Control - independent of the supervisor mode, its
  peer-worker rows gone.
- [ ] `DESIGN.md § Planning model` and `§ Git & delivery model`: the
  seat model - one flow, supervisor declared per project, seats with
  fixed inputs and a one-item lifetime; `§ Decisions` gains a bullet
  on why the stamps went, no ADR file.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
