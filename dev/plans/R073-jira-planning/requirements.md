---
approved: yes
kind: mnt
---

# R073: Planning moves to Jira

## Current state

The repo carries a full planning layer beside its documentation:
`dev/plans/` with roadmap, per-initiative requirements, task indexes,
branch plans, findings files, and an archive - a second home for data
whose durable part belongs in docs and whose historical part belongs
nowhere the agent reads. The costs, observed across this session's
runs:

- **Worker context pollution.** Before and after every branch the
  worker leaves implementation to do planning bookkeeping: checkbox
  marks, backlog lines, findings files, closure evidence, archival
  moves. Each detour spends context and invites off-plan decisions;
  the planning prose it reads back in later turns is stale by then.
- **Bookkeeping deliveries.** Checkbox and index edits ride MRs;
  closure needs its own gate (`check-archival`); stamps
  (`approved:`, `supervised:`) duplicate the plan MR's own approval.
- **Duplicated homes.** Findings promote into docs at close, so facts
  live twice with a rule (`plan.md § Archival`) needed to reconcile
  them; four CI checks exist only to police plan-file shape.
- **Two unattended modes for one job.** `/dev auto` and
  `/dev supervise` both run planned work with no user at the keyboard
  and differ only in who answers the worker: a stamp vouching that no
  question will arise, or a supervising session. Each carries its own
  stamp, pre-flight, and halt path. The cold read that tests a plan on
  a fresh reader is a stamp step, so it retires with the stamps unless
  re-homed; and the implementer writes the docs, so the docs contract
  rests on a context already full of implementation.

## Desired state

Jira is the single planning home; the repo holds implementation,
operations, and documentation - nothing else.

1. **Mapping.** Epic = initiative (requirements in the epic
   description). Ticket = task, its description the detailed plan;
   one ticket is one branch. A batch is a ticket with attached
   sub-tickets. History, decisions, and evidence live in the tracker;
   reports and findings are ticket comments.
2. **The worker sees one task.** The dispatch injects the ticket's
   plan and the epic's requirements; with the repo's docs and code,
   that is the worker's whole context. It reads Jira read-only, writes
   progress and reports as ticket comments, and never writes a
   planning artifact into the repo. No plan file is tracked in git.
3. **One unattended flow, three dispatched seats.** `/dev auto` and
   `/dev supervise` merge: the worker engine (fresh implementer per
   item, spec check, review, checkpoint) runs under a supervisor that
   dispatches planner, worker, and doc writer, answers
   implementation-level questions, verifies the boundary, and merges
   within bounds (R072-T002). The project declares who holds the seat,
   `Supervisor: human | AI`, and the always-ask list reaches the user
   under either. The stamp pair has no successor: readiness is a
   property of the plan, not of the mode running it.
4. **Planning exits through a cold read.** A ticket's plan is ready
   for dispatch when a fresh agent, given exactly the worker's inputs,
   says what it would build and finds nothing ambiguous; a question
   the inputs cannot answer is a plan gap fixed before the epic is
   approved. The check moves from the stamps to the planner's exit.
5. **Docs come from a doc-writer seat.** After the worker's code lands
   on the branch, the supervisor dispatches a doc writer with the
   diff, the ticket, and the existing docs, and none of the
   implementer's context, to write `docs/` on the same branch; the
   documentation contract's verification gate is its exit. The
   implementer's dispatch names no doc target.
6. **Docs are the repo's knowledge, at `docs/`.** One documentation
   directory per project, top-level, internal and external audiences
   under the same contract; `dev/docs/` moves there and `dev/`
   disappears from tracking (supervisor ledgers and session state stay
   gitignored local files). The R068 contract is unchanged: docs
   reflect current state, carry no history or task sequence, and link
   only external URLs or sibling docs. Durable facts land in docs
   directly at the branch that learns them - there is no findings
   file to promote from.
7. **Fewer, larger branches.** One ticket, one branch, typically
   10-30 commits; commits need not be atomic. The MR is the review
   and delivery unit, cutting per-branch routine to one cycle.
8. **Skill rewrite.** `/dev plan` writes epics and tickets in Jira;
   `/dev code <ticket>` and the supervisor's dispatch start from a
   ticket id; `finish` closes the ticket and comments the MR link.
   Commit and MR text cite the ticket key as the durable id.
