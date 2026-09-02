# R072-T002: Merge the operator seat into the supervisor

task: R072-T002
type: mnt

Two seats: worker implements, supervisor dispatches, verifies, merges
within declared bounds, and escalates directly to the user. The
operator seat and its relay retire.

- [ ] `companions/declarations.md`: the grant becomes scoped delivery
  plus merge - the supervisor's last act on a green in-class MR/PR is
  the merge, carrying the `supervised` label and the merge comment
  (signature section unchanged otherwise); the `## Operator modes`
  section retires; the always-ask-the-user list replaces the
  always-escalated classes: releases, `CLAUDE.md`/`rules/`/`skills/`
  changes (declaration-line exception kept), customer data or
  disclosure, off-plan work, history rewrites, red gates.
- [ ] `supervise.md`: § Deliver or escalate becomes merge-or-ask -
  within a named class the supervisor merges on the evidence it
  assembled; everything else goes to the user over Remote Control;
  § Boundary verification drops the local test/lint re-run: CI on the
  MR/PR matched to the head sha, plan boxes, diff confinement, and
  the committer signature are the checks.
- [ ] `companions/supervisor-runbook.md`: rewrite the topology to two
  seats - the operator briefs, relays, and merge handovers become the
  supervisor's own steps or direct user asks; Remote Control section
  points the escalation path at the user's device; failure modes
  reviewed for operator-seat entries.
- [ ] Sweep the remaining seat references: `auto.md` halt line,
  `finish.md`, `verification-policy.md`, `templates.md` - the word
  operator resolves to the user or the supervisor, whichever holds
  the act.

> Mark and commit the task `[x]` in the R's `tasks.md`, plus any
> release-plan entry.
>
> Complete the branch: re-review docs across all commits, cleanup
> (stale/temp data), mark plan complete, commit.
