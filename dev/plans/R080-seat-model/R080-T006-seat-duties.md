---
task: R080-T006
type: mnt
depends-on: R080-T008
cold-read: passed
---

# R080-T006: seat responsibilities per mode

Branch: `mnt/seat-duties`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 6 and 7.

One table says who does what: a row per duty - writing and updating a
plan, dispatching, changing an item's approach, changing an item's
acceptance, clearing a permission prompt, verifying the boundary,
merging, being asked - a column per supervisor mode, and in each cell
the seat that holds it: user, supervisor, planner, implementer or
reviewer. The doc writer joins the table when R080-T004 lands. The
duty statements scattered across the flow, the runbook, the
declarations, the rules and the hand-off note cite the table instead
of restating it, and the skill files carry the two-layer item of
`§ Desired state` 7: an item's acceptance is the planner's text up to
an `Approach:` run-in, and the approach after the run-in is the
implementer's. The items below follow that seam.

- [x] `run.md` gains `## Seats` holding the responsibilities table of
  `requirements.md § Desired state` 6 for the seats in the tree, with
  the halt rule under it, and stays within 300 lines and 80 columns
  (table rows exempt). Approach: the heading goes after the intro
  paragraph and before `## Resolve`; the intro's seat paragraph ("A
  seat is a subagent of the runner..." through "trips the
  sensitive-file guard)") moves under the heading, above the table,
  unchanged. The table has a row per duty and a column per mode; where
  both modes hold the same seat the `Supervisor: AI` cell reads "the
  same" and the row's qualification sits in the human cell, a
  qualification split across the columns reading as mode-specific when
  it is not. The cells, `Supervisor: human` | `Supervisor: AI`:
  writing and updating a plan - planner: both layers at the detail
  round, the acceptance on a re-dispatch, an approach gap once | the
  same;
  dispatching - user | supervisor;
  changing an item's approach - implementer, in the commit that
  carries the code | the same;
  changing an item's acceptance - planner writes, user approves | the
  same;
  clearing a permission prompt - nobody: a prompt is a pre-flight
  defect | the same, with no `requirements.md` cite in the cell: a
  plan path does not resolve from `skills/dev/`;
  verifying the boundary - user | supervisor;
  merging - user | supervisor within the declared bounds, else user;
  being asked - user: pre-flight permission proposals, acceptance
  changes, the always-ask escalations | the same.
  One sentence above the table: under `Supervisor: human` the user's
  own session is the supervisor, so the user holds every supervisor
  cell; under `Supervisor: AI` the runner is, and the user holds the
  asked-of row and the acceptance-approval cell. Under the table: a
  run reaching a duty the table leaves unassigned halts and reports,
  never improvises; the reviewer holds no cell, the seat being the
  close review's `code-reviewer` dispatch and the spec reviewer of
  `companions/spec-reviewer-prompt.md`. The section adds 22 lines to a
  281-line file and two cuts return five: the intro's "Either mode
  routes questions through § Question resolution. The
  session never implements: every code or doc edit is a seat's, and
  the runner's own edits are the plan bookkeeping and the closing
  commit." drops, the table's rows carrying it, and the stall
  paragraph closing `§ Dispatch per item` shrinks to the next item's
  one sentence.
- [x] `run.md § Question resolution` routes acceptance-level questions
  only - those whose answer changes an item's acceptance - to the
  planner, and says an approach-level question is the implementer's,
  resolved in the approach text and its commit with no seat and no
  approval; `§ Dispatch per item` 2's DONE_WITH_CONCERNS clause
  narrows the same way, and the stall paragraph closing that section
  agrees with the prompt cell. Each cites `(§ Seats)`. Approach: the
  first sentence of `§ Question resolution` reads "An acceptance-level
  question - an implementer's blocker, a concern or a spec ambiguity
  whose answer changes an item's acceptance, a cold-read gap found in
  flight - halts the item and re-dispatches the planner (§ Seats;
  `companions/planner-prompt.md`) with that text, on the item's own
  branch (`git-workflow.md § Trunk`)." Its "a change that only cites
  text already in the tree keeps the record and needs no commit"
  reads "a change that only cites text already in the tree keeps the
  record, and an implementer's approach edit rides the code's
  commit". The second
  paragraph opens "Every acceptance-level answer takes that route; an
  approach-level question - which files, which sentences, which
  order - costs no seat and no approval: the implementer resolves it
  in the item's approach text and commits the plan edit with the code
  (§ Seats)." and keeps the rest. `§ Dispatch per item` 2: "a concern
  that changes plan text" reads "a concern that changes an item's
  acceptance". The stall paragraph after step 4 already reads its one
  sentence from item 1 - "A prompt the declared set did not predict - a
  compound command offers no prefix for a Bash rule to match - halts
  the item as a pre-flight defect, cleared by nobody (§ Seats, the
  prompt row)." - and is verified, not rewritten. No sentence is cut
  for the added text: both `§ Question resolution` paragraphs are
  rewrapped tight to 80 columns, which returns the four lines the new
  wording costs and leaves the file at 298.
