# Supervising Execution

Engine behind `/dev supervise` (R-040): automate the operator role
within declared bounds - dispatch planned work, verify boundaries with
existing gates, merge or escalate. The supervisor never implements,
never edits plans or its own bounds, and never bypasses host gates (no
admin merges).

## Resolve

1. **Projects** - bare inside a repo: that project. Repo-less: every
   entry in `~/.claude/supervisor/portfolio.md` (per project: path,
   VCS host, worker transport - `local`, the default and only built
   transport; `ssh <target>` is R040-T003's scope). The portfolio is
   config only - never write state there.
2. **Bounds** - read each project's `CLAUDE.md § Agent toolchain`
   declaration (`companions/toolchain.md § Supervisor bounds`) and its
   `.claude/supervisor.md` instructions when referenced. No
   declaration → read-only: report and escalate, merge nothing.
3. **Scope** - an explicit `B-XXX` / task id / `R-XXX` argument; bare =
   the project's open batch (`branch-plan.md § Batches`: a member task
   `[ ]` in `tasks.md`, no report), else open tasks with stamped
   plans. Scope selects pre-approved work - anything lacking approved
   requirements or an `agentic: approved` plan is reported NOT READY,
   never dispatched.

## Dispatch

One headless worker session per project, under that project's declared
transport and permissions - the pre-flight is `auto.md`'s. The worker
runs the `/dev auto` engine on the scoped batch (a lone task is a
batch of one). The supervisor passes ids only; workers read plans from
their repo - the supervisor never relays content.

## Monitor

Follow the worker to checkpoint or halt. Collect the checkpoint report
path and MR/PR references - never diffs or transcripts; the
supervisor's context stays report-level so one supervisor spans many
sessions.

## Boundary verification - existing gates only

At a checkpoint, before any merge:

1. `B-XXX.report.md` exists - no report, no accept (`auto.md`).
2. The report verifies each member's acceptance criteria.
3. Project gates are green: declared test/lint plus CI on the MR/PR
   (declared state-check command).
4. A batch closing an R carries the closure and archival marks
   (`plan.md § Approval and closure`, `§ Archival`).

The supervisor adds no quality logic of its own. A judgment the gates
cannot settle is an escalation, not a call.

## Merge or escalate

Within bounds - green `plan/` MR/PRs; green batch/member MR/PRs whose
report verifies the criteria - merge via the declared command and
apply the signature: the `supervised` label plus a merge comment
naming the bound (`companions/toolchain.md § Supervisor bounds`).
Everything else escalates: releases, convention changes, red gates,
off-plan work, gate-unsettleable judgments.

Escalations are existing artifacts read back - halted members, the
reports' queued judgment calls, refused merges - never a parallel
store.

## Sync

On "status": per initiative - merged / in-flight / halted / escalated,
with MR/PR links - derived from artifacts at ask time (task
checkboxes, reports, state-check output). Resolving an escalation
resumes the affected member. The loop ends when scope is delivered or
only escalations remain; report which.
