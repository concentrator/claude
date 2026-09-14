---
task: R080-T005
type: mnt
depends-on: R080-T007, R080-T009
---

# R080-T005: harvest the pilot run

Branch: `mnt/seat-pilot`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Acceptance criteria`.

R080-T007 was the pilot. It ran the seat flow end to end in this
repository under `Supervisor: AI` and delivered as PR #540: permission
pre-flight, cold reads, planner re-dispatches for acceptance changes,
implementer and spec-check cycles, a doc-writer pass through its
verification gate, a close review, a reopening under `branch-plan.md
§ Scope changes mid-branch`, and a supervised merge. This branch
harvests that run - three defects it surfaced fixed where a seat reads
them, R080's acceptance criteria evidenced from it, and the R's
remaining close-out work named as a task. No second run is staged.

- [ ] `run.md § Pre-flight` asks the runner for a value it can produce.
  The pre-flight invocation's `--runner-mode` argument reads `<the
  declared mode>` where it reads `<the runner's launch mode>` today,
  and `companions/supervisor-runbook.md § Modes by seat` states that
  the runner passes the mode its own table gives it: the value is
  self-attested, no session reading its own launch flags, and a runner
  that cannot state one passes `unknown`, which fails the permission
  mode assertion under `Supervisor: AI` and is ignored under
  `Supervisor: human`. Today the placeholder reads as an instruction to
  observe the host, which nothing in a seat's or a session's inputs
  provides, and the value decides the run:
  `scripts/preflight-permissions.sh` asserts `auto` under
  `--supervisor AI` and exits non-zero otherwise, so a wrong value
  either stops a sound run or drops the assertion a promptless run
  rests on. The rule exists only
  in `R080-T007-perm-preflight.md`'s approach text, which archives with
  the R (`plan.md § Archival`), leaving the flow no home for it.
  Approach: in `run.md § Pre-flight`'s first bullet, replace the
  placeholder in place - `run.md` stands at the 300-line cap
  `scripts/ci/check-caps.sh` enforces on `skills/dev/*.md`, with the
  80-character line ceiling beside it, so the edit adds no line and
  the new text is shorter than the old. The sentence itself lands at
  the end of `companions/supervisor-runbook.md § Modes by seat`, after
  the paragraph closing "a pre-flight defect that nobody clears";
  companions carry no cap. The mode assertion is
  `scripts/preflight-permissions.sh`, the block under "the mode
  assertion and the never-list".

- [ ] `rules/writing-artifacts.md § Bulk edits` settles which
  instruction wins where a host or session injection directs a seat to
  change files with `sed`, heredocs or a short script: on Markdown this
  rule stands, and a seat meeting both follows it and owes its
  dispatcher no report of the conflict. The rule file is the home
  because a dispatched seat's context carries it whenever Markdown is
  read or edited, so one sentence reaches every seat where seven
  definitions would not. Two backlog leavings close with it and drop
  from `tasks.md`: the R080-T010 planning act's "no rule says which
  instruction wins", and the R080-T007 close's rediscovery tax, whose
  own proposal named § Bulk edits as one of the two candidate homes.
  Approach: two sentences at the end of `rules/writing-artifacts.md
  § Bulk edits`, stating the precedence and that following it needs no
  report. In `dev/plans/R080-seat-model/tasks.md`, strike the first
  clause of the sentence opening "From the R080-T010 planning act:",
  re-heading the sentence on its surviving clause about a cite to a
  sentence that wraps, and strike the whole sentence opening "The
  auto-mode instruction a session injects". Anchored `Edit` calls, one
  occurrence at a time, and the paragraph re-read after each
  (`rules/writing-artifacts.md § Bulk edits`).