- [x] The remaining `run.md` duty statements cite `(§ Seats)` and
  restate no cell: the intro paragraph's mode sentence ("Under
  `Supervisor: AI` it dispatches, verifies and merges..."), `§ Close`
  2's approval sentence, `§ Checkpoint`'s "the choice the **user**'s
  under `Supervisor: human`..." sentence and its Halt bullet, and
  `§ Merge or ask`'s two mode sentences ("Under `Supervisor: AI`,
  within a named class..." and "Under `Supervisor: human` every merge
  is the **user**'s"), `§ Pre-flight`'s "applied on approval
  (**user**)" and `§ Question resolution`'s "The change is the
  **user**'s to approve under either supervisor mode". Approach: the
  cite is appended in parentheses at the end of the clause it
  qualifies, joining an existing parenthesis that closes that clause -
  `§ Pre-flight` reads "(**user**; § Seats)", the Halt bullet
  "(`branch-plan.md § Scope discoveries`; § Seats)" and
  `§ Question resolution` "(`companions/declarations.md § Supervisor
  bounds`; § Seats)" - while `§ Checkpoint`'s choice sentence and
  `§ Merge or ask`'s human sentence take the cite before their colon,
  the end of the sentence carrying a different clause. The Halt
  bullet's "an implementer's plan-changing concern" reads "an
  implementer's acceptance-changing concern"; no other word changes.
  No sentence is cut: the intro, the Halt bullet, `§ Merge or ask`'s
  second paragraph and `§ Question resolution`'s tail are rewrapped
  tight to 80 columns, which returns three more lines than the cites
  cost and leaves the file at 295.
- [x] `companions/declarations.md § Supervisor bounds` and
  `companions/supervisor-runbook.md` cite `(run.md § Seats)` at every
  duty sentence and have nobody clearing a prompt. Approach:
  `declarations.md`: "it dispatches the seats, and the user approves
  the planner's changes (`run.md § Question resolution`), clears what
  stops them and merges." reads "it dispatches the seats, and the
  user approves the planner's acceptance changes and merges (`run.md
  § Seats`)."; "and the user approves plan changes and answers the
  always-ask list." reads "and the user approves acceptance changes
  and answers the always-ask list (`run.md § Seats`)."; the grant
  bullet's "an implementer's question instead takes the planner's
  change and the **user**'s approval under either mode (`run.md
  § Question resolution`)" reads "an acceptance-level question
  instead takes the planner's change and the **user**'s approval
  under either mode (`run.md § Seats`, `§ Question resolution`)".
  `supervisor-runbook.md § Two variants`: the table stays keyed by
  where the runner runs; the "Who starts it" row's cells gain
  "(`run.md § Seats`)". `§ The loop`: the human line pair reads
  "approves acceptance changes, answers the" / "always-ask
  escalations, merges", the AI pair "approves acceptance changes,
  answers the" / "always-ask escalations only", the `|` column
  unmoved; the "asking?" branch reads "acceptance question?", its
  arrow text unchanged, and the three `+--` branch lines and the `|`
  line between the first two are re-padded so the `->`, `+`, `|` and
  `-+` columns still align: the label field widens to 20 characters,
  putting `->` at column 38 and the two `-+` lines at 91.
  `§ Variant A` step 3 opens "**Runner** routes
  an acceptance-level question through `run.md § Question resolution`
  (`run.md § Seats`):", rest unchanged; `§ Variant B` step 6 "approves
  plan changes" reads "approves acceptance changes (`run.md
  § Seats`)". `§ Modes by seat`: "Under `Supervisor: human` the user
  is at the keyboard, so their session's mode governs and its prompts
  are theirs to clear." reads "Under `Supervisor: human` the user's
  session's mode governs; under either mode a prompt the declared set
  did not predict is a pre-flight defect that nobody clears (`run.md
  § Seats`)." `§ tmux recipes`' "Keystroke authority" paragraph matches
  `run.md § Dispatch per item`: a single key sent to the runner's
  dialog is an answer and text typed into its input box a dispatch,
  and no key goes past a permission prompt - the prompt is a
  pre-flight defect the runner halts on and reports, and the user
  fixes the declared set and re-runs (`run.md § Seats`; `run.md
  § Dispatch per item`); the `send-keys '1'` recipe and its "once they
  have read the pane" clause drop, the second-dispatcher and deadlock
  sentences stay, the second reworded to keep its subject once the
  clause it followed is gone.
  R080-T007 builds the pre-flight mechanics; no `depends-on` on it.
- [x] `branch-plan.md` carries the two-layer item: `§ Body` defines
  the seam, `§ Rails` says the acceptance is the planner's alone and
  the approach the implementer's to change, and `§ Session boundary`
  and `§ Scope discoveries` cite `(run.md § Seats)`. Approach:
  `§ Body` gains, after its first sentence: "Each item is its
  acceptance - what the commit delivers against the requirements, one
  or a few sentences - followed by an `Approach:` run-in and the
  approach: which files, which sentences, which order. The acceptance
  is the planner's, the approach the implementer's (§ Rails)."
  `§ Rails`' first bullet reads: "An item's acceptance is the
  planner's alone (`run.md § Seats`; `companions/planner-prompt.md`);
  its approach is the implementer's to change while working, the plan
  edit committed with the code. No seat makes the closing decisions.
  The implementer keeps the code, the approach, the plan checkboxes
  and the findings files." `§ Session boundary`'s first sentence gains
  "(`run.md § Seats`)". `§ Scope discoveries`' Blocker definition "a
  plan item is ambiguous" reads "an item's acceptance is ambiguous";
  its **Stop** bullet: "an
  ambiguous item, a missing step" reads "an item whose acceptance is
  ambiguous, a missing step", and the bullet gains, before "Never
  inline-fix": "An approach question - files, sentences, order - is
  no blocker: settle it in the item's approach text (`run.md
  § Seats`)." `§ Stop conditions`' first row event reads "Blocker the
  plan can absorb (§ Scope discoveries), or an implementer's
  acceptance-level NEEDS_CONTEXT". The file stays within 300 lines
  and 80 columns (table rows exempt).
- [x] `handoff.md` and `git-workflow.md § Trunk` cite `(run.md
  § Seats)` at their seat duty sentences; `solo` stays, not being a
  seat. Approach: `handoff.md`'s roles sentence reads "`supervisor`
  (the runner session of `/dev run`, its duties `run.md § Seats`;
  re-briefed from this note and its ledger,
  `dev/supervisor/<scope>.md`), `solo` (a session outside a run)".
  `git-workflow.md § Trunk`: "the planner edits
  plan content, the implementer stays on checkboxes and findings
  files (`branch-plan.md § Rails`)" reads "the planner edits
  acceptance text, the implementer the approach, the checkboxes and
  the findings files (`run.md § Seats`)"; `§ Merge policy`'s
  "delegable to a supervisor within a project's declared bounds
  (`companions/declarations.md § Supervisor bounds`)" adds "`run.md
  § Seats`" inside the parentheses. Both files stay within 300 lines
  and 80 columns.
- [x] `companions/implementer-prompt.md` tells the implementer the
  approach is theirs to change and the acceptance is not, and
  `companions/spec-reviewer-prompt.md` checks that the item's
  acceptance text is unchanged from the branch base (`requirements.md
  § Desired state` 4). Approach: `implementer-prompt.md § Plan &
  Findings Files`: "Plan content is the planner's: you keep the
  checkboxes and the findings file." reads "An item's acceptance - its
  text up to the `Approach:` run-in - is the planner's and never
  yours to edit; the approach after it is yours: change it as the
  work needs and commit the plan edit with the code (`run.md
  § Seats`). You also keep the checkboxes and the findings file."
  `§ Before You Begin`: the bullet "The approach or implementation
  strategy" drops, and between the bullet list and "Report them as
  NEEDS_CONTEXT" goes "An approach question - which files, which
  sentences, which order - is yours to settle in the item's approach
  text, not a report." `§ Your Job`'s "something unexpected or
  unclear is a NEEDS_CONTEXT report" reads "something unexpected or
  unclear in the acceptance is a NEEDS_CONTEXT report". `§ When
  You're in Over Your Head`: "The runner routes it through `run.md
  § Question resolution`: a planner changes the plan" reads "The
  runner routes an acceptance-level question through `run.md
  § Question resolution` (`run.md § Seats`): a planner changes the
  acceptance", and the escalation bullet "You feel uncertain about
  whether your approach is correct" reads "You feel uncertain whether
  the item's acceptance can be met". Only
  `spec-reviewer-prompt.md`'s prose intro names the branch base among
  the seat's inputs: the implementer's input set is the plan, the docs
  and the code and nothing else (`run.md § Dispatch per item` 1,
  `§ Question resolution`), so naming a fourth there would contradict
  both the runner and the template's own `## Inputs`. The same seam
  reaches two more sections: `§ Code Organization`'s first bullet makes
  the plan's file structure the approach's starting point, with files
  split or added as the work needs and the change recorded in the
  approach text, and `§ When You're in Over Your Head`'s first
  escalation trigger drops its multiple-valid-approaches wording for a
  way forward that changes what the item delivers.
  `spec-reviewer-prompt.md`: the `## Inputs` list gains "- Branch base:
  `<base>`, the commit the branch was cut from, for the plan file's
  diff." and the purpose line adds "and left the item's acceptance as
  the planner wrote it"; `## Your Job` gains, before "Verify by
  reading code": "**Acceptance unchanged:** `git diff <base> <sha> --
  <plan path>` shows no change in the item's acceptance - its text up
  to the `Approach:` run-in. A changed approach is the implementer's
  and no finding; a changed acceptance is an issue (`run.md
  § Seats`)." The runner fills `<base>` as it fills `<sha>`.