9. **Teardown.** `dev/plans/` (archive included) is deleted - git
   history preserves it; ROADMAP, task indexes, branch-plan and
   findings templates, the archival gate, `check-plan-integrity`,
   `check-batch-tags`, and the accretion stamp exemptions retire.
   R071 (install-shipped archival gate) is dropped as moot.

## Invariants

- User gates keep their force in tracker form: an epic is approved by
  the user before its tickets run; MR merge remains the delivery gate.
- Code and docs CI gates (tests, lint, em dash, docs scope, caps) are
  untouched.
- The R068 docs framework keeps its contract; this R moves its home
  to `docs/` and removes its plan-file competitor, not its rules.
- Two-seat supervision (R072) is the execution model this R re-points
  at tickets and folds the modes into; the worker/supervisor seam,
  merge authority, and always-ask list are R072-T002's and are not
  re-decided here.
- A seat's context is its dispatch: no seat reads another seat's
  transcript, planning conversation, or working files.

## Scope

`skills/dev/` (all planning-facing files: `dev.md` surface, `plan.md`,
`brainstorm.md`, `write-plan.md`, `branch-plan.md`, `finish.md`,
`auto.md`, `supervise.md`, runbook, `templates.md`, `handoff.md`,
`migrate.md`, `start.md`); the seat model (`companions/declarations.md`
supervision declaration, `companions/supervisor-runbook.md § Modes`,
`companions/verification-policy.md § Comprehension check`,
`companions/implementer-prompt.md`, a doc-writer prompt, `DESIGN.md`);
`scripts/ci/` plan checks and their tests;
`dev/plans/` corpus (migrate open, delete all); the `dev/docs/` to
`docs/` move with every rule that names the old path (`layout.md
§ Docs`, `companions/documentation.md`, project overlays); Jira
integration surface (project, issue types, agent credentials,
read/write skill); consuming projects after their in-flight
initiatives close.

## Acceptance criteria

- [ ] No tracked file exists under `dev/`, docs live at `docs/`, and
      no rule or skill references repo plan files or `dev/` paths.
      Verified by `git ls-files dev` empty and grep across
      `skills/dev/` and `scripts/ci/`.
- [ ] `/dev plan` produces Jira epics/tickets; `/dev code` and the
      supervised dispatch start from a ticket id and inject its plan;
      verified by one pilot task executed end to end with its report
      landing as a ticket comment and no planning write in its diff.
- [ ] Every open initiative and task existing at migration is
      reachable in Jira with its content; verified by a migration
      manifest comment on each epic naming its source R id.
- [ ] One unattended flow: `Supervisor: human | AI` is the only
      supervision-role declaration, and `Operator mode:`, `agentic:`,
      `supervised:` appear in no rule, skill, template, or CI check;
      verified by grep across `CLAUDE.md`, `rules/`, `skills/`,
      `scripts/ci/`.
- [ ] The pilot's plan passed a cold read before its epic was approved
      and its docs were written by a doc-writer dispatch; verified by
      the cold-read result and the doc-writer report as ticket
      comments, and by the implementer dispatch text naming no doc
      target.
- [ ] `run-all.sh` carries no plan-file check and the suite is green.
- [ ] MR and commit text cite ticket keys; the branch of the pilot
      task maps one to one to its ticket.

## Constraints

- Jira access must work from both seats: this machine and the worker
  host (VM). Agent-usable credentials, never printed.
- Wallarm Jira houses work projects; where the personal `~/.claude`
  planning lands (same instance or a personal project) is settled at
  detail time with the project keys.
- In-flight initiatives (R019 remainder, fp-remedy R002/R011/R003)
  finish under current rules; their projects migrate at their next
  planning round.
- R072-T002 (the operator seat merges into the supervisor) lands
  first; T003 rewrites its result and re-decides none of its bounds.

## Open questions

- Jira project key(s) and issue-type scheme (Epic/Task/Sub-task
  availability per project).
- Credential path for the VM worker/supervisor (API token scope,
  storage).

## References

- R072 (execution cuts this R re-points at tickets; R072-T002 is the
  two-seat result the mode merge builds on), R068 (docs framework),
  R070 (archival gate this R retires).
