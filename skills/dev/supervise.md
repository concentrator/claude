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
   declaration (`companions/declarations.md § Supervisor bounds`) and its
   `.claude/supervisor.md` instructions when referenced. No
   declaration → read-only: report and escalate, merge nothing.
3. **Scope** - an explicit `B-XXX` / task id / `R-XXX` argument; bare =
   the project's open batch (`branch-plan.md § Batches`: a member task
   `[ ]` in `tasks.md`, no report), else open tasks with stamped
   plans. Scope selects pre-approved work - anything lacking approved
   requirements or an `agentic: approved` plan is reported NOT READY,
   never dispatched.

## Dispatch

**Adopt before dispatch.** A worker may already exist - started by the
user or a previous supervisor session. Before launching one, check, in
order: local peer sessions rooted in the project's path; a running
worker process on the scope; the scope's `pre-R<NNN>-B-XXX` tag or
`batch/R<NNN>-B-XXX` branch present with no `B-XXX.report.md`. Any hit
means a worker is (or was) on the batch: adopt it - status ping, then
monitor - or, if it is dead, resume `/dev auto B-XXX` in a new session
over its intact refs. Never run two workers on one project.

One headless worker session per project, under that project's declared
transport and permissions - the pre-flight is `auto.md`'s. The worker
runs the `/dev auto` engine on the scoped batch (a lone task is a
batch of one). The supervisor passes ids only; workers read plans from
their repo - the supervisor never relays content; its ledgered
question answers are the one exception. Workers never stall on
permission prompts: the session starts under guaranteed prompt
acceptance (the declared permissions cover every tool the plan needs)
or the supervisor accepts the worker's edit prompts - edits inside
the worker's repo within the declared permissions only; any other
prompt halts the member and escalates.

## Monitor

Follow the worker to checkpoint or halt. Collect the checkpoint report
path and MR/PR references - never diffs or transcripts; the
supervisor's context stays report-level so one supervisor spans many
sessions.

## Question resolution

Within a declared grant, a worker halting on an implementation
question - a NEEDS_CONTEXT, a choice between offered options, a spec
ambiguity - gets the supervisor's resolution on the plan's and
requirements' terms, the best option advised where possible, and the
member resumes. The question arrives with the excerpt needed to
answer it, never a diff or transcript. The decision split and its
fail-safe are the bounds home's (`companions/declarations.md
§ Supervisor bounds`): a design-touching or unclassifiable question is
never answered - it escalates. The worker carries each received
answer into the report's `## Supervisor decisions` section when the
checkpoint writes it.

## Boundary verification - existing gates only

At a checkpoint, before any merge:

1. `B-XXX.report.md` exists - no report, no accept (`auto.md`).
2. The report verifies each member's acceptance criteria.
3. Project gates are green: declared test/lint plus CI on the MR/PR
   (declared state-check command).
4. A batch closing an R does **not** carry the closure and archival
   marks - they ride a close-out plan MR/PR (`plan/r<NNN>-close`)
   opened after the batch MR/PR merges (`branch-plan.md § Batches`).
   Verify that the batch left them alone and that the close-out is
   queued; a batch stamping `status: done` has closed on an unverified
   criterion, since CI-green criteria are only verifiable on the MR/PR
   the batch itself creates (`plan.md § Approval and closure`,
   `§ Archival`).

Checkpoint boundary checks are existing gates only. The report's
queued judgment calls split by decision level (`companions/
declarations.md § Supervisor bounds`): implementation-level calls are
the supervisor's to resolve, carried into `## Supervisor decisions`
by the worker's checkpoint fixup; design-level calls escalate.

## Merge or escalate

Within bounds - green `plan/` MR/PRs; green batch/member MR/PRs whose
report verifies the criteria - merge via the declared command and
apply the signature: the `supervised` label plus a merge comment
naming the bound (`companions/declarations.md § Supervisor bounds`).
Everything else escalates - the always-escalated classes per
`companions/declarations.md § Supervisor bounds`, and anything the
grant does not name.

Escalations are existing artifacts read back - halted members, the
reports' queued judgment calls, refused merges - never a parallel
store.

## Sync

On "status": per initiative - merged / in-flight / halted / escalated,
with MR/PR links - derived from artifacts at ask time (task
checkboxes, reports, state-check output). Resolving an escalation
resumes the affected member. The loop ends when scope is delivered or
only escalations remain; report which.