- [x] `companions/planner-prompt.md` writes each item with the
  `Approach:` seam, takes re-dispatch for acceptance-level questions
  and cold-read gaps, and fixes an approach gap once. Approach: the
  opening paragraph's "whenever a blocker, an implementer's
  plan-changing concern, a cold-read gap or the user's rejection of a
  change needs plan text changed" reads "whenever an acceptance-level
  question (`run.md § Question resolution`), a cold-read gap or the
  user's rejection of a change needs plan text changed". Job 1 gains:
  "Write each item as its acceptance - what it delivers against the
  requirements, one or a few sentences - then an `Approach:` run-in
  and the approach: which files, which sentences, which order
  (`branch-plan.md § Body`). The acceptance is yours; the approach is
  the implementer's to change in flight (`run.md § Seats`)." Job 3's
  record split reads: "A change to an acceptance that adds a decision
  drops `cold-read: passed` from the header, the dispatcher's re-read
  re-earning it; a change that only cites text already in the tree,
  or a fix to an item's approach, leaves the record standing - an
  approach gap the read reports is fixed once and re-runs no read
  (`write-plan.md` step 6 draws that split)." Job 4's "no other seat
  edits plan content" reads "no other seat edits acceptance text".
  `## Exit`'s "a gap
  re-dispatches a planner with the gap's text" reads "an acceptance
  gap re-dispatches a planner with the gap's text and re-runs the
  read, an approach gap once with no second read". `## Inputs`' own
  re-dispatch bullet lists the same triggers as the opening paragraph,
  so it reads "the acceptance-level question's, the cold-read gap's or
  the user's objection text, verbatim": left naming a blocker and a
  concern it would still invite approach-level text the seat no longer
  takes.
