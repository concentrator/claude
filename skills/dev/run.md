# Running planned work

Engine behind `/dev run <scope>`: planned work - a task, a batch or an
initiative - runs as dispatched seats under the supervisor seat the
project declares (`companions/declarations.md § Supervisor bounds`).
The runner session holds that seat. Under `Supervisor: AI` it
dispatches, verifies and merges within the declared bounds; under
`Supervisor: human` the steps marked **user** below are the user's
own. Rules: `branch-plan.md`. Host gates are never bypassed - no admin
merges.

## Seats

A seat is a subagent of the runner, dispatched with the Task tool in
the runner's checkout for one item, inheriting the runner's permission
mode and shut down at its exit; the next seat starts fresh, and only
the branch and the plan item carry over. Seats run one at a time, and
the runner runs git only between dispatches. A seat touches plan and
findings files only through Read/Edit/Write and never `.claude/`
config (edit-class shell there trips the sensitive-file guard).

Under `Supervisor: human` the user's own session is the supervisor, so the user
holds every supervisor cell; under `Supervisor: AI` the runner is, and the user
holds the asked-of row and the acceptance-approval cell.

| Duty | `Supervisor: human` | `Supervisor: AI` |
| --- | --- | --- |
| Writing and updating a plan | planner: both layers at the detail round, the acceptance on a re-dispatch, an approach gap once | the same |
| Dispatching | user | supervisor |
| Changing an item's approach | implementer, in the commit that carries the code | the same |
| Changing an item's acceptance | planner writes, user approves | the same |
| Clearing a permission prompt | nobody: a prompt is a pre-flight defect | the same |
| Verifying the boundary | user | supervisor |
| Merging | user | supervisor within the declared bounds, else user |
| Being asked | user: pre-flight permission proposals, acceptance changes, the always-ask escalations | the same |

A run reaching a duty the table leaves unassigned halts and reports, never
improvises. The reviewer holds no cell, the seat being the close review's
`code-reviewer` dispatch (§ Close) and the spec reviewer of
`companions/spec-reviewer-prompt.md`.

## Resolve

1. **Scope** - an explicit `R<NNN>-B<NNN>`, task id or slug, or
   `R<NNN>`; bare = the project's open batch (`branch-plan.md
   § Batches`: a member task `[ ]` in `tasks.md`, no report), else
   the next open task whose plan is read. An initiative runs its open
   batch, else its open tasks in `tasks.md` order, each a task-scoped
   run. Scope selects pre-approved work: anything lacking approved
   requirements or `cold-read: passed` (`branch-plan.md § Header`) is
   reported NOT READY, never dispatched, the report naming the
   missing record; a plan whose `depends-on` is unmerged the same. The
   check runs at every implementer dispatch, not at scope start alone -
   the reader seat's dispatch is not one, its read being what earns the
   record - so a plan changed mid-branch is admitted again once the
   record stands, kept through a cite-only change or restored by the
   bookkeeping commit (§ Question resolution).
2. **Supervisor** - read `CLAUDE.md § Supervision`: the `Supervisor:`
   line and the bounds, plus `.claude/supervisor.md` where referenced.
   No block, or no `Supervisor:` line → halt, naming it.
3. **Ledger** - open the scope's file (§ Ledger).

## Pre-flight

- Permissions: every `companions/auto-permissions.template.json` rule
  (`__PROJECT_DIR__`/`__HOME__` → abs paths without their leading
  slash - the rules carry the `//` prefix) plus the CLAUDE.md
  `## Agent toolchain` rules, incl. a VCS-host CLI (`glab`/`gh`;
  absent → push-only, manual MR/PR), is carried by a tracked tier
  (user-global `settings.json`, project `.claude/settings.json`) or
  deliberately narrowed by one (`companions/toolchain.md § Permission
  carve-out`); the rest are proposed into `.claude/settings.local.json`,
  applied on approval (**user**). No toolchain section → halt, ask.
- No plan in scope names a target under `.claude/`: config is never a
  seat's to write (`companions/implementer-prompt.md`). Every
  pre-flight check runs before any action; failures are reported
  together in one message, and the run halts with no branch created
  and no edit made.
- Default branch, clean tree, fast tier green
  (`companions/declarations.md § Declared commands`).
