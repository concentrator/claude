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

- **Item 1, four denied shapes and three reason lines.** The item says
  the branch "denies four shapes ... Its three reason lines carry the
  predicate and the rule". The trunk-entry line reads "it enters the
  default branch of `<repo>` with uncommitted work", which is false for
  the second shape, a `-b|-B|-c|-C` naming the default branch from a
  clean tree, and no rationale for that shape appears in the item.
  Either a fourth line or a stated sharing with its wording is needed.

- **Item 2, the requirement 8 deviation is declared but reconciled
  nowhere.** The item calls itself "this plan's one deviation from
  `requirements.md § Desired state` 8". That requirement and its
  acceptance criterion both say the pre-flight applies every adjustment,
  where this plan has it propose and the user apply, the settings
  surface being a host gate. No item and no backlog line amends either,
  so R080-T005's criterion stays unmeetable as written. A plan cannot
  amend a requirement; who does is not settled by the plan's inputs.

- **Item 1, the carve-out pattern is read per tier and tiers can
  disagree.** "A tracked `deny` carrying the blanket entry is pattern 2
  ... one carrying both narrow entries is pattern 1" says nothing about
  a user tier on one pattern and a project tier on the other, where the
  union is the session's reality; the text implies pattern 2 by "deny
  beats allow" without saying so. Unstated too: whether a deny in the
  untracked local tier participates. It binds the session; the script
  reads only tracked tiers for denies.

- **Item 1, the withheld-`hooks/` fork leaves its order open.** "The
  implementer writes the companion and the test, the branch is the
  user's to apply, and the item halts to the user when it is reached and
  resumes on their commit" admits two orders: the implementer commits
  first and the hook test is red in `Test (full)` until the user
  commits, or the halt comes first and the implementer follows. R080-T011
  is `[ ]`, so the tree cannot settle which fork holds yet.

## Approach notes

- **Item 2, the default branch's name.** How the script learns
  `<default>` for the pattern-1 deny strings is unstated; no declaration
  in `companions/declarations.md` or `companions/toolchain.md` gives it,
  and `hooks/dev-branch-guard.sh`'s `is_trunk` chain - `origin/HEAD`,
  `init.defaultBranch`, then the main/master literals - is the only
  precedent.

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
