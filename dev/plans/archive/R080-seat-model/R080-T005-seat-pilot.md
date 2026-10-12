---
task: R080-T005
type: mnt
depends-on: R080-T007, R080-T009
cold-read: passed
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

- [x] `run.md § Pre-flight` asks the runner for a value it can produce.
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
  swap plus the cite, the bullet rewrapped to five lines: the cite
  costs more than the swap frees, and no wrapping holds it to four. The
  gained line is affordable and needs no tightening to pay for it: the
  commit "Raise the dev mode-file cap to 350 lines" lifted the line cap
  `scripts/ci/check-caps.sh` enforces on `skills/dev/*.md`, a commit the
  findings file's first note predates, so the bullet's other wording
  stands. The 80-character ceiling beside it still binds, and `bash
  scripts/ci/check-caps.sh` confirms both. The rule's three clauses land
  in `companions/supervisor-runbook.md § Modes by seat` as one paragraph
  after the one closing "a pre-flight defect that nobody clears" and
  before the one opening "That set's never-list", with the fallback
  added to the `Runner` row's `Supervisor: human` cell; companions carry
  neither cap. The mode assertion is
  `scripts/preflight-permissions.sh`, the block under "the mode
  assertion and the never-list".

- [x] `rules/writing-artifacts.md § Bulk edits` settles which
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

