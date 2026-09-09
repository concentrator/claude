# R080 tasks - Work by seats

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R080-T###`, counter scoped to this initiative).

Order matters: the docs move first so the doc writer has one target,
the planner and the duties table after the flow, the permission
pre-flight after every seat exists, the pilot last.

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

- [ ] **R080-T007 [mnt]**: deterministic permission pre-flight - a
  declared permission set per seat (mode plus allow rules) derived
  from the toolchain declaration and the seat prompts; a pre-flight
  script that resolves the set against the tracked tiers, applies
  every adjustment before the first dispatch and reports every gap in
  one message, with its test; the runbook's prompt-clearing rows and
  failure modes re-read against it. Depends on R080-T004.

- [ ] **R080-T005 [mnt]**: pilot task end to end under the seats -
  pre-flight, cold read, worker dispatch, doc-writer pass, supervised
  merge, no prompt outside the declared set; fixes from the pilot land
  on the same branch. Depends on R080-T007.

Backlog: R080-T001, T002 and T004 to T008 still carry a
`supervised: approved` header line the plan header no longer admits
(`skills/dev/branch-plan.md § Header`); strip it on the R080 close-out
plan MR/PR. The acceptance criterion on the refused plan names
`/dev code`; reword to `/dev run` there too. From the R080-T008 close
review: the T008 task line above still says a blocker re-dispatches
the planner "with the worker paused" where `skills/dev/run.md
§ Question resolution` halts the item and dispatches a fresh
implementer; `requirements.md § Desired state` 1 still has the
supervisor answering implementation-level questions; the cold read
(`skills/dev/write-plan.md` step 6) needs a stopping rule - two rounds,
then judgment-level gaps go to the findings file - and a plan change
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
release.