- Batch scope: tag `pre-R<NNN>-B<NNN>` (e.g. `pre-R062-B001`); create
  `batch/R<NNN>-B<NNN>` off default. Task scope: the task's branch off
  default, prefix from `type:`, no tag.

## Dispatch per item

Per task in scope order - a member already `[x]` in `tasks.md` is
skipped, noted for the checkpoint, never re-implemented; else its
branch per plan - and per commit checkbox:

1. Dispatch a fresh implementer (`companions/implementer-prompt.md`)
   naming the plan file - the item it works is the first `[ ]` - with
   the docs and the code as its inputs and nothing else. Its loop is
   the plan's `type:` mode file (`feat.md`, `fix.md`, `refactor.md`);
   `doc`/`test`/`mnt` run `branch-plan.md § Commit cadence` alone.
2. DONE → spec check. DONE_WITH_CONCERNS → a concern that changes an
   item's acceptance takes § Question resolution as NEEDS_CONTEXT does:
   the item's `[x]` stands and its commit goes unchecked; the planner's
   change adds a new checkbox for the redo, as § Close step 2 does for
   fixes, so the fresh implementer works the concern and its commit is
   what the spec check reads; the runner records `<item>: spec check
   skipped: superseded by plan change`, carried verbatim into the
   report's Cost section like every skip
   (`companions/verification-policy.md § Spec-check skip`). Any other
   concern the runner ledgers (§ Ledger) and carries into the report,
   then spec check. NEEDS_CONTEXT → § Question resolution. Halt
   triggers: `branch-plan.md § Stop conditions`.
3. Spec check (`companions/spec-reviewer-prompt.md`): exactly the item;
   skipped per `companions/verification-policy.md § Spec-check skip`.
   Reject → fix → recheck.
4. The implementer marks `[x]` in its commit (`branch-plan.md § Commit
   cadence` 3); the runner confirms the mark landed before the spec
   check.

A prompt the declared set did not predict - a compound command offers
no prefix for a Bash rule to match - halts the item as a pre-flight
defect, cleared by nobody (§ Seats, the prompt row).

## Question resolution

An acceptance-level question - an implementer's blocker, a concern or a spec
ambiguity whose answer changes an item's acceptance, a cold-read gap found in
flight - halts the item and re-dispatches the planner (§ Seats;
`companions/planner-prompt.md`) with that text, on the item's own branch
(`git-workflow.md § Trunk`). The halt reverts the item's uncommitted edits -
`git checkout -- .` and removal of the untracked files the seat created - so the
branch stands at its last commit before the planner is dispatched. The planner
commits its change locally, nothing being pushed until the runner delivers; a
planner reporting DONE_WITH_CONCERNS (`companions/planner-prompt.md § Report
Format`) has committed too, so its change takes the read below as DONE's does
and its concern reaches the user with the change for approval. The runner then
runs `write-plan.md` step 6 on the changed plan, the reader a dispatched seat
(`companions/verification-policy.md § Comprehension check`), never the runner's
own read. Where the change dropped `cold-read: passed` - a change adding a
decision, `companions/planner-prompt.md` Job 3 - the pass is recorded in the
runner's own bookkeeping commit on the item's branch, while a change that only
cites text already in the tree keeps the record, and an implementer's approach
edit rides the code's commit. The change is the **user**'s to approve under
either supervisor mode (`companions/declarations.md § Supervisor bounds`); a
rejection re-dispatches the planner with the objection's text, and the next
planner commit replaces the text - no revert, and the runner edits no plan
content. Only then is a fresh implementer dispatched, starting from the last
commit. A seat never resumes.

