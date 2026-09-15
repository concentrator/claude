# R080-T005 findings

Notes the last cold read reported and no planner fixed, one bullet per
gap. `write-plan.md` step 6 sends what a second read finds here rather
than to another planner pass. The implementer reads them with the plan;
the close triages what is still open.

- [x] **Item 1's line budget is about 28 characters short, and `run.md`
  fails its cap if the item is followed literally.** Approach-level, so
  it is the implementer's to fix in the commit that carries the edit
  (`run.md § Seats`). The approach says the swap frees 7 characters and
  tightening "reports every rule with the tier carrying it" to "reports
  each rule's tier" pays for the rest. Measured on the tree: the bullet
  runs 299 characters over its lines, the swap frees 7 and the
  tightening 19, and the cite
  `` (`companions/supervisor-runbook.md § Modes by seat`) `` costs 54 -
  net +28, which pushes the bullet to a fifth line and `run.md` to 301
  against `scripts/ci/check-caps.sh:12`'s `(( n <= 300 ))`. Dropping
  `companions/` from the cite does not close it. The implementer needs
  a shorter route - more tightening in the same bullet, a shorter cite
  form the file already uses, or a line recovered elsewhere in
  § Pre-flight - and the choice is the approach's to record.

- [x] **Item 5's evidence arms do not cover a third shape the pilot
  history holds, and its stop rule makes the outcome undecidable.**
  Acceptance-level. The item describes two shapes: acceptance text
  changing in commits that carry no code, and approach edits riding the
  implementer commits that carry theirs, the checkbox being the one
  above-the-run-in change an implementer commit makes. The branch's
  mandatory final commit "Complete R080-T007: permission pre-flight" -
  the runner's under `run.md § Close` 4, not a planner's - carries no
  code and changes acceptance text beyond its checkbox, inside an item
  that has no `Approach:` run-in at all. It is neither arm. Item 5 then
  says "Where a check returns something the criterion does not admit,
  the item stops and reports rather than marking", so one implementer
  marks criterion 5 and another halts the branch. A halt here is
  legitimate and takes `run.md § Question resolution` to a planner;
  what the item cannot do is leave the choice open. Everything else in
  the check holds: all 15 commits that changed acceptance text on the
  pilot branch carry no code, and every code-carrying implementer
  commit's only acceptance-region change is its checkbox.

- [x] **Item 3's "all four verifier-class seats" rests on a paragraph
  `agents/dev-docs-verifier.md` does not have.** Acceptance-level. The
  item says the whole verifier bound is what that file "alone carries
  today across its conduct and its § Probing", and that striking the
  `tasks.md` leaving closes it for four seats. The file has no conduct
  paragraph; its only read-only clause is § Probing's closing "toward
  the checkout you stay read-only", and it carries nothing of "runs no
  git that moves HEAD, switches a branch or changes the working tree" -
  the clause the pilot's own `git checkout main` incident motivated.
  The approach names three files, so an implementer strikes a leaving
  as closed across four seats while the fourth was never audited.
  Either the docs verifier is in scope for the same paragraph, making
  it a fourth file the approach names, or the item says why § Probing's
  shorter clause suffices and drops the "whole verifier bound" framing
  for it.

- [x] **Item 4's criterion-3 evidence omits one of the criterion's own
  four verifications.** Acceptance-level, one clause. Criterion 3 as
  amended verifies by the plan's `cold-read: passed` header, **the
  commit that recorded it**, the doc-writer commit, and
  `companions/implementer-prompt.md`'s input set. The item lists three
  and drops the recording commit, so the `Evidence:` line written from
  it under-covers the criterion it marks. The commit exists and the
  plan names it elsewhere: "Record the cold-read pass for the reopened
  items".

- [x] **Item 6's criterion-7 backlog line records a hole without its
  consequence.** Acceptance-level. The item has the implementer append
  the reviewer's missing duty row to `tasks.md`'s backlog, which is the
  right destination, but nothing in it says that `run.md:33` - "A run
  reaching a duty the duty table below leaves unassigned halts and
  reports, never improvises" - makes the missing row bite every spec
  check the flow dispatches, this branch's included. A close-out reader
  gets a note about a table hole and no signal that the live flow has
  been improvising past it, which is the fact that justifies deferring
  a one-line edit to a file at its cap.

- [x] **Item 5's three-class sort leaves out a fourth class the tree
  holds: the runner's standalone bookkeeping commits.** Acceptance-level.
  The item sorts the pilot plan file's history into planner, implementer
  and runner-final commits "and no fourth". The tree holds commits whose
  only plan-file change is `+cold-read: passed` and which carry no code -
  six inside PR #540 ("Record the cold-read pass for the reopened items",
  "... for the subject-guard item", "... for the worker-seed item",
  "Record R080-T007's cold-read pass on the close items", "... and last
  notes", "... and notes"), seven across the whole file history. They are
  the runner's, not the planner's: `run.md § Question resolution`, the
  item's own cite, says the pass "is recorded in the runner's own
  bookkeeping commit on the item's branch". The item's only clause for
  them - "A `cold-read: passed` key riding such a commit is bookkeeping,
  not plan text" - reads on the runner's *mandatory final* commit, which
  does carry the key alongside its `[x]`; a commit whose entire content
  is the key is not a key riding a commit. Under the item's stop rule,
  which now names "a commit touching the plan file outside those three
  classes", one implementer marks criterion 5 and another halts the
  branch - the same undecidability the note above reported, in a new
  shape. Fix direction: sort plan-file *changes* rather than commits, or
  name the bookkeeping commit as a fourth class.