- [ ] `agents/dev-spec-reviewer.md` and `agents/dev-cold-reader.md`
  state the bound `agents/code-reviewer.md`'s conduct paragraph and
  `agents/dev-docs-verifier.md § Probing` already carry: the seat is
  read-only toward the checkout, runs no git that moves HEAD, switches
  a branch or changes the working tree, and probes repo-touching
  behavior only in a throwaway tree with `GIT_DIR`, `GIT_WORK_TREE` and
  `GIT_INDEX_FILE` unset (`companions/verification-policy.md
  § Verifier isolation`). Both hold `Bash` and say only "You read",
  which is what left the bound to hand-written dispatch text after a
  review seat ran `git checkout main` against the dirty live checkout
  in the pilot run. The definition is the home: it carries what holds
  on every dispatch (`requirements.md § Desired state` 10), so the
  leaving's "dispatch text doing work a seat companion could do once"
  closes in `tasks.md` with the two files.
  Approach: in each of the two definitions, a `**Reading the repo.**`
  paragraph immediately before `**Config.**`, its wording taken from
  `agents/code-reviewer.md`'s conduct paragraph and closing on the
  § Verifier isolation cite, so the two read alike. Then strike from
  `tasks.md` the sentence opening "`companions/verification-policy.md
  § Verifier isolation` binds every verifier".

- [ ] `requirements.md § Acceptance criteria` carries criteria 1 to 3
  marked and evidenced, in the `[x]` plus `Evidence:` shape
  `dev/plans/archive/R072-workflow-slim/requirements.md` uses. Criterion
  2 loses the retired command first: it names `/dev run`'s resolve step
  once, the unattended flow having retired into it, which is the reword
  `tasks.md § Backlog` rules ("reword to `/dev run` there too"), and its
  verification clause names the refusal the pilot produced in place of a
  dry run, a live refusal being the run that could have failed
  (`companions/verification-policy.md § Verification modality`) and no
  plan lacking the record outliving the R. Criterion 1's evidence is the
  grep over `CLAUDE.md`, `rules/`, `skills/` and `scripts/ci/` for the
  four retired commands and the three retired declaration keys, which
  returns nothing. Criterion 2's is the pilot branch's own sequence: a
  planner change dropping the record (the commit "Reopen R080-T007 for
  the & substitution defect"), the runner's bookkeeping commit restoring
  it ("Record the cold-read pass for the reopened items"), and only then
  the next implementer commit - `run.md § Resolve` 1 being the step that
  holds the dispatch back until the record stands. Criterion 3's is
  `R080-T007-perm-preflight.md`'s `cold-read: passed` header, the
  doc-writer commit "Document the permission pre-flight and guard
  shapes", and the doc target no implementer dispatch can name
  (`companions/implementer-prompt.md`, its input set;
  `agents/dev-implementer.md § Conventions`, where the docs are inputs).
  Approach: run each check before its line is written - the grep, `git
  log` over PR #540's commits, the header read - and write only what the
  run returns. Edit `requirements.md § Acceptance criteria` alone: the
  criterion 2 rewording, then the three marks with an `Evidence:` line
  under each, indented as the R072 file has them. Cite the pilot's
  commits by subject, never by hash (`rules/writing-artifacts.md § Name
  things by their durable id`), and the run itself as PR #540.

- [ ] Criteria 4 to 6 are marked and evidenced in the same shape.
  Criterion 4's evidence is the four dispatch companions -
  `companions/planner-prompt.md`, `implementer-prompt.md`,
  `spec-reviewer-prompt.md` and `doc-writer-prompt.md` - each read
  against `requirements.md § Desired state` 4, every one carrying an
  `## Inputs` block that its prose calls the seat's whole set. Criterion
  5's is the pilot plan file's history across PR #540: each change above
  an item's `Approach:` run-in rides a planner commit, approach edits
  ride the implementer commits that carry their code, which is the
  split `run.md § Seats` assigns. Criterion 6's is the grep over
  `rules/`, `skills/` and `scripts/ci/` returning no rule that names a
  project's docs, plans or session tree by a literal path -
  `git ls-files dev/docs` is empty and `dev/docs` survives only in
  `migrate.md` and `companions/root-migration.md` as a migration
  source - together with the installed-project half, which
  `scripts/test/install-dev.test.sh` pins in its case asserting that a
  project's declaration and `LAYOUT.md` survive two installs
  byte-identical, a refresh over a fixture project being the run that
  could fail.
  Approach: run the four reads, the `git log` over the plan file and
  both greps, then the installer test case, before writing; the test
  runs through `bash scripts/test/install-dev.test.sh`, whose fixtures
  live outside the checkout. Edit `requirements.md § Acceptance
  criteria` alone, three marks and three `Evidence:` lines. Where a
  check returns something the criterion does not admit, the item stops
  and reports rather than marking (`branch-plan.md § Scope
  discoveries`).

