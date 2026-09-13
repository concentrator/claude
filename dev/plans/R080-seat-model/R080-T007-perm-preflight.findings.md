# R080-T007 findings

Notes the second cold read still reported and no planner fixed, one
bullet per gap. `write-plan.md` step 6 sends what a last read finds here
rather than to another planner pass. The implementer reads them with the
plan.

- **Item 3, the `§ Failure modes` cite does not carry the reshape, and
  the entry the approach keeps contradicts the new text.** The item says
  "The seat reshapes the command per `companions/supervisor-runbook.md
  § Failure modes` and re-runs it itself ... Nobody clears it, and no
  count of events is kept anywhere", and the approach says that section
  "keeps its classifier entries". It has three, not two
  (`companions/supervisor-runbook.md:208-215` and `:228-230`): a
  classifier failing closed ("could not evaluate") answered by writing
  readable commands; a transcript overflow answered by manual approval;
  and "The classifier denies a previously-allowed command: denials are
  nondeterministic - retry once, identical; a second denial is an
  answer." Only the first is a reshape, and it is keyed to the
  could-not-evaluate message rather than to a denial. A denial proper is
  the third, whose remedy is an identical retry with a count of one -
  the retry and the count the new `run.md` text says nobody holds. The
  approach edits the second entry and the `defaultMode` entry and leaves
  the third, so after the branch the runbook says "retry once,
  identical" where `run.md` says "reshape, no count". Settle which the
  seat follows, and whether the third entry is rewritten, retired or
  re-scoped.

- **Item 3, the reshape instruction has no home in a file the seat
  reads.** A seat's inputs are the plan, the docs and the code
  (`companions/implementer-prompt.md § Inputs`); no seat definition or
  dispatch companion tells it to read the runbook. "Reshape and re-run,
  else BLOCKED with the classifier's text" therefore reaches no seat.
  The dispatch companion is this branch's to change; a definition
  paragraph is R080-T011's.

- **Item 3, "halts the item to the user as any blocker does
  (`branch-plan.md § Stop conditions`)" names no row.** That table has
  two blocker rows: absorbable, routed to `run.md § Question
  resolution`, which reverts the item's uncommitted edits and
  re-dispatches a planner - and a planner cannot fix a classifier
  denial; and premise-invalidating, which halts and reports. `run.md
  § Checkpoint`'s Halt bullet draws the same split. A classifier BLOCKED
  is neither, so whether the revert runs and what re-enters the item
  afterwards is undetermined. Unstated too: a classifier denial of the
  runner's own command (`git merge`, `git tag`, the halt's `git
  read-tree`, all under `auto`) fits neither class, the classifier-event
  class being defined as landing inside a seat's `Bash` call.

- **Item 2, when the client reads a settings tier: settled, the plan
  stands.** The one-content rule rests on the tier's working-tree file
  being what the session's own permission check reads, and the resume
  that follows has the user edit a tier at the halt and re-enter
  `§ Pre-flight` with no restart. A probe on this host settles it: with
  `deny: ["Bash(git tag:*)"]` added to `.claude/settings.local.json`
  mid-session, `git tag --list` was denied while `git status --short`
  ran; with the key removed, `git tag --list` ran. The client re-reads
  a tier live, in both directions, so a deny the pre-flight reports
  present is a deny that binds the halted session. Cite the fact rather
  than re-deriving it; it is R080's to promote
  (`tasks.md § Archival, promotion target`).

- **Item 4, `present (local)` is stated without its qualifier.** "Its
  seeded local tier satisfies both entries - `present (local)` under the
  first item's rule" holds only where no earlier tier carries the pair;
  item 1 states the same claim with that qualifier and item 4 drops it.
  A worker cloning a project whose tracked `.claude/settings.json`
  carries the pair - as this repository's does - prints
  `present (project)` under the tier order. The gate still passes, so
  the defect is the sentence; but item 4's approach makes these words
  the `settings()` comment, so the over-strong claim would land in
  `scripts/worker-workspace.sh`.

- **Item 2, the convergence sentence's `MAINTENANCE.md` cite; routed to
  this branch's close.** It cites `§ Generalize allow rules` step 5 for
  promoting a durable rule into the tracked project tier, where step 5
  reads "Rule covered by a broader tier (global ⊃ project ⊃ local) →
  keep the broad one, delete the shadowed" - it deletes a shadowed rule
  and adds nothing to the broader tier (`MAINTENANCE.md:96-97`,
  verified), and no other step in the section promotes. The cite needs
  another step or another home. Nothing in the script turns on it: the
  operative claim, that the script writes only the local tier, holds.

## Approach notes

- **Item 4, the LAYOUT node's padding.** "Which the 24-character name
  reaches with six spaces" miscounts: siblings put `#` at 34 characters,
  which a 24-character name reaches with two spaces.
