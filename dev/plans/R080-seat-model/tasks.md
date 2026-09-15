# R080 tasks - Work by seats

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R080-T###`, counter scoped to this initiative).

Order matters: the docs move first so the doc writer has one target,
the planner and the duties table after the flow, the layout
declaration once the doc writer has its target, the seat definitions
once the duties table names every duty, the hooks rule once those
definitions state it in one place, the permission pre-flight once each
seat's definition carries the tool set it resolves against and the
hooks rule says who writes a guard, the pilot last.

## Open

- [x] **R080-T001 [mnt]**: docs move - `dev/docs/` moves to `docs/`
  with every rule naming the old path (`layout.md § Docs`,
  `companions/documentation.md`, project overlays); migration steps
  for consuming projects, applied per project at its next planning
  round.

- [x] **R080-T002 [mnt]**: cold read at the planner's exit - a fresh
  agent given the worker's inputs says what it would build; re-homed
  from `branch-plan.md § Stamps` and
  `companions/verification-policy.md § Comprehension check`; a gap is
  fixed before approval; mandatory - the plan records the passed read
  and `/dev code` and the flow refuse a plan without it.

- [x] **R080-T003 [mnt]**: one runner - `/dev run <scope>` replaces
  `/dev code`, `/dev auto` and `/dev supervise`, and `/dev docs`
  retires: planned work runs as dispatched seats under a supervisor
  seat declared `Supervisor: human | AI`, the session never
  implementing itself; the stamp pair retires; a seat is a subagent
  of the runner started for one item and shut down at its exit; the
  implementer's dispatch carries the task's plan, docs and code only,
  and the reviewer's the plan, its acceptance criteria and the diff.
  Depends on R080-T002.

- [x] **R080-T008 [mnt]**: planner seat - a dispatched agent that
  writes or updates one branch plan from the initiative's
  requirements, the task line, the docs, the code and the initiative's
  other plans, exiting through the cold read; the detail round and
  `plan.md § Adjusting existing plans` dispatch it, a worker's blocker
  or cold-read gap re-dispatches it with the worker paused, and no
  other seat edits plan content. Depends on R080-T003.

- [x] **R080-T006 [mnt]**: seat responsibilities per mode - one table
  in the flow file, a row per duty - plan, dispatch, clear a prompt,
  verify, merge, be asked - a column per supervisor mode and a
  seat in each cell; every duty statement in `skills/dev/` cites it; a duty
  the table leaves unassigned halts the run. Depends on R080-T003.

- [x] **R080-T004 [mnt]**: doc-writer seat - a dispatched agent that
  writes `docs/` on the worker's branch from the diff, the plan item,
  and the existing docs, exiting through
  `companions/documentation.md § Verification gate`; the implementer
  prompt drops doc targets; `branch-plan.md § Commit cadence`'s docs
  step re-points to the seat.

- [x] **R080-T009 [mnt]**: declared layout - the project root
  `CLAUDE.md` declares its key paths (docs home, plans tree, session
  tree, layout file), retiring `extended-docs:`; `.claude/LAYOUT.md`
  holds the full, actual tree, seeded by `start.md` from `layout.md`'s
  canonical structure and written by `migrate.md` from the inventory;
  every rule, skill or CI check naming `docs/` or `dev/` literally
  resolves it through the declaration; this repository's own
  declaration and `LAYOUT.md`; the installer leaves both untouched.
  Depends on R080-T004.

- [x] **R080-T010 [mnt]**: seat agent definitions - one file per seat
  under `agents/` with its tools, model, effort, conduct and duties;
  the prompt companions reduced to the per-dispatch template; `run.md
  § Seats` naming every seat once and citing both homes; the models
  table reduced to the tier-selection and capacity-fallback rules.
  Depends on R080-T006.

