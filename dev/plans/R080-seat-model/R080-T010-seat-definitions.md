---
task: R080-T010
type: mnt
depends-on: R080-T006
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
  VIBE session to pick one; the prefix says whose they are.
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
  verifier alone among them carries `Write`, for the throwaway fixtures
  `companions/verification-policy.md § Verifier isolation` requires,
  which a shell heredoc cannot build without tripping the obfuscation
  guard.
- **A tool set cannot bound `Bash`, and no definition claims it can.**
  `agents/code-reviewer.md` bans every HEAD-moving git command in
  prose, and a reviewer still checked out `main` mid-branch: under
  `auto` the classifier reads `git checkout` as benign. Only a deny
  rule holds a seat off HEAD, and the deny floor is R080-T007's (below).
- **The config rule is about shell and settings, not paths.** Every
  definition carries it where the companions today say "never write
  config", in three parts: no seat runs edit-class shell (`sed -i`,
  `tee`, a redirection) against anything under the config directory,
  which is what the sensitive-file guard fires on; no seat writes the
  settings surface - `settings.json`, `.claude/settings.json`,
  `.claude/settings.local.json`, `hooks/`, `~/.claude.json` - whose
  only writer is the user's own `--apply` run of R080-T007's pre-flight
  script; and everything else in the checkout - `skills/`, `rules/`,
  `agents/`, `docs/`, `dev/plans/` - is tracked product source a seat
  edits through Read/Edit/Write. A path reading is vacuous here: this
  repository's checkout root is the config directory, so it would
  forbid every task this repository has ever run.
- **The `tools:` key is the harness's**, read from the agent file's
  frontmatter: the Agent tool's own description names
  `.claude/agents/*.md` frontmatter as where an agent type's tools,
  model and effort come from, and the agent-type listing prints each
  type's set - `code-reviewer`, which declares none, listed with all
  tools. The names written are the harness's own: `Grep` and `Glob`
  are subagent tools and are used, `TodoWrite` is not one and no seat
  lists it, and a name the harness does not know is dropped silently,
  so a wrong name costs a capability and never a parse error. What the
  listing does not settle is whether a declared `tools:` key narrows
  what a dispatch actually holds; the first definition written settles
  that on its first dispatch, by being asked to list its own tools.
- **A duty statement cites the table, never restates it** (`§ Desired
  state` 6). Each definition's duties line says that the seat's duties
  are the cells `skills/dev/run.md § Seats` gives it and that a duty
  the table leaves unassigned is not its own. It names no cell: the
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
reviewers: a seat holds no Agent tool and seats run one at a time
(`run.md § Seats`), so the split is the dispatcher's and runs as one
verifier dispatch per section.

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

