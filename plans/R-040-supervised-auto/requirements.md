---
approved: pending
kind: feat
---

# R-040: Supervisor-orchestrated autonomous DEV

## Motivation

DEV is optimizing for autonomous execution on curated projects: planning
happens with the user in project context, detailed enough - including a
quick PoC during the planning round for complicated tasks - that an agent
implements the plan without the user present, and `/dev auto` is the
execution engine. The missing piece is supervision at scale: today every
checkpoint accept, MR merge, and halt waits on the user, so autonomous
capacity is bounded by user attention rather than agent capability.

## Goals

- **Supervisor role**: an agent on the local machine, in its own
  context, orchestrating execution sessions that run on a remote
  machine.
- **Delegated delivery**: the supervisor reviews and merges MRs within
  declared capability bounds - automating delivery of pre-approved
  decisions, never the decisions themselves.
- **Correctness checks**: at boundaries the supervisor verifies task and
  doc state - closure criteria, promote-then-archive, accretion rules -
  before accepting work.
- **Escalation surface**: the user periodically checks status with the
  supervisor and resolves raised issues; unraised work proceeds.
- **Planning-round PoCs**: a complicated task may get a quick PoC during
  planning so its plan is solo-implementable; lands as `plan.md` /
  `write-plan.md` changes when shaped.
- **Auto-mode first**: dev-system changes are evaluated for agent
  legibility and `/dev auto` compatibility; builds on R-004 (parallel
  batches).

## Non-goals

- Implementation in the current round - this stub captures direction;
  the shape round decides architecture (remote-session transport,
  capability-bound declaration format, status protocol).

## References

`auto.md`, `branch-plan.md § Agentic execution`, R-004.
