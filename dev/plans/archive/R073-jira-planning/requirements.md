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
3. **Fewer, larger branches.** One ticket, one branch, typically
   10-30 commits; commits need not be atomic. The MR is the review
   and delivery unit, cutting per-branch routine to one cycle.
4. **Skill rewrite.** `/dev plan` writes epics and tickets in Jira;
   `/dev code <ticket>` and the supervisor's dispatch start from a
   ticket id; `finish` closes the ticket and comments the MR link.
   Commit and MR text cite the ticket key as the durable id.
5. **Teardown.** `dev/plans/` (archive included) is deleted - git
   history preserves it, and with the docs already at `docs/` (R080)
   `dev/` disappears from tracking; supervisor ledgers and session
   state stay gitignored local files. ROADMAP, task indexes,
   branch-plan and findings templates, the archival gate,
   `check-plan-integrity`, `check-batch-tags`, and the accretion stamp
   exemptions retire. Durable facts land in docs at the branch that
   learns them - there is no findings file to promote from. R071
   (install-shipped archival gate) is dropped as moot.

## Invariants

- User gates keep their force in tracker form: an epic is approved by
  the user before its tickets run; MR merge remains the delivery gate.
- Code and docs CI gates (tests, lint, em dash, docs scope, caps) are
  untouched.
- The R068 docs framework keeps its contract; this R removes its
  plan-file competitor, not its rules.
- The seat model (R080) is the execution model this R re-points at
  tickets; the seats, their inputs, merge authority, and the always-ask
  list are R080's and R072-T002's and are not re-decided here.

## Scope

`skills/dev/` (all planning-facing files: `dev.md` surface, `plan.md`,
`brainstorm.md`, `write-plan.md`, `branch-plan.md`, `finish.md`, the
unattended flow and its runbook, `templates.md`, `handoff.md`,
`migrate.md`, `start.md`); the seat prompts where they name the plan
item they inject; `scripts/ci/` plan checks and their tests;
`dev/plans/` corpus (migrate open, delete all); Jira integration
surface (project, issue types, agent credentials, read/write skill);
consuming projects after their in-flight initiatives close.

## Acceptance criteria

- [ ] No tracked file exists under `dev/`, and no rule or skill
      references repo plan files or `dev/` paths. Verified by
      `git ls-files dev` empty and grep across `skills/dev/` and
      `scripts/ci/`.
- [ ] `/dev plan` produces Jira epics/tickets; `/dev code` and the
      supervised dispatch start from a ticket id and inject its plan;
      verified by one pilot task executed end to end with its report
      landing as a ticket comment and no planning write in its diff.
- [ ] Every open initiative and task existing at migration is
      reachable in Jira with its content; verified by a migration
      manifest comment on each epic naming its source R id.
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
- R080 (work by seats) lands first; T003 swaps the plan item every
  dispatch injects for a ticket and re-decides no seat.

## Open questions

- Jira project key(s) and issue-type scheme (Epic/Task/Sub-task
  availability per project).
- Credential path for the VM worker/supervisor (API token scope,
  storage).

## References

- R080 (the seats this R re-points at tickets), R072 (execution cuts
  those seats build on), R068 (docs framework), R070 (archival gate
  this R retires).
