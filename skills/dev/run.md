# Running planned work

Engine behind `/dev run <scope>`: planned work - a task, a batch or an
initiative - runs as dispatched seats under the supervisor seat the project
declares (`companions/declarations.md § Supervisor bounds`). The runner session
holds that seat. Under `Supervisor: AI` it dispatches, verifies and merges
within the declared bounds; under `Supervisor: human` the steps marked **user**
below are the user's own (§ Seats). Rules: `branch-plan.md`. Host gates are
never bypassed - no admin merges.

## Seats

A seat is a subagent of the runner, dispatched with the Task tool in
the runner's checkout for one item, inheriting the runner's permission
mode and shut down at its exit; the next seat starts fresh, and only
the branch and the plan item carry over. Seats run one at a time, and
the runner runs git only between dispatches.

| Seat | Dispatched | Definition; dispatch |
| --- | --- | --- |
| Planner | at the detail round, and to fix a strict plan's cold-read gaps once (`write-plan.md` step 6) | `agents/dev-planner.md`; `companions/planner-prompt.md` |
| Cold reader | once over a new strict plan before it is approved (`write-plan.md` step 6) | `agents/dev-cold-reader.md`; `companions/verification-policy.md § Comprehension check` |
| Implementer | per commit item (§ Dispatch per item) | `agents/dev-implementer.md`; `companions/implementer-prompt.md` |
| Doc writer | once per branch whose diff changes user-facing behavior (§ Close 3) | `agents/dev-doc-writer.md`; `companions/doc-writer-prompt.md` |
| Docs verifier | over every doc the writer touched (§ Close 3) | `agents/dev-docs-verifier.md`; `companions/documentation.md § Verification gate` |
| Code reviewer | at branch close and at batch close (§ Close 1, § Batch close 1) | `agents/code-reviewer.md`; the steps at left, no companion |

**Loop bound.** Every review - the close review, the docs gate - runs
one pass and one fix round. What the fix round leaves open goes to the
user; nothing is reviewed a second time.

Under `Supervisor: human` the user's own session is the supervisor, so the user
holds every supervisor cell; under `Supervisor: AI` the runner is, and the user
holds the asked-of row, the plan-edit cell and the merges outside the
declared bounds (the Merging row's "else user"). A run reaching a duty the duty
table below leaves unassigned halts and reports, never improvises.

| Duty | `Supervisor: human` | `Supervisor: AI` |
| --- | --- | --- |
| Writing a plan | planner, at the detail round; plan text is unchanged during a run (§ Question resolution) | the same |
| Dispatching | user | supervisor |
| Taking a different route to an item's outcome | implementer, in the code, reporting the divergence | the same |
| Changing plan text | user approves (`branch-plan.md § Plan edits`) | the same |
| Writing the docs | doc writer | the same |
| Clearing a permission prompt | nobody: a pre-flight defect halts the item; a classifier denial reaches the user as the seat's BLOCKED report (§ Dispatch per item) | the same |
| Verifying the boundary | user | supervisor |
| Merging | user | supervisor within the declared bounds, else user |
| Being asked | user: pre-flight permission proposals, plan edits, the always-ask escalations | the same |

## Resolve

1. **Scope** - an explicit `R<NNN>-B<NNN>`, task id or slug, or `R<NNN>`;
   bare = the project's open batch (`branch-plan.md § Batches`: a member
   task `[ ]` in `tasks.md`, no report), else the next open task whose plan
   is read. An initiative runs its open batch, else its open tasks in
   `tasks.md` order, each a task-scoped run. Scope selects pre-approved work:
   anything lacking approved requirements or a merged plan, or a strict plan
   lacking `cold-read: passed` (`branch-plan.md § Header`), is reported NOT
   READY, never dispatched, the report naming the missing record; a plan whose
   `depends-on` is unmerged the same.
2. **Supervisor** - read `CLAUDE.md § Supervision`: the `Supervisor:`
   line and the bounds, plus `.claude/supervisor.md` where referenced.
   No block, or no `Supervisor:` line → halt, naming it.
3. **Ledger** - open the scope's file (§ Ledger).

## Pre-flight

- Permissions: `<config>/scripts/preflight-permissions.sh --project .
  --supervisor <declared> --runner-mode <the declared mode>`
  (`companions/supervisor-runbook.md § Modes by seat`) reports every rule with
  the tier carrying it; a gap halts the run and prints the `--apply` line for
  the **user** (§ Seats). No toolchain section → halt, ask.
- No plan in scope gives a **seat** a settings-surface target
  (`agents/dev-implementer.md`, its config paragraph); the rest of `.claude/` is
  tracked source a plan may name, and an item naming the **user** as the writer
  is admitted, halting to the user when reached and resuming on their commit.
  Every pre-flight check runs before any action; failures are reported together
  in one message, and the run halts with no branch created and no edit made.
- Default branch, clean tree, fast tier green
  (`companions/declarations.md § Declared commands`).
