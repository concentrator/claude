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
them, R080's acceptance criteria evidenced from it where it reaches
them, and the R's remaining close-out work named as a task. No second
run is staged.

- [ ] `run.md § Pre-flight` asks the runner for a value it can produce.
  The pre-flight invocation's `--runner-mode` argument reads `<the
  declared mode>` where it reads `<the runner's launch mode>` today and
  carries a cite to `companions/supervisor-runbook.md § Modes by seat`,
  which `run.md` names nowhere, so "declared" cannot read as the
  `Supervisor:` line that the same invocation's `--supervisor
  <declared>` already takes. That section states that the runner passes
  the mode its own table gives it: the value is self-attested, no
  session reading its own launch flags, and a runner
  that cannot state one passes `unknown`, which fails the permission
  mode assertion under `Supervisor: AI` and is ignored under
  `Supervisor: human`. The table gains no row - `unknown` is no seat -
  and the fallback lands in the `Runner` row's `Supervisor: human`
  cell, whose "the user's session's own mode" is the value no session
  can read. Today the placeholder reads as an instruction to
  observe the host, which nothing in a seat's or a session's inputs
  provides, and the value decides the run:
  `scripts/preflight-permissions.sh` asserts `auto` under
  `--supervisor AI` and exits non-zero otherwise, so a wrong value
  either stops a sound run or drops the assertion a promptless run
  rests on. The rule exists only
  in `R080-T007-perm-preflight.md`'s approach text, which archives with
  the R (`plan.md § Archival`), leaving the flow no home for it.
  Approach: in `run.md § Pre-flight`'s first bullet, the placeholder
  swap plus the cite, the bullet rewrapped to its present four lines -
  `run.md` stands at the 300-line cap `scripts/ci/check-caps.sh`
  enforces on `skills/dev/*.md`, with the 80-character line ceiling
  beside it, so the edit adds no line. The swap frees 7 characters and
  tightening "reports every rule with the tier carrying it" to "reports
  each rule's tier" pays for the rest; `bash scripts/ci/check-caps.sh`
  confirms. The rule's three clauses land in
  `companions/supervisor-runbook.md § Modes by seat` as one paragraph
  after the one closing "a pre-flight defect that nobody clears" and
  before the one opening "That set's never-list", with the fallback
  added to the `Runner` row's `Supervisor: human` cell; companions carry
  neither cap. The mode assertion is
  `scripts/preflight-permissions.sh`, the block under "the mode
  assertion and the never-list".

- [ ] `rules/writing-artifacts.md § Bulk edits` settles which
  instruction wins where a host or session injection directs a seat to
  change files with `sed`, heredocs or a short script: on Markdown this
  rule stands, and a seat meeting both follows it and owes its
  dispatcher no report of the conflict. The rule file is the home
  because a dispatched seat's context carries it whenever Markdown is
  read or edited, so one sentence reaches every seat where seven
  definitions would not. The R080-T007 close's rediscovery tax closes
  with it and drops from `tasks.md`, its own proposal having named
  § Bulk edits as one of the two candidate homes. The R080-T010
  planning act's leaving narrows rather than closes: § Bulk edits
  settles Markdown, which is what its opening line binds, while that
  leaving records the same conflict against each prompt companion's
  "edit with Read/Edit/Write, never `sed`/`cat`/`awk`", which no file
  class bounds, so the question stands for every other file class and
  the leaving keeps that half.
  Approach: two sentences at the end of `rules/writing-artifacts.md
  § Bulk edits`, stating the precedence and that following it needs no
  report. In `dev/plans/R080-seat-model/tasks.md`, reword the first
  clause of the sentence opening "From the R080-T010 planning act:" to
  drop its `rules/writing-artifacts.md § Bulk edits` half and bound
  what stays open to files outside Markdown, leaving its second clause
  about a cite to a sentence that wraps as it is, and strike whole the
  sentence opening "The auto-mode instruction a session injects".
  Anchored `Edit` calls, one
  occurrence at a time, and the paragraph re-read after each
  (`rules/writing-artifacts.md § Bulk edits`).

- [ ] `agents/dev-spec-reviewer.md`, `agents/dev-cold-reader.md` and
  `agents/code-reviewer.md` each state the whole verifier bound, which
  `agents/dev-docs-verifier.md` alone carries today across its conduct
  and its § Probing: the seat is read-only toward the checkout, runs
  no git that moves HEAD, switches
  a branch or changes the working tree, and probes repo-touching
  behavior only in a throwaway tree with `GIT_DIR`, `GIT_WORK_TREE` and
  `GIT_INDEX_FILE` unset (`companions/verification-policy.md
  § Verifier isolation`). The first two hold `Bash` and say only "You
  read", which is what left the bound to hand-written dispatch text
  after a review seat ran `git checkout main` against the dirty live
  checkout in the pilot run. The code reviewer is in scope for the
  probing half alone: its conduct paragraph carries the read-only
  clauses and stops there, while it holds `Bash`, runs at every branch
  close and at batch close (`run.md § Seats`), and checks changed
  claims against ground truth, which is § Verifier isolation's own
  case. The definition is the home: it carries what holds
  on every dispatch (`requirements.md § Desired state` 10), so the
  leaving's "no verifier's dispatch companion repeats it" closes across
  all four verifier-class seats and drops from `tasks.md`.
  Approach: in `dev-spec-reviewer.md` and `dev-cold-reader.md`, a
  `**Reading the repo.**` paragraph immediately before
  `**Config.**`, composed from the two
  halves that exist - `agents/code-reviewer.md`'s conduct clauses and
  `agents/dev-docs-verifier.md § Probing`'s throwaway tree - and
  closing on the § Verifier isolation cite; in `code-reviewer.md`, the
  probing clause and that cite appended to its conduct paragraph, so
  the three read alike. Then strike from
  `tasks.md` the sentence opening "`companions/verification-policy.md
  § Verifier isolation` binds every verifier".

- [ ] `requirements.md § Acceptance criteria` carries criteria 1 and 3
  marked and evidenced, in the `[x]` plus `Evidence:` shape
  `dev/plans/archive/R072-workflow-slim/requirements.md` uses, and
  criterion 2 reworded but unmarked. Criterion 2 loses the retired
  command: it names `/dev run`'s resolve step once, the unattended
  flow having retired into it, which is the reword
  `tasks.md`'s backlog rules ("reword to `/dev run` there too"). Its
  verification, a dry run on a plan lacking the record, is not
  something the pilot produced: the one record-less window on that
  branch - opened by the planner commit "Reopen R080-T007 for the &
  substitution defect" and closed by the bookkeeping commit "Record the
  cold-read pass for the reopened items" - held no implementer dispatch,
  so the branch evidences `run.md § Resolve` 1 obeyed and no refusal,
  and a criterion asking for a refusal is not evidenceable from this
  run. The dry run stays owed, and a backlog line carries it to the R's
  close-out. Criterion 1's evidence is the grep over `CLAUDE.md`,
  `rules/`, `skills/` and `scripts/ci/` for the four retired commands
  and the three retired declaration keys, which returns nothing.
  Criterion 3's is
  `R080-T007-perm-preflight.md`'s `cold-read: passed` header, the
  doc-writer commit "Document the permission pre-flight and guard
  shapes", and the doc target no implementer dispatch can name
  (`companions/implementer-prompt.md`, its input set;
  `agents/dev-implementer.md § Conventions`, where the docs are inputs).
  Approach: run each check before its line is written - the grep, `git
  log` over PR #540's commits, the header read - and write only what the
  run returns. In `requirements.md § Acceptance criteria`, the
  criterion 2 rewording, then the two marks with an `Evidence:` line
  under each, indented as the R072 file has them. Then in `tasks.md`,
  replace the spent sentence "The acceptance criterion on the refused
  plan names `/dev code`; reword to `/dev run` there too." in the
  paragraph opening "Backlog: R080-T001" with the dry run criterion 2
  still owes, that paragraph being where the close-out's bookkeeping
  already sits. Cite the pilot's commits by subject, never by hash
  (`rules/writing-artifacts.md § Name
  things by their durable id`), and the run itself as PR #540.

- [ ] Criteria 4 to 6 are marked and evidenced in the same shape.
  Criterion 4's evidence is the four dispatch companions -
  `companions/planner-prompt.md`, `implementer-prompt.md`,
  `spec-reviewer-prompt.md` and `doc-writer-prompt.md` - each read
  against `requirements.md § Desired state` 4, every one carrying an
  `## Inputs` block that its prose calls the seat's whole set. Criterion
  5's is the pilot plan file's history across PR #540: acceptance text
  changes land in commits that carry no code, approach edits ride the
  implementer commits that carry theirs, and the one change above an
  `Approach:` run-in an implementer commit makes is its own `[ ]` to
  `[x]` mark, which `requirements.md § Desired state` 7 leaves to it -
  the split `run.md § Seats` assigns. No commit on the branch names its
  seat, `git-workflow.md § Commit messages` admitting no trailer, so the
  evidence line claims the shape and no writer beyond it. Criterion 6's
  is the grep over `rules/`, `skills/` and `scripts/ci/` returning no
  rule that names a
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

- [ ] Criterion 8 is marked and evidenced, and criterion 7's read is
  recorded unmarked: the duty table gives the reviewer no cell, so the
  criterion fails on the seat axis and `tasks.md` carries the gap.
  Criterion 7's read is `run.md § Seats`' duty table against
  `requirements.md § Desired state` 6 on both axes - every duty that
  section names has a row and a seat in each mode's cell, the table
  adding the docs row; of the seats it names, the reviewer holds no
  cell, the roster above the table naming the spec reviewer and the
  code reviewer while no row assigns reading a diff against an item's
  acceptance - plus the grep of the seat names across `skills/dev/`
  returning no duty statement that cites no table. The missing row is
  one line and `run.md` stands at its 300-line cap, so adding it is the
  R080 close-out's, not this branch's. Criterion 8's evidence is three
  tree-verifiable parts: `bash scripts/preflight-permissions.sh
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
  side. In `requirements.md § Acceptance criteria`, criterion 8's mark
  and its `Evidence:` line; then in `tasks.md`, the reviewer's missing
  duty row appended to the paragraph opening "Backlog: R080-T001",
  where the close-out's other bookkeeping sits. Where a check other
  than that recorded gap returns something its criterion does not
  admit, the item stops and reports rather than marking
  (`branch-plan.md § Scope discoveries`).

- [ ] `tasks.md` names the two things the pilot left with no owner. The
  archival promotion its own § Archival paragraph specifies - the host
  facts moving to `docs/references/claude-code-host.md` with the probe
  runs under `docs/reports/`, a promotion that creates the declared docs
  home - becomes `R080-T012 [doc]`, since `plan.md § Archival` requires
  every promotion before the R's directory moves and a multi-commit
  deliverable is a task rather than a commit item (`plan.md § Levels`);
  the task line cites that paragraph rather than restating it, and the
  docs it ships are a doc-writer seat's on its own branch
  (`branch-plan.md § Commit cadence` 2). The new line ends "Depends on
  R080-T005." as every sibling but `R080-T004` ends on its dependency:
  the promotion reads the backlog paragraphs this branch rewrites, and
  it is the last task the R holds open. The file's opening order
  paragraph ends "the pilot last", which a task after `R080-T005`
  falsifies, so it ends on the promotion instead. The second thing is
  a backlog line:
  the deferred cold-read record's mechanics are assembled from three
  files - `write-plan.md` step 6 for which change drops the record and
  what the second read ends, `run.md § Question resolution` for the
  bookkeeping commit that restores it, and `agents/dev-planner.md` for
  the planner's half - so a run needing the whole rule reads all three,
  and what R080 rules is whether one of them states it once and the
  others cite it.
  Approach: add the `R080-T012` bullet to `tasks.md § Open` after
  `R080-T005`, in the shape of the lines above it, tagged `[doc]`,
  citing the "Archival, promotion target" paragraph and closing on its
  `Depends on` line; re-end the opening order paragraph's sentence on
  the promotion, replacing "the pilot last"; append the backlog
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
  MR/PR it and `tasks.md`'s backlog paragraphs name is where the R's
  remaining bookkeeping lands - the `supervised: approved` header lines the
  backlog lists among them.
  Approach: `branch-plan.md § Closing routine` in order, the task mark
  last; the findings file, if the branch opened one, is triaged and
  committed with it.