- [x] `agents/dev-spec-reviewer.md`, `agents/dev-cold-reader.md`,
  `agents/code-reviewer.md` and `agents/dev-docs-verifier.md` each
  state the whole verifier bound: toward the checkout the seat is
  read-only - no writes, no file edits, and no git command that moves
  HEAD, switches a branch or changes the working tree - and a probe of
  repo-touching behavior runs in a throwaway repo, where mutating git
  is the probe's own subject, bounded by
  `companions/verification-policy.md § Verifier isolation`. That clause
  bounds where such a probe runs and grants no tool: each seat probes
  within its own `tools:` line, so the spec reviewer's and the cold
  reader's `tools: Read, Bash` admit a fixture their Bash builds and no
  `Write`-built one, and
  `dev-docs-verifier.md § Probing`'s heredoc-versus-`Write` sentence
  stays in that file alone as the note of the one seat holding `Write`.
  The cold reader's "You write nothing" is bounded by its own text to
  the plan file and its findings file and so does not reach a fixture
  outside the checkout. Each file
  names the throwaway repo and cites the section for its terms rather
  than restating them: the scrubbed git environment the section
  specifies - `GIT_DIR`, `GIT_WORK_TREE` and `GIT_INDEX_FILE` unset -
  stays there, its one home (`rules/writing-artifacts.md § One home
  per finding`), and the cite is the shape
  `dev-docs-verifier.md § Probing` already uses. Today the bound
  exists in halves and in two files. `code-reviewer.md`'s conduct
  paragraph carries the read-only clauses and the HEAD-moving git list
  and stops there, with no probing clause and no § Verifier isolation
  cite;
  `dev-docs-verifier.md § Probing` carries the throwaway repo, that
  cite and the shorter "toward the checkout you stay read-only", and
  nothing of the git list - the clause a review seat's `git checkout
  main` into the live dirty checkout motivated in the pilot run. The
  other two hold `Bash` and carry neither half: the spec reviewer says
  only "Verify by reading code", the cold reader "You write nothing",
  of the plan file and its findings file. So each of the four gains the
  half it lacks, and the docs verifier's `Write` tool and its fixture's
  own git survive, the bound being written toward the checkout. The
  definition is the home: it carries what holds
  on every dispatch (`requirements.md § Desired state` 10), so the
  leaving's "no verifier's dispatch companion repeats it" closes across
  all four verifier-class seats and drops from `tasks.md`. The fourth
  file costs no budget: `scripts/ci/check-caps.sh` caps `CLAUDE.md`,
  `DESIGN.md`, the skill bodies and `skills/dev/*.md`, and nothing
  under `agents/`.
  Approach: the text that travels is `agents/code-reviewer.md`'s
  conduct paragraph from "You are read-only toward the repo" on - the
  `(checkout/switch/reset/restore/stash)` parenthetical and the "read
  state with `git diff`/`log`/`show` only" clause included - plus
  `agents/dev-docs-verifier.md § Probing`'s throwaway repo, closing on
  the § Verifier isolation cite; that paragraph's opening "You work
  alone" sentence is a dispatch bound rather than the verifier bound
  and does not travel, nor does § Probing's "The fixture lives outside
  the checkout" half, which the cite already carries as "never against
  the live repo" (`rules/writing-artifacts.md § One home per finding`).
  In `dev-cold-reader.md`, that text as a `**Reading the repo.**`
  paragraph immediately before `**Config.**`.
  In `dev-spec-reviewer.md` the same text is appended to the existing
  `**Verify by reading code.**` paragraph rather than set beside it,
  that paragraph already ruling how the seat reads the repo, and its
  Read-tool and plain-`git show` sentence standing in for the
  read-state clause rather than being followed by it. In
  `code-reviewer.md`, the
  probing clause and that cite appended to its conduct paragraph; in
  `dev-docs-verifier.md`, § Probing's closing sentence rewritten to
  carry the full read-only clause - the no-writes half and the git
  list - in place of its shorter "toward the checkout you stay
  read-only", its fixture half kept, and its opening sentence gaining
  the probe's-own-subject clause it lacks, so the four carry the same
  bound. Then strike from
  `tasks.md` the sentence opening "`companions/verification-policy.md
  § Verifier isolation` binds every verifier".

- [x] `requirements.md § Acceptance criteria` carries criteria 1 and 3
  marked and evidenced, in the `[x]` plus `Evidence:` shape
  `dev/plans/archive/R072-workflow-slim/requirements.md` uses, and
  criterion 2 reworded but unmarked. Criterion 2 loses the retired
  command: it names `/dev run`'s resolve step once, the unattended
  flow having retired into it, which is the reword
  `tasks.md`'s backlog rules ("reword to `/dev run` there too"). Its
  verification, a dry run on a plan lacking the record, is not
  something the pilot produced: each record-less window on that branch
  - opened by a planner change dropping the record and closed by the
  bookkeeping commit restoring it (`run.md § Question resolution`), one
  such pair being "Reopen R080-T007 for the & substitution defect" and
  "Record the cold-read pass for the reopened items" - holds plan-text
  commits alone and no implementer dispatch,
  so the branch evidences `run.md § Resolve` 1 obeyed and no refusal,
  and a criterion asking for a refusal is not evidenceable from this
  run. The dry run stays owed, and a backlog line carries it to the R's
  close-out. Criterion 1's evidence is the grep over `CLAUDE.md`,
  `rules/`, `skills/` and `scripts/ci/` for the four retired commands
  and the three retired declaration keys, which returns nothing.
  Criterion 3's is
  `R080-T007-perm-preflight.md`'s `cold-read: passed` header, the
  commit that recorded it - "Record R080-T007's cold read and its open
  notes", on the plan MR/PR that carried the read the plan was approved
  on, the record being the session's bookkeeping rather than plan text
  (`run.md § Question resolution`), and the later planner changes that
  dropped and re-earned it being a cycle the criterion does not reach -
  the doc-writer commit "Document the permission pre-flight and guard
  shapes", and the doc target no implementer dispatch can name
  (`companions/implementer-prompt.md`, its input set;
  `agents/dev-implementer.md § Conventions`, where the docs are inputs).
  Approach: run each check before its line is written - the grep, `git
  log` over PR #540's commits and over the plan MR/PR's, which is where
  the record commit sits, the header read - and write only what the
  run returns. The plan MR/PR is PR #536, resolved with `git log
  --merges --grep "#536"` and confirmed by the record commit sitting in
  the range between that merge's two parents; the evidence line names
  both runs by number, a bare description being no durable id. In
  `requirements.md § Acceptance criteria`, the
  criterion 2 rewording, then the two marks with an `Evidence:` line
  under each, indented as the R072 file has them. Then in `tasks.md`,
  replace the spent sentence "The acceptance criterion on the refused
  plan names `/dev code`; reword to `/dev run` there too." in the
  paragraph opening "Backlog: R080-T001" with the dry run criterion 2
  still owes, that paragraph being where the close-out's bookkeeping
  already sits. Cite the pilot's commits by subject, never by hash
  (`rules/writing-artifacts.md § Name
  things by their durable id`), and the run itself as PR #540.

- [x] Criteria 4 to 6 are marked and evidenced in the same shape.
  Criterion 4's evidence is the four dispatch companions -
  `companions/planner-prompt.md`, `implementer-prompt.md`,
  `spec-reviewer-prompt.md` and `doc-writer-prompt.md` - each read
  against `requirements.md § Desired state` 4, every one carrying an
  `## Inputs` block that its prose calls the seat's whole set. Criterion
  5's is the pilot plan file's history over the commits PR #540
  merged, the set pinned as the range between that merge commit's
  first and second parents - the branch as merged, which carries the
  plan-MR/PR-era commits that opened it, from "Settle R080-T007's
  fourth reason line and tier read" through "Record R080-T007's
  cold-read pass and last notes" - six that `gh pr view 540`'s commit
  list need not carry, and that the range settles in. Those commits
  sort into four classes and no fifth. Planner commits carry no code
  and hold every acceptance-text change. Implementer commits carry the
  code, their approach edits riding it, and the one change above an
  `Approach:` run-in such a commit makes is its own `[ ]` to `[x]`
  mark, which `requirements.md § Desired state` 7 leaves to it - the
  split `run.md § Seats` assigns. The runner's mandatory final commit
  (`run.md § Close` 4) carries no code either and changes the final
  item, which has no `Approach:` run-in and so reads wholly as
  acceptance: its `[x]` and the plan-complete and task marks
  `branch-plan.md § Closing routine` 7 assigns the runner, plus, in the
  first of the pilot's two final commits - the reopening gave it a
  second - one stale line-number cite corrected in the same item. That
  correction is the third class's only
  content beyond the assigned marks, and the criterion is marked rather
  than halted on it: it changes nothing the item must deliver, and a
  stale line cite is a class R080's backlog already holds open ("An
  approach's line cites go stale against the code they name"). The
  evidence line names it rather than hiding it, as criterion 8's names
  its exposure. The fourth class is the runner's bookkeeping commits,
  several of them in that range: each carries no code and no
  acceptance text, its whole plan-file change being the
  `cold-read: passed` header key a planner change dropped and the
  re-run read re-earned; `run.md § Question resolution` puts that
  record in the runner's own bookkeeping commit on the item's branch,
  which is why no planner commit carries it. The key is the
  session's record rather than plan text, on those commits and on the
  final commit carrying it beside its `[x]`, so neither reads as an
  acceptance change against the criterion. No
  commit on the branch names its
  seat, `git-workflow.md § Commit messages` admitting no trailer, so the
  evidence line claims the shape and no writer beyond it. Criterion 6's
  is the grep over `rules/`, `skills/` and `scripts/ci/` returning no
  rule that names a
  project's docs, plans or session tree by a literal path -
  `git ls-files dev/docs` is empty and `dev/docs` survives only in
  `migrate.md` and `companions/root-migration.md` as a migration
  source. Two further hit classes the grep returns are admitted, both
  by `companions/declarations.md § Declared paths`: that section's own
  `- Docs:` / `- Plans:` / `- Session:` block, which it calls their
  one home, and the `P=${P:-dev/plans}` line in
  `check-plan-integrity.sh`, `check-archival.sh`,
  `check-accretion.sh` and `check-batch-tags.sh`, each the one default
  that section lets a reading script carry as the fallback of its
  read. The grep's pattern is the implementer's and so is its hit set,
  which is why the hits are judged by a predicate rather than by a
  class list: a hit fails the criterion only where it is a rule or a
  check sending a seat or a script to a live project's docs, plans or
  session tree by a literal path instead of through the declaration.
  A hit naming a pre-declaration layout as a migration source
  (`skills/dev/migrate.md`, `companions/root-migration.md`), one in a
  comment rather than an instruction (`check-accretion.sh`'s
  `plans/archive/` line), and one naming no project tree at all - a
  URL path or an example filename in a skill outside `skills/dev/` -
  each passes, as the two admitted classes do. The grep runs with the
  installed-project half, which
  `scripts/test/install-dev.test.sh` pins in its case asserting that a
  project's declaration and `LAYOUT.md` survive two installs
  byte-identical, a refresh over a fixture project being the run that
  could fail.
  Approach: run the four reads; the `git log` over the plan file across
  that merge range, the merge commit resolved with `git log --merges
  --grep "#540"`; the criterion-6 literal-path grep over `rules/`,
  `skills/` and `scripts/ci/`; the `dev/docs` grep behind the
  two-file survival claim; and `git ls-files dev/docs` - then the
  installer test case, before writing; the test
  runs through `bash scripts/test/install-dev.test.sh`, whose fixtures
  live outside the checkout. The grep's pattern takes `dev/docs`,
  `dev/plans` and `dev/session`, a bare `docs/`, `plans/` or `session/`
  and `LAYOUT.md`, so the layout axis rides the same run and
  `check-stray.sh`'s `L=${L:-.claude/LAYOUT.md}` lands in the same
  admitted fallback class as the four `P=${P:-dev/plans}` defaults,
  `companions/declarations.md § Declared paths` stating the class by
  the read rather than by the key. Edit `requirements.md § Acceptance
  criteria` alone, three marks and three `Evidence:` lines. Criterion
  5's line names the pinned range as the branch as merged and says the
  detail round that wrote the plan and the earlier plan-MR/PR commits
  sit before it, and it names what the two final commits changed in the
  plan file and in `tasks.md` rather than the acceptance's three-way
  list, the plan file carrying no plan-complete mark beside the `[x]`. Where a
  check returns something the criterion does not admit - a commit
  touching the plan file outside those four classes included - the
  item stops and reports rather than marking (`branch-plan.md § Scope
  discoveries`).

- [x] Criterion 8 is marked and evidenced, and what criterion 7's read
  failed on is recorded in `tasks.md` alone: the duty table gives the
  reviewer no cell, so the criterion fails on the seat axis and the
  backlog line carries that gap. Of the read described below, that
  failing half alone is written down: the passing half evidences no
  criterion, 7 staying unmarked, and a backlog paragraph carries open
  work rather than a verification log.
  `requirements.md` gains nothing under criterion 7 -
  its box stays `[ ]` with no mark and no `Evidence:` line, an
  unevidenced criterion carrying no record of the read that failed it.
  Criterion 7's read is `run.md § Seats`' duty table against
  `requirements.md § Desired state` 6 on both axes - every duty that
  section names has a row and a seat in each mode's cell, the table
  adding the docs row; of the seats it names, the reviewer holds no
  cell, the roster above the table naming the spec reviewer and the
  code reviewer while no row assigns reading a diff against an item's
  acceptance - plus the grep of the seat names across `skills/dev/`
  returning no duty statement that cites no table. The hole is not
  inert, and the backlog line records that with it: `run.md § Seats`
  has a run reaching a duty the table leaves unassigned halt and
  report, never improvise, so on the criterion's reading every spec
  check the flow dispatches (`run.md § Dispatch per item` 3) reaches
  one, this branch's included, and the live flow has been improvising
  past that sentence since the table landed. Closing it is still the
  R080 close-out's rather than this branch's, and not for the line
  budget - the commit "Raise the dev mode-file cap to 350 lines" left
  `run.md` room the cap check confirms (`bash
  scripts/ci/check-caps.sh`) - but because the row contradicts
  the `**Duties.**` sentence all four verifier-class definitions carry,
  "no cell of the duty table in `skills/dev/run.md § Seats` is yours",
  and `requirements.md § Desired state` 6's own duty list names no
  reviewing duty for the row to hold: what moves - the criterion's seat
  axis, the table, or those definitions - is a ruling, not a one-line
  edit. Criterion 8's evidence is three
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
  duty row recorded in the paragraph opening "Backlog: R080-T001",
  where the close-out's other bookkeeping sits - two sentences, the
  first carrying the hole and the halt sentence it sits under, the
  second naming the three candidates a ruling would move rather than
  ruling among them, which is the acceptance's own settlement. They
  land beside the criterion-2 sentence rather than at the paragraph's
  end, which closes a labelled "From the R080-T008 close review:"
  chain that a sentence appended after it would read into. Where a check other
  than that recorded gap returns something its criterion does not
  admit, the item stops and reports rather than marking
  (`branch-plan.md § Scope discoveries`).

- [x] `tasks.md` names the two things the pilot left with no owner. The
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

- [x] Complete the branch: cleanup (stale/temp data), mark the plan
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

- [x] The probe clause in `agents/dev-spec-reviewer.md`,
  `agents/dev-cold-reader.md`, `agents/code-reviewer.md` and
  `agents/dev-docs-verifier.md` admits only the git the bound it cites
  allows. Each of the four says today that a probe of repo-touching
  behavior runs in a throwaway repo, "where mutating git is the
  probe's own subject", bounded by `companions/verification-policy.md
  § Verifier isolation` - and that section bars destructive git
  (`reset --hard`, `clean`, ref deletion) outright, "cleanup of its own
  mess included - a verifier that needs cleanup stops and reports".
  The two compose only if "mutating" excludes "destructive", which
  neither text says, so each definition grants in its own sentence what
  the cite beside it withdraws. The four definitions narrow and
  § Verifier isolation is not edited: the destructive list is that
  section's one home (`rules/writing-artifacts.md § One home per
  finding`), and the four clauses end up reading identically, as they
  do today (item 3 above). The narrowing costs no probe these seats
  run today: the repo-touching behavior they probe in this repository
  is `hooks/dev-branch-guard.sh`, a `PreToolUse` decision function
  that reads a tool call's JSON on stdin and emits an allow or a deny
  without ever running the command it judges, so a destructive
  spelling is probed as a string, and building its fixture takes
  `init`, `add`, `commit` and `checkout -b`. What some later probe of
  another subject would need is not claimed here and need not be:
  `§ Verifier isolation` bars destructive git whatever the sentence
  beside it says, so the narrowing withdraws nothing the cite left
  standing. Teardown lands in no file - the four clauses gain no
  teardown sentence and `§ Verifier isolation` is not edited, so its
  "a verifier that needs cleanup stops and reports" stands as
  written, over the destructive git it names. That the pilot's
  fixture is torn down with `rm -rf` of a directory outside the
  checkout is stated here as why today's probe reaches for no
  destructive git, never as a rule: a reading meant to bind a seat
  would need a home of its own, and this item gives it none. Item 3's
  acceptance, which quotes the wider clause, keeps its text and its
  mark - it states what its commit delivered, the mark records that
  the commit landed (`branch-plan.md § Body`), and acceptance text is
  no other seat's to edit (`requirements.md § Desired state` 7,
  `run.md § Seats`).
  Approach: one anchored `Edit` per file over that clause, the same
  replacement in all four - "where non-destructive git is the probe's
  own subject", the barred verbs left to the cite rather than
  restated. The clause sits in `dev-spec-reviewer.md`'s `**Verify by
  reading code.**` paragraph, in `dev-cold-reader.md`'s `**Reading the
  repo.**` paragraph, in `code-reviewer.md`'s `**Conduct.**`
  paragraph, and in `dev-docs-verifier.md § Probing`'s opening
  sentence, where it wraps across its lines differently from the other
  three, so each anchor is that file's own wrapping. Re-wrap each
  paragraph to its file's width and re-read it after the edit
  (`rules/writing-artifacts.md § Bulk edits`);
  `scripts/ci/check-caps.sh` caps nothing under `agents/`, so no line
  budget is at stake.

- [x] The two records of the probe-fixture leaving count the seats it
  reaches: three, not two. `tasks.md`'s paragraph opening "Backlog,
  from the R080-T007 close:" closes on a sentence naming
  `agents/dev-spec-reviewer.md` and `agents/dev-cold-reader.md` as the
  seats told to build a probe fixture with `Bash` and never told that
  a shell heredoc carrying JSON or JS trips the harness obfuscation
  guard and stalls the run on a permission prompt; note 14 of
  `dev/plans/R080-seat-model/R080-T005-seat-pilot.findings.md` - "Item
  3: the two seats without `Write` are sent down a route whose hazard
  note stays in another file" - counts the same two.
  `agents/code-reviewer.md` declares `tools: Read, Bash, WebFetch,
  WebSearch`, no `Write`, and item 3 above gave it the same probe
  clause, so it is the third seat on that route. Both places read
  three verifier-class seats and name `agents/code-reviewer.md` beside
  the other two. Nothing else about the leaving moves: it stays the
  R080 close-out's to route, and what R080 rules is still whether the
  warning travels to the seats without `Write` or their fixture route
  changes. Note 14's other claims hold as written and stay - four
  definitions declare `Write` (`dev-planner.md`, `dev-implementer.md`,
  `dev-doc-writer.md`, `dev-docs-verifier.md`), and the heredoc
  sentence sits in `dev-implementer.md` and `dev-docs-verifier.md`
  alone, which is also what `tasks.md`'s "the two definitions that
  route the fixture through `Write`" counts - as does the note's
  quotation of item 3, which rules the spec reviewer's and the cold
  reader's fixture and names no third seat. What is corrected is each
  record's own count of the seats on the route, never a quoted or a
  `Write`-holding count. The findings file's other 17 notes and all 18
  marks are untouched.
  Approach: in `tasks.md`, two anchored `Edit`s at the paragraph's
  close, one per sentence - the sentence naming the seats, whose pair
  of file names becomes three, and the sentence after it, the one the
  paragraph closes on, whose "the two seats without `Write`" becomes
  three. Each anchor is the file's own wrapping rather than the quoted
  clause, which wraps across lines. In the findings file, the same
  correction in note 14's bold title, in its "Whether the warning
  should reach the two Bash-only seats" clause and in its "So the two
  seats without `Write`" sentence, plus the third seat named where
  that last sentence states the consequence, `agents/code-reviewer.md`
  holding `Bash` and no `Write`. The Bash-only clause is reworded
  rather than counted up - that seat holds `WebFetch` and `WebSearch`
  besides `Bash` - and reads "the three seats without `Write`". One
  occurrence at a time, each paragraph re-read after its edit
  (`rules/writing-artifacts.md § Bulk edits`).

- [x] `tasks.md`'s opening order paragraph stops asserting a position
  the file does not hold. It ends "the pilot next, the archival
  promotion last", while the `## Open` list it introduces - the list
  its own opening words, "Order matters", govern - carries
  `R080-T012`, the promotion, above `R080-T013` and `R080-T014`. The
  claim drops rather than the bullet moving: no line of the list
  moves, no mark changes, and `R080-T012`, `R080-T013` and
  `R080-T014` stay `[ ]`. Nothing earlier in the sentence moves
  either: "the pilot next" stands as written, naming the place the
  pilot and its harvest took. `R080-T013` and `R080-T014` gain no
  clause of their own, deliberately - the sentence records the
  sequence the R's merged tasks ran in, those two arrived from the
  pilot's close with no order settled against `R080-T012`, and
  settling one is an ordering decision this item does not make. The
  sentence re-ends on the bound the promotion actually has - `plan.md
  § Archival`, where archival runs at initiative close, a closing task
  promotes but never moves files, and the closing branch's final
  commit carries the whole directory's move to
  `<plans>/archive/R<NNN>-<slug>/` - so what the sentence states is
  that the promotion precedes the R's archival, which holds whatever
  order the task list takes and cannot go stale when R080 gains
  another task. That is the bound `R080-T012`'s own line already
  cites. Item 7 above, whose closing sentence put the ending this
  item drops into the file, keeps its acceptance text and its mark on
  the terms item 9 states: it records what its commit delivered, and
  `tasks.md` is what this item edits, never a delivered item
  (`requirements.md § Desired state` 7, `run.md § Seats`;
  `branch-plan.md § Body`).
  Approach: one anchored `Edit` on the paragraph's closing clause,
  re-wrapped to the file's width and the paragraph re-read after it
  (`rules/writing-artifacts.md § Bulk edits`). The clause reads "the
  archival promotion before the R is archived" and carries no
  `plan.md § Archival` cite of its own: it states the bound in words,
  and the cite's home in this file is the `R080-T012` bullet the order
  paragraph introduces (`writing.md § No repetition`,
  `rules/writing-artifacts.md § One home per finding`). Nothing else in
  `tasks.md` changes: not the list, not the `R080-T012` bullet, not a
  mark.

- [x] Complete the branch: cleanup (stale/temp data), mark the plan
  complete, `R080-T005` `[x]` in `tasks.md`, commit. This is the
  branch's second final commit, the three items above being a
  reopening after the first, which `branch-plan.md § Scope changes
  mid-branch` closes with a new final commit of its own. The task mark
  is asserted rather than flipped: `R080-T005` reads `[x]` from the
  first final commit and the reopening does not clear it, whether a
  reopening should clear the mark being a question the R080 backlog
  holds open against `§ Scope changes mid-branch`. The R080 closure
  check does not run here either: `R080-T012` stays open, so no
  ROADMAP mark and no archive move ride this branch and the R stays
  open on its own evidence (`plan.md § Approval and closure`, `plan.md
  § Archival`).
  Approach: `branch-plan.md § Closing routine`'s mandatory final item,
  quoted at step 7 - cleanup, the plan complete, the task mark, the
  commit - is this item's whole executable part, the task mark last;
  the routine's close review, findings-triage prompts and doc-writer
  pass are dispatches no seat makes. The findings file's five open
  notes are triaged as the close ruled: two closed as delivered, one
  discarded won't-fix, and two promoted as one sentence appended to
  `tasks.md`'s paragraph opening "Backlog, from the R080-T007 close:"
  rather than as a task line, a new task id being a planning decision.
  Stage by name - this plan file, the initiative's `tasks.md` and this
  branch's findings file, which that triage is the only edit to - so
  the commit leaves no modified tracked file behind and sweeps in no
  untracked path. `bash scripts/ci/run-all.sh` green before the commit,
  as it is before every commit on the branch (`branch-plan.md
  § Rails`).
