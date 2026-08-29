# Supervising Execution

Engine behind `/dev supervise` (R-040): automate the operator role
within declared bounds - dispatch planned work, verify boundaries with
existing gates, deliver or escalate. The supervisor never implements,
never edits plans or its own bounds, and never merges
(`companions/declarations.md § Supervisor bounds`, no grant merges).
Host gates are never bypassed - no admin merges.

**Never run git in a worker's working tree.** Absolute, not a caution:
a caution did not prevent this, and the damage is silent when it
happens. Under the local transport the supervisor and its worker share
one checkout, so any command that moves HEAD, creates a branch, stages,
stashes or checks out there acts on whatever the worker left. Inspect
read-only through explicit refs - `git -C <repo> show <ref>:<path>`,
`git -C <repo> log <ref>` - and nothing else. When the supervisor must
author plan artifacts in an adopter repo, it takes its own worktree or
waits for the worker to report idle, and cuts its plan branch (`plan.md
§ Where plans live in git`) as
`git switch -c <name> origin/main`; the bare `-c` form inherits the
current HEAD, which is how a plan branch acquires a worker's unmerged
commits and carries them to trunk on merge.

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
3. **Scope** - an explicit `R<NNN>-B<NNN>` / task id / `R<NNN>` argument; bare =
   the project's open batch (`branch-plan.md § Batches`: a member task
   `[ ]` in `tasks.md`, no report), else open tasks with stamped
   plans. Scope selects pre-approved work - anything lacking approved
   requirements or an `agentic: approved` plan is reported NOT READY,
   never dispatched.

## Dispatch

**Adopt before dispatch.** A worker may already exist - started by the
user or a previous supervisor session. Before launching one, check, in
order: local peer sessions rooted in the project's path; a running
worker process on the scope; the scope's `pre-R<NNN>-B<NNN>` tag or
`batch/R<NNN>-B<NNN>` branch present with no `R<NNN>-B<NNN>.report.md`. Any hit
means a worker is (or was) on the batch: adopt it - status ping, then
monitor - or, if it is dead, resume `/dev auto R<NNN>-B<NNN>` in a new session
over its intact refs. Never run two workers on one project.

One interactive worker session per project, under that project's
declared transport and permissions - the pre-flight is `auto.md`'s.
Headless does not serve: it cannot edit protected `.claude/` paths and
has no way to answer a prompt, so a blocked headless worker is a dead
one. Which mode each role runs in, and how the two reach each other,
is per variant in `companions/supervisor-runbook.md`. The worker runs
the `/dev auto` engine on the scoped batch (a lone task is a batch of
one). The batch bounds the worker session (`branch-plan.md
§ Session boundary`); the supervisor is exempt - report-level context
lets one session span many workers (§ Monitor).

**When the scope is not a batch.** `§ Resolve` admits open tasks with
stamped plans, and a task without a batch manifest is delivered
manually: the worker runs `/dev code <slug>` and closes per
`finish.md`, not the auto engine. Everything else here holds
unchanged - ids only, questions to the supervisor, no merge by the
worker. What differs is the evidence at the checkpoint: there is no
`R<NNN>-B<NNN>.report.md`, so `finish.md § 1`'s verify set stands in its place. Verify that set from
artifacts exactly as a report would be verified; a manual branch
missing it is no more mergeable than a batch missing its report. The supervisor passes ids only; workers read plans from
their repo - the supervisor never relays content; its ledgered
question answers are the one exception, and even those travel as a
path. Anything longer than a line goes to a file on the host outside
the worker's checkout - writing into that tree is how a relayed answer
becomes an accidental commit - and the supervisor sends where it is.
The worker reads it once and re-reads on demand; the channel carries
one path either way, whatever the answer's length. The exception is
about authorship, not about transport. A worker does stall on permission
prompts, and no declaration prevents it: Bash rules match a command
prefix, and a compound command - a loop, a pipeline, a `case` - offers
none to match, so it escalates however wide the allowlist is. Clearing
those prompts - commands inside the worker's repo within the declared
permissions only - is the supervisor's work, which is why the supervisor
runs in a mode that never blocks it
(`companions/supervisor-runbook.md`). Under the `acceptEdits` session
default, edits and in-cwd filesystem commands apply without a prompt,
so edit prompts are not a supervisor control; any other prompt halts
the member and
escalates.

## Monitor

Follow the worker to checkpoint or halt. Collect the checkpoint report
path and MR/PR references - never diffs or transcripts; the
supervisor's context stays report-level so one supervisor spans many
sessions. Hand-off note at each boundary, re-brief after compaction,
for supervisor and worker alike: `handoff.md`.

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

At a checkpoint, before the MR/PR is handed over:

1. `R<NNN>-B<NNN>.report.md` exists - no report, no accept (`auto.md`).
2. The report verifies each member's acceptance criteria.
3. `batch/R<NNN>-B<NNN>` has moved off `pre-R<NNN>-B<NNN>`. One
   `git log -1` on each. Still equal while the member work is
   complete means no member branch ever merged in, so the work
   travelled some other route - and every gate that route skipped is
   unrun. Check it before the gates below, because a green pipeline on
   the wrong branch proves nothing about what reached trunk.
4. Project gates are green: declared test/lint plus CI on the MR/PR
   (declared state-check command).
5. A batch closing an R does **not** carry the closure and archival
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

## Deliver or escalate

The delivery classes live in `companions/declarations.md § Supervisor
bounds` and are deliberately not restated here: a partial copy is how a
supervisor comes to believe a class it holds does not exist. Read the
project's declared bound, then name the class the MR/PR falls into.
Delivering without naming a class and escalating without having read the
declaration are the same error in opposite directions.

The terminal state on a branch is a green MR/PR plus the report that
verifies it (`companions/declarations.md § Supervisor bounds`). Within a named class, hand that MR/PR to
the operator with the evidence cited and nothing else: report path,
gate results, state-check output. The operator decides and applies the
signature (§ Supervision signature there). Everything else escalates -
the always-escalated classes per that same section, and anything the
grant does not name.

Branch protection is not the supervisor's to satisfy by other means: a
red gate escalates rather than being worked around.

Escalations are existing artifacts read back - halted members, the
reports' queued judgment calls, refused deliveries - never a parallel
store.

## Sync

On "status": per initiative - merged / in-flight / halted / escalated,
with MR/PR links - derived from artifacts at ask time (task
checkboxes, reports, state-check output). Resolving an escalation
resumes the affected member. The loop ends when scope is delivered or
only escalations remain; report which.
