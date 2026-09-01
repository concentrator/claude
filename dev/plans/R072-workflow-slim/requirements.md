---
approved: pending
kind: mnt
---

# R072: Slim the per-task workflow

## Current state

The workflow's per-task process cost outweighs the work it wraps.
Measured this session on a supervised three-task run (ledger-timestamped)
against a manual baseline task:

- The close review is the largest block in both modes: roughly half of
  a supervised task's active time, against a quarter for the
  implementation itself. On a doc-correction task the closing sequence
  (close review, per-claim verification, quality-bar check) ran about
  three times longer than the edits it reviewed and produced every
  escalation of the task.
- The supervised topology runs three seats (worker, supervisor,
  operator). Every escalation crosses two extra hops at 3-6 minutes
  each; the supervisor re-runs the full local gate set the worker just
  ran and the pipeline re-verifies anyway; the operator re-reviews what
  the supervisor already verified before merging.
- Plan approval is stamped twice: an `approved:` frontmatter field plus
  the plan MR itself, and detail rounds add `supervised: approved`
  stamps per branch plan. The stamps duplicate the gate the MR merge
  already is.
- Close review pressure treats a missing test as a finding, producing
  tests that satisfy the rule rather than guard an invariant -
  against `plan.md § Proportionality`.
- Plan-file edits route through plan MRs even for checkbox marks,
  backlog lines, and wording, adding a delivery cycle to bookkeeping.

## Desired state

One task costs its implementation plus a review proportional to its
risk, delivered through at most two seats.

1. **Size-scaled close review.** One `code-reviewer` dispatch whose
   rubric scales with the diff class: doc-only diffs get a claim
   spot-check; code and rules diffs get the full review; a second
   verification agent runs only when the reviewer reports uncertainty
   or the diff crosses a declared threshold (rules files, CI scripts).
   Review dimensions are a checklist inside the one prompt, not
   separate agents - the R-057-T002 reviewer set and the R-025
   checklist initiative are superseded by this rubric.
2. **Two-seat supervision.** The operator seat merges into the
   supervisor: one supervising session dispatches, verifies, merges
   within declared bounds, and escalates directly to the user (Remote
   Control). At handover it verifies only what CI cannot: plan boxes,
   diff confinement, commit signature, pipeline green matched to the
   MR head sha - never a local re-run of gates the worker ran and CI
   re-ran. A short always-ask-the-user list survives the merge:
   rules-file edits, customer data or disclosure, off-plan work,
   history rewrites.
3. **MR merge is plan approval.** The `approved:` and
   `supervised: approved` stamps retire; merging the plan MR is the
   one approval gate. Existing stamps freeze as history.
4. **Proportional tests.** A test is written when it guards an
   invariant or pins a fixed bug; doc, config, and plan tasks ship
   none, and the reviewer may not flag a missing test unless system
   integrity is at risk.
5. **Direct plan-file edits.** Checkbox marks, backlog lines, task
   additions, and wording are direct edits on the working branch.
   Protected and unchanged: merged history, and the requirements of an
   R another branch is currently executing against.

## Invariants

- The worker/supervisor seam stays: the doer never verifies its own
  delivery in supervised mode.
- Tier-1 CI gates and the archival gate are untouched; what changes is
  who re-runs them, not what they check.
- Closure rules (`plan.md § Approval and closure` closing conditions,
  one-delivery archival) keep their meaning with stamps removed:
  `status: done` remains the closure mark.
- Manual mode's user gates (ship, merge) are unchanged.

## Scope

`skills/dev/`: `supervise.md`, `companions/supervisor-runbook.md`,
`companions/declarations.md`, `plan.md`, `branch-plan.md`, `finish.md`,
`brainstorm.md`, `templates.md`, `delegation.md`;
`agents/code-reviewer.md`; `scripts/ci/` stamp handling
(`check-accretion.sh` exemptions, `check-plan-integrity.sh` if it reads
stamps); ROADMAP entries R-025 and R-057.

## Acceptance criteria

- [ ] The closing-routine table routes every diff class to one
      reviewer dispatch; the second-agent condition is stated in
      `agents/code-reviewer.md` and no flow dispatches reviewers by
      dimension. Verified by reading the routing table and agent file.
- [ ] `supervise.md` and the runbook define two seats; no step hands
      over to an operator, re-runs local gates at handover, or merges
      without the always-ask list stated. Verified by grep for the
      operator seat across `skills/dev/`.
- [ ] No template, rule, or CI check requires or reads `approved:` or
      `supervised:` stamps; a new plan file carries neither. Verified
      by grep across `skills/dev/` and `scripts/ci/`.
- [ ] The test rule states the invariant/fixed-bug condition and the
      reviewer prohibition; `code-reviewer.md` carries the matching
      conduct line.
- [ ] `plan.md § Adjusting existing plans` names the direct-edit set
      and the protected set; no rule routes checkbox or backlog edits
      through a plan MR.
- [ ] R-057 and R-025 are closed or tombstoned with one-line notes
      naming this R.

## Constraints

- Rules prose stays within existing size gates (CLAUDE.md 100 lines,
  DESIGN.md word cap).
- Projects consuming these skills (per-project supervisor overlays)
  must keep working: the overlay contract in `declarations.md` changes
  shape only where the operator seat is named.

## Open questions

- Sweep existing `approved:`/`supervised:` frontmatter from open plan
  files, or freeze it in place? (Lean: freeze; the fields become
  inert.)
- Does the merged supervisor also own the `supervised` MR label at
  merge, per this run's practice? (Lean: yes, named in the runbook.)

## References

- R-057 (close-review cap, T001 shipped), R-025 (checklist stub),
  R068 (documentation framework), R069 (supervised-run hardening).
- Timing evidence: this session's supervised R019 run ledger and the
  R070 manual baseline.
