---
task: R080-T004
type: mnt
depends-on: R080-T003, R080-T006, R080-T008
supervised: approved
---

# R080-T004: doc-writer seat

Branch: `mnt/doc-writer`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 3, 4, 6, 7
and 8.

Docs stop being the implementer's job. Once every implementer commit of
a branch has landed - the close review's approved fixes included - the
runner dispatches a doc writer with the branch diff, the plan and the
existing docs, and none of the implementer's context; it writes every
doc the branch ships on the same branch, commits, and reports. Its exit
is the documentation contract's verification gate: the runner, never
the seat, dispatches the gate's verifier over the touched docs, and a
WRONG or UNPROVEN verdict re-dispatches a fresh doc writer with the
verdicts. The pass is one step of `run.md § Close`, holds regardless of
branch size, and its report is ledgered. The seat's permission mode is
the runner's, as every seat's is; its declared permission set is
R080-T007's.

- [ ] `companions/doc-writer-prompt.md` is the doc writer's dispatch
  template, its input set the diff, the branch's plan items and the
  existing docs and nothing else (`requirements.md § Desired state` 3
  and 4). The diff is the branch's from the commit it was cut from
  (`run.md § Dispatch per item` 3's second base; the planner-commit
  base there is for the plan file's acceptance diff and never the doc
  writer's), so in a batch-scoped run no other member's work reaches
  the seat. The plan input is "the plan item" of `§ Desired state` 3
  and 4: the branch's plan items, the plan file being where they live
  and every item of it the branch's, so the prompt's `## Inputs` names
  the plan items and reads them from the plan file; they are read for
  their decisions and never cited in a doc (`§ Desired state` 4). The
  docs are `docs/` with its index, `README.md` and the CHANGELOG, the
  seat's to write, and `DESIGN.md` where present, read only -
  architecture stays the implementer's (`branch-plan.md
  § Architecture-changing branches`). A re-dispatch adds the gate's
  WRONG and UNPROVEN verdicts, verbatim, as the planner's adds the gap's
  text (`companions/planner-prompt.md § Inputs`). The job: bring every doc
  the branch ships to the shipped code under
  `companions/documentation.md` and `layout.md § Docs` - the `docs/`
  doc and its index line per the project's granularity, the CHANGELOG
  `## [Unreleased]` entry under `release-routine: yes`, `README.md` for
  new public surface, `extended-docs: yes` per the project's
  conventions, a doc the diff leaves accurate untouched - fix every
  WRONG and resolve or mark every UNPROVEN on a re-dispatch, touch no
  code, plan or config, and commit the docs as one commit on the branch
  (`git-workflow.md § Commit messages`). The exit: report back; the
  runner dispatches the gate's verifier (`run.md § Close` 3, item 2),
  the seat never - no seat dispatches a seat
  (`companions/planner-prompt.md § Exit`), and the verifier is never
  the author (`companions/documentation.md § Verification gate`). The
  report: DONE | DONE_WITH_CONCERNS | BLOCKED, the docs touched, the
  commit subject, the claims marked unverified, concerns. The seat has
  no NEEDS_CONTEXT: a fact the diff, the plan and the docs cannot
  settle is marked in the doc as unverified per the gate, never asked,
  the plan item being where such a decision belongs (`§ Desired state`
  4). `companions/verification-policy.md § Models` gains one row, the
  doc writer and the gate's verifier at `fable`, under the capacity
  fallback that governs the planner and review rows.
  Approach: the file mirrors `companions/planner-prompt.md`: an intro
  paragraph naming when the runner dispatches it (`run.md § Close` 3)
  and the input set, then a fenced Task tool block with `## Inputs`
  (Diff: `git diff <base> HEAD`, `<base>` filled by the runner as the
  spec reviewer's is; Plan items: every item of `<path>`, the branch's
  plan file; Docs: `docs/`, `docs/index.md`, `README.md`, the
  CHANGELOG, `DESIGN.md` read only, each where present; the
  re-dispatch bullet; "Nothing else is an input" with the
  implementer's report and transcript named as never reaching the
  seat), `## Your Job` (read the diff and the plan, then each doc the
  change touches; write per `companions/documentation.md § Reference
  discipline`, `§ Content quality` and `layout.md § Docs`' provenance
  marks; the unverified mark for an unsettled fact; one commit),
  `## Conventions` (`git-workflow.md § Commit messages`, `CLAUDE.md
  § Audience visibility`, `rules/writing-artifacts.md`; docs edited
  with Read/Edit/Write, never `sed`/`cat`/`awk`; never config; commands
  print only what the step needs, `branch-plan.md § Commit cadence` 4),
  `## Exit` (report back; the runner runs the gate; dispatch nothing),
  `## Report Format` (the statuses and fields above). `§ Models`: the
  row "Doc writers and the docs gate's verifier | Fable 5 (`fable`)"
  after the planner row.
- [ ] `run.md` runs the doc writer once per branch as `§ Close` step 3,
  after the approved fixes of step 2 have landed and before the
  mandatory final commit, so one pass sees all the branch's code
  (`requirements.md § Desired state` 3: after the implementer's code
  lands): the runner dispatches the doc writer on the diff from the
  commit the branch was cut from, the plan and the docs, then the
  gate's verifier over every doc it touched
  (`companions/documentation.md § Verification gate`), never the
  writer; WRONG or UNPROVEN re-dispatches a fresh doc writer with the
  verdicts, a second such verdict or a doc writer's BLOCKED halts the
  branch (`branch-plan.md § Stop conditions`, item 5); the doc writer's
  report - status, docs touched, commit subject - rides its `dispatch`
  ledger entry and the verdicts a `verify` entry (`§ Ledger`), which is
  where acceptance criterion 3 reads them; close folding never skips
  the step. `§ Seats` gains the doc writer's row, `Writing the docs`
  (`§ Desired state` 6; the `tasks.md` backlog homes the row here) -
  under `Supervisor: human` "doc writer, once per branch at § Close 3"
  and under `Supervisor: AI` "the same" - and its no-cell sentence
  names the gate's verifier beside the spec reviewer, the reviewer
  seat's third dispatch. `§ Batch close` 3's "Docs coherence pass
  (CHANGELOG/README across member branches)." drops: the pass is the
  batch review's already (`agents/code-reviewer.md`, the batch-mode
  paragraph's "doc coherence"), and `companions/report-template.md
  § Docs coherence` stays as that review's report section, both reading
  docs, not writing them. `§ Close`'s final-commit step drops "docs
  re-review". The file stays within 300 lines and 80 columns (table
  rows exempt).
  Approach: `§ Close` reads "1. Close review ..." and "2. Fixes ..."
  unchanged, then "3. Docs: dispatch the doc writer
  (`companions/doc-writer-prompt.md`) on the diff from the commit the
  branch was cut from (§ Dispatch per item 3), the plan and the docs,
  then the gate's verifier over every doc it touched
  (`companions/documentation.md § Verification gate`); WRONG or
  UNPROVEN re-dispatches a fresh doc writer with the verdicts, a second
  time or a BLOCKED halts (`branch-plan.md § Stop conditions`). The
  report rides the dispatch entry and the verdicts a verify entry
  (§ Ledger); folding never skips it (§ Seats)." The old step 3 becomes
  4 and reads "(cleanup, plan complete, task mark per `branch-plan.md
  § Closing routine`)"; the old 4 becomes 5. No other file cites § Close
  by a step number above 2 (`§ Dispatch per item` 2 cites "§ Close step
  2", unmoved). The `§ Seats` row goes after "Changing an item's
  acceptance"; the no-cell sentence reads "The reviewer holds no cell,
  the seat being the close review's `code-reviewer` dispatch (§ Close),
  the spec reviewer of `companions/spec-reviewer-prompt.md` and the docs
  gate's verifier (§ Close 3)." `§ Batch close` 3 reads "Run `Test
  (full)` - the batch's one full local run; red → halt." The lines the
  step and the row add are returned by the two cuts and by rewrapping
  tight to 80 columns the blocks with slack: `§ Resolve` 1, the
  `§ Pre-flight` `.claude/` bullet, `§ Dispatch per item` 2 and 4,
  `§ Close` 1 and 2, `§ Ledger`'s paragraph.
- [ ] `companions/supervisor-runbook.md` and `DESIGN.md` count the doc
  writer among the seats: `§ Modes by seat`'s dispatched-seat row names
  it, the run keeping one permission mode, the runner's
  (`requirements.md § Desired state` 8; the seat's tool set and allow
  rules are R080-T007's `seat-permissions.md`), `§ The loop`'s seat box
  lists it, and `DESIGN.md § Git & delivery model`'s seat list gains
  it, the file staying within 1000 words.
  Approach: the row "| Planner, implementer, reviewer | inherits the
  runner's | inherits the runner's |" reads "| Planner, implementer,
  reviewer, doc writer | inherits the runner's | inherits the
  runner's |"; the box line "|  implementer / reviewer" reads
  "|  implementer / reviewer / doc writer", re-padded so its closing
  `|` stays in the box's column. `DESIGN.md`: "dispatches seats -
  planner, implementer and reviewer today -" reads "dispatches seats -
  planner, implementer, reviewer and doc writer -", one word more,
  under the 1000-word cap.
- [ ] The implementer's dispatch names no doc target and no rule asks
  the implementer or its reviewer for docs (`requirements.md § Desired
  state` 3, last sentence; acceptance criterion 3):
  `companions/implementer-prompt.md` drops its docs step and the docs
  clause of `## Conventions` and says the docs are read, never written;
  `companions/spec-reviewer-prompt.md` drops its docs-updated check;
  `fix.md` and `refactor.md` drop their docs-delta sentences;
  `companions/verification-policy.md § Mechanical commits` drops the
  CHANGELOG-counts-toward-the-limit sentence, no commit item carrying a
  doc file any more.
  Approach: `implementer-prompt.md § Your Job`: "4. Docs in this same
  commit per project conventions (see ## Conventions)" drops and 5 to 7
  renumber 4 to 6; `## Conventions`' first sentence ends "CLAUDE.md
  § Code Comments + § Audience visibility." - "and project
  `## Conventions` (docs/CHANGELOG)" gone - and the section gains
  "`docs/`, `README.md` and the CHANGELOG are inputs, never targets:
  every doc the branch ships is the doc writer's (`run.md § Seats`)."
  `spec-reviewer-prompt.md`, Convention drift: "- Were docs updated per
  project conventions where the commit item required it?" drops, the
  other two bullets staying. `fix.md`: "Finish every pass per
  `branch-plan.md § Commit cadence`." alone, "Docs delta: a fix that
  changes documented behavior updates `README.md`." gone.
  `refactor.md`: the same, "Docs delta: README / extended docs only
  when public surface changed." gone and "If a step breaks tests..."
  staying. `verification-policy.md § Mechanical commits` 1: the
  sentence from "Convention-mandated doc files" through "is not
  mechanical." drops; the condition's first sentence stays.
- [ ] `branch-plan.md` re-points its docs rules to the seat and
  `companions/verification-policy.md § Close folding` keeps the pass on
  a folded branch: `§ Body`'s item definition no longer names the docs
  a commit touches but the decisions its docs will need, the doc
  writer's to read and the docs' never to cite (`requirements.md
  § Desired state` 4); `§ Doc-before-commit` retires, its placeholder
  rule governing docs written per commit; `§ Commit cadence` 2 says the
  docs are none in this commit and the doc writer's once per branch;
  `§ Closing routine` 1's bookkeeping drops CHANGELOG, its step 7 is
  the doc-writer pass, and the mandatory final item's template drops
  "re-review docs across all commits" with the two sentences that
  explain it; `§ Batches`' per-branch-close paragraph and `§ Close
  folding`'s invariants add the doc-writer pass to what holds
  regardless of size; `§ Stop conditions` gains the doc writer's halt
  row. `branch-plan.md` stays within 300 lines and 80 columns (table
  rows exempt).
  Approach: `§ Body` first sentence: "naming the change and any
  documentation it touches" reads "naming the change and carrying the
  decisions its docs will need - the doc writer's to read, never the
  docs' to cite (`run.md § Seats`)". The `## Doc-before-commit` heading
  and its paragraph go; nothing cites the heading. `§ Commit cadence`
  2 reads "**Docs** - none in this commit: every doc the branch ships -
  `docs/` with its index, the CHANGELOG `## [Unreleased]` entry under
  `release-routine: yes`, `README.md` for new public surface,
  `extended-docs: yes` per project `CLAUDE.md § Conventions` - is the
  doc writer's, written once per branch at `run.md § Close` 3 (`run.md
  § Seats`)." `§ Closing routine` 1: "Bookkeeping (plan marks,
  CHANGELOG) keys no review." reads "Bookkeeping (plan marks) keys no
  review." Step 7's run-in and first sentence read "**Docs** - the
  doc-writer pass (`run.md § Close` 3): the seat writes every doc the
  branch ships to the shipped code and commits it, and the gate's
  verifier clears it (`companions/documentation.md § Verification
  gate`; `run.md § Seats`). Then the **mandatory final item** of every
  plan:"; the quoted template reads "Complete the branch: cleanup
  (stale/temp data), mark plan complete, mark the task `[x]` in the R's
  `tasks.md` plus any release-plan entry, commit. (Batch members: the
  task mark rides the batch branch, § Batches.)"; "because the
  re-review and cleanup ahead of it" reads "because the cleanup ahead
  of it"; "The commit includes the resolved findings file and the
  reconciled doc." reads "The commit includes the resolved findings
  file." `§ Batches`: "The mandatory final commit and a green fast
  tier before merging into the batch branch hold regardless of size"
  reads "The doc-writer pass (`run.md § Close` 3), the mandatory final
  commit and a green fast tier before merging into the batch branch
  hold regardless of size". `§ Stop conditions` gains, after the
  planner row, "| Doc writer reports BLOCKED, or the docs gate's
  verifier reports WRONG or UNPROVEN on the same branch twice | Halt,
  report |". `verification-policy.md § Close folding`, Invariants: "the
  final commit and the green gate hold for every branch" reads "the
  doc-writer pass and its gate (`run.md § Close` 3), the final commit
  and the green gate hold for every branch".
- [ ] `layout.md § Docs` and `companions/documentation.md
  § Verification gate` name the doc writer as the author the gate is
  independent of (`requirements.md § Desired state` 3) and the runner
  as the verifier's dispatcher in a run.
  Approach: `layout.md § Docs`, first paragraph, after "the Reference
  application of the global documentation framework
  (`companions/documentation.md`).": "Their author is the doc-writer
  seat, at each branch's close (`run.md § Seats`)." `documentation.md
  § Verification gate`: "an **independent agent** - never the author -"
  reads "an **independent agent** - never the author, for `docs/` the
  doc-writer seat (`run.md § Seats`) -"; "The verifier is a subagent
  the session dispatches without pausing to confirm" reads "The
  verifier is a subagent the session - in a run, the runner (`run.md
  § Close` 3) - dispatches without pausing to confirm". `layout.md`
  stays within 300 lines and the item adds no line over 80 columns.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, cleanup (stale/temp
  data), mark plan complete, mark the task `[x]` in `tasks.md`, commit -
  the template as item 5 leaves it, this branch retiring its docs
  re-review.
  Approach: the close review reads every sentence the items above
  quote against the tree; then the marks and the commit.
