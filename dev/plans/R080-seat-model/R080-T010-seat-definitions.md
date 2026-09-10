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
  `code-reviewer` keeps its name and file: eight sites in `skills/dev/`,
  one in `skills/dispatching-parallel-agents/`, `LAYOUT.md`, `README.md`
  and a test fixture (`scripts/test/dev-session-brief.test.sh`) cite it,
  and `§ Desired state` 10 asks for a definition, not a rename.
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
  slightly broad one. Each item states its derivation. Two rules run
  across the roster: no seat gets the Agent tool, because no seat
  dispatches a seat (`companions/planner-prompt.md § Exit`,
  `doc-writer-prompt.md § Exit`, `agents/code-reviewer.md`), and no
  seat but the docs verifier gets `WebFetch`/`WebSearch`, because every
  other seat's inputs are closed (`§ Desired state` 4) while the gate's
  ground truth includes vendor docs (`companions/documentation.md
  § Verification gate`). The three reviewer seats and the cold reader
  are read-only toward the repository, as `agents/code-reviewer.md`
  already states in prose, so their sets carry no `Write`, `Edit` or
  `NotebookEdit`; `Bash` stays, the review reading git, and the conduct
  sentence is what bounds it.
- **The `tools:` key is the harness's**, read from the agent file's
  frontmatter: the Agent tool's own description names
  `.claude/agents/*.md` frontmatter as where an agent type's tools,
  model and effort come from, and the agent-type listing prints each
  type's set - `code-reviewer`, which declares none, listed with all
  tools. The names written are the harness's own tool names, confirmed
  against that listing before the set is written.
- **A duty statement cites the table, never restates it** (`§ Desired
  state` 6). Each definition's duties line says that the seat's duties
  are the cells `skills/dev/run.md § Seats` gives it and that a duty
  the table leaves unassigned is not its own.
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
`§ Report Format` cite point at companion sections that stay.

`scripts/install-dev.sh` ships no `agents/`, so an installed project
reads a `run.md § Seats` that cites definitions it does not have. The
gap is pre-existing - `branch-plan.md § Closing routine` already cites
`agents/code-reviewer.md` there - and this task neither widens the
installer nor closes it; it is the owning R's backlog to route.

`README.md` is the doc writer's (`run.md § Seats`; `branch-plan.md
§ Commit cadence` 2). The facts it will need: the `agents/` row now
holds one definition per dispatched seat of a run - planner, cold
reader, implementer, spec reviewer, doc writer, docs verifier and code
reviewer - each carrying the tools, model and conduct that hold on
every dispatch, while the inputs, exit and report format of a single
dispatch stay in `skills/dev/companions/`; the definitions are this
repository's own and the installer copies none of them.

- [ ] `agents/dev-implementer.md` is the implementer seat's standing
  definition and `companions/implementer-prompt.md` keeps only the
  dispatch. The definition carries `name: dev-implementer`, a one-line
  `description`, `model: opus` (`companions/verification-policy.md
  § Models`' Default implementers row; the mechanical and
  judgment-heavy rows reach the seat as the dispatch's override), the
  tool set below, and as its body the standing text the companion holds
  today: what an approach question is and what a NEEDS_CONTEXT is, the
  pass discipline (implement exactly the item, tests per branch type,
  the fast tier green, commit, self-review), the conventions,
  `<docs>`/`README.md`/the CHANGELOG as inputs and never targets, code
  organization, scratch and probe scripts, plan and findings files,
  corrections handed to it, when it is in over its head, and the
  self-review checklist; plus the duties line. Tools: `Read`, `Edit`,
  `Write`, `NotebookEdit`, `Glob`, `Grep`, `Bash`, `TodoWrite`,
  `Skill` - it writes code, plan checkboxes and the findings file, a
  notebook where a project has one, searches the tree before adding a
  helper (`feat.md § Code reuse`), runs the fast tier and commits, and
  `fix.md` step 2 invokes `systematic-debugging`; it gets no Agent and
  no web tools. The companion keeps its preamble, `## Inputs` (the plan
  and its findings file, the docs, the code), a one-line job naming the
  plan's `type:` mode file as the loop, and `## Report Format`, and its
  fenced block dispatches `Task tool (dev-implementer)`.
  Approach: write `agents/dev-implementer.md` with the frontmatter
  above and the body sections moved verbatim from the companion's
  `## Before You Begin`, `## Your Job`, `## Conventions`, `## Code
  Organization`, `## Scratch & Probe Scripts`, `## Plan & Findings
  Files`, `## Corrections Handed to You`, `## When You're in Over Your
  Head` and `## Before Reporting Back: Self-Review`, unindented out of
  the fenced block, their `run.md`-relative cites rewritten
  repository-relative (`skills/dev/run.md § Seats`,
  `skills/dev/branch-plan.md § Commit cadence`) and the `<docs>`
  sentence keeping its `CLAUDE.md § Layout` cite. The duties line, last:
  "**Duties.** Yours are the cells `skills/dev/run.md § Seats` gives the
  implementer - the code, the item's approach, the plan checkboxes and
  the findings file; a duty the table leaves unassigned is not yours."
  Then cut those sections from `companions/implementer-prompt.md`,
  leaving lines 1-26 (the preamble, the fence, `## Inputs`), a
  three-line `## Your Job` - implement exactly what the item specifies
  on the loop of the plan's `type:` mode file (`<mode file>`), then
  report - and `## Report Format` unchanged; change line 9 to `Task
  tool (dev-implementer):`. The file lands near 40 lines; companions
  are exempt from the mode-file cap (`scripts/ci/check-caps.sh`, whose
  loop matches `skills/dev/[^/]+\.md` only).
