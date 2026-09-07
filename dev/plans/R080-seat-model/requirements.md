---
approved: yes
kind: mnt
---

# R080: Work by seats

## Current state

Planned work runs through one context that does everything. The costs,
observed across this repo's runs and fp-remedy's:

- **Two unattended modes for one job.** `/dev auto` and
  `/dev supervise` both run planned work with no user at the keyboard
  and differ only in who answers the worker: a stamp vouching that no
  question will arise, or a supervising session. Each carries its own
  stamp, pre-flight, and halt path.
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

1. **One unattended flow, three dispatched seats.** `/dev auto` and
   `/dev supervise` merge: the worker engine (fresh implementer per
   item, spec check, review, checkpoint) runs under a supervisor that
   dispatches planner, worker, and doc writer, answers
   implementation-level questions, verifies the boundary, and merges
   within bounds (R072-T002). The project declares who holds the seat,
   `Supervisor: human | AI`, and the always-ask list reaches the user
   under either. The stamp pair has no successor: readiness is a
   property of the plan, not of the mode running it. A seat is an
   agent started for one item and shut down at its exit; the next
   seat starts fresh, and only the branch and the plan item carry over.
2. **Planning exits through a cold read.** A task's plan is ready for
   dispatch when a fresh agent, given exactly the worker's inputs, says
   what it would build and finds nothing ambiguous; a question the
   inputs cannot answer is a plan gap fixed before the plan is
   approved. The check moves from the stamps to the planner's exit.
3. **Docs come from a doc-writer seat.** After the worker's code lands
   on the branch, the supervisor dispatches a doc writer with the
   diff, the plan item, and the existing docs, and none of the
   implementer's context, to write `docs/` on the same branch; the
   documentation contract's verification gate is its exit. The
   implementer's dispatch names no doc target.
4. **Each seat reads a fixed input set, and nothing more.** The
   implementer: the task's plan, the docs, and the code. The reviewer:
   the same plan plus the task's requirements, which are the
   acceptance criteria the initiative holds for it. The doc writer:
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

## Invariants

- A seat's context is its dispatch: no seat reads another seat's
  transcript, planning conversation, or working files.
- Two-seat supervision (R072) is the execution model this R folds the
  modes into; the worker/supervisor seam, merge authority, and
  always-ask list are R072-T002's and are not re-decided here.
- The R068 docs framework keeps its contract; this R moves its home
  to `docs/`, not its rules.
- The plan item a dispatch injects is whatever the planning home holds:
  a branch plan today, a ticket once R073 lands. Nothing here binds a
  seat to either.

## Scope

`skills/dev/auto.md`, `supervise.md`, `branch-plan.md § Stamps` and
`§ Commit cadence`, `layout.md § Docs`; the seat model
(`companions/declarations.md` supervision declaration,
`companions/supervisor-runbook.md § Modes`,
`companions/verification-policy.md § Comprehension check`,
`companions/implementer-prompt.md`, a doc-writer prompt, a reviewer
input list, `DESIGN.md`); the `dev/docs/` to `docs/` move with every
rule that names the old path (`companions/documentation.md`, project
overlays); consuming projects after their in-flight initiatives close.

## Acceptance criteria

- [ ] One unattended flow: `Supervisor: human | AI` is the only
      supervision-role declaration, and `Operator mode:`, `agentic:`,
      `supervised:` appear in no rule, skill, template, or CI check;
      verified by grep across `CLAUDE.md`, `rules/`, `skills/`,
      `scripts/ci/`.
- [ ] The pilot's plan passed a cold read before it was approved and
      its docs were written by a doc-writer dispatch; verified by the
      cold-read result and the doc-writer report in the supervisor's
      ledger, and by the implementer dispatch text naming no doc
      target.
- [ ] Each seat's dispatch text lists its inputs and nothing outside
      them; verified by reading the three prompts against § Desired
      state 4.
- [ ] Docs live at `docs/` and no rule, skill, or overlay names
      `dev/docs/`; verified by `git ls-files dev/docs` empty and grep
      across `rules/`, `skills/`, `CLAUDE.md`.

## Constraints

- R072-T002 (the operator seat merges into the supervisor) lands
  first; the mode merge rewrites its result and re-decides none of its
  bounds.
- In-flight initiatives (R019 remainder, fp-remedy R011/R003) finish
  under current rules; their projects adopt the seats at their next
  planning round.

## Open questions

- Where the reviewer seat's input list lives: the existing review
  checklist or a prompt of its own beside the implementer's.

## References

- R072 (two-seat supervision the mode merge builds on), R068 (docs
  framework whose home moves), R073 (planning moves to Jira; swaps the
  plan item every dispatch injects for a ticket and depends on this R).