- [ ] The four companion-backed seats split in two: `agents/dev-planner.md`,
  `agents/dev-implementer.md`, `agents/dev-spec-reviewer.md` and
  `agents/dev-doc-writer.md` carry what holds on every dispatch, and
  each companion keeps only the dispatch. One move made four times, one
  commit. Each definition's frontmatter is `name: dev-<seat>`, a
  one-line `description`, the model the table gives it
  (`companions/verification-policy.md § Models`, the row named) and its
  tool set, and no `effort:` key: none of the four pins one today
  (`§ Effort mechanics`). Its body is the sections the table names,
  moved verbatim from the companion, with the config rule above in
  place of that file's "never write config" sentence and the duties
  line last. The three writing seats take "**Duties.** Yours are the
  cells `skills/dev/run.md § Seats` gives the <subject>; a duty the
  table leaves unassigned is not yours.", `<subject>` being the table's
  last column; the spec reviewer takes "**Duties.** You read: no cell
  of `skills/dev/run.md § Seats` is yours, and a finding is reported,
  never fixed." Each companion's fenced block dispatches `Task tool
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
  the fenced block and its cites rewritten repository-relative now that
  they no longer sit under `skills/dev/` (`skills/dev/run.md § Seats`,
  `skills/dev/branch-plan.md § Commit cadence`,
  `skills/dev/write-plan.md`, `skills/dev/git-workflow.md § Commit
  messages`, `skills/dev/companions/documentation.md`), each `<docs>`
  or `<plans>` placeholder keeping its `CLAUDE.md § Layout` cite at
  first use, and an intra-file cite whose target stays in the companion
  rewritten to name it as the dispatch's - the implementer's "the
  statuses under ## Report Format are your only channel" reads "the
  statuses your dispatch's `## Report Format` names are your only
  channel". The planner's three moved jobs renumber 1 to 3, so Job 3's
  "item 1 above" still resolves. Then cut each companion.
  `planner-prompt.md`: Job 2 becomes Job 1 ("Write the plan to `<path
  to the plan file>`. The dispatch names that file: you neither choose
  the slug nor create the branch."), Jobs 1, 3 and 4 and `##
  Conventions` go, `## Exit` keeps its first sentence through the
  `cold-read: passed` record, and line 11 reads `Task tool
  (dev-planner):`.
  `implementer-prompt.md`: lines 1-26 stay (preamble, fence, `##
  Inputs`), `## Your Job` becomes three lines - implement exactly what
  the item specifies on the loop of the plan's `type:` mode file
  (`<mode file>`), then report - `## Report Format` is unchanged, and
  line 9 reads `Task tool (dev-implementer):`.
  `spec-reviewer-prompt.md`: `## Your Job` goes, leaving lines 1-31 and
  the `Report:` block at 65-70, its closing fence included; line 14
  reads `Task tool (dev-spec-reviewer):`.
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
- [ ] The two seats dispatched with no prompt companion get definitions
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
  isolation` bounds, and `Write` is how it builds that section's
  throwaway fixtures, since a shell heredoc carrying JSON or JS trips
  the obfuscation guard and stalls the run on a prompt - it stays
  read-only toward the checkout, writing only under a throwaway
  directory outside it, and is never the author of what it verifies;
  body: the per-claim verdicts and the comprehension pass are
  `companions/documentation.md § Verification gate`'s and are cited,
  not restated. Both carry the duties line. At the dispatch sites,
  `companions/verification-policy.md § Comprehension check` and
  `companions/documentation.md § Verification gate` name the seat and
  its type, so the definition loads.
  Approach: both files repository-relative, the docs verifier citing
  `skills/dev/companions/documentation.md § Verification gate` and
  `skills/dev/companions/verification-policy.md § Verifier isolation`,
  the cold reader `skills/dev/write-plan.md` step 6 and
  `skills/dev/companions/implementer-prompt.md § Inputs`; each duties
  line reads "**Duties.** You read: no cell of `skills/dev/run.md
  § Seats` is yours, and a gap is reported, never fixed." In
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
  verifier dispatch per section": the seat holds no Agent tool and
  seats run one at a time (`run.md § Seats`), so the split is the
  dispatcher's and the dispatches are sequential.
- [ ] `agents/code-reviewer.md` declares its tool set and cites its
  duties, so the roster reads the same for every seat. It gains
  `tools: Read, Glob, Grep, Bash, WebFetch, WebSearch` in the
  frontmatter and a closing duties line citing `skills/dev/run.md
  § Seats`. The first four are the set its conduct paragraph already
  describes in prose: no Agent (it "never invokes the Agent tool, or
  any subagent"), no `Write`/`Edit` (it is read-only toward the repo),
  `Bash` for the `git diff`/`log`/`show` it reads state with. The web
  tools are not in that paragraph, which says nothing about the web,
  and withholding them would narrow the seat: its rules-and-prose
  class checks each changed claim against the verification gate's
  sources "as written" (`companions/documentation.md § Verification
  gate`), and those include vendor docs. `name`, `description`,
  `model: fable` and `effort: medium` are unchanged, the values
  `§ Models`' last row and `§ Effort mechanics` already point at.
  Approach: add the `tools:` line after `effort: medium`, and after the
  `**Output**` paragraph: "**Duties.** You read: no cell of
  `skills/dev/run.md § Seats` is yours, and a finding is reported,
  never fixed." Nothing else in the file changes.
- [ ] `run.md § Seats` names every seat once and cites both homes, and
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
  Where the edits below do not fit, the room comes from the same
  rewraps - the closing paragraph's fold and the companion cites the
  roster replaces.
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
  reaching a duty the table below leaves unassigned halts and reports,
  never improvises." Then `§ Pre-flight`'s "config is never a seat's to
  write (`companions/implementer-prompt.md`)" reads
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
- [ ] `companions/verification-policy.md § Models` keeps only the two
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
  `companions/supervisor-runbook.md § Modes by seat` stops enumerating
  four seats where there are seven.
  Approach: `verification-policy.md § Models` opens "A seat's model is
  its definition's (`run.md § Seats`); the two rules a definition
  cannot hold stay here.", then `**Implementer tier.**` (the current
  `**Routing:**` paragraph, its "Default implementers row (`opus`)"
  reading "the model `agents/dev-implementer.md` pins") and
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
  <after>". `supervisor-runbook.md § Modes by seat`: the second row's
  "Planner, implementer, reviewer, doc writer" reads "Any dispatched
  seat (`run.md § Seats`)", and the loop diagram's seat box reads "any
  seat of run.md § Seats" in place of its three-role line. The
  section's "Every seat holds its commands to `branch-plan.md § Commit
  cadence` point 4" stays: it is the only place that rule reaches all
  seven, only the implementer's and the doc writer's text carrying it
  into a definition.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, `LAYOUT.md`'s `agents/`
  block current (`branch-plan.md § Architecture-changing branches`,
  which folds layout upkeep into the final commit without the flag),
  cleanup, mark plan complete, mark the task `[x]` in `tasks.md` and
  add the installer gap there as a backlog line -
  `scripts/install-dev.sh` ships no `agents/`, so an installed project
  reads a `run.md § Seats` citing definitions it does not have - then
  commit. `git grep -n 'general-purpose' -- skills/dev` then returns
  nothing, every dispatch naming its seat's type, and `git grep -n -E
  'fable|opus|sonnet' -- skills rules` returns only
  `companions/verification-policy.md`'s two remaining rules.
  Approach: `LAYOUT.md`'s two `agents/` lines become three - the
  directory comment reads "the run's seat definitions
  (skills/dev/run.md § Seats)", `code-reviewer.md` keeps a line, and
  `dev-*.md` is one pattern line, "one per dispatched seat", as
  `check-*.sh` and `*.test.sh` are drawn (`skills/dev/layout.md
  § Layout file`); `check-stray.sh` matches first-level nodes only, so
  the fast tier is green before and after. The close review reads every
  quoted sentence above against the tree and runs the two greps; then
  the marks and the commit.