- [x] `write-plan.md` and `companions/verification-policy.md
  § Comprehension check` say the read tests the acceptance and the
  initial approach, and an approach gap is fixed once and re-runs no
  read. Approach: `write-plan.md` step 3's "naming the change in one
  sentence and the docs it touches" reads "written as its acceptance -
  what it delivers against the requirements, one or a few sentences -
  then `Approach:` and the files, sentences and order"; the new cite
  joins the step's existing parenthesis rather than opening a second
  one beside it, so the pair reads "(`branch-plan.md § Body`; task
  right-sizing: `plan.md § Levels`)". Step 6's "a fix that adds a
  decision re-runs the read, a fix that cites text already in the tree
  does not" reads "the reader tests the acceptance and the initial
  approach, so an acceptance fix that adds a decision re-runs the read,
  an acceptance fix that cites text already in the tree does not, and
  an approach gap is fixed once and re-runs no read (`run.md
  § Seats`)" - the "so" carrying the split from the clause that
  explains it. `§ Readiness checklist`'s "nothing is left to the
  implementer" reads "no decision is left to the implementer".
  `verification-policy.md § Comprehension check`: "and ask what it
  would build and what is ambiguous or assumed" reads "and ask what it
  would build and what is ambiguous or assumed in the acceptance and
  the initial approach"; "a planner fixes it, the read re-runs per the
  rule of `write-plan.md` step 6" reads "a planner fixes it - an
  acceptance gap re-runs the read per `write-plan.md` step 6, an
  approach gap is fixed once and re-runs no read, the approach being
  the implementer's to change in flight (`run.md § Seats`) -", the
  dashes closing the split so the sentence's "and the header then
  records" tail keeps its subject. `write-plan.md` stays within 300
  lines and 80 columns.
