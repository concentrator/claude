---
task: R080-T010
type: mnt
depends-on: R080-T006
cold-read: passed
---

# R080-T010: seat agent definitions

Branch: `mnt/seat-definitions`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 10, bounded
by 1, 6, 7 and 8 and by `§ Invariants`.

Every seat gets one home for what holds on every dispatch and one for
what holds of a single dispatch. The agent file under `agents/` carries
the name, the description, the tools the seat may use, its model, its
effort and its standing conduct, and cites the duties it holds. The
prompt companion carries that dispatch's inputs, the exit contract and
the report format. `run.md § Seats` names every seat once in workflow
terms and cites both homes rather than restating either.

Decisions the items rest on, each homed in the item that writes it:

- **The roster is seven dispatched seats.** Four dispatch from a prompt
  companion today - planner, implementer, spec reviewer, doc writer -
  and three dispatch without one: the cold reader
  (`companions/verification-policy.md § Comprehension check`), the docs
  gate's verifier (`companions/documentation.md § Verification gate`)
  and the code reviewer (`run.md § Close` 1, `§ Batch close` 1), which
  already has `agents/code-reviewer.md`. All seven get a definition:
  each is a dispatched agent with a fixed input set, so each is what
  `§ Desired state` 8's declared permission set resolves against, and
  the docs verifier holds a model value today that has nowhere else to
  go. The supervisor seat gets no file: an `agents/` definition
  configures a dispatched subagent, and the supervisor is the runner
  session itself (`run.md`, intro), whose permission mode and model come
  from how the user starts it (`companions/supervisor-runbook.md
  § Modes by seat`) and whose conduct is `run.md`. The user seat has no
  file for the same reason. No seat is added or retired here.
