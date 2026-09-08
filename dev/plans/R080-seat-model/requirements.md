---
approved: yes
kind: mnt
---

# R080: Work by seats

## Current state

Planned work runs through one context that does everything. The costs,
observed across this repo's runs and fp-remedy's:

- **Three runners for one job.** `/dev code`, `/dev auto` and
  `/dev supervise` all run planned work and differ in who implements
  and who answers the worker: the session itself, a subagent nobody
  answers under a stamp vouching that no question will arise, or a
  subagent a supervising session answers. Each carries its own
  pre-flight, halt path and close; two of them are rarely used, and
  `/dev docs` beside them has no planned task to run.
- **The cold read is a stamp step.** The check that tests a plan on a
  fresh reader lives in `branch-plan.md § Stamps`, so it retires with
  the stamps unless re-homed.
- **The implementer writes the docs.** The documentation contract
  rests on a context already full of implementation, and the writer
  reaches for the plan files beside the docs as sources.
- **Two docs homes.** `dev/docs/` sits under the planning tree, so a
  reader of one is a reader of the other, and every rule that names the
  docs path names `dev/`.

## Desired state

One supervisor dispatches specialised seats, each an agent with a fixed
input set, started for one item and shut down at its exit.

1. **One runner, dispatched seats.** `/dev run <scope>` replaces
   `/dev code`, `/dev auto` and `/dev supervise`: planned work - a
   task, a batch or an initiative - runs as dispatched seats (fresh
   implementer per item, reviewer, doc writer, planner re-read on a
   gap) under a supervisor that answers implementation-level
   questions, verifies the boundary, and merges within bounds
   (R072-T002). The session never implements itself. The project
   declares who holds the supervisor seat, `Supervisor: human | AI`,
   and the always-ask list reaches the user under either. `/dev docs`
   retires: doc work runs inside every branch through the doc-writer
   seat. The stamp pair has no successor: readiness is a property of
   the plan, not of the mode running it. A seat is an agent started
   for one item and shut down at its exit; the next seat starts fresh,
   and only the branch and the plan item carry over.
2. **Planning exits through a cold read, and only through it.** A
   task's plan is ready for dispatch when a fresh agent, given exactly
   the worker's inputs, says what it would build and finds nothing
   ambiguous; a question the inputs cannot answer is a plan gap fixed
   before the plan is approved. The read is mandatory: no plan is
   offered for approval, stamped, or dispatched without a passed read,
   and the plan records that it passed. A plan without one is
   unsettled, and an unsettled plan is what makes a worker halt
   mid-branch. The check moves from the stamps to the planner's exit.
3. **Docs come from a doc-writer seat.** After the worker's code lands
   on the branch, the supervisor dispatches a doc writer with the
   diff, the plan item, and the existing docs, and none of the
   implementer's context, to write `docs/` on the same branch; the
   documentation contract's verification gate is its exit. The
   implementer's dispatch names no doc target.
4. **Each seat reads a fixed input set, and nothing more.** The
   planner: the initiative's requirements, the task line, the docs,
   the code, and the initiative's other plans. The implementer: the
   task's plan, the docs, and the code. The reviewer: the same plan
   plus the task's requirements, which are the acceptance criteria the
   initiative holds for it, and the diff; its list lives in
   `companions/spec-reviewer-prompt.md`. The doc writer:
   the diff, the plan item, and the existing docs. The plan item may
   carry decisions and explanations for the doc writer's benefit, but
   the docs never cite it: the doc writer states the fact as the docs'
   own.
5. **Docs are the repo's knowledge, at `docs/`.** One documentation
   directory per project, top-level, internal and external audiences
   under the same contract; `dev/docs/` moves there, and every rule
   that names the old path follows. The R068 contract is unchanged:
   docs reflect current state, carry no history or task sequence, and
   link only external URLs or sibling docs. Durable facts land in docs
   directly at the branch that learns them.
6. **One responsibilities table per supervisor mode.** For each seat -
   user, supervisor, planner, implementer, reviewer, doc writer - and
   each mode, `Supervisor: human` and `Supervisor: AI`, one table says
   who writes and updates a plan, who dispatches, who answers a seat's
   question, who clears a permission prompt, who verifies the
   boundary, who merges, and who is asked. Every rule that assigns a
   seat a duty cites the table; a duty the table does not assign is
   nobody's, and a run that reaches one halts rather than improvising.
7. **Plans come from a planner seat.** The planner writes and updates
   branch plans and nothing else: dispatched at the detail round once
   per task, and re-dispatched when a worker's blocker or a cold-read
   gap needs a plan changed, with the worker paused until the read
   passes again. No other seat edits plan content; the implementer
   marks checkboxes and the reviewer reads. The user approves what the
   planner wrote, under either supervisor mode.