Every acceptance-level answer takes that route; an approach-level question -
which files, which sentences, which order - costs no seat and no approval: the
implementer resolves it in the item's approach text and commits the plan edit
with the code (§ Seats). An implementer's inputs are the plan, the docs and the
code (`companions/implementer-prompt.md`), so an answer reaches the next
implementer only as plan text, and the planner is what writes it there. The
re-dispatch carries the blocker's, the concern's, the cold-read gap's or the
user's objection text and nothing else - never a diff or a transcript. Each
answer is ledgered (§ Ledger) and carried into the report's `## Supervisor
decisions` section at checkpoint.

## Close

Per branch, when its last non-final item is `[x]`:

1. Close review: `code-reviewer` on the branch diff vs plan. In a
   batch-scoped run a small branch skips it
   (`companions/verification-policy.md § Close folding`); a
   task-scoped run closes in full (`branch-plan.md § Closing
   routine`).
2. Fixes: mechanical ones applied, judgment calls queued; approval of
   the applied set is the **user**'s under `Supervisor: human`. The
   approved fixes go to the planner as one change on the branch
   (`plan.md § Adjusting existing plans`), each fix a new checkbox and
   the change approved per § Question resolution; a fresh implementer
   works them.
3. The runner makes the mandatory final commit (docs re-review,
   cleanup, plan complete, task mark per `branch-plan.md § Closing
   routine`).
4. Fast tier green → batch scope: merge into `batch/R<NNN>-B<NNN>`;
   task scope: `finish.md` from its § 1, then § Checkpoint. Red → halt.

Rails hold throughout (`branch-plan.md § Rails`).

## Batch close

1. Full-diff review vs default (`code-reviewer`, most capable):
   cross-branch interactions, duplicated helpers, convention drift;
   folded small branches get first-review vs their plans.
2. Fixes land as batch-branch commits; queue judgment calls.
3. Run `Test (full)` - the batch's one full local run; red → halt.
   Docs coherence pass (CHANGELOG/README across member branches).
4. Mark member-task checkboxes; commit on `batch/R<NNN>-B<NNN>`
   (`branch-plan.md § Batches`).

Models + spec-check depth: `companions/verification-policy.md`.

## Checkpoint

At scope end or halt, write the R's `batches/R<NNN>-B<NNN>.report.md`
per `companions/report-template.md`, re-verifying acceptance criteria.
No report → no accept. A task-scoped run has no report: `finish.md
§ 1`'s verify set stands in its place, and a branch missing it is no
more mergeable than a batch missing its report. Then - the choice the
**user**'s under `Supervisor: human`, the runner's within bounds under
`Supervisor: AI`:

- **Accept** → push the branch to origin + open the CI-gated MR/PR per
  `companions/toolchain.md`, description from the report; then
  § Boundary verification and § Merge or ask. Findings triage; ref
  cleanup per `branch-plan.md § Rails` - after the MR/PR merges,
  post-merge cleanup deletes the batch branch, local and origin.
- **Reject** → ref handling per `branch-plan.md § Rails`.
- **Halt** → failed item reported. A question halt - an implementer's
  plan-changing concern, NEEDS_CONTEXT or an absorbable blocker
  (`branch-plan.md § Scope discoveries`) - takes § Question resolution,
  whose revert drops the item's uncommitted edits; any other halt - a
  red tier, a spec check rejecting twice (`branch-plan.md § Stop
  conditions`) - keeps the work intact. The run resumes on the same
  scope.

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

The terminal state on a branch is a green MR/PR plus the report that
verifies it. Under `Supervisor: AI`, within a named class the runner
merges on the evidence it assembled - report path, gate results,
state-check output - and applies the signature (§ Supervision
signature there); everything else is asked of the user directly
(Remote Control where connected) - the always-ask list per that same
section, and anything the grant does not name. Under `Supervisor:
human` every merge is the **user**'s: the run presents the MR/PR and
its evidence and waits, and this step replaces the ship question of
`finish.md § 2-3` for a task-scoped run under AI.

Branch protection is not the runner's to satisfy by other means: a
red gate escalates rather than being worked around. Escalations are
existing artifacts read back - halted items, the reports' queued
judgment calls, refused deliveries - never a parallel store.

## Ledger

The runner's working memory is `dev/supervisor/<scope>.md` in the
checkout, beside `dev/session/` and ignored like it, so an append
dirties nothing. One file per scope; a resumed runner on the same host
opens the same file. Opened at § Resolve (`mkdir -p` the directory,
then the first entry), it takes one entry per event from § Dispatch
per item through § Merge or ask, in `handoff.md § The file` format:
`## <event> <UTC timestamp>` - dispatch, question, answer, prompt,
verify, escalation, merge - the timestamp read from the clock
(`date -u`) at write time, never composed or carried forward - over
`- key: value` lines naming the ids, appended with a single
`printf '%s\n' ... >>`, never `Edit`, which rewrites it. Working
memory only: a decision still lands in the report's `## Supervisor
decisions` (`companions/report-template.md`); the ledger is the
evidence a re-brief reads, never a second home for a finding.

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
