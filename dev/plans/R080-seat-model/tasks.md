# R080 tasks - Work by seats

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R080-T###`, counter scoped to this initiative).

Order matters: the docs move first so the doc writer has one target,
the planner and the duties table after the flow, the layout
declaration once the doc writer has its target, the seat definitions
once the duties table names every duty, the permission pre-flight once
each seat's definition carries the tool set it resolves against, the
pilot last.

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

- [ ] **R080-T010 [mnt]**: seat agent definitions - one file per seat
  under `agents/` with its tools, model, effort, conduct and duties;
  the prompt companions reduced to the per-dispatch template; `run.md
  § Seats` naming every seat once and citing both homes; the models
  table reduced to the tier-selection and capacity-fallback rules.
  Depends on R080-T006.

- [ ] **R080-T007 [mnt]**: deterministic permission pre-flight - a
  declared permission set per seat (mode plus allow rules) derived
  from the toolchain declaration and the seat prompts; a pre-flight
  script that resolves the set against the tracked tiers, applies
  every adjustment before the first dispatch and reports every gap in
  one message, with its test; the runbook's prompt-clearing rows and
  failure modes re-read against it. Depends on R080-T004 and
  R080-T010.

- [ ] **R080-T005 [mnt]**: pilot task end to end under the seats -
  pre-flight, cold read, worker dispatch, doc-writer pass, supervised
  merge, no prompt outside the declared set; fixes from the pilot land
  on the same branch. Depends on R080-T007 and R080-T009.

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
list (`handoff.md § Writing the note`, `run.md § Monitor`). The
per-commit spec check on Fable is the run's largest seat cost; the
models table is policy, so moving it to Opus is a plan item
(`companions/verification-policy.md § Models`). From the R080-T009
close: `scripts/install-dev.sh` still withholds
`check-plan-integrity.sh` and `check-archival.sh` as depending on this
repository's layout, a reason the declaration read removed;
`check-batch-tags.sh` fails a worktree whose `- Plans:` differs from
the trunk's tree with a message naming the ref, not the mismatch;
`scripts/test/install-dev.test.sh` sits one line under the 300-line
cap; `.gitignore`'s comments cite the retired `supervise.md`; the
installer's step-7 comment says "the target's `CLAUDE.md § Layout`"
where the code reads the project's root `CLAUDE.md`.