8. **Permissions are declared, validated and applied before the run.**
   Each seat has a declared permission set: its tool set and the allow
   rules its commands need, derived from the toolchain declaration and
   the seat's prompt; the run has one permission mode, the runner's.
   Pre-flight resolves the whole set against the tracked tiers,
   applies every adjustment to the project's local settings before
   the first dispatch, and reports
   every gap in one message; anything it cannot apply stops the run
   before it starts. The run raises no prompt the declared set did not
   predict and tells no seat it is at the keyboard: a prompt that
   appears is a pre-flight defect, fixed in the declared set, never
   cleared by hand and moved past.

## Invariants

- A seat's context is its dispatch: no seat reads another seat's
  transcript, planning conversation, or working files.
- Host gates and deny rules stay the hard floor: the permission set
  widens allow rules within a tracked tier, never a deny, and never
  `bypassPermissions`.
- Two-seat supervision (R072) is the execution model this R folds the
  modes into; the worker/supervisor seam, merge authority, and
  always-ask list are R072-T002's and are not re-decided here.
- The R068 docs framework keeps its contract; this R moves its home
  to `docs/`, not its rules.
- The plan item a dispatch injects is whatever the planning home holds:
  a branch plan today, a ticket once R073 lands. Nothing here binds a
  seat to either.

## Scope

`skills/dev/auto.md`, `supervise.md`, `docs.md`, the `/dev code`
section of `SKILL.md`, `feat.md`, `fix.md`, `refactor.md`, `finish.md`,
`branch-plan.md § Stamps` and `§ Commit cadence`, `layout.md § Docs`;
the seat model (`companions/declarations.md` supervision declaration,
`companions/supervisor-runbook.md § Modes`,
`companions/verification-policy.md § Comprehension check`,
`companions/implementer-prompt.md`, a planner prompt, a doc-writer
prompt, a reviewer input list, `DESIGN.md`); the permission surface
(`companions/auto-permissions.template.json`,
`companions/toolchain.md § Permission carve-out`, a pre-flight script
under `scripts/` with its test); the `dev/docs/` to `docs/` move with
every rule that names the old path (`companions/documentation.md`,
project overlays); consuming projects after their in-flight
initiatives close.

## Acceptance criteria

- [ ] One runner: `/dev run` is the only command that starts planned
      work, `/dev code`, `/dev auto`, `/dev supervise` and `/dev docs`
      appear in no rule, skill, template, or CI check;
      `Supervisor: human | AI` is the only supervision-role
      declaration, and `Operator mode:`, `agentic:`, `supervised:`
      appear nowhere either; verified by grep across `CLAUDE.md`,
      `rules/`, `skills/`, `scripts/ci/`.
- [ ] A plan with no recorded cold read is refused by `/dev code` and
      by the unattended flow's resolve step; verified by a dry run on
      a plan lacking the record.
- [ ] The pilot's plan passed a cold read before it was approved and
      its docs were written by a doc-writer dispatch; verified by the
      cold-read result and the doc-writer report in the supervisor's
      ledger, and by the implementer dispatch text naming no doc
      target.
- [ ] Each seat's dispatch text lists its inputs and nothing outside
      them; verified by reading the four prompts against § Desired
      state 4.
- [ ] Every branch plan written or changed after this R lands came
      from a planner dispatch; verified by the pilot's ledger holding a
      planner entry for its plan and for any mid-branch change.
- [ ] Docs live at `docs/` and no rule, skill, or overlay names
      `dev/docs/` as the docs home; the migration names it only as its
      source. Verified by `git ls-files dev/docs` empty and grep across
      `rules/`, `skills/`, `CLAUDE.md`.
- [ ] Each seat's duties under each supervisor mode are in one table
      and every duty statement elsewhere cites it; verified by reading
      the table against § Desired state 6 and grepping the seat names
      across `skills/dev/` for an uncited duty.
- [ ] The pilot's pre-flight applied every permission adjustment
      before the first dispatch and the run raised no prompt outside
      the declared set; verified by the pre-flight report and a pilot
      ledger with no prompt-cleared entry.

## Constraints

- R072-T002 (the operator seat merges into the supervisor) lands
  first; the mode merge rewrites its result and re-decides none of its
  bounds.
- In-flight initiatives (R019 remainder, fp-remedy R011/R003) finish
  under current rules; their projects adopt the seats at their next
  planning round.

## Open questions

None.

## References

- R072 (two-seat supervision the mode merge builds on), R068 (docs
  framework whose home moves), R073 (planning moves to Jira; swaps the
  plan item every dispatch injects for a ticket and depends on this R).