- [ ] Criteria 7 and 8 are marked and evidenced, closing the set.
  Criterion 7's evidence is `run.md § Seats`' duty table read against
  `requirements.md § Desired state` 6 - every duty that section names
  has a row and a seat in each mode's cell, the table adding the docs
  row - plus the grep of the seat names across `skills/dev/` returning
  no duty statement that cites no table. Criterion 8's is three
  tree-verifiable halves: `bash scripts/preflight-permissions.sh
  --project . --supervisor AI --runner-mode auto` exits 0 with no gap
  line, which is the re-run reporting none; the gaps the pilot's
  pre-flight named were closed in the declared set, by the commits
  "Declare the verbs the flow already runs" and "Declare the checkpoint
  push under carve-out pattern 1"; and no item of the pilot halted on a
  prompt, its plan carrying every item `[x]` and its one reopening
  naming a shell substitution defect, where a prompt outside the
  declared set is a pre-flight defect that halts the item and nobody
  clears (`run.md § Dispatch per item`). The evidence line for 8 names
  the exposure the close recorded rather than hiding it: commands a
  `/dev run` reaches that no declared string covers, which raise no
  prompt under `auto`, since it suspends Bash allow rules
  (`companions/supervisor-runbook.md § Modes by seat`), and are a
  `Supervisor: human` exposure the R080 backlog holds open.
  Approach: run the pre-flight without `--apply` - never with it - and
  the seat-name grep; read the table and § Desired state 6 side by
  side. Edit `requirements.md § Acceptance criteria` alone, two marks
  and two `Evidence:` lines.

- [ ] `tasks.md` names the two things the pilot left with no owner. The
  archival promotion its own § Archival paragraph specifies - the host
  facts moving to `docs/references/claude-code-host.md` with the probe
  runs under `docs/reports/`, a promotion that creates the declared docs
  home - becomes `R080-T012 [doc]`, since `plan.md § Archival` requires
  every promotion before the R's directory moves and a multi-commit
  deliverable is a task rather than a commit item (`plan.md § Levels`);
  the task line cites that paragraph rather than restating it, and the
  docs it ships are a doc-writer seat's on its own branch
  (`branch-plan.md § Commit cadence` 2). The second is a backlog line:
  the deferred cold-read record's mechanics are assembled from three
  files - `write-plan.md` step 6 for which change drops the record and
  what the second read ends, `run.md § Question resolution` for the
  bookkeeping commit that restores it, and `agents/dev-planner.md` for
  the planner's half - so a run needing the whole rule reads all three,
  and what R080 rules is whether one of them states it once and the
  others cite it.
  Approach: add the `R080-T012` bullet to `tasks.md § Open` after
  `R080-T005`, in the shape of the lines above it, tagged `[doc]` and
  citing the "Archival, promotion target" paragraph; append the backlog
  sentence to the paragraph opening "Backlog, from the R080-T007
  close:", where the run's other leavings sit.

- [ ] Complete the branch: cleanup (stale/temp data), mark the plan
  complete, mark `R080-T005` `[x]` in `tasks.md`, commit. The R080
  closure check does not run here: `plan.md § Approval and closure`
  runs it on the branch completing the R's last open task, and the
  item above leaves `R080-T012` open, so no ROADMAP mark and no archive
  move ride this branch and the R stays open on its own evidence
  (`plan.md § Archival`). `run.md § Boundary verification` 5 binds a
  batch closing an R, not this task-scoped run, and the close-out plan
  MR/PR it and `tasks.md § Backlog` name is where the R's remaining
  bookkeeping lands - the `supervised: approved` header lines the
  backlog lists among them.
  Approach: `branch-plan.md § Closing routine` in order, the task mark
  last; the findings file, if the branch opened one, is triaged and
  committed with it.
