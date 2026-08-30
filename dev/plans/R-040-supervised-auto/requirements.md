---
approved: 2026-08-08
kind: feat
---

# R-040: Supervisor-orchestrated autonomous DEV

## Motivation

Planning happens with the user in project context, detailed enough that
an agent implements a plan without the user present (comprehension
gate; planning-round PoCs, R-042), and `/dev auto` executes batches
unattended until checkpoint or halt. The remaining bottleneck is the
operator role: every checkpoint accept, MR merge, and halt waits for
the user, so autonomous capacity is bounded by user attention rather
than agent capability. A supervisor agent automates that role within
declared bounds - the pattern is a release manager over a merge queue,
with the host gates (protected trunk, required checks) staying the
hard floor.

## Goals

- **Supervisor role**: one repo-less, machine-agnostic agent in its
  own context, supervising a declared portfolio of projects
  (`~/.claude/supervisor/portfolio.md` - per project: path, host;
  config only, never state). It drives one Claude Code worker session
  per project beside itself - both on the operator's machine, or both
  on a worker host the operator reaches over SSH
  (`companions/supervisor-runbook.md § Two variants`). Workers carry
  all repo identity and do all in-repo work; the supervisor
  dispatches, monitors, and collects outcomes - it never implements.
- **Delegated delivery within declared bounds** - default: deliver
  green `plan/` MRs and green batch/member MRs whose checkpoint report
  verifies the acceptance criteria (the approved plan is the decision;
  the supervisor automates its delivery). The merge itself is never the
  supervisor's - it hands the green MR up, and the seat that decides is
  declared per project as an operator mode. Escalate: releases,
  convention changes (`CLAUDE.md`, `rules/`, `skills/`), red gates,
  off-plan work. Bounds are declared per project and readable by the
  supervisor; per-repo overrides allowed. Every merge of supervised
  work carries a host signature - a `supervised` label plus a merge
  comment naming the bound applied and the seat that applied it - in
  host metadata, never in commit or MR/PR prose.
- **Quality acceptance layer**: the supervisor is the worker's first
  responder. A worker halting on an implementation question - a
  NEEDS_CONTEXT, a choice between offered options, a spec ambiguity -
  gets a rational resolution on the plan's and requirements' terms,
  with the best option advised where possible, and execution continues
  without user involvement. A question touching project design or
  architecture is never answered - it escalates. Checkpoint boundary
  checks stay existing gates only - Tier-1 suites, the closure check,
  promote-then-archive, the comprehension check, CI; host gates remain
  the hard floor.
- **Decision authority split**: implementation-level judgments - code
  shape, naming, test details, review-finding triage within the plan's
  stated behavior - are the supervisor's to make without approval, and
  every such decision is recorded in the final report with its
  rationale. Design and architectural decisions - component
  boundaries, schemas, API shapes, `DESIGN.md`-level structure,
  plan-content changes - are never made without confirmation: they
  escalate.
- **Escalation surface**: raised issues queue with actionable context;
  the user syncs periodically and resolves them; unraised work
  proceeds. Status is derived from existing artifacts (batch reports,
  task checkboxes, MR states) - no parallel bookkeeping.

## Non-goals

- A new enforcement layer: host protection + required checks remain
  the only hard gates; the supervisor never bypasses them (no admin
  merges).
- Self-expansion: the supervisor never edits its own bounds or the
  conventions governing it - those changes always escalate.
- Cloud-vendor execution environments - a worker host is an owned
  machine reached over SSH.
- Parallelism within a batch (R-004; compose later).

## User experience

- `/dev supervise [project] [scope]` - bare inside a repo supervises
  that project; started repo-less, every portfolio project. Scope
  selects pre-approved work (`B-XXX`, a task id, `R-XXX`; bare = the
  open batch, else stamped open tasks) and never authorizes work. The
  loop runs until scope is delivered or only escalations remain.
- Per-project surfaces: merge authority lives only in the project's
  `CLAUDE.md § Supervision` bounds declaration; operating
  instructions (project quirks, escalation additions) live in an
  optional `.claude/supervisor.md` referenced from it.
- A user sync is a conversation: "status" yields per-initiative state
  (merged / in-flight / halted / escalated, with MR links) read from
  artifacts; resolving an escalation resumes the affected work.

## Acceptance criteria

- [ ] A per-project capability-bounds declaration exists; the
      supervisor refuses any action outside it and escalates instead.
- [ ] The supervisor runs a full batch lifecycle unattended on a
      worker session: dispatch, monitor, checkpoint verification
      (report + criteria + gates), delivery of a green MR - in either
      runbook variant.
- [ ] Escalations queue with context sufficient to resolve without
      reading raw transcripts; a sync empties the queue.
- [ ] A worker's implementation question is resolved by the
      supervisor and the run continues; every resolution appears in
      the final report; a design-touching question escalates
      unanswered.
- [ ] Every checkpoint boundary check is an existing gate.
- [ ] A design or architectural decision never lands supervised
      without confirmation.
- [ ] No worker session stalls on a permission prompt: prompts are
      pre-accepted by the declared mode or accepted by the supervisor.
- [ ] Every merge is a normal green-gated MR merge - host protections
      untouched throughout the pilot.
- [ ] The supervisor runs repo-less over the portfolio: adding a
      project is one portfolio entry plus that project's own
      declarations; supervising two projects is one loop, not two
      sessions.
- [ ] Every merge of supervised work is distinguishable on the host
      (label + comment) with commit and MR/PR prose untouched.
- [ ] Pilot, two local stages in the same adopter project
      (attack-checker), the user present only at sync points: first
      its plans/docs migration batch - planned and stamped in that
      repo, delivered supervised; then one real task's batch. Both
      stages exercise question resolution, the decision ledger, and
      the prompt constraint.

## Constraints

- Worker sessions run Claude Code under the project's declared
  permissions (`companions/auto-permissions.template.json` +
  `CLAUDE.md § Agent toolchain`), exactly as `/dev auto` pre-flights -
  in either runbook variant.
- The supervisor's context stays implementation-free (reports and
  states, not diffs by default) so one supervisor spans many sessions;
  a worker's question arrives with the excerpt needed to answer it,
  never the whole diff or transcript.
- Worker sessions never stall on permission prompts: either the
  session starts in a mode with guaranteed prompt acceptance (the
  declared auto-permissions grant covers every tool the plan needs) or
  the supervisor accepts the worker's edit prompts itself; a prompt
  neither pre-accepted nor supervisor-acceptable halts the member and
  escalates.
- Depends on R-042 for plan quality; benefits from R-004, does not
  require it.

## Open questions

- Supervisor continuity across its own context limits (handoff
  protocol).

## References

- `skills/dev/auto.md`, `branch-plan.md § Agentic execution`,
  `finish.md` - the lifecycle being supervised.
- `git-workflow.md § Merge policy` - the policy the bounds extend.
- `companions/verification-policy.md § Comprehension check`.
- R-004 (parallel batches), R-042 (planning-round PoCs).
