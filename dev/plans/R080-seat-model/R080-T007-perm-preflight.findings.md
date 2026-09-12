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

- **Item 1, which content of a tracked tier satisfies a deny entry.**
  "Each entry is satisfied only by that exact string in a tracked tier's
  `deny` ... Tracked is the literal word: the tier's file is git-tracked
  in the repository owning it ... so the project tier satisfies an entry
  once its `.claude/settings.json` is committed" carries two readings
  that pass different trees: the file is tracked and the string is read
  from the working-tree file, so an uncommitted deny added to a tracked
  file satisfies; or the string must be in the committed content
  (`git show HEAD:$rel`, how item 2's approach reads the mode key). The
  literal-word sentence points to the first, the rationale "a fresh
  clone keeps it" and the word "committed" to the second, and item 2's
  approach names `HEAD:$rel` for the mode key alone. Which content a
  deny entry is read from is the implementer's to settle in the approach
  text.

## Approach notes

- **Item 1, where the entry branch gets `<repo>`.** The approach says
  "`<repo>` is `$top`, the physical top level the entry check resolved",
  but the entry branch it describes names `resolve_target` and the
  `git -C "$dir" status` test and computes no `$top`; only the restore
  helper does, with `rev-parse --show-toplevel` then `cd && pwd -P`.
  Reusing that computation in the entry branch is the obvious reading.

- **Item 2, the tier list in `missing (untracked in <tiers>)`.** With
  two untracked tiers carrying the entry - an adopter's user tier beside
  local - the separator and the order are unstated. Tier order
  `user, project, local`, comma-separated, is the obvious reading.

- **Item 1, the adopter claim about `$HOME`.** "None in an adopter,
  whose `$HOME/.claude/settings.json` no repository tracks" is a claim
  about adopters rather than a rule: a `$HOME` that is itself a
  dotfiles checkout tracks that file, and the literal rule then counts
  the user tier as satisfying. The rule as written is what to build; the
  sentence needs no fix unless the plan means to exclude that case.

- **Item 2, the toolchain parse.** "A span holding no space is a CLI
  name ... and contributes no prefix" also drops a one-word command
  (`make`, `pytest`), which the rule cannot tell from a CLI name. And
  "(the second span of the Test (full) bullet)" miscounts: that bullet
  holds one span. The yield list itself is right.

- **Item 1, the allow walk.** "The `Read(//__HOME__/.claude/...)` rules
  to the dispatch companions that name those trees" does not hold: no
  prompt companion names `.claude/skills`, `.claude/rules` or
  `settings.json`. The skills tree is named by the seat definitions, and
  nothing in the four sources names `rules/**` or
  `Read(//__HOME__/.claude/settings.json)`. The acceptance rule drops
  the last two; the approach's claim that every other entry is kept is
  wrong as written.

- **Item 4, the LAYOUT node's padding.** "Which the 24-character name
  reaches with six spaces" miscounts: siblings put `#` at 34 characters,
  which a 24-character name reaches with two spaces.

- **Item 2, the tier comparison's path.** `rel=${tier#"$top"/}` assumes
  the tier path is already physical. `--show-toplevel` returns a
  physical path, so a symlinked `$HOME` component reads every tier as
  `untracked` and passes. It fails open, and one canonicalizing `pwd -P`
  closes it, as `--project` already has.
