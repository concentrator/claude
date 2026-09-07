---
task: R072-T002
type: mnt
---

# R072-T002: merge the operator seat into the supervisor

Branch: `mnt/two-seat`. Requirements:
`dev/plans/R072-workflow-slim/requirements.md`.

Two seats: the worker implements; the supervisor dispatches, verifies,
merges within declared bounds, and escalates directly to the user. The
operator seat and its relay retire.

- [ ] `companions/declarations.md`: the grant is scoped delivery plus
  merge - the supervisor's last act on a green in-class MR/PR is the
  merge, carrying the `supervised` label and the merge comment
  (signature section unchanged otherwise); the `## Operator modes`
  section retires; the always-ask-the-user list replaces the
  always-escalated classes: releases, `CLAUDE.md`/`rules/`/`skills/`
  changes (declaration-line exception kept), customer data or
  disclosure, off-plan work, history rewrites, red gates.
- [ ] `supervise.md`: § Deliver or escalate becomes merge-or-ask -
  within a named class the supervisor merges on the evidence it
  assembled; everything else goes to the user over Remote Control.
  § Boundary verification drops the local test/lint re-run: CI on the
  MR/PR matched to the head sha, plan boxes, diff confinement, and the
  committer signature are the checks (this also clears the pre-tier
  test/lint wording the R's backlog routes here).
- [ ] `companions/supervisor-runbook.md`: the topology is two seats -
  operator briefs, relays, and merge handovers become the supervisor's
  own steps or direct user asks; the Remote Control section points the
  escalation path at the user's device; failure modes reviewed for
  operator-seat entries.
- [ ] Sweep the remaining seat and pre-tier wording sites:
  `handoff.md` roles (the operator seat leaves the table), `auto.md`
  halt line, `git-workflow.md` merge line (the word operator resolves
  to the user or the supervisor, whichever holds the act),
  `CLAUDE.md § Supervision` operator-mode line;
  `git-workflow.md § Delivery cadence` and
  `companions/report-template.md` pre-tier "tests + lint" wording
  matches the tiered verify (R072-T004); the R's `tasks.md` backlog
  line clears.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, R072 closure check per `plan.md § Approval and closure`
  when this closes the R's last open task (criteria verified with
  one-line evidence, ROADMAP `[x]`, archival in the closing delivery),
  cleanup.