- [x] **R080-T011 [mnt]**: who writes `hooks/` - the config paragraph
  every seat definition carries withholds `hooks/` alongside the
  settings surface, yet `hooks/` is tracked source the installer ships
  and two planned changes need a guard edit (R080-T007's bar on a
  seat's HEAD moves, and the backlog's edit-class-shell guard); settle
  it in the paragraph's one home and propagate to all seven
  definitions - either a seat writes `hooks/` as tracked source, with
  the caveat this self-hosting checkout's guards are live and a seat
  can weaken the guard binding it, or the withholding stands and every
  rule planning a guard change names the user as its writer. Depends
  on R080-T010.

- [x] **R080-T007 [mnt]**: deterministic permission pre-flight - a
  declared permission set per seat (mode plus allow rules) derived
  from the toolchain declaration, each seat's definition under
  `agents/` and its dispatch companion under `skills/dev/companions/`;
  a pre-flight script that resolves the set against the tracked
  tiers, applies every adjustment before the first dispatch and
  reports every gap in one message, with its test; the runbook's
  prompt-clearing rows and failure modes re-read against it;
  `run.md § Pre-flight`'s "No plan in scope names a target under
  `.claude/`" reworded to name the settings surface, which is what
  that sentence's own cite (`agents/dev-implementer.md`) withholds
  from a seat, every other path under the config directory being
  tracked source; a seat held off HEAD by a branch in
  `hooks/dev-branch-guard.sh` rather than by a settings deny on `git
  checkout`, `switch`, `reset`, `restore` and `stash` - a deny binds
  the whole session, stopping the flow's own HEAD moves, where the
  guard reads a command's arguments and so passes `switch -c` on a new
  branch while stopping a trunk checkout, and hooks fire for a
  dispatched seat as they do for the session (the R080-T010 probe,
  below); under
  `auto` no per-seat `Bash` allow derivation is needed, each
  definition's tool set being the scope boundary and `auto` suspending
  Bash allow rules, so whether one is needed under a supervisor mode
  that does not suspend them is T007's to settle
  (`companions/supervisor-runbook.md § Modes by seat`). Depends on
  R080-T004, R080-T010 and R080-T011.

- [ ] **R080-T005 [mnt]**: harvest the pilot run - R080-T007 ran the
  seat flow end to end in this repository (pre-flight, cold reads,
  planner re-dispatches, implementer and spec-check cycles, doc-writer
  pass, close review, supervised merge), so this task fixes what that
  run surfaced in the flow files and the seat definitions and evidences
  R080's acceptance criteria from it rather than staging a second run.
  Depends on R080-T007 and R080-T009.

