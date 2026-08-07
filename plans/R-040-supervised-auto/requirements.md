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

- **Supervisor role**: one repo-less agent on the local machine, in
  its own context, supervising a declared portfolio of projects
  (`~/.claude/supervisor/portfolio.md` - per project: path, host,
  worker SSH target; config only, never state). It drives one worker
  session per project on the remote machine over SSH (headless Claude
  Code); workers carry all repo identity and do all in-repo work; the
  supervisor dispatches, monitors, and collects outcomes - it never
  implements.
- **Delegated delivery within declared bounds** - default: merge green
  `plan/` MRs and green batch/member MRs whose checkpoint report
  verifies the acceptance criteria (the approved plan is the decision;
  the supervisor automates its delivery). Escalate: releases,
  convention changes (`CLAUDE.md`, `rules/`, `skills/`), red gates,
  off-plan work. Bounds are declared per project and readable by the
  supervisor; per-repo overrides allowed. Every supervisor merge
  carries a host signature - a `supervised` label plus a merge comment
  naming the bound applied - in host metadata, never in commit or
  MR/PR prose.
- **Boundary verification by existing gates**: before accepting or
  merging, the supervisor runs what already exists - Tier-1 suites,
  the closure check, promote-then-archive, the comprehension check.
  It reuses gates, never invents its own quality logic.
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
- Cloud-vendor execution environments - SSH to owned machines only.
- Parallelism within a batch (R-004; compose later).

## User experience

- `/dev supervise [project] [scope]` - bare inside a repo supervises
  that project; started repo-less, every portfolio project. Scope
  selects pre-approved work (`B-XXX`, a task id, `R-XXX`; bare = the
  open batch, else stamped open tasks) and never authorizes work. The
  loop runs until scope is delivered or only escalations remain.
- Per-project surfaces: merge authority lives only in the project's
  `CLAUDE.md § Agent toolchain` bounds declaration; operating
  instructions (project quirks, escalation additions) live in an
  optional `.claude/supervisor.md` referenced from it.
- A user sync is a conversation: "status" yields per-initiative state
  (merged / in-flight / halted / escalated, with MR links) read from
  artifacts; resolving an escalation resumes the affected work.

## Acceptance criteria

- [ ] A per-project capability-bounds declaration exists; the
      supervisor refuses any action outside it and escalates instead.
- [ ] The supervisor runs a full batch lifecycle unattended on a
      remote session: dispatch, monitor, checkpoint verification
      (report + criteria + gates), merge within bounds.
- [ ] Escalations queue with context sufficient to resolve without
      reading raw transcripts; a sync empties the queue.
- [ ] Every boundary check is an existing gate; the supervisor adds
      zero quality logic of its own.
- [ ] Every merge is a normal green-gated MR merge - host protections
      untouched throughout the pilot.
- [ ] The supervisor runs repo-less over the portfolio: adding a
      project is one portfolio entry plus that project's own
      declarations; supervising two projects is one loop, not two
      sessions.
- [ ] Every supervisor merge is distinguishable on the host (label +
      comment) with commit and MR/PR prose untouched.
- [ ] Pilot: one real batch in an adopter project delivered end to end
      supervised, the user present only at sync points.

## Constraints

- Remote sessions run headless Claude Code under the project's
  declared permissions (`companions/auto-permissions.template.json` +
  `CLAUDE.md § Agent toolchain`), exactly as `/dev auto` pre-flights.
- The supervisor's context stays implementation-free (reports and
  states, not diffs by default) so one supervisor spans many sessions.
- Depends on R-042 for plan quality; benefits from R-004, does not
  require it.

## Open questions

- Session lifetime: one remote session per batch, or a persistent
  worker per project?
- Supervisor continuity across its own context limits (handoff
  protocol).

## References

- `skills/dev/auto.md`, `branch-plan.md § Agentic execution`,
  `finish.md` - the lifecycle being supervised.
- `git-workflow.md § Merge policy` - the policy the bounds extend.
- `companions/verification-policy.md § Comprehension check`.
- R-004 (parallel batches), R-042 (planning-round PoCs).