- **Naming.** The six new files are `agents/dev-<seat>.md` with a
  matching `name:`. They load in every session on this machine, DEV or
  not, and a bare `planner` or `implementer` in that list invites a
  VIBE session to pick one; the prefix says whose they are. The listing
  selects on `description:` as much as on name, so each of the six
  descriptions carries the same guard: one line opening "Seat of `/dev
  run`, dispatched by the runner only:" and closing with when the run
  dispatches it (the roster's Dispatched cell, item 4, in brief).
  `code-reviewer` keeps its name and file: five files under
  `skills/dev/`, `skills/dispatching-parallel-agents/SKILL.md`,
  `LAYOUT.md` and a test fixture
  (`scripts/test/dev-session-brief.test.sh`) cite it, and `§ Desired
  state` 10 asks for a definition, not a rename.
- **A dispatch names its seat's type.** Each companion's fenced block
  reads `Task tool (dev-<seat>)` where it reads `Task tool
  (general-purpose)` today, and the two companion-less dispatch sites
  name theirs the same way. Without it the definition is never loaded,
  and neither the tool set `§ Desired state` 8 resolves against nor the
  model reaches the dispatch.
- **Models are carried over, not chosen.** Every value in
  `companions/verification-policy.md § Models` moves to the definition
  of the seat that holds it: `fable` for the planner, the spec reviewer,
  the doc writer and the docs verifier; `opus` for the implementer,
  which is the Default implementers row, the mechanical and
  judgment-heavy rows staying as the dispatch override the tier rule
  applies; `fable` and `effort: medium` already stand in
  `agents/code-reviewer.md`. The cold reader has no row today and its
  definition pins no model: a key a definition omits inherits the
  session's (`§ Effort mechanics`), which is what that dispatch takes
  now. Effort follows the same rule - only `code-reviewer` pins one
  today and only it keeps one, since pinning a level per seat would
  change dispatch behaviour no requirement asks for.
- **The Probes row retires with the table.** Its value is the Default
  implementers row's `opus` and probing is implementer work
  (`companions/implementer-prompt.md § Scratch & Probe Scripts`, moving
  to the implementer's definition), so folding it away moves no
  dispatch off the model it takes today.
- **A tool set is derived from the seat's prompt and its work**, and a
  too-narrow set halts a seat mid-item, which costs more than a
  slightly broad one. Each item states its seats' sets. Three rules run
  across the roster. No seat gets the Agent tool, because no seat
  dispatches a seat (`companions/planner-prompt.md § Exit`,
  `doc-writer-prompt.md § Exit`, `agents/code-reviewer.md`). `WebFetch`
  and `WebSearch` go to the two seats whose ground truth reaches
  outside the checkout, the docs verifier and the code reviewer - both
  resolve claims against `companions/documentation.md § Verification
  gate`, whose authoritative sources include vendor docs - and to no
  other, the remaining five having closed input sets (`§ Desired state`
  4). The three reviewer seats and the cold reader are read-only toward
  the repository, as `agents/code-reviewer.md` already states in prose,
  so their sets carry no `Edit` and no `NotebookEdit`; the docs
  verifier alone among them carries `Write`, to build the throwaway
  repo `companions/verification-policy.md § Verifier isolation`
  requires it to probe in: a shell heredoc carrying JSON or JS trips
  the obfuscation guard. That section says nothing about how a fixture
  is written, and the only file carrying the heredoc fact today
  (`implementer-prompt.md § Scratch & Probe Scripts`) becomes the
  implementer's definition, which no verifier cites; the docs verifier's
  definition states the fact in its own words.
- **A tool set cannot bound `Bash`, and no definition claims it can.**
  `agents/code-reviewer.md` bans every HEAD-moving git command in
  prose, and a reviewer still checked out `main` mid-branch: under
  `auto` the classifier reads `git checkout` as benign. Only a deny
  rule holds a seat off HEAD, and the deny floor is R080-T007's (below).
- **The config rule is about shell and settings, not paths**, and all
  seven definitions carry it, every seat holding `Bash`. In each it
  reads: "**Config.** No edit-class shell - `sed -i`, `tee`, a
  redirection - against anything under the config directory: that is
  what the sensitive-file guard fires on. Never the settings surface -
  `settings.json`, `.claude/settings.json`,
  `.claude/settings.local.json`, `hooks/`, `~/.claude.json`. Every
  other path under the config directory - skills, rules, agent
  definitions, the docs, the plans - is tracked source rather than
  config: a seat treats it as it treats any file in the checkout, within
  the tools it holds." The third sentence is not optional - without it a
  seat facing `skills/dev/run.md` re-derives the halt from the second
  alone - and it names no tool, so the one wording holds for the four
  seats read-only toward the repository as for the three that write.
  The settings surface's only writer is the user's own `--apply` run of
  R080-T007's pre-flight script. The sentence three companions carry
  today - "never write config - settings, hooks, skills, rules,
  `CLAUDE.md` - wherever it lives" at `planner-prompt.md` lines 69-71,
  `doc-writer-prompt.md` line 65 and `implementer-prompt.md` line 103,
  there with the guarded-paths clause that follows it - is replaced by
  that wording and never moved: moved as-is it ships the halt into
  three definitions. A path reading is vacuous here: this repository's
  checkout root is the config directory, so it would forbid every task
  this repository has ever run.
- **The `tools:` key is the harness's**, read from the agent file's
  frontmatter: the Agent tool's own description names
  `.claude/agents/*.md` frontmatter as where an agent type's tools,
  model and effort come from, and the agent-type listing prints each
  type's set - `code-reviewer`, which declares none, listed with all
  tools. A name the client does not provide is dropped silently, with
  no parse error, so it costs a capability rather than failing loudly,
  and declaring it widens nothing: a set stops at the names this client
  provides. `Glob` and `Grep` are not among them. A dispatched seat
  declaring `Read, Glob, Grep, Bash` held `Read, Bash`; a second, asked
  to call them, reported that neither tool exists in its set; a third
  held `Read, Bash, WebFetch, WebSearch` against a declaration carrying
  both; and the user's own session has neither, in its registry or its
  deferred one. The earlier reading that found them present asked a
  seat to list its tools, which is a self-report of the seat's prompt
  rather than a call, so it measured a different thing. Item 6 below
  drops both names from the seven definitions and records what that
  costs. Two things stay as they were: no definition lists `TodoWrite`,
  and whether a declared `tools:` key narrows what a dispatch holds is
  still open - the refusal proves only that a missing name drops, and
  every other report is a self-report.
- **A duty statement cites the table, never restates it** (`§ Desired
  state` 6). Each definition's duties line says that the seat's duties
  are the cells the duty table of `skills/dev/run.md § Seats` gives it
  and that a duty the table leaves unassigned is not its own - "the
  duty table" because the section holds a roster table too once item 4
  lands. It names no cell: the
  table's rows are not a per-seat list - the planner's cell carries
  both layers at the detail round and the acceptance on a re-dispatch,
  the implementer holds one cell, not three - and an enumeration drifts
  from the table it exists to cite.
- **Paths in an agent file are repository-relative**, as
  `agents/code-reviewer.md`'s already are (`skills/dev/plan.md
  § Proportionality`), and a declared path is named by its placeholder
  with the declaration named at first use (`<plans>`, `<docs>`; the
  same file's `CLAUDE.md § Layout` cite), so a dispatched seat resolves
  it without `companions/declarations.md`.

Considered and not casualties: `DESIGN.md § Git & delivery model` names
four seat classes in a one-paragraph summary of the model and states no
model, effort, tool set or conduct, so it is not invalidated and the
branch does not touch `DESIGN.md` (no `architecture-changing:` header);
`REQUIREMENTS.md`'s "most capable model" and
`companions/report-template.md`'s "(full diff vs base, most capable
model)" name the tier the requirement sets, not a dispatch value, and
the value they resolve to is `agents/code-reviewer.md`'s;
`skills/dispatching-parallel-agents/SKILL.md`'s `subagent_type` table
routes generic work and its `code-reviewer` row stays true;
`release.md` step 3 and `branch-plan.md § Closing routine` 1 name the
reviewer and its rubric, both still where they point;
`write-plan.md § Inputs` and `run.md § Question resolution`'s
`§ Report Format` cite point at companion sections that stay; and
`companions/supervisor-runbook.md`'s "Every seat holds its commands to
`branch-plan.md § Commit cadence` point 4" is the one home for a rule
that holds across the roster, which nothing here replaces - only the
implementer's and the doc writer's text carries that sentence today, so
the five other seats would lose it.

Two lines the split does invalidate, each fixed in the item that
invalidates it. `write-plan.md § Steps` says steps 1 and 3 to 5 belong
to one planner and cites `companions/planner-prompt.md`; after the move
those steps are the definition's. `companions/documentation.md
§ Verification gate` says to split a large doc across parallel
reviewers: a seat holds no Agent tool, so the split is the
dispatcher's, one verifier dispatch per section. That reason holds
wherever the gate runs; whether the dispatches are sequential is the
session's - in a run they are, seats running one at a time (`run.md
§ Seats`), and the gate also serves a session outside one.

What R080-T007 inherits, none of it this task's to write. `run.md
§ Pre-flight`'s "No plan in scope names a target under `.claude/`" is
the path reading the config rule above retires; it must name the
settings surface instead, and that section's permission text is
R080-T007's. The deny floor gains `git checkout`, `switch`, `reset`,
`restore` and `stash`: a deny survives `auto` and binds a subagent,
which is the only thing that holds a seat off HEAD. And T007's per-seat
`Bash` derivation decides nothing, so it need not run: the tool set
here is the scope boundary, and the run has one permission mode, `auto`
(`companions/supervisor-runbook.md § Modes by seat`), which suspends
Bash allow rules.

`scripts/install-dev.sh` ships no `agents/`, so an installed project
reads a `run.md § Seats` that cites definitions it does not have. The
gap is pre-existing - `branch-plan.md § Closing routine` already cites
`agents/code-reviewer.md` there - and this task neither widens the
installer nor closes it; the final item writes it as an unnumbered
backlog line in `dev/plans/R080-seat-model/tasks.md` (`plan.md
§ Referential integrity`).

`README.md` is the doc writer's (`run.md § Seats`; `branch-plan.md
§ Commit cadence` 2). The facts it will need: the `agents/` row now
holds one definition per dispatched seat of a run - planner, cold
reader, implementer, spec reviewer, doc writer, docs verifier and code
reviewer - each carrying the tools, model and conduct that hold on
every dispatch, while the inputs, exit and report format of a single
dispatch stay in `skills/dev/companions/`; the definitions are this
repository's own and the installer copies none of them.

- [x] The four companion-backed seats split in two: `agents/dev-planner.md`,
  `agents/dev-implementer.md`, `agents/dev-spec-reviewer.md` and
  `agents/dev-doc-writer.md` carry what holds on every dispatch, and
  each companion keeps only the dispatch. One move made four times, one
  commit. Each definition's frontmatter is `name: dev-<seat>`, a
  one-line `description`, the model the table gives it
  (`companions/verification-policy.md § Models`, the row named) and its
  tool set, and no `effort:` key: none of the four pins one today
  (`§ Effort mechanics`). Its body is the sections the table names,
  moved verbatim from the companion, with the config rule above where
  that file's "never write config" sentence stood - before the duties
  line for the spec reviewer, which carries none - and the duties line
  last. The three writing seats take "**Duties.** Yours are the cells
  the duty table of `skills/dev/run.md § Seats` gives the <subject>; a
  duty it leaves unassigned is not yours.", `<subject>` being the
  table's last column; the spec reviewer takes "**Duties.** You read:
  no cell of the duty table in `skills/dev/run.md § Seats` is yours,
  and a finding is reported, never fixed." The implementer's `## Your
  Job` has one home, the definition: the companion keeps no job
  section, so the fast-tier verify and the commit step move with the
  rest. Each companion's fenced block dispatches `Task tool
  (dev-<seat>)`.

  | Seat | Model (`§ Models` row) | Tools | Sections moved | Duties subject |
  | --- | --- | --- | --- | --- |
  | Planner | `fable` (Planners) | `Read`, `Edit`, `Write`, `Glob`, `Grep`, `Bash` | `## Your Job` 1, 3 and 4; `## Conventions`; `## Exit`'s dispatch-nothing sentence | the planner |
  | Implementer | `opus` (Default implementers) | `Read`, `Edit`, `Write`, `NotebookEdit`, `Glob`, `Grep`, `Bash`, `Skill` | `## Before You Begin`; `## Your Job`; `## Conventions`; `## Code Organization`; `## Scratch & Probe Scripts`; `## Plan & Findings Files`; `## Corrections Handed to You`; `## When You're in Over Your Head`; `## Before Reporting Back: Self-Review` | the implementer |
  | Spec reviewer | `fable` (Spec-compliance checks) | `Read`, `Glob`, `Grep`, `Bash` | the `**Purpose:**` line; `## Your Job` | reads, holds no cell |
  | Doc writer | `fable` (Doc writers) | `Read`, `Edit`, `Write`, `Glob`, `Grep`, `Bash` | `## Your Job` 1-5; `## Conventions`; `## Exit`'s dispatch-nothing sentence | the doc writer |

  The sets follow the work: the planner writes one plan file and
  commits; the implementer also writes code, a notebook where a project
  has one and the findings file, searches the tree before adding a
  helper (`feat.md § Code reuse`), runs the fast tier, and takes
  `Skill` because `fix.md` step 2 invokes `systematic-debugging`; the
  doc writer writes `<docs>`, its index, `README.md` and the CHANGELOG
  and reads the diff with git; the spec reviewer only reads, its `Bash`
  being `git show` and the plan file's `git diff <base> <sha>`. The
  implementer's model is the Default implementers row, the mechanical
  and judgment-heavy rows reaching the seat as the dispatch's override.
  Approach: write the four definitions, each section unindented out of
  the fenced block and every cite to a file under `skills/dev/` given
  that prefix now that the text no longer sits there - `run.md § Seats`
  and `§ Question resolution`, `branch-plan.md § Body` and `§ Commit
  cadence`, `write-plan.md` (its steps and `§ Readiness checklist`),
  `git-workflow.md § Commit messages`, `plan.md § Where things live`,
  `layout.md § Docs`, `changelog.md`, `companions/documentation.md`'s
  three sections; `rules/writing-artifacts.md` and `CLAUDE.md` are
  repository-relative already, and a bare `layout.md` in `agents/`
  resolves to nothing - each `<docs>` or `<plans>` placeholder keeping
  its `CLAUDE.md § Layout` cite at first use, and an intra-file cite
  whose target stays in the companion rewritten to name it as the
  dispatch's - the implementer's "the statuses under ## Report Format
  are your only channel" reads "the statuses your dispatch's `## Report
  Format` names are your only channel". A definition is not a dispatch,
  so a dispatch placeholder in moved text is either named as the
  dispatch's or replaced by prose: the planner's "Commit on `<branch>`"
  reads "Commit on the branch the dispatch names"; the spec reviewer's
  `git diff <base> <sha> -- <plan path>` keeps its three, the sentence
  opening "With the `<base>`, `<sha>` and plan path your dispatch
  names,"; `<task-id>-<slug>.findings.md` is a file pattern, kept as it
  is, and `/tmp` in the scratch section is a literal path, kept. The
  implementer's job step 1 reads "Implement exactly what the commit
  item specifies, on the loop the plan's `type:` selects
  (`skills/dev/run.md § Dispatch per item` 1)": the mode file is that
  step's and the plan header names the type, so no placeholder is
  needed. The planner's three moved jobs renumber 1 to 3, so Job 3's
  "item 1 above" still resolves. Then cut each companion.
  A moved fragment the table names without a heading - the planner's
  and the doc writer's dispatch-nothing sentence, the spec reviewer's
  `**Purpose:**` line - carries none in the definition either: an
  `## Exit` heading over one sentence would read as a second exit
  contract beside the companion's. Each `description:` is
  double-quoted: the guard opening carries a colon, which a plain YAML
  scalar cannot hold.
  `planner-prompt.md`: Job 2 becomes Job 1 ("Write the plan to `<path
  to the plan file>`. The dispatch names that file: you neither choose
  the slug nor create the branch."), Jobs 1, 3 and 4 and `##
  Conventions` go, `## Exit` keeps its first sentence through the
  `cold-read: passed` record, and line 11 reads `Task tool
  (dev-planner):`.
  `implementer-prompt.md`: lines 1-26 stay (preamble, fence, `##
  Inputs`), `## Report Format` follows them unchanged - `## Before You
  Begin` through `## Before Reporting Back: Self-Review` are the
  definition's, `## Your Job` whole - and line 9 reads `Task tool
  (dev-implementer):`.
  `spec-reviewer-prompt.md`: the `**Purpose:**` paragraph and `## Your
  Job` go, leaving lines 1-7 and 12-31 - line 8's blank goes with the
  paragraph under it, so one blank stands between the preamble and the
  fence - and the `Report:` block at 65-70, its closing fence included;
  line 14 reads `Task tool (dev-spec-reviewer):`.
  `doc-writer-prompt.md`: lines 1-36 stay - line 37 is the `## Your
  Job` heading the cut takes - and line 35's "(## Your Job, point 3)"
  reads "(`agents/dev-doc-writer.md`: the claim takes the `unverified`
  mark)"; `## Exit` keeps its first sentence through the re-dispatch
  clause; `## Report Format` is unchanged; line 11 reads `Task tool
  (dev-doc-writer):`. Companions are exempt from the mode-file cap
  (`scripts/ci/check-caps.sh`, whose loop matches `skills/dev/[^/]+\.md`
  only). Three cites outside `run.md` follow the planner's text to its
  new home, all reading `agents/dev-planner.md`: `branch-plan.md
  § Rails`' "(`run.md § Seats`; `companions/planner-prompt.md`)",
  `plan.md § Adjusting existing plans`' "one planner per change
  (`companions/planner-prompt.md`), which states the change as a diff
  of items", and `write-plan.md § Steps`' "Steps 1 and 3 to 5 belong to
  one planner dispatched per task (`companions/planner-prompt.md`)" -
  that file's `§ Inputs` cite stays, pointing at the companion's
  `## Inputs`. `run.md`'s own cites move in the `run.md` item below, so
  its `Job 3` cite points at a Job that has moved until that item
  lands; the branch is consistent at its close.
- [x] The two seats dispatched with no prompt companion get definitions
  and their dispatch sites name them. `agents/dev-cold-reader.md`:
  `name: dev-cold-reader`, its description, no `model:` and no
  `effort:` - an omitted key inherits the session's, which is what the
  read takes today (`companions/verification-policy.md § Effort
  mechanics`) - tools `Read`, `Glob`, `Grep`, `Bash`, read-only and
  writing nothing, the pass and the notes being the session's
  (`write-plan.md` step 6); body: it is given exactly the implementer's
  inputs and answers what it would build and what is ambiguous or
  assumed in the acceptance and the initial approach, a question the
  inputs cannot answer is a plan gap it reports rather than a fault it
  works around, and it neither edits the plan nor dispatches anything.
  `agents/dev-docs-verifier.md`: `name: dev-docs-verifier`, its
  description, `model: fable` (`§ Models`' "Doc writers and the docs
  gate's verifier" row), tools `Read`, `Write`, `Glob`, `Grep`, `Bash`,
  `WebFetch`, `WebSearch` - its ground truth is the live system, the
  source, `--help`, config files and vendor docs, so it reaches the
  web; `Bash` is what `companions/verification-policy.md § Verifier
  isolation` bounds, and `Write` is how it builds the files of that
  throwaway repo, the definition stating the reason in its own words -
  a shell heredoc carrying JSON or JS trips the obfuscation guard and
  stalls the run on a prompt - since `§ Verifier isolation` says
  nothing about how a fixture is written and the file carrying that
  fact today becomes `agents/dev-implementer.md`, which no verifier
  cites; it stays read-only toward the checkout, writing only under a
  throwaway directory outside it, and is never the author of what it
  verifies; body: the per-claim verdicts and the comprehension pass are
  `companions/documentation.md § Verification gate`'s and are cited,
  not restated. Both carry the config rule, then the duties line, and
  each `description:` follows the naming decision above. At the
  dispatch sites,
  `companions/verification-policy.md § Comprehension check` and
  `companions/documentation.md § Verification gate` name the seat and
  its type, so the definition loads.
  Approach: both files repository-relative, the docs verifier citing
  `skills/dev/companions/documentation.md § Verification gate` and
  `skills/dev/companions/verification-policy.md § Verifier isolation`,
  the cold reader `skills/dev/write-plan.md` step 6 and
  `skills/dev/companions/implementer-prompt.md § Inputs`; each duties
  line reads "**Duties.** You read: no cell of the duty table in
  `skills/dev/run.md § Seats` is yours, and a gap is reported, never
  fixed." In
  `verification-policy.md § Comprehension check`, "dispatch a fresh
  subagent with exactly the implementer's inputs" reads "dispatch the
  cold reader (`agents/dev-cold-reader.md`, the `dev-cold-reader` type)
  with exactly the implementer's inputs". In `documentation.md
  § Verification gate`, "The verifier is a subagent the session - in a
  run, the runner (`run.md § Close` 3) - dispatches" reads "The
  verifier is the docs-verifier seat (`agents/dev-docs-verifier.md`,
  the `dev-docs-verifier` type) the session - in a run, the runner
  (`run.md § Close` 3) - dispatches". The same section's "split a large
  doc across parallel reviewers by section
  (`dispatching-parallel-agents`)" reads "split a large doc across one
  verifier dispatch per section, the split being the dispatcher's: a
  seat holds no Agent tool" - the reason is the tool set, which holds
  wherever the gate runs; in a run the dispatches are sequential
  (`run.md § Seats`), and the sentence does not say so, the gate
  serving sessions outside a run too.
- [x] `agents/code-reviewer.md` declares its tool set and cites its
  duties, so the roster reads the same for every seat. It gains
  `tools: Read, Glob, Grep, Bash, WebFetch, WebSearch` in the
  frontmatter, the config rule and a closing duties line citing
  `skills/dev/run.md § Seats`. The first four are the set its conduct
  paragraph already describes in prose: no Agent (it "never invokes the
  Agent tool, or any subagent"), no `Write`/`Edit` (it is read-only
  toward the repo),
  `Bash` for the `git diff`/`log`/`show` it reads state with. The web
  tools are not in that paragraph, which says nothing about the web,
  and withholding them would narrow the seat: its rules-and-prose
  class checks each changed claim against the verification gate's
  sources "as written" (`companions/documentation.md § Verification
  gate`), and those include vendor docs. `name`, `description`,
  `model: fable` and `effort: medium` are unchanged, the values
  `§ Models`' last row and `§ Effort mechanics` already point at.
  Approach: add the `tools:` line after `effort: medium`, and after the
  `**Output**` paragraph the config rule (the decision above, verbatim)
  then "**Duties.** You read: no cell of the duty table in
  `skills/dev/run.md § Seats` is yours, and a finding is reported,
  never fixed." Nothing else in the file changes.
- [x] `run.md § Seats` names every seat once and cites both homes, and
  the file stays within 300 lines and 80 columns
  (`scripts/ci/check-caps.sh`). The section gains a roster table - one
  row per dispatched seat, giving where the run dispatches it and its
  two homes - and loses two restatements: the conduct sentence "A seat
  touches plan and findings files only through Read/Edit/Write and
  never `.claude/` config", whose rule every definition now carries in
  the corrected form the decision above gives it, and the sentence
  disambiguating the three reviewer seats, which the roster's rows
  replace. The supervisor needs no row:
  the section's first sentence is "A seat is a subagent of the runner",
  and the intro already says the runner session holds the supervisor
  seat. Elsewhere in the file, a companion cite the roster now carries
  resolves through `§ Seats`, and the planner's change rule resolves to
  `agents/dev-planner.md`. The budget is the binding constraint:
  `run.md` is at 299 lines of the 300-line cap, so the section's net
  must not push it over, and the check settles it, not an estimate.
  Where the edits below leave the file over 300, one cut is authorized
  and no other, and it takes two clauses, not a sentence. In
  `§ Question resolution`'s "The planner commits its change locally,
  nothing being pushed until the runner delivers; a planner reporting
  DONE_WITH_CONCERNS (`companions/planner-prompt.md § Report Format`)
  has committed too, so its change takes the read below as DONE's does
  and its concern reaches the user with the change for approval" (lines
  126-130), the two planner-commit clauses - "commits its change
  locally, nothing being pushed until the runner delivers" and "has
  committed too" - restate the commit rule this task moves into
  `agents/dev-planner.md`, and they alone go; the DONE_WITH_CONCERNS
  clause stays with its `§ Report Format` cite, that being run flow.
  The sentence then reads "The planner's commit is its definition's
  (`agents/dev-planner.md`); the change of a planner reporting
  DONE_WITH_CONCERNS (`companions/planner-prompt.md § Report Format`)
  takes the read below as DONE's does and its concern reaches the user
  with the change for approval." Taken only if the file lands over 300
  after the edits below.
  Approach: in `§ Seats`, drop the last sentence of the first
  paragraph, which rewraps. After it, a blank and a nine-line table -
  header, separator and seven rows, exempt from
  the column ceiling - `| Seat | Dispatched | Definition; dispatch |`
  with rows: Planner, "at the detail round and on an acceptance-level
  question (§ Question resolution)", `agents/dev-planner.md`;
  `companions/planner-prompt.md`; Cold reader, "over a new or changed
  plan before it is approved (`write-plan.md` step 6)",
  `agents/dev-cold-reader.md`; `companions/verification-policy.md
  § Comprehension check`; Implementer, "per commit item (§ Dispatch per
  item)", `agents/dev-implementer.md`;
  `companions/implementer-prompt.md`; Spec reviewer, "per implementer
  commit (§ Dispatch per item 3)", `agents/dev-spec-reviewer.md`;
  `companions/spec-reviewer-prompt.md`; Doc writer, "once per branch
  (§ Close 3)", `agents/dev-doc-writer.md`;
  `companions/doc-writer-prompt.md`; Docs verifier, "over every doc the
  writer touched (§ Close 3)", `agents/dev-docs-verifier.md`;
  `companions/documentation.md § Verification gate`; Code reviewer, "at
  branch close and at batch close (§ Close 1, § Batch close 1)",
  `agents/code-reviewer.md`; the steps at left, no companion. The
  closing paragraph's second sentence goes and its first joins the
  supervisor-mode paragraph above the duty table, reading "... A run
  reaching a duty the duty table below leaves unassigned halts and
  reports, never improvises." Then `§ Pre-flight`'s "config is never a
  seat's to write (`companions/implementer-prompt.md`)" reads
  "(`agents/dev-implementer.md`)", the rule's home now being the
  definitions rather than `§ Seats`; the sentence's own path reading is
  R080-T007's to correct, so nothing else on that line moves.
  `§ Dispatch per item` 1 drops both the companion path and "with the
  docs and the code as its inputs and nothing else", the input set
  being the companion's; `§ Close` 3 cites `§ Seats` for the doc writer
  and for the gate; and `§ Question resolution`'s first paragraph cites
  `§ Seats` for the planner's re-dispatch and for the reader, and
  `agents/dev-planner.md` where it cited `companions/planner-prompt.md`
  Job 3. `§ Dispatch per item` 3's spec-reviewer cite and
  `§ Question resolution`'s `§ Report Format` cite point at companion
  sections that stay and are left alone. Verify with
  `bash scripts/ci/run-all.sh`.
- [x] `companions/verification-policy.md § Models` keeps only the two
  rules a definition cannot hold, and the run's own bookkeeping follows
  the split. The table goes: every value is now its seat's definition,
  which the section cites. What stays is the implementer tier rule -
  mechanical predicate true (§ Mechanical commits) takes `sonnet`, a
  plan item tagged `(judgment-heavy)` takes `fable`, anything else the
  model `agents/dev-implementer.md` pins, no predicate inferring the
  tag - and the capacity fallback, unchanged but reading against the
  definitions. Three lines go with the table: the `Effort:` line, which
  `§ Effort mechanics` already carries; the Probes row, whose value is
  the default implementer's; and the spec-check disambiguation
  paragraph, whose model clause is a value and whose distinction
  `§ Spec-check skip` and `§ Close folding` already draw.
  `§ Effort mechanics` says that a seat's model and effort are its
  definition's, names the roster, and keeps what it has: the `effort:`
  range, `code-reviewer`'s `medium`, the dispatch overriding `model`
  only, and an omitted key inheriting the session's.
  `companions/report-template.md`'s Cost row measures the pair, since
  the standing text moved rather than shrank, and
  `companions/supervisor-runbook.md` stops enumerating seats where
  there are seven, in `§ Modes by seat`'s table and `§ The loop`'s
  diagram.
  Approach: `verification-policy.md § Models` opens "A seat's model is
  its definition's (`run.md § Seats`); the two rules a definition
  cannot hold stay here.", then `**Implementer tier.**` (the current
  `**Routing:**` paragraph, naming the models rather than the rows,
  which the deleted table no longer carries: "Mechanical-commit row
  (`sonnet`)" reads "(§ Mechanical commits) → `sonnet`",
  "Judgment-heavy row (`fable`)" reads "`fable`", and "the Default
  implementers row (`opus`)" reads "the model
  `agents/dev-implementer.md` pins", as the acceptance above states the
  rule) and
  `**Capacity fallback.**` unchanged but for "Before dispatching a
  `fable` role" reading "Before dispatching a seat whose definition
  pins `fable`" and "`fable` roles to `opus`, `opus` roles to `sonnet`"
  reading "a `fable` seat to `opus`, an `opus` seat to `sonnet`"; the
  table, the `Effort:` line and `**Spec-check disambiguation:**` are
  deleted. `§ Effort mechanics`' paragraph reads: model and effort
  route per seat, each definition's frontmatter carrying `model:` and,
  where the seat pins one, `effort:` (`low`/`medium`/`high`/`xhigh`/
  `max`; `agents/code-reviewer.md` pins `medium`), the roster `run.md
  § Seats`; a dispatch overrides `model` only, which is why the
  implementer's tier is the dispatch's (§ Models) and its definition's
  value the default; a key a definition omits inherits the session's -
  `effortLevel` the default rather than the ceiling.
  `report-template.md` line 47-48: "dispatch-prompt sizes (wc -w):
  implementer-prompt.md <before> → <after>; spec-reviewer-prompt.md
  <before> → <after>" reads "seat prompt sizes (wc -w, definition +
  dispatch): implementer <before> → <after>; spec reviewer <before> →
  <after>". `supervisor-runbook.md`: in `§ Modes by seat`, the table's
  second row's "Planner, implementer, reviewer, doc writer" (line 184)
  reads "Any dispatched seat (`run.md § Seats`)"; in `§ The loop`, the
  seat box's three-role line (line 43, `implementer / reviewer / doc
  writer`) reads `any seat of run.md § Seats`, padded so the box's
  right border stays in column with the rows above and below. `§ Modes
  by seat`'s "Every seat holds its commands to `branch-plan.md § Commit
  cadence` point 4" stays: it is the only place that rule reaches all
  seven, only the implementer's and the doc writer's text carrying it
  into a definition.
- [x] The seven `tools:` lines lose `Glob` and `Grep`, the two names
  observed absent from this client's registry (the decision above), and
  R080's backlog carries that observation with its condition and its
  cost. Reading the seven lines checks the item: `Read, Bash` for the
  cold reader and the spec reviewer, `Read, Edit, Write, Bash` for the
  planner and the doc writer, `Read, Edit, Write, NotebookEdit, Bash,
  Skill` for the implementer, `Read, Write, Bash, WebFetch, WebSearch`
  for the docs verifier, `Read, Bash, WebFetch, WebSearch` for the code
  reviewer - items 1 to 3's sets, less those two names, the order of
  the rest untouched. No other name is checked here and none is
  claimed sound: `Edit`, `Write`, `NotebookEdit` and `Skill` are
  unobserved, the one method a seat has for testing them is the
  self-report the decision above disqualifies, and the fast tier reads
  no tool name - no check under `scripts/ci/` parses agent frontmatter.
  A name later found missing is another drop on the same backlog line.
  Those seven sets supersede where items 1 to 3 state them - item 1's
  Tools column, item 2's cold-reader and docs-verifier tool lists, item
  3's quoted `tools:` line - so a close review reading those items
  against the tree finds `Glob` and `Grep` gone by this item, not
  missing by failure. The observation has one home, the R's backlog
  line rather than the seven files it changes
  (`rules/writing-artifacts.md § One home per finding`), and that line
  carries the cost with it: those seats now search through `Bash`, the
  one tool a tool set cannot bound (the decision above).
  Approach: edit the `tools:` line of `agents/dev-planner.md`,
  `agents/dev-implementer.md`, `agents/dev-spec-reviewer.md`,
  `agents/dev-doc-writer.md`, `agents/dev-cold-reader.md`,
  `agents/dev-docs-verifier.md` and `agents/code-reviewer.md`. No body
  text is a casualty: `git grep -n -w 'Glob\|Grep' -- agents skills
  rules scripts` returns twelve lines, the seven `tools:` lines and
  five that declare nothing - `agents/dev-implementer.md:71`'s "Glob
  deletes are rejected by the sandbox", a glob-pattern `rm` rather than
  the tool; `skills/dev/write-plan.md:94`'s "Grep the tree", the verb;
  and `scripts/test/context-cost.test.sh:199`, `:203` and `:209`, where
  `Grep` labels a tool block in a synthetic transcript the cost
  accounting is measured on, an arbitrary name rather than a claim that
  the tool exists. `-w` keeps "Global" out, and the pathspec omits
  `dev/plans`, which an unanchored `'*.md'` would sweep for this plan's
  own text and the archive's. Then append one line at the end of the
  paragraph that closes `dev/plans/R080-seat-model/tasks.md` - the one
  opening "Backlog, loop simplification (from the R080-T008 run", after
  its last sentence, which ends "the compound-command rule at `run.md
  § Dispatch per item`." - not inside it at the R080-T010 run-in. It
  reads: "From the R080-T010 run: a `tools:` name this client's
  registry does not provide is dropped silently, with no error - a
  dispatched seat declaring `Read, Glob, Grep, Bash` held `Read, Bash`,
  and one asked to call them reported that neither tool exists - so no
  definition declares `Glob` or `Grep`, at the cost of those seats
  searching through `Bash` alone; re-add both to the sets R080-T010
  names on a client that provides them." "From the R080-T010 run"
  rather than "close": this item lands before the close item, and the
  neighbouring lines attribute an observation to the act that produced
  it. Verify with `bash scripts/ci/run-all.sh`, which guards the rest
  of the tree rather than the sets, those being read.
- [x] `agents/dev-docs-verifier.md` cites the verification gate where
  it restates it today, so the file's own claim to neither restate nor
  narrow that section holds. The Purpose paragraph reduces to the
  seat's job, citing `skills/dev/companions/documentation.md
  § Verification gate` for what ground truth is rather than copying
  that section's source list, and loses the sentence saying why the
  seat reaches the web: it changes no behaviour, the web tools being
  the frontmatter's whether or not it is written. The
  author-independence line states the bar and cites the same section
  for the rule instead of repeating its wording. Nothing else moves -
  the probing paragraph, the config rule and the duties line stand as
  item 2 wrote them.
  Approach: the Purpose paragraph (lines 8-12) becomes "**Purpose:**
  check the claims of the doc your dispatch names against ground truth,
  which `skills/dev/companions/documentation.md § Verification gate`
  defines."; `## Your Job`'s first sentence then reads "Run that
  section as it is written.", the two sentences after it unchanged; and
  the author-independence line - "You are never the author of what you
  verify - a doc its author also verified is unverified." - reads "You
  verify no doc you authored: the independence rule is
  `skills/dev/companions/documentation.md § Verification gate`'s."
  Anchor the last two edits on that text rather than on a line number:
  the Purpose replacement collapses five lines to two, shifting every
  number under it. Verify with `bash scripts/ci/run-all.sh`.
- [x] `skills/dev/companions/verification-policy.md § Comprehension
  check` keeps only what is the dispatcher's, the reader's own conduct
  living in its definition. What to hand the reader, how a gap routes
  into a planner re-dispatch, and the `cold-read: passed` record stay;
  the cold-context rationale and the ask - the two questions - go, the
  section citing `agents/dev-cold-reader.md` for them and for the rule
  that a question the inputs cannot answer is a plan gap rather than a
  reader fault. `write-plan.md` step 6 keeps its wording and is no
  casualty: it states the input set and the ask as part of the planner
  flow it owns - the same step routes each gap and records
  `cold-read: passed` - so what the dispatcher commissions stays with
  the dispatcher's step, and the conduct has one home. The definition
  itself is untouched: its body is item 2's above, and the dispatch
  site is what that item left standing.
  Approach: the section's text from its opening through the clause "A
  question the inputs cannot answer is a plan gap, not a reader fault:
  a planner fixes it -" (lines 146 to 154 - the first two sentences and
  the third's opening clause, which ends mid-line) becomes
  "The dispatcher's read of the plan (`write-plan.md` step 6).
  Dispatch the cold reader (`agents/dev-cold-reader.md`, the
  `dev-cold-reader` type) with exactly the implementer's inputs - the
  plan, the docs and the code (`companions/implementer-prompt.md`),
  never the planning conversation; the two questions it answers and
  the gap rule are its definition's." The routing sentence keeps its
  text from "an acceptance gap re-runs the read once" through the
  `cold-read: passed` record and its `branch-plan.md § Header` cite,
  opening "A gap is a planner's to fix - "; the closing sentence from
  "This catches `NEEDS_CONTEXT` halts" is unchanged. Verify with
  `bash scripts/ci/run-all.sh`.
- [x] R080-T007's entry in `dev/plans/R080-seat-model/tasks.md` claims
  everything this task hands that one, and R080's backlog records that
  T007's existing plan predates the hand-over, so neither reaches
  T007's detail round through this file alone, which archives at the
  close. Three things pass over, each stated today in the "What
  R080-T007 inherits" paragraph above and nowhere else. `§ Pre-flight`'s
  "No plan in scope names a target under `.claude/`" reads a path where
  its own cite reads a settings surface (`agents/dev-implementer.md`,
  carrying the config rule the decisions above state), and that
  section's permission text is T007's. The deny floor gains `git
  checkout`, `switch`, `reset`, `restore` and `stash`: a deny survives
  `auto` (`companions/supervisor-runbook.md § Modes by seat`) and binds
  a subagent, which is the only thing that holds a seat off HEAD. And
  under `auto` a per-seat `Bash` allow derivation decides nothing: each
  definition's tool set is the scope boundary, and `auto` suspends Bash
  allow rules while leaving deny rules and every non-`Bash` rule of the
  entry's "mode plus allow rules" in force. That one is handed over as
  the observation it is, not as a ruling on T007's scope. `auto` is the
  runner's mode under `Supervisor: AI` alone; under `Supervisor: human`
  the user session's mode governs and Bash allow rules bind (same
  section), and T007's declared set carries the mode as well as the
  rules (its task line), so both modes are its scope and whether a
  derivation is needed under the second is its question to settle. The
  entry's "derived from the toolchain declaration and the seat prompts"
  is reworded on its own ground, which the acceptance states so the
  change is not read as drift: the phrase names where a seat's commands
  are read from, and this branch moved standing conduct into `agents/`
  and left the dispatch in `skills/dev/companions/`. That holds in
  either mode; the `Bash` question above is separate and conditional
  and neither clause rests on the other. The three claims go in the task
  sentence rather than a backlog line - a backlog line holds a
  discovery with no owning open task, promoted or dropped at the R's
  next shape round (`skills/dev/plan.md § Referential integrity`),
  while these have an open task whose planner writes its plan from that
  sentence - and the stale plan file goes the other way, being that
  planner's to rewrite at its detail round rather than work the task
  claims. It rides this item because it is the same hand-over: a
  planner reading the existing plan first never reaches the task
  sentence. `skills/dev/run.md` is untouched here and carries no marker
  for the pending fix (`rules/writing-artifacts.md § State the
  present`).
  Approach: in `dev/plans/R080-seat-model/tasks.md`, the R080-T007
  entry (lines 77-84) opens "deterministic permission pre-flight - a
  declared permission set per seat (mode plus allow rules) derived from
  the toolchain declaration and the seat prompts;" and ends "the
  runbook's prompt-clearing rows and failure modes re-read against it.
  Depends on R080-T004 and R080-T010." Two edits, the entry rewrapped
  after them and still one semicolon list closed by that `Depends on`
  sentence. "derived from the toolchain declaration and the seat
  prompts" reads "derived from the toolchain declaration, each seat's
  definition under `agents/` and its dispatch companion under
  `skills/dev/companions/`". Three clauses then join the list in this
  order before the period of "re-read against it", each written into
  the entry as it stands below, joined by "; ", carrying no period of
  its own and no quotation mark except the two the first clause quotes
  around the `§ Pre-flight` sentence, which reach `tasks.md` as typed.
  First: `run.md § Pre-flight`'s "No plan in scope names a target under
  `.claude/`" reworded to name the settings surface, which is what that
  sentence's own cite (`agents/dev-implementer.md`) withholds from a
  seat, every other path under the config directory being tracked
  source. Second: the deny floor extended with `git checkout`,
  `switch`, `reset`, `restore` and `stash`, the only bar that holds a
  seat off HEAD, a deny surviving `auto` and binding a subagent. Third:
  under `auto` no per-seat `Bash` allow derivation is needed, each
  definition's tool set being the scope boundary and `auto` suspending
  Bash allow rules, so whether one is needed under a supervisor mode
  that does not suspend them is T007's to settle
  (`companions/supervisor-runbook.md § Modes by seat`).
  Then append to the loop-simplification backlog paragraph, after its
  closing sentence (the R080-T010 tools observation, ending "on a
  client that provides them."): "From the R080-T010 run:
  `R080-T007-perm-preflight.md` predates the seat model - its
  `depends-on` names R080-T004 alone where the task line names
  R080-T010 too, and its `run.md § Pre-flight` item rewrites that
  section without the correction the task line now hands it - so T007's
  detail round re-plans it rather than running it as written." The
  opener is "run" rather than "close review" for item 6's reason: this
  item lands before the close, and the paragraph's neighbouring lines
  attribute an observation to the act that produced it. The
  `supervised: approved` line that file also carries is not repeated
  there: the backlog paragraph above already names it for T004 to T008
  (`rules/writing-artifacts.md § One home per finding`). Item 10 below
  edits a sentence in the middle of the same paragraph, so the two
  touch different sentences of it. No multi-word `tasks.md` quote in
  this item or item 10 is contiguous in the file - each wraps a line
  break - so an `Edit` anchors on a fragment that sits within one line,
  or retypes the whole entry or the whole sentence; either way the
  entry and the paragraph are rewrapped after the edit. Nothing else in
  either paragraph moves; `tasks.md` is under no line or column cap
  (`scripts/ci/check-caps.sh` matches `skills/dev/[^/]+\.md` only).
  Verify with `bash scripts/ci/run-all.sh`.
- [x] The R080 backlog line on the spec check's model cites where that
  model is declared and why changing it is a plan item, so the open
  work it records stays findable. Item 5 deleted the models table the
  line points at: `companions/verification-policy.md § Models` keeps
  the implementer tier rule and the capacity fallback only, and the
  spec reviewer's `fable` is its definition's frontmatter
  (`agents/dev-spec-reviewer.md`). Frontmatter alone is not the reason
  - a dispatch overrides `model` (`§ Effort mechanics`) - so the line
  gives the one that holds: the implementer has a written per-dispatch
  rule selecting its tier and the spec reviewer has none, so nothing
  but an edit to that definition moves the seat. The work the line
  records is unchanged, as is its place in the loop-simplification
  paragraph; the cite and the reason are what change.
  Approach: in `dev/plans/R080-seat-model/tasks.md`, replace this
  sentence, unique in the file and wrapped across four lines within
  the loop-simplification paragraph - "The per-commit spec check on
  Fable is the run's largest seat cost; the models table is policy, so
  moving it to Opus is a plan item
  (`companions/verification-policy.md § Models`)." - with "The
  per-commit spec check on Fable is the run's largest seat cost; no
  rule selects that seat's model per dispatch as the implementer tier
  does (`companions/verification-policy.md § Models`), so moving it to
  Opus means editing `agents/dev-spec-reviewer.md`, a plan item." It
  wraps a line break, so it is no literal `Edit` anchor: anchor on a
  fragment within one line or retype the sentence. Rewrap from that
  sentence to the end of the paragraph, item 9's appended sentence
  included; no other sentence's words change and no other paragraph
  moves. Verify with `bash scripts/ci/run-all.sh`.
- [x] The duty table's doc-writer row names the seat and nothing the
  roster already carries, so `run.md § Seats` states that seat's
  cadence once. The roster row (line 25) gives "once per branch
  (§ Close 3)" in its Dispatched column and the duty row (line 41)
  repeats it sixteen lines below, which `writing.md § No repetition`
  bites; cadence is the roster's column, so the duty row keeps the
  seat name alone and a reader after the cadence reads it off the
  roster. The planner pair is not the same case and stays: its duty
  row (line 37) says which plan layer at which occasion - both layers
  at the detail round, the acceptance on a re-dispatch, an approach
  gap once - which the roster's Dispatched cell does not carry. No
  duties line is a casualty: each cites the table rather than a cell,
  and the row still names the doc writer.
  Approach: in `skills/dev/run.md`, line 41 - "| Writing the docs |
  doc writer, once per branch at § Close 3 | the same |" - becomes
  "| Writing the docs | doc writer | the same |". The edit removes
  text within one row and adds no line, so the file stays at the
  300-line cap (`scripts/ci/check-caps.sh`). Nothing else in either
  table moves, and `branch-plan.md § Commit cadence` 2's "written once
  per branch at `run.md § Close` 3" is another file's docs step, left
  alone. Verify with `bash scripts/ci/run-all.sh`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, `LAYOUT.md`'s `agents/`
  block current (`branch-plan.md § Architecture-changing branches`,
  which folds layout upkeep into the final commit without the flag),
  cleanup, mark plan complete, mark the task `[x]` in `tasks.md` and
  add this branch's two unowned observations there as backlog lines -
  the installer gap, `scripts/install-dev.sh` shipping no `agents/`, so
  an installed project reads a `run.md § Seats` citing definitions it
  does not have; and the unbounded restart clause in `write-plan.md`
  step 6, a change after the record restarting the read count only
  where it changes an acceptance - then commit. Both ride the close
  because neither has an owning open task
  (`skills/dev/plan.md § Referential integrity`) and this commit is
  already the branch's one write of R080's backlog: giving either its
  own checkbox would rewrap the same paragraph twice, and folding
  either into item 9 or 10 would give that item a second acceptance.
  `git grep -n 'general-purpose' -- skills/dev` then returns
  nothing, every dispatch naming its seat's type, and `git grep -n -E
  'fable|opus|sonnet' -- skills rules` returns only
  `companions/verification-policy.md`'s two remaining rules.
  Approach: `LAYOUT.md`'s two `agents/` lines become three - the
  directory comment reads "the run's seat definitions
  (skills/dev/run.md § Seats)", `code-reviewer.md` keeps a line, and
  `dev-*.md` is one pattern line, "one per dispatched seat", as
  `check-*.sh` and `*.test.sh` are drawn (`skills/dev/layout.md
  § Layout file`); `check-stray.sh` matches first-level nodes only, so
  the fast tier is green before and after. Both backlog lines go at the
  end of the loop-simplification paragraph in
  `dev/plans/R080-seat-model/tasks.md`, after the sentences items 9 and
  10 leave there, the second reading: "From the R080-T010 run:
  `write-plan.md` step 6's "A planner change made after the pass is
  recorded starts a count of its own" reads as unbounded where the same
  step's earlier rule is not - bound it to a change that alters an
  acceptance, an approach or wording change restarting no count." Its
  inner double quotes are literal and reach `tasks.md` as typed, and
  the paragraph is rewrapped from the first appended sentence on. The
  close review reads every quoted sentence above against the tree and
  runs the two greps; then the marks and the commit.