- [x] `plan.md § Adjusting existing plans` and
  `companions/report-template.md § Supervisor decisions` name the
  acceptance-level change kinds and cite `(run.md § Seats)`.
  Approach: `plan.md`'s branch-plan bullet clause "commits added after
  the final, a blocker, an implementer's plan-changing concern, a
  cold-read gap, the user's rejection of a change" reads "commits
  added after the final, an acceptance-level question (`run.md
  § Question resolution`), a cold-read gap, the user's rejection of a
  change; an item's approach is the implementer's, changed in its
  own commit with no planner (`run.md § Seats`)"; the bullet's
  "presents it for the user's approval" gains "(`run.md § Seats`)".
  `report-template.md`: "the plan changes the user approved" reads
  "the acceptance changes the user approved", and the sentence's
  existing cite reads "(`run.md § Seats`, `§ Question resolution`)" -
  the acceptance asks both files for the `§ Seats` cite, and this
  section is where the report names the change kind. `plan.md` stays
  within 300 lines and 80 columns.
- [ ] `run.md § Dispatch per item` 3 defines the spec reviewer's
  `<base>` as the planner commit the branch's latest ledgered answer
  names, else the commit the branch was cut from, and `§ Question
  resolution` says each answer is ledgered with the planner's commit:
  the ledger already records every approved answer (`§ Ledger`), and
  git alone cannot tell a planner commit from the runner's bookkeeping
  commit, which also touches the plan file. A planner's approved
  acceptance change (`requirements.md § Desired state` 7) is then no
  "Acceptance unchanged" finding (`§ Desired state` 4).
  `companions/spec-reviewer-prompt.md` names the base by that
  definition wherever it names it - the prose intro and the `## Inputs`
  line. `run.md` stays within 300 lines and 80 columns (table rows
  exempt). Approach: `run.md` step 3: after "skipped per
  `companions/verification-policy.md § Spec-check skip`." the step
  reads "Its `<base>` is the planner commit the branch's latest
  ledgered answer names (§ Question resolution), else the commit the
  branch was cut from, so an approved acceptance change is no finding.
  Reject → fix → recheck." - three lines where "Reject → fix →
  recheck." held one, the file at 297. `§ Question resolution`'s
  closing sentence "Each answer is ledgered (§ Ledger) and carried into
  the report's `## Supervisor decisions` section at checkpoint." reads
  "Each answer is ledgered with the planner's commit (§ Ledger) and
  carried into the report's `## Supervisor decisions` section at
  checkpoint.", its two lines rewrapped tight to 80 columns, adding
  none. `spec-reviewer-prompt.md`: the `## Inputs` bullet "Branch base:
  `<base>`, the commit the branch was cut from, for the plan file's
  diff." reads "Branch base: `<base>`, the planner commit the branch's
  latest ledgered answer names, else the commit the branch was cut from
  (`run.md § Dispatch per item` 3), for the plan file's diff."; the
  intro's "the branch base and the diff" reads "the branch base (`run.md
  § Dispatch per item` 3) and the diff", the paragraph rewrapped. The
  "Acceptance unchanged" check keeps its command: the base moves, the
  diff does not.
- [ ] `run.md § Seats`' intro sentence gives the user, under
  `Supervisor: AI`, the merges outside the declared bounds beside the
  asked-of row and the acceptance-approval cell, matching the Merging
  row's "else user"; the file stays within 300 lines and 80 columns
  (table rows exempt). Approach: "and the user holds the asked-of row
  and the acceptance-approval cell." reads "and the user holds the
  asked-of row, the acceptance-approval cell and the merges outside the
  declared bounds (the Merging row's "else user")." - one line, the
  file at 298 after the item above.
- [ ] `companions/declarations.md § Supervisor bounds`' decision split
  names acceptance text, not plan content, as design-level, the
  approach being the implementer's (`run.md § Seats`). Approach:
  "`DESIGN.md`-level structure, plan content." reads "`DESIGN.md`-level
  structure, acceptance text."; no other word changes.
- [ ] `companions/supervisor-runbook.md § Two variants`' "Who starts
  it" row carries no `(run.md § Seats)` cite, the table having no row
  for starting the runner. Approach: the row reads "| Who starts it |
  the user, in a terminal | the user, over ssh |"; the rest of the
  table and the file unchanged.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` and `bash scripts/ci/run-all.sh` green, the task marked in
  `tasks.md`. Approach: the close review reads every site the items
  above name for its cite; then mark the task, cleanup, commit.