- Batch scope: tag `pre-R<NNN>-B<NNN>` (e.g. `pre-R062-B001`); create
  `batch/R<NNN>-B<NNN>` off default. Task scope: the task's branch off
  default, prefix from `type:`, no tag.

## Dispatch per item

Per task in scope order - a member already `[x]` in `tasks.md` is
skipped, noted for the checkpoint, never re-implemented; else its
branch per plan - and per commit checkbox:

1. Dispatch a fresh implementer naming the plan file - the item it
   works is the first `[ ]`, or the task report's `## Review` entry the
   dispatch names (2, § Close 2). Its loop is the plan's `type:` mode file
   (`feat.md`, `fix.md`, `refactor.md`); `doc`/`test`/`mnt` run
   `branch-plan.md § Commit cadence` alone.
2. DONE → next item. DONE_WITH_CONCERNS → a concern that changes an item's
   acceptance takes § Question resolution as NEEDS_CONTEXT does: the item's
   `[x]` stands, and the runner writes the redo the user's answer asks for
   as a `## Review` entry of the task report, which the next dispatch
   names. Any
   other concern the runner ledgers (§ Ledger) and carries into the report.
   NEEDS_CONTEXT → § Question resolution. Halt triggers: `branch-plan.md § Stop
   conditions`.
3. The implementer marks `[x]` in its commit (`branch-plan.md § Commit cadence`
   3); the runner confirms the mark landed before the next dispatch. The
   branch's check against its plan is the close review (§ Close 1).

Two prompt classes (`companions/seat-permissions.md § Prompt classes`). A
pre-flight defect - a gap in the mode-independent set - halts the item, cleared
by nobody (§ Seats, the prompt row). A classifier denial under `auto` is the
seat's to handle; where it cannot, its BLOCKED report halts and reports, the
work intact (§ Checkpoint), ledgered a `prompt` event (§ Ledger). Commands match
a declared prefix outside `auto` and are classifier-readable under it.

## Question resolution

A question the plan cannot answer - an implementer's blocker, a concern
whose answer changes what an item delivers, a proposed plan edit
(`branch-plan.md § Plan edits`) - halts the item and goes to the **user** as
the seat's text, under either supervisor mode. The halt reverts the item's
uncommitted edits - `git read-tree --reset -u HEAD` and removal of the
untracked files the seat created - so the branch stands at its last commit.
The runner writes the user's answer to the task report's `## Answers`,
naming the item it answers (`branch-plan.md § Task report`), in a
bookkeeping commit on the item's branch; plan text is unchanged during a
run, an approved plan edit included. A fresh implementer then starts
from that commit. A seat never resumes.

A route question - which files, which order, toward the same outcome -
costs no seat and no approval: the implementer decides it in the code and
reports the divergence. An implementer's inputs are the plan, the docs and
the code (`companions/implementer-prompt.md`), so an answer reaches the next
implementer only through the task report beside the plan. Each answer is
ledgered with the runner's commit (§ Ledger) and carried into the
report's `## Supervisor decisions` section at checkpoint.

## Close

Per branch, when its last non-final item is `[x]`:

1. Close review: `code-reviewer` on the branch diff vs plan. In a batch-scoped
   run a small branch skips it (`companions/verification-policy.md § Close
   folding`); a task-scoped run closes in full (`branch-plan.md § Closing
   routine`).
2. Fixes, one round (§ Seats, loop bound): mechanical ones applied,
   judgment calls queued; approval of the applied set is the **user**'s
   under `Supervisor: human` (§ Seats). The approved fixes are the
   `## Review` entries the runner wrote (`branch-plan.md § Task report`);
   a fresh implementer, dispatched naming them, commits them. The fixes
   are not reviewed again.
3. Docs, only when the diff changes user-facing behavior: dispatch the
   doc writer (§ Seats) on the diff from the commit the branch was cut
   from, the plan and the docs, then the gate's verifier over every doc
   it touched (§ Seats). WRONG or UNPROVEN re-dispatches one fresh doc
   writer with the verdicts; its result goes to the user with them, not
   to a second verification. A BLOCKED halts (`branch-plan.md § Stop
   conditions`). The report rides the dispatch entry and the verdicts a
   verify entry (§ Ledger); folding never skips it (§ Seats).
4. The runner makes the mandatory final commit (cleanup, plan complete,
   task mark per `branch-plan.md § Closing routine`).
5. Fast tier green → batch scope: merge into `batch/R<NNN>-B<NNN>`;
   task scope: `finish.md` from its § 1, then § Checkpoint. Red → halt.

Rails hold throughout (`branch-plan.md § Rails`).

## Batch close

1. Full-diff review vs default (`code-reviewer`, most capable):
   cross-branch interactions, duplicated helpers, convention drift;
   folded small branches get first-review vs their plans.
2. Fixes land as batch-branch commits; queue judgment calls.
3. Run `Test (full)` - the batch's one full local run; red → halt.
4. Mark member-task checkboxes; commit on `batch/R<NNN>-B<NNN>`
   (`branch-plan.md § Batches`).

Models and close folding: `companions/verification-policy.md`.

## Checkpoint