- [x] **Item 3's acceptance enumerates a bound neither existing half
  carries, so the approach cannot compose it.** Acceptance-level, with an
  approach knock-on. The acceptance has each definition state that a
  probe runs in a throwaway tree "with `GIT_DIR`, `GIT_WORK_TREE` and
  `GIT_INDEX_FILE` unset ..., where mutating git is the probe's own
  subject". `agents/code-reviewer.md` has no probing clause at all, and
  `agents/dev-docs-verifier.md § Probing` says only "runs in a throwaway
  repo, bounded by ... § Verifier isolation": the three variable names
  live in `companions/verification-policy.md § Verifier isolation` alone.
  So the approach's "composed from the two halves that exist" cannot
  produce what the acceptance enumerates, and an implementer cannot tell
  whether each file spells the three variables out or cites the section
  holding them. Second edge of the same sentence: the approach gives
  `dev-docs-verifier.md` the git clause only, so it keeps "toward the
  checkout you stay read-only" without "no writes, no file edits" and
  without the env vars, which makes the approach's "so the four read
  alike" unachievable as written. Settling enumerate-vs-cite settles both.

- [x] **Item 6's "criterion 7's read is recorded unmarked" names no
  destination for the record.** Acceptance-level, minor. The approach
  writes nothing for criterion 7 in `requirements.md` - it names
  criterion 8's mark and evidence line, then the `tasks.md` backlog
  sentence - so an implementer can read "recorded" as an `Evidence:`-style
  line under a still-`[ ]` criterion 7. The approach's silence is the
  likelier reading; the acceptance should say the record lives in
  `tasks.md` only.