- [ ] `agents/dev-planner.md` is the planner seat's standing definition
  and `companions/planner-prompt.md` keeps only the dispatch. The
  definition carries `name: dev-planner`, its description, `model:
  fable` (`§ Models`' Planners row), tools `Read`, `Edit`, `Write`,
  `Glob`, `Grep`, `Bash`, `TodoWrite` - it writes one plan file, reads
  the requirements, the task line, the docs, the code and the
  initiative's other plans, greps the tree for the casualties
  `write-plan.md § Readiness checklist` demands, and commits - with no
  Agent and no web tools, its input set being closed; and as its body
  the standing text the companion holds today: how an item is written
  (acceptance, then the `Approach:` run-in), the change rule (state the
  change as a diff of items and make exactly that change; a change
  adding a decision drops `cold-read: passed`, one citing text already
  in the tree does not), the commit rule (commit on the branch, never
  push, the commit stands whether or not the user approves), the
  conventions, "dispatch nothing yourself", and the duties line. The
  companion keeps its preamble, `## Inputs` with the re-dispatch line,
  the sentence naming the plan file the dispatch settles, `## Exit` and
  `## Report Format`, and dispatches `Task tool (dev-planner)`.
  Approach: write `agents/dev-planner.md` from the companion's `## Your
  Job` 1, 3 and 4 and `## Conventions` plus the `## Exit` sentence
  "Dispatch nothing yourself - no seat dispatches a seat", cites
  rewritten repository-relative (`skills/dev/write-plan.md`,
  `skills/dev/branch-plan.md § Body`, `skills/dev/run.md § Seats`); the
  duties line reads "**Duties.** Yours are the cells `skills/dev/run.md
  § Seats` gives the planner - an item's acceptance text and nothing
  else; a duty the table leaves unassigned is not yours." In the
  companion, Job 1 becomes "Write the plan to `<path to the plan
  file>`. The dispatch names that file: you neither choose the slug nor
  create the branch.", Jobs 3 and 4 and `## Conventions` go, `## Exit`
  keeps its first sentence through the `cold-read: passed` record and
  drops the dispatch-nothing line, and line 11 reads `Task tool
  (dev-planner):`. Two cites outside `run.md` follow the change rule to
  its new home: `branch-plan.md § Rails`' "(`run.md § Seats`;
  `companions/planner-prompt.md`)" reads "(`run.md § Seats`;
  `agents/dev-planner.md`)", and `plan.md § Adjusting existing plans`'
  "one planner per change (`companions/planner-prompt.md`), which
  states the change as a diff of items" reads "one planner per change
  (`agents/dev-planner.md`), which states the change as a diff of
  items". `run.md`'s own cites move in the `run.md` item below, so its
  `Job 3` cite points at a Job that has moved for four commits; the
  branch is consistent at its close.