At scope end or halt, write the R's `batches/R<NNN>-B<NNN>.report.md`
per `companions/report-template.md`, re-verifying acceptance criteria.
No report → no accept. A task-scoped run has no report: `finish.md
§ 1`'s verify set stands in its place, and a branch missing it is no
more mergeable than a batch missing its report. Then - the choice the
**user**'s under `Supervisor: human`, the runner's within bounds under
`Supervisor: AI` (§ Seats):

- **Accept** → push the branch to origin + open the CI-gated MR/PR per
  `companions/toolchain.md`, description from the report; then
  § Boundary verification and § Merge or ask. Findings triage; ref
  cleanup per `branch-plan.md § Rails` - after the MR/PR merges,
  post-merge cleanup deletes the batch branch, local and origin.
- **Reject** → ref handling per `branch-plan.md § Rails`.
- **Halt** → failed item reported. A question halt - an implementer's
  acceptance-changing concern, NEEDS_CONTEXT or an absorbable blocker
  (`branch-plan.md § Scope discoveries`; § Seats) - takes § Question resolution,
  whose revert drops the item's uncommitted edits; any other halt - a red tier
  (`branch-plan.md § Stop conditions`) - keeps the work intact. The run
  resumes on the same scope.

## Boundary verification

Existing gates only, before the MR/PR is merged or asked of the user:

1. The report exists (task scope: the `finish.md § 1` set) - no
   report, no accept.
2. The report verifies each member's acceptance criteria.
3. Batch scope: `batch/R<NNN>-B<NNN>` has moved off
   `pre-R<NNN>-B<NNN>` (one `git log -1` on each): equal refs mean no
   member branch merged in, so the work took another route, with
   every gate on that route unrun. Check it before the gates below.
4. CI on the MR/PR is green, matched to the head sha (declared
   state-check command) - never a local re-run of gates the seats ran
   and CI re-ran. Plan boxes, diff confinement, and the committer
   signature complete the check.
5. A batch closing an R does **not** carry the closure and archival
   marks - they ride a close-out plan MR/PR (`plan/r<NNN>-close`)
   opened after the batch MR/PR merges (`branch-plan.md § Batches`).
   Verify that the batch left them alone and that the close-out is
   queued; a batch marking the R `[x]` in ROADMAP has closed on an
   unverified criterion, since CI-green criteria are only verifiable
   on the MR/PR the batch itself creates (`plan.md § Approval and
   closure`, `§ Archival`).

The report's queued judgment calls follow § Question resolution.

## Merge or ask

The delivery classes live in `companions/declarations.md § Supervisor
bounds` and are not restated here: a partial copy misleads. Read the
project's declared bound, then name the class the MR/PR falls into;
never deliver without a class or escalate without having read the
declaration.

The terminal state on a branch is a green MR/PR plus the report that verifies
it. Under `Supervisor: AI`, within a named class the runner merges on the
evidence it assembled - report path, gate results, state-check output - and
applies the signature (§ Supervision signature there); everything else is asked
of the user directly (Remote Control where connected) - the always-ask list per
that same section, and anything the grant does not name (§ Seats). Under
`Supervisor: human` every merge is the **user**'s (§ Seats): the run presents
the MR/PR and its evidence and waits, and this step replaces the ship question
of `finish.md § 2-3` for a task-scoped run under AI.

Branch protection is not the runner's to satisfy by other means: a
red gate escalates rather than being worked around. Escalations are
existing artifacts read back - halted items, the reports' queued
judgment calls, refused deliveries - never a parallel store.

## Ledger

The runner's working memory is `supervisor/<scope>.md` beside `<session>`
(`companions/declarations.md § Declared paths`), ignored like it, so an append
dirties nothing. One file per scope; a resumed runner on the same host opens
the same file. Opened at § Resolve (`mkdir -p` the directory, then the first
entry), it takes one entry per event from § Dispatch per item through § Merge
or ask, in `handoff.md § The file` format: `## <event> <UTC timestamp>` -
dispatch, question, answer, prompt, verify, escalation, merge - the timestamp
read from the clock (`date -u`) at write time, never composed or carried
forward - over `- key: value` lines naming the ids, appended with a single
`printf '%s\n' ... >>`, never `Edit`, which rewrites it. Working memory only:
a decision still lands in the report's `## Supervisor decisions`
(`companions/report-template.md`); the ledger is the evidence a re-brief
reads, never a second home for a finding.

## Monitor

The runner's context stays report-level: it collects report paths and
MR/PR references, never diffs or transcripts, so one runner spans a
scope. Hand-off note at each boundary and re-brief after compaction:
`handoff.md`. The scope is the runner's unit (`branch-plan.md
§ Session boundary`).

## Sync

On "status": per initiative - merged / in-flight / halted / escalated,
with MR/PR links - derived from artifacts at ask time (task
checkboxes, reports, state-check output). Resolving an escalation
re-dispatches the affected item - a fresh implementer on the plan,
re-read where it changed. The run ends when the scope is delivered or
only escalations remain; report which.
