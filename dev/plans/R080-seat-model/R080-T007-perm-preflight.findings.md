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

- **Item 2, when the client reads a settings tier.** The one-content
  rule rests on "the tier's working-tree file, which is what the
  session's own permission check reads and so what binds the run", and
  the resume that follows has the user edit the tracked project tier at
  the halt, re-enter `§ Pre-flight`, and the run continue with no
  restart. Nothing in the plan's inputs establishes when the client
  reads a tier. If tiers are read at session start, the script reports
  the deny present while the halted runner session is not bound by it,
  and deny rules are the hard floor (`requirements.md § Invariants`).
  What settles it is a client-behavior fact the plan can cite, or a
  resume that names a session restart. The allow half of the assumption
  is pre-existing in `run.md § Pre-flight`; the deny half is this
  branch's.

- **Item 2, how a deny string is matched against a needed allow rule.**
  The cannot-apply list carries "a needed allow rule any tier denies",
  where every other class has an explicit matching rule - prefix
  coverage for Bash, literal-prefix containment for paths, exact for
  WebFetch and bare tools, exact string for the declared deny set - and
  the same paragraph says "A deny rule is the one class no coverage rule
  reaches", which is about satisfying the declared entries rather than
  testing a tier's deny against an allow. Exact string, prefix overlap,
  or the containment rule read the other way is the implementer's to
  pick, and it decides whether a worker's `Bash(git push origin main:*)`
  deny conflicts with an allow rule.

- **Item 2, whether an unresolvable default branch stops a pattern-2
  session.** "A default branch the script cannot resolve and so no
  pattern-1 string to check" implies the cannot-apply fires only where a
  pattern-1 string must be built, while the check-order sentence ("The
  pattern read needs `<default>`") reads as unconditional. Live here,
  not a corner: `git symbolic-ref --short refs/remotes/origin/HEAD`
  exits 128 in this checkout, so an adopter on pattern 2 with no
  `init.defaultBranch` either passes or is stopped depending on the
  choice.

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

## Approach notes

- **Item 1, where the entry branch gets `<repo>`.** The approach says
  "`<repo>` is `$top`, the physical top level the entry check resolved",
  but the entry branch it describes names `resolve_target` and the
  `git -C "$dir" status` test and computes no `$top`; only the restore
  helper does, with `rev-parse --show-toplevel` then `cd && pwd -P`.
  Reusing that computation in the entry branch is the obvious reading.

- **Item 2, the report-status list does not cover the lines the item
  needs.** "Report lines carry one status each: `present (…)`,
  `missing`, `inert (auto)`, `applied (local)`, `cannot apply:
  <reason>`" leaves four kinds of line homeless. The mode-assertion
  lines use another vocabulary - two test cases in the same paragraph
  assert a `defaultMode` "printed as untracked" and "an untracked tier
  passes with its value printed". Most cannot-apply reasons attach to no
  rule at all (untrusted workspace, `jq` absent, missing `.claude/`, an
  unwritable local tier, an unresolvable default branch), so whether
  `cannot apply` is a standalone line, a trailing verdict or a header is
  unstated. For pattern 2 under `Supervisor: AI` the items disagree in
  shape: item 1 reads that entry `present (user)` where item 2 lists the
  case as cannot-apply, and one line cannot carry both under "one status
  each". And the missing-deny remedy and the pattern name itself have no
  place in the grammar. No test case pins report text.

- **Item 2, the tier-path canonicalization states no failure route.**
  `tier="$(cd "$(dirname "$tier")" && pwd -P)/$(basename "$tier")"`
  carries none, where `--project` two paragraphs above has "a failure
  exiting non-zero". Two cases fall through: a tier whose directory is
  absent, where the substitution yields `/settings.json` and reaches
  `untracked` only by accident; and a tier file that does not exist,
  which is the ordinary state of `.claude/settings.local.json` before
  the first `--apply`, where "`untracked` passes with the tier's value
  printed" has no value to print. Whether the script runs under `set -e`
  - which decides whether the failed `cd` aborts or falls through - is
  also unstated.

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

- **Item 2, the convergence sentence's `MAINTENANCE.md` cite.** It
  cites `§ Generalize allow rules` step 5 for promoting a durable rule
  into the tracked project tier, where step 5 reads "Rule covered by a
  broader tier (global ⊃ project ⊃ local) → keep the broad one, delete
  the shadowed" - it deletes a shadowed rule and adds nothing to the
  broader tier (`MAINTENANCE.md:96-97`, verified). The cite needs
  another step or another home.