- [x] **Item 5's criterion-6 grep pre-clears one hit class and the
  tightened stop rule turns the rest into judgment calls.**
  Acceptance-level, minor, carried over rather than introduced. A literal
  grep for a project's docs, plans or session tree by path also returns
  `companions/declarations.md`'s own `- Docs: docs/`, `- Plans:
  dev/plans/`, `- Session: dev/session/` block and the `P=${P:-dev/plans}`
  fallbacks in `check-plan-integrity.sh`, `check-archival.sh`,
  `check-accretion.sh` and `check-batch-tags.sh`. Both are admitted -
  `declarations.md § Declared paths` calls that block "their one home"
  and has a reading script carry "its default once, as the fallback of
  the read" - so the check is resolvable from the tree, but the item
  pre-clears only the `dev/docs` migration-source class. One clause
  citing that section closes it.

- [x] **Item 4's approach names the plan MR/PR by description, not by
  number.** Approach-level, so the implementer's to settle in the commit
  that carries the edit (`run.md § Seats`). The record commit sits on
  PR #536 (`plan/r080-t007-preflight`), derivable only by walking merges
  or querying `gh`, while the approach closes with "the run itself as
  PR #540" - so the evidence line would cite one run by number and one by
  a bare description, against `rules/writing-artifacts.md § Name things by
  their durable id`. Name the number, or say the evidence line cites that
  commit by subject alone.

- [x] **Item 5's list of what the runner's final commit changes is three
  items long where the plan file holds two.** Closed as delivered: the
  approach dropped the three-way list, and criterion 5's `Evidence:`
  line names what the two final commits changed - the `[x]`, the
  `cold-read: passed` key on the second, the task mark in `tasks.md`,
  and the stale line cite corrected in the first - each readable
  against the plan file and `tasks.md`. Wording, lowest. It reads "its
  `[x]` and the plan-complete and task marks `branch-plan.md § Closing
  routine` 7 assigns the runner", but in the plan file that commit made
  two changes - the `[x]` and the line-cite fix - while the task mark
  lands in `tasks.md` and "plan complete" has no separate marker, being
  the same `[x]`. Harmless to the class sort; it makes the evidence
  line's three-way list unverifiable against the plan file alone.

- [x] **Item 5: criterion 6's layout axis has no check and falls outside
  the predicate.** Closed as delivered on all three fix directions: the
  approach's grep pattern takes `LAYOUT.md` and folds `check-stray.sh`'s
  `L=${L:-.claude/LAYOUT.md}` into the same admitted fallback class as
  the four `P=${P:-dev/plans}` defaults, and criterion 6's `Evidence:`
  line reads on the layout axis with the rest and names both halves of
  the LAYOUT clause - `check-stray.sh` for this repository, and
  `scripts/test/install-dev.test.sh`'s two-install case for an installed
  project. Acceptance-level. The item checks "no rule that names
  a project's docs, plans or session tree by a literal path", and its
  predicate names the same three axes. Criterion 6 itself reads "docs,
  plans, session **or layout**", and adds that `.claude/LAYOUT.md` holds
  the full tree "in this repository and in every installed project". Two
  consequences on the tree: `scripts/ci/check-stray.sh` reads the
  declaration and then carries `L=${L:-.claude/LAYOUT.md}`, the same
  fallback class `companions/declarations.md § Declared paths` admits,
  but the item's admitted list names only `P=${P:-dev/plans}` in four
  other scripts, so the implementer meets an admitted-looking hit the
  item does not name and whose axis the predicate omits; and nothing in
  the item's check list evidences the this-repository half of the LAYOUT
  clause, though `check-stray.sh` is the check that pins it. Same shape
  as the criterion-3 under-coverage the planner fixed in item 4. Fix
  direction: widen the predicate's axis to include layout, fold
  `check-stray.sh`'s default into the admitted fallback class, and say
  whether the criterion-6 evidence line covers the LAYOUT half and by
  which run.

- [x] **Item 5: the pinned range's descriptive clause does not match the
  tree, though the pin itself is unambiguous.** Closed as delivered on
  the first fix direction: the pin stands and criterion 5's `Evidence:`
  line calls the range the branch as merged, naming the six
  plan-MR/PR-era commits it carries and saying the detail round that
  wrote the plan and the earlier plan-MR/PR commits sit before it.
  Acceptance-level. The item pins criterion 5's commit set to the range
  between PR #540's merge commit's two parents, described as "the branch
  as merged, which carries the plan-MR/PR-era commits that opened it".
  The range does carry the six named commits, but they are not the
  commits that opened the plan: the pilot plan file was created in
  "Detail R080: eight tasks and their branch plans", and nine plan-file
  commits precede the range's start, including two acceptance rewrites
  ("Rewrite R080-T007 around what enforces the set", "Re-plan R080-T007
  against the seat definitions") and the very commit item 4 cites as
  criterion 3's record, "Record R080-T007's cold read and its open
  notes". Criterion 5 asks after "Every branch plan written, and every
  acceptance change made, after this R lands", so an evidence line
  written off this range covers the merged branch and not the plan's
  writing. The implementer cannot tell whether the exclusion is
  deliberate scoping, which would want saying in the evidence line, or
  an error in the pin. Fix direction: one clause saying the range is the
  merged branch and that the detail-round and earlier plan-MR commits
  sit outside it, or a wider pin.

- [x] **Item 3: the two seats without `Write` are sent down a route
  whose hazard note stays in another file.** Closed won't-fix: item 3's
  acceptance rules that sentence into `agents/dev-docs-verifier.md`
  alone, so the residue is the ruling's rather than a gap this branch
  closes, and the tree matches the ruling - the sentence sits in that
  file and in `agents/dev-implementer.md`, the two seats holding
  `Write`. Whether the warning should reach the two Bash-only seats is
  the R080 close-out's to route. Observation rather than gap, low. The
  item rules the spec reviewer's and cold reader's fixture "a fixture
  their Bash builds and no `Write`-built one", and keeps the
  heredoc-versus-`Write` sentence in `agents/dev-docs-verifier.md`
  alone. That sentence's reason is a live hazard - a shell heredoc
  carrying JSON or JS trips the harness obfuscation guard and stalls the
  run on a permission prompt - which reaches any Bash-built fixture. So
  the two seats without `Write` get the route and not the warning.
  Nothing blocks the implementer: the ruling is explicit and the edit is
  text, so this is a consequence the item chose rather than a question
  it left open.

- [x] **Item 5's approach names no way to resolve the merge commit.**
  Approach-level, so the implementer's to settle in the commit that
  carries the edit (`run.md § Seats`). "The `git log` over the plan file
  across that merge range" needs the merge commit, and
  `rules/writing-artifacts.md § Name things by their durable id` bars a
  hash. `git log --merges --grep "#540"` resolves it in one call.

- [x] **Item 3's approach does not say whether § Probing's "The fixture
  lives outside the checkout" half travels.** Approach-level. The
  traveling text is named as "`agents/dev-docs-verifier.md § Probing`'s
  throwaway repo"; that half is named neither as traveling nor as
  staying, and the § Verifier isolation cite already carries "never
  against the live repo", so either choice is defensible.

- [x] **Item 3's approach rewrites a sentence whose other half it does
  not mention.** Approach-level. § Probing's closing sentence is "The
  fixture lives outside the checkout, and toward the checkout you stay
  read-only.", and the approach replaces "its shorter 'toward the
  checkout you stay read-only'", so the rewrite has to preserve the
  fixture half. Wording is the implementer's.

- [x] **Item 6's approach reads as if the backlog sentence should state
  a ruling.** Approach-level. "One sentence carrying the hole, the halt
  sentence it sits under, and the ruling that closes it" invites writing
  the ruling; the acceptance settles it the other way - what moves is "a
  ruling, not a one-line edit" - so the sentence names the candidates
  and leaves the decision to the R's close-out.