- [ ] `agents/dev-spec-reviewer.md` is the spec reviewer's standing
  definition and `companions/spec-reviewer-prompt.md` keeps only the
  dispatch. The definition carries `name: dev-spec-reviewer`, its
  description, `model: fable` (`§ Models`' Spec-compliance checks row),
  tools `Read`, `Glob`, `Grep`, `Bash` - read-only toward the
  repository as `agents/code-reviewer.md` is, `Bash` for `git show` and
  the plan file's `git diff <base> <sha>`, no Agent and no web tools -
  and as its body the standing rubric the companion holds today, the
  shape `agents/code-reviewer.md` already gives a reviewer's rubric:
  the purpose sentence, the four checks (missing requirements,
  extra or unneeded work, misunderstandings, convention drift), the
  acceptance-unchanged check with the approach/acceptance split, the
  read-the-code rule and its ban on process substitution, and the
  duties line. The companion keeps its preamble, `## Inputs` (the plan
  and the item text, the criteria list, the commit, the base) and the
  three report verdicts, and dispatches `Task tool (dev-spec-reviewer)`.
  Approach: write `agents/dev-spec-reviewer.md` from the companion's
  `**Purpose:**` line and `## Your Job`, cites rewritten
  repository-relative (`skills/dev/run.md § Seats`,
  `skills/dev/git-workflow.md § Commit messages`); the duties line
  reads "**Duties.** You read: no cell of `skills/dev/run.md § Seats`
  is yours, and a finding is reported, never fixed." Then cut `## Your
  Job` from the companion, leaving lines 1-31 (preamble, fence, the
  intro sentence, `## Inputs`) and the `Report:` block at 65-69, and
  change line 14 to `Task tool (dev-spec-reviewer):`.
- [ ] `agents/dev-doc-writer.md` is the doc writer's standing definition
  and `companions/doc-writer-prompt.md` keeps only the dispatch. The
  definition carries `name: dev-doc-writer`, its description, `model:
  fable` (`§ Models`' Doc writers row), tools `Read`, `Edit`, `Write`,
  `Glob`, `Grep`, `Bash`, `TodoWrite` - it reads the diff with git,
  writes `<docs>`, its index, `README.md` and the CHANGELOG, and
  commits once on the branch - with no Agent and no web tools, a fact
  the inputs settle: a doc claim the diff, the plan items and the
  existing docs cannot settle takes the `unverified` mark rather than a
  lookup (`companions/documentation.md § Verification gate`); and as
  its body the standing text the companion holds today: the method
  (read the diff and the plan items, then each doc the change touches;
  bring every doc the branch ships to the shipped code; write per
  `§ Reference discipline` and `§ Content quality` with the provenance
  marks; correct every WRONG and resolve every UNPROVEN on a
  re-dispatch; commit the docs as one commit, code and plans not
  yours), the conventions, "dispatch nothing yourself", and the duties
  line. The companion keeps its preamble, `## Inputs` with the
  re-dispatch verdicts line, `## Exit` and `## Report Format`, and
  dispatches `Task tool (dev-doc-writer)`.
  Approach: write `agents/dev-doc-writer.md` from the companion's
  `## Your Job` 1-5, `## Conventions` and the `## Exit` dispatch-nothing
  sentence, cites rewritten repository-relative
  (`skills/dev/layout.md § Docs`, `skills/dev/changelog.md`,
  `skills/dev/companions/documentation.md`, `skills/dev/run.md
  § Seats`) and the `<docs>` sentence keeping its `CLAUDE.md § Layout`
  cite; the duties line reads "**Duties.** Yours is the cell
  `skills/dev/run.md § Seats` gives the doc writer - every doc the
  branch ships, once per branch; a duty the table leaves unassigned is
  not yours." Then cut `## Your Job` and `## Conventions` from the
  companion, leaving lines 1-37 and `## Exit` (first sentence through
  the re-dispatch clause, dispatch-nothing dropped) and `## Report
  Format`, and change line 11 to `Task tool (dev-doc-writer):`.
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
  gate's verifier" row), tools `Read`, `Glob`, `Grep`, `Bash`,
  `WebFetch`, `WebSearch` - the only seat with web tools, its ground
  truth being the live system, the source, `--help`, config files and
  vendor docs, and `Bash` also what
  `companions/verification-policy.md § Verifier isolation` bounds -
  read-only toward the repository and never the author of what it
  verifies; body: the per-claim verdicts and the comprehension pass are
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
  (`run.md § Close` 3) - dispatches".
- [ ] `agents/code-reviewer.md` declares its tool set and cites its
  duties, so the roster reads the same for every seat. It gains
  `tools: Read, Glob, Grep, Bash` in the frontmatter - the set its
  conduct paragraph already describes in prose, no Agent (it "never
  invokes the Agent tool, or any subagent"), no `Write`/`Edit` (it is
  read-only toward the repo) and `Bash` for the `git diff`/`log`/`show`
  it reads state with - and a closing duties line citing
  `skills/dev/run.md § Seats`. `name`, `description`, `model: fable`
  and `effort: medium` are unchanged, the values `§ Models`' last row
  and `§ Effort mechanics` already point at.
  Approach: add the `tools:` line after `effort: medium`, and after the
  `**Output**` paragraph: "**Duties.** You read: no cell of
  `skills/dev/run.md § Seats` is yours, and a finding is reported,
  never fixed." Nothing else in the file changes.
- [ ] `run.md § Seats` names every seat once and cites both homes, and
  the file stays within 300 lines and 80 columns
  (`scripts/ci/check-caps.sh`). The section gains a roster table - one
  row per dispatched seat, giving where the run dispatches it and its
  two homes - and loses two restatements the definitions now carry: the
  conduct sentence "A seat touches plan and findings files only through
  Read/Edit/Write and never `.claude/` config", which every definition
  states as its own, and the sentence disambiguating the three reviewer
  seats, which the roster's rows replace. The supervisor needs no row:
  the section's first sentence is "A seat is a subagent of the runner",
  and the intro already says the runner session holds the supervisor
  seat. Elsewhere in the file, a companion cite the roster now carries
  resolves through `§ Seats`, and the planner's change rule resolves to
  `agents/dev-planner.md`. The budget: 299 lines today, 298 after.
  Approach: in `§ Seats`, drop the last sentence of the first
  paragraph, which rewraps from 7 lines to 5 (-2). After it, a blank
  and a nine-line table - header, separator and seven rows, exempt from
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
  `agents/code-reviewer.md`; the steps at left, no companion (+10 with
  its blank). The
  closing paragraph's second sentence goes and its first joins the
  supervisor-mode paragraph above the duty table, reading "... A run
  reaching a duty the table below leaves unassigned halts and reports,
  never improvises." - five lines in place of 4 + blank + 2 (-4).
  `§ Seats` lands at 35 lines from 31. Then `§ Pre-flight`'s "config is
  never a seat's to write (`companions/implementer-prompt.md`)" reads
  "(§ Seats)", 4 lines unchanged; `§ Dispatch per item` 1 drops both
  the companion path and "with the docs and the code as its inputs and
  nothing else", the input set being the companion's, and rewraps to 4
  lines (-1); `§ Close` 3 cites `§ Seats` for the doc writer and for
  the gate, rewrapping to 7 (-1); and `§ Question resolution`'s first
  paragraph cites `§ Seats` for the planner's re-dispatch and for the
  reader, and `agents/dev-planner.md` where it cited
  `companions/planner-prompt.md` Job 3, rewrapping to 22 lines from 25
  (-3). `§ Dispatch per item` 3's spec-reviewer cite and
  `§ Question resolution`'s `§ Report Format` cite point at companion
  sections that stay and are left alone. Verify with `wc -l` and a
  column check over the non-table lines.
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
  seat (`run.md § Seats`)", and the sentence "Every seat holds its
  commands to `branch-plan.md § Commit cadence` point 4" goes, each
  definition now carrying it; the loop diagram's seat box reads "any
  seat of run.md § Seats" in place of its three-role line.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, `LAYOUT.md`'s `agents/`
  block current (`branch-plan.md § Architecture-changing branches`,
  which folds layout upkeep into the final commit without the flag),
  cleanup, mark plan complete, mark the task `[x]` in `tasks.md`,
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