- [ ] **R080-T013 [fix]**: settle the `## Agent toolchain` contract and
  harden the pre-flight against it. `rules/claude-md.md § Agent
  toolchain declaration` has a project declare its commands "as
  `permissions.allow` rules", while `companions/declarations.md
  § Declared commands`, the syntax home that line cites, declares
  commands the run "uses for `permissions.allow`" and `finish` runs
  instead of probing the host - and `scripts/preflight-permissions.sh`
  reads the section the second way, harvesting backticked spans and
  wrapping each in `Bash(...:*)`, so a project that followed the rule
  got `Bash(Bash(npm test:*):*)` written into its local tier by
  `--apply`. The commands contract wins, that section declaring roles
  beyond permission syntax; the rule is reworded to commands the
  pre-flight derives rules from, `declarations.md` gains the list
  format its citers assume, and `toolchain_rules()` passes a
  tool-rule-shaped span through untouched, skips a span holding `&&`,
  `||`, `;` or `|` with a warning naming its parts - `Test (fast)`
  declared as two chained commands yields one rule that can never match
  - and stops on a top-level `deny`, `allow` or `ask` key in any tier
  it reads, a shape that silently emptied a project's deny list and
  left the branch-guard hook as the only thing refusing a force push.
  Each with a case in `scripts/test/preflight-permissions.test.sh`.
  Depends on R080-T007.

- [ ] **R080-T014 [mnt]**: session-scoped supervisor selection, the
  user proposal in the backlog below. `CLAUDE.md § Supervision`'s
  `Supervisor:` line is the seat's only home, so flipping AI to human
  costs a branch and a plan MR/PR, while `companions/declarations.md
  § Supervisor bounds` bars the obvious route outright - "authority
  never moves there", of the untracked `.claude/supervisor.md`, which
  `run.md § Resolve` 2 already reads for the bounds text. The shape to
  settle is a tracked ceiling with a selection at or below it and never
  above, the seat taken recorded in the run's ledger (`run.md
  § Ledger`); which artifact carries the selection - the untracked file
  or a run-time argument - is this task's first decision.
  `scripts/preflight-permissions.sh` reads the declared seat too,
  asserting the runner's `auto` mode under `Supervisor: AI` and
  asserting nothing under `human`, so the selection reaches the
  pre-flight or the gate asserts against the wrong seat. Depends on
  R080-T007.

Backlog: R080-T001, T002 and T004 to T008 still carry a
`supervised: approved` header line the plan header no longer admits
(`skills/dev/branch-plan.md § Header`); strip it on the R080 close-out
plan MR/PR. The acceptance criterion on the refused plan names
`/dev code`; reword to `/dev run` there too. From the R080-T008 close
review: the T008 task line above still says a blocker re-dispatches
the planner "with the worker paused" where `skills/dev/run.md
§ Question resolution` halts the item and dispatches a fresh
implementer; `requirements.md § Desired state` 1 still has the
supervisor answering implementation-level questions; a plan change
should stay within the files a reviewer named; `write-plan.md § Bulk
mode` has parallel planners committing in one checkout, a race the
session's single commit avoided; pre-existing cites `run.md
§ Archival`, `finish.md § 2-3` and `CLAUDE.md § Conventions` resolve to
no heading; `DESIGN.md` sits at 998 of its 1000 words.

Backlog, loop simplification (from the R080-T008 run, each a rule edit
unless noted): the second verifier fires on a Critical finding only,
not on the diff touching `skills/` (`branch-plan.md § Closing routine`,
`companions/verification-policy.md § Verifier isolation`) - in this
repository every diff touches it; close-review fixes with quoted
wording get a spec check, not a second close review (`run.md § Close`);
the mechanical predicate keys on fully quoted wording, not on a file
count (`companions/verification-policy.md § Mechanical commits`); the
merge ask on every task-scoped run goes by widening the bounds to
task-scoped delivery or by running the initiative as one batch
(`CLAUDE.md § Supervision`); the verify offer and the ship options land
in one message (`finish.md § 2`); the ledger is the one record written
as events happen, the hand-off note, the checkpoint report and the
session summary derived from it (`run.md § Ledger`, `handoff.md`,
`companions/report-template.md`; design change); a plan whose items
are all quoted-wording gets one implementer walking them in order with
one spec check at the end (`run.md § Dispatch per item`; design
change); the reader's dispatch says that only acceptance-level
findings are gaps and approach findings go to the implementers as
notes (`write-plan.md` step 6). The release
routine (`skills/dev/release.md` step 3) hands the `[Unreleased]`
CHANGELOG entry to the code reviewer, whose rubric routes it to the
docs gate (`agents/code-reviewer.md`), and no doc writer runs in a
release. In a run the hand-off boundary is the item and an intent
change (a ruling, a queued change, a blocker), never a dispatch: the
ledger holds the dispatches and git the landed items, and the
R080-T009 run wrote 87 blocks for 6 compactions under the current
list (`handoff.md § Writing the note`, `run.md § Monitor`). From the
R080-T009 close: `scripts/install-dev.sh` still withholds
`check-plan-integrity.sh` and `check-archival.sh` as depending on this
repository's layout, a reason the declaration read removed;
`check-batch-tags.sh` fails a worktree whose `- Plans:` differs from the
trunk's tree with a message naming the ref, not the mismatch;
`scripts/test/install-dev.test.sh` sits one line under the 300-line cap;
`.gitignore`'s comments cite the retired `supervise.md`; the installer's
step-7 comment says "the target's `CLAUDE.md § Layout`" where the code
reads the project's root `CLAUDE.md`. From the R080-T010 planning act: a
host instruction telling an agent to prefer `Bash` for file changes
reaches every dispatched seat and contradicts each prompt companion's
"edit with Read/Edit/Write, never `sed`/`cat`/`awk`", which no file
class bounds - a planner rewrote plan prose with a script under it, and
no rule says which instruction wins outside Markdown, where
`rules/writing-artifacts.md § Bulk edits` settles it; a cite to a
sentence that wraps names its first line in two
companions and a line range in a third, one convention per citation
rather than one for the file. A three-arm probe then proved where that
instruction lands unguarded: the hook pair fires for a dispatched seat's
`Bash` call as it does for the session's, but
`hooks/dev-branch-guard.sh` judges a `Bash` call as a git mutation only
- its write path cases on the `Write|Edit|NotebookEdit` matcher - so
edit-class shell against a tracked file on a trunk runs untouched while
the same edit through `Edit` is denied. The fix is a branch in the
guard, or a third hook on the same `Bash` matcher, denying edit-class
shell whose target is tracked, its reason line citing
`rules/writing-artifacts.md § Bulk edits` and naming `Edit`/`Write` as
the way through. Also from that probe: a `PreToolUse` deny is
all-or-nothing per call, so a guard that trips on one edit-class
fragment stops every command chained with it - a second and harder
reason for the compound-command rule at `run.md § Dispatch per item`.
From the R080-T010 run: a `tools:` name this client's registry does not
provide is dropped silently, with no error - a dispatched seat declaring
`Read, Glob, Grep, Bash` held `Read, Bash`, and one asked to call them
reported that neither tool exists - so no definition declares `Glob` or
`Grep`, at the cost of those seats searching through `Bash` alone;
re-add both to the sets R080-T010 names on a client that provides them.
From the R080-T010 run: `R080-T007-perm-preflight.md` predates the seat
model - its `depends-on` names R080-T004 alone where the task line names
R080-T010 too, and its `run.md § Pre-flight` item rewrites that section
without the correction the task line now hands it - so T007's detail
round re-plans it rather than running it as written. From the
R080-T010 run: `scripts/install-dev.sh` ships no `agents/`, so an
installed project reads a `run.md § Seats` citing definitions it does
not have. From the R080-T010 run: `write-plan.md` step 6's "A planner
change made after the pass is recorded starts a count of its own"
reads as unbounded where the same step's earlier rule is not - bound it
to a change that alters an acceptance, an approach or wording change
restarting no count. From the R080-T010 run:
`companions/documentation.md § Verification gate` fixes comprehension
findings like WRONG claims, while `run.md § Close` 3 halts on a second
WRONG, so a second gate pass's comprehension findings either halt the
run or send a third doc writer no rule provides, and a whole-doc pass
never converges, each rewrite handing the next pass new sentences -
bind comprehension findings to the sentences the branch wrote and keep
them out of the halt count. From the R080-T010 docs gate: `README.md
§ Installing` leaves four installer facts unstated - `install-dev.sh`
resolves its source from the current directory, so a run by absolute
path from inside another repo copies from that repo; it needs `jq`;
a project install dirties the tracked `.gitignore`, so "re-run it to
refresh" is refused until that is committed or `--force` is passed;
and the hygiene section it seeds lands in `<path>/.claude/MAINTENANCE.md`.
From the R080-T011 close: CI is no check on a weakened hook, since
`.github/workflows/ci.yml` runs the branch's own tree and
`scripts/ci/check-secrets.sh` sources `hooks/secret-patterns.sh` from
it, while `main`'s protection requires zero approving reviews - so a
seat that edits a hook and its test together passes the gate and an AI
supervisor merges it, and the spec reviewer reading the diff against
the plan item is the real check; say so wherever the floor is described
(`git-workflow.md § Enforcement`, `requirements.md § Invariants`).
`R080-T010-seat-definitions.md` calls the user's pre-flight `--apply`
the settings surface's only writer, where `scripts/install-dev.sh`
writes the `hooks` key of a target's `settings.json` and
`scripts/worker-workspace.sh` writes `.claude/settings.local.json`, and
no pre-flight script exists yet; correct it where R080's close-out can
reach it. The Config paragraph every seat definition carries names a
"sensitive-file guard" that matches no hook in `hooks/`, its only other
mention being a permission-dialog label in
`companions/supervisor-runbook.md` - name the real mechanism or drop
the clause. `git-workflow.md § Enforcement` says `main` requires an
up-to-date branch where the host reports `strict: false`. From the
R080-T007 plan round: `requirements.md` reads the tier set two ways
R080-T007 now contradicts - `§ Invariants` says the permission set
"widens allow rules within a tracked tier" where `--apply` writes the
gitignored local tier, and `§ Desired state` 8 says pre-flight
"resolves the whole set against the tracked tiers" where that task's
first item reads the carve-out pattern off the untracked local tier
too; settle both sentences against the read the task lands.
`agents/dev-cold-reader.md` carries no `model:` key where the other six
seat definitions carry `model: opus`.

Backlog, from the R080-T007 close: `hooks/dev-branch-guard.sh`'s
HEAD-move scan splits a command textually (`hscan="${cmd//$'\n'/;}"`),
so a `git commit -m "...git reset --hard..."` or a heredoc whose body
carries a reset line is refused though nothing destructive runs, against
a header that promises fail-open; the push scan splits the same way, so
the fix is a shared segment splitter rather than a patch in one branch.
A `/dev run` runs commands the declared set does not reach, each to be
declared with its source or ruled out with its verb chosen: the
pre-flight's own invocation at `run.md § Pre-flight`, which this
repository's root `settings.json` meets with `Bash(bash -n:*)` alone and
its `.claude/settings.json` with `run-all.sh` and `check-caps.sh` alone,
so the gate cannot gate its own invocation; `bash
~/.claude/scripts/model-quota.sh "Fable"`, read before any `fable`
dispatch (`companions/verification-policy.md § Models`); the
untracked-file removal at `run.md § Question resolution`, whose verb,
`git clean -fd`, discards untracked work the way the four denied shapes
discard tracked work and is reached by no guard branch, so the verb
lands with its guard or not at all; the re-brief's "Then delete the
file" (`handoff.md § Reading it back`); a remote branch deletion outside
the merge command's `--delete-branch` (`finish.md § 4` step 4), a push
no declared string reaches and a delete-push string being a carve-out
entry `toolchain.md § Permission carve-out` does not state, its local
half covered by `Bash(git branch:*)`; and the work-product class no
declared set can enumerate in advance, down to the
`node --env-file=.env /tmp/probe.mjs` that `agents/dev-implementer.md
§ Scratch & Probe Scripts` tells a seat to write and run with no
`Bash(node:*)` declared. `scripts/preflight-permissions.sh` prints the
`--apply` line it tells the user to run unquoted, so that line breaks on
a project path carrying `&` or a space - the very shape the `a&b`
fixture pins for the substitution fix. The same script chmods the local
tier 644 unconditionally after the `mv` from a 0600 `mktemp`, relaxing a
deliberately restrictive mode where it should capture the existing
file's mode and restore it, defaulting to 644 where the file did not
exist. `branch-plan.md § Commit cadence` 3 cites `git-workflow.md
§ Commit messages` and `companions/implementer-prompt.md` does not,
though that companion is the seat's own instruction sheet and the one
file an implementer certainly reads, so a seat invents the body
convention: four messages drifted in this run while only
`branch-plan.md` carried the cite, and none once a dispatch named the
rule. The pre-flight self-test's assertion helpers read an aborted run
as the behavior they assert - `rcn()` takes the 127 a missing file
returns as the non-zero exit it wanted, and `nowant()` passes whenever
its `grep` finds nothing - so a syntax error, a host without `jq` or any
other early exit satisfies every `rcn` and `nowant` site in
`scripts/test/preflight-permissions.test.sh`; the subject guard this
branch added closes the missing-subject case and no other, and
tightening the helpers is a per-case review of which negative assertions
legitimately produce short output, so it is a task of its own
(`R080-T007-perm-preflight.findings.md § Close triage`). A hook deny
beats a settings allow and no test pins it: the root `settings.json`
allows `Bash(git checkout:*)` and registers `hooks/dev-branch-guard.sh`
on its `Bash` PreToolUse matcher, and the guard's refusal of an entry
into a dirty default branch stands over that allow - the precedence
carries the whole pre-flight, a rule the report calls `present` being
still refusable at the call - while the three guard suites feed the hook
its JSON on stdin and read its decision rather than the client's
resolution of a deny against an allow. An approach's line cites go stale
against the code they name: this plan's item 8 cites
`scripts/preflight-permissions.sh:275` and `:282-285`, which the
branch's own commits moved to 276 and 283-286 - harmless to an
implementer working from the code, misleading to a later reader - and
the class is what to rule on, a line number being no durable id while
`rules/writing-artifacts.md § Name things by their durable id` governs
hashes and says nothing of line cites: either an approach cites an
anchor instead, or a stale line cite is accepted as approach text the
implementer is free to correct (`run.md § Seats`). The fast tier never
exercises the installed copy: `scripts/ci/run-all.sh` runs its checks
over this checkout and no installer, so what an adopter's `.claude/`
runs - the shipped self-test resolving its subject from
`${BASH_SOURCE[0]}`, and that test's subject guard - is proven only by a
hand-run `bash scripts/install-dev.sh --project <dir>` with the subject
moved aside, which is how the worker-seed and subject-guard defects
surfaced; `scripts/test/install-dev.test.sh` runs the copied
`check-accretion` and `check-batch-tags` suites and never the copied
pre-flight one, so which tier owns that run is open. The guard's
by-name entry test is fail-open on indirect spellings: it compares the
first bare token after
the verb with `is_trunk`, a literal string equality, so `git checkout
-`, `git switch -`, `git checkout @{-1}` and `git checkout main --` all
allow on a tracked-dirty tree, as do `git branch main`,
`git branch -f main HEAD` and `git worktree add ../wt main`, the verb
alternation reading `checkout|switch|restore|reset|stash` alone; the
file's header calls it fail-open and `seat-permissions.md § HEAD moves
and whole-tree discards` states each shape by its verbs, so the bound is
recorded rather than misstated, and what R080 rules is whether the
heuristic tightens rather than a defect to patch. This repository's
shell code is written, probed and run locally on a `/bin/bash` two
major versions behind the one CI runs, so a shell-semantics defect is
green on every local run and red on every CI run, which is how the `&`
expansion passed two plan items, a close review and a full local
suite; what R080 rules is where a second shell comes from - a declared
version floor, a CI-only class of assertion, or a probe step that
names the gap - rather than this branch's two lines. A task mark
asserted a completion for three commits: `R080-T007` read `[x]` here
after the branch reopened, through "Reopen R080-T007 for the &
substitution defect" and the gap fix and cold-read record that
followed it, and cleared to `[ ]` only in the fix commit; the end
state is coherent and rewriting history was declined, but the flip
belongs in the reopening commit itself, since `§ Closing routine` 7
orders the task mark last precisely so a `[x]` never asserts a
completion the branch has not reached and a reopening is that same
hazard read backwards, so what R080 rules is whether
`branch-plan.md § Scope changes mid-branch`, which today names only
the new checkboxes and the new final commit, states the mark's
clearing as the reopening's own step. A test case cannot fail where
its fixture sits: `scripts/test/preflight-permissions.test.sh`'s "an
`&` path opens no gap to apply" survives a mangled `Edit` rule,
because the fixture tier carries the template's own `Edit(//tmp/**)`
and `Edit(//private/tmp/**)`, whose literal prefixes cover any
declared project path under those two trees, so the pre-flight reports
the mangled rule `present`, `--apply` writes no local tier, and the
assertion holds either way; it bites only where the host's `mktemp -d`
lands outside both, as this one's `/var/folders` does, the masking is
the test's rather than the fix's, and what R080 rules is whether a
fixture may sit anywhere a declared rule already covers. Two files
stand against their cap with a split deferred:
`scripts/preflight-permissions.sh` sits on
`scripts/ci/check-code-size.sh`'s 300-line file cap with no line left
to spend, the last one going to "Stop R080-T007's pre-flight on a
partial template", and `scripts/test/preflight-permissions.test.sh`
runs close behind it after the regression case "Pin R080-T007's stop
on a partial template" added; that script is what computes and
enforces both counts, neither file took a `code-size-allow.txt` entry,
and the next change to either needs a restructure, a split, or an
allow-list decision, which is a planning call rather than an
implementer's. A split prompt never fired: `branch-plan.md § Size cap`
prompts to split past 30 commits, and this branch crossed 30 during
the close fix pass with no prompt raised; nothing is split here, so
the leaving is the threshold passing unremarked rather than this
branch's size, and the count is read with `git rev-list --count
main..HEAD`, which no flow step runs, leaving the cap resting on a
runner's recollection across a branch whose commits span many seats.
What R080 rules there is whether § Size cap gets a mechanical check -
a flow step or a hook reading that count at a named point - or stays
the judgement the runner is trusted to make. A user proposal, not a
settled call: make the supervisor seat switchable per session without a
tracked commit, `CLAUDE.md § Supervision`'s `Supervisor:` line being its
only home today, so flipping AI to human takes a branch and a plan
MR/PR. `companions/declarations.md § Supervisor bounds` bars the obvious
route - "authority never moves there", of the untracked
`.claude/supervisor.md` - and the reason holds: an untracked file
granting merge rights leaves no trace in history, and anything that can
write a file could promote itself into the merge seat. The shape
proposed instead is a tracked ceiling with an untracked or run-time
selection at or below it, the seat taken recorded in the run's ledger.
What R080 rules is whether that shape is right and which artifact
carries the selection.

Archival, promotion target (`plan.md § Archival`): this initiative
bought a set of facts about the host that no file in the tree states,
each with a probe behind it - a `tools:` name the client's registry
does not provide is dropped silently; hooks fire for a dispatched
seat's call as for the session's, while `hooks/dev-branch-guard.sh`
judges a `Bash` call as a git mutation alone; `auto` suspends Bash
allow rules and routes every command to a classifier, leaving deny
rules, non-Bash allows and the mode assertion as the only deterministic
enforcement; hook registration is read at session start where an edit
to a registered script is live at once, while a settings tier is
re-read live in both directions - a `deny` added to
`.claude/settings.local.json` mid-session blocked the matching command
and lifting the key unblocked it, an unrelated command running
throughout; `~/.claude.json`'s
`hasTrustDialogAccepted` makes a project tier's allow entries inert;
and CI runs the branch's own tree, so a gate sourcing a file from
`hooks/` cannot police it. They sit in this backlog and in plan prose,
which `§ Archival` moves under `archive/` at the R's close, so the
facts outlive their home. Promote them to
`docs/references/claude-code-host.md`, an adapted reference
(`companions/documentation.md § Diataxis typing`), with the probe runs
behind the observable ones under `docs/reports/`; every claim carries
the version it was verified against. The declared docs home does not
exist yet - `CLAUDE.md § Layout` says `Docs: docs/` and the tree has
none, `layout.md § Creation policy` making it lazy - so this promotion
creates it.
