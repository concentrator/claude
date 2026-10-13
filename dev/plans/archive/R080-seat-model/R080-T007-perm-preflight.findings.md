# R080-T007 findings

Notes the second cold read still reported and no planner fixed, one
bullet per gap. `write-plan.md` step 6 sends what a last read finds here
rather than to another planner pass. The implementer reads them with the
plan.

- [x] **Item 2, when the client reads a settings tier: settled, the plan
  stands.** Closed won't-fix: the note records its own verdict and asks
  for no change; promoting the fact is R080's, not this branch's. The one-content rule rests on the tier's working-tree file
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

- [x] **Item 4, `present (local)` is stated without its qualifier.**
  Closed won't-fix: every shipped word is already qualified, so no
  reader meets the over-strong claim; rewriting an approved acceptance
  sentence after the fact buys nothing. "Its
  seeded local tier satisfies both entries - `present (local)` under the
  first item's rule" holds only where no earlier tier carries the pair;
  item 1 states the same claim with that qualifier and item 4's
  acceptance drops it. A worker cloning a project whose tracked
  `.claude/settings.json` carries the pair - as this repository's does -
  prints `present (project)` under the tier order. The gate still
  passes, and the shipped text is already qualified: item 4's approach
  states the tier order instead, and `scripts/worker-workspace.sh`'s
  `settings()` comment reads "each reported against the first tier that
  carries it". The over-strong wording is the acceptance sentence alone.

## Close triage

- [x] **The pre-flight self-test's assertion helpers pass vacuously on
  any early exit.** Promoted: it is R080 backlog, named in the final
  commit's backlog paragraph. `rcn()` tests `[ "$RC" -ne 0 ]`, so it
  treats the 127 `bash` returns for a missing file as the non-zero exit
  it wanted, and `nowant()` passes whenever its `grep` finds nothing, so
  both read an aborted run as the behavior they assert. The subject
  guard closes the case this branch found - an adopter whose `.claude/`
  lacks the script or the template - but a syntax error, a host without
  `jq`, or any other early exit still satisfies all 21 sites - 12 `rcn`
  and 9 `nowant`.
  Tightening them needs a per-case review of which negative assertions
  legitimately produce short output, which is why it is not a widening
  of the guard. Its own task in R080.

## Approach notes

- [x] **Item 4, the LAYOUT node's padding.** Closed won't-fix: approach
  text, and the shipped node is padded correctly - the arithmetic was
  wrong where the result was not.

## Reopening read

The last read of the two items the branch reopened on. It passed both,
so these are what it still reported and no planner fixed
(`write-plan.md` step 6). The implementer reads them with the plan; the
close triages what is still open.

- [x] **The fix item's `Cannot iterate over null` exit code is wrong.**
  Acted on by the implementer: the approach now reads "exits 5 (probed
  on this host's jq 1.7.1)", and the spec check re-probed the 5.
  The approach says iterating a null "returns 1"; jq exits **5**. The
  consequence it draws holds - the pipeline's `|| return 1` fires either
  way - and the approach is the implementer's to correct while working.

- [x] **The comment anchor under-covers its sentence.** Half acted on,
  half withdrawn: the implementer rewrote the sentence the note pointed
  at, and left the cite because the note is wrong about whose it is. The
  cite sits before the `Approach:` run-in, so it is acceptance, which
  `run.md § Seats` makes the planner's to change with the user's
  approval. The approach
  cites `scripts/test/worker-workspace.test.sh:266-267` for case 46's
  comment; the comment runs 266-269 and the `sed` sentence ends on 269.
  The clause to rewrite does sit on 266-267, so the edit is findable.

- [x] **"Both stay required" has a loose antecedent.** Routed to the
  final commit as an acceptance repair, the ambiguity being one a reader
  could act on by skipping the full local suite. In the close
  item, the preceding sentence names both "every gate on this host" and
  `bash scripts/ci/run-all.sh`, so a reader can take "Both" as the lint
  tier and the CI run and never run `scripts/test/run-all.sh` - which
  `finish.md § 1` requires as the branch's one full local run.

- [x] **The close item's mark lands before the evidence that can
  falsify it.** Closed won't-fix: the item resolves it in terms, as the
  note itself says, and a mark that a red run clears again is the
  ordering `§ Closing routine` 7 asks for, not a violation of it. Its acceptance makes the pushed CI run the close
  condition, but the implementer ticks the box and writes
  `R080-T007`'s `[x]` at commit time, before that run exists. The item
  resolves it in terms - its commit is the branch's last commit and not
  its close, and a red run reopens and clears the mark again - so this
  is legible rather than broken.

- [x] **The property's `grep` is a proxy, not a reading.** Closed
  won't-fix: wording, and the proxy is sound for the property it stands
  in for - run at both revisions it matched exactly the two hazard lines
  and nothing else. It matches
  any `${var//pattern/replacement}` in the two scripts, so a literal
  replacement would trip it, and it would miss a pattern half carrying
  `/`. Sound evidence for this property here - run twice, it matches
  exactly the two hazard lines and nothing else - but the acceptance
  calls it a reading of the property.

- [x] **The close item's claim about this file is now stale.** Closed
  by the ruling the note asked for: the notes landed open and are
  triaged here, and no acceptance was rewritten to make the sentence
  true again. It says
  the findings entries "are all `[x]` and are not reopened", true when
  written; these six notes are open, and `branch-plan.md § Closing
  routine` 6 asks the close to triage them. Left as the user ruled:
  open, triaged at close, with no acceptance rewritten to make the
  sentence true again.

- [x] **A fourth assertion is masked on CI by the fixture's location.**
  Promoted: it is R080 backlog, named in the final commit's backlog
  paragraph. A test that cannot fail where it runs is the branch's own
  lesson twice over.
  `preflight-permissions.test.sh:104` ("an `&` path opens no gap to
  apply") survives a mangled `Edit` rule because the fixture lives
  under `/tmp` and the fixture tier carries the template's own
  `Edit(//tmp/**)`, whose literal prefix covers the mangled path. It is
  green on CI today, so it is correctly absent from the fix item's
  acceptance; on a bash-5.2 host whose `mktemp -d` sits elsewhere it
  would fail. The masking is the test's, not the fix's. "Which the 24-character name
  reaches with six spaces" miscounts: siblings put `#` at 34 characters,
  which a 24-character name reaches with two spaces.

## Second count, read 2

The planner pass that bound the close item's gates and widened its
leavings started a count of its own (`write-plan.md` step 6). Read 1's
three gaps went back to a planner; these are what read 2 still
reported, and it is the last read, so they are notes rather than
another pass. The runner settled the first two as close conduct, the
user ruling on all four together.

- [x] **The item asserts a findings state this read invalidates.** Settled by
  the runner as close conduct: these four notes are written resolved,
  with the rulings that resolve them, so the file is all `[x]` when the
  close stages it and the item's two clauses are true as written. Where
  a later branch lands open notes at commit time, triage precedes
  staging - `§ Closing routine` 6 wants the decision, and "staged as it
  stands" describes the file after that triage, not instead of it. The item says the findings file's entries are
  "all `[x]` and are not reopened" and that it "is staged as it
  stands", both true of the tree when written; step 6 then sends this
  read's own notes to that same file. An implementer meeting open notes
  would stage them unresolved.

- [x] **The nine untracked directories get a prohibition and no
  disposition.** Settled by the runner, and by the user's standing
  instruction: they survive the close untouched. `cleanup` in
  `§ Closing routine` 6 means stale or temp data this branch created,
  never `feedback/`, `wallarm-knowledge/` or the seven `skills/`
  directories, none of which this branch wrote or is entitled to
  remove. The item bars `git add -A` for
  sweeping them in but never says they stay, while `cleanup (stale/temp
  data)` sits in the same stage list and this backlog paragraph names
  `git clean -fd` as the verb that discards untracked work. The end
  state the item promises is "no modified tracked file behind", so the
  nine `??` lines `git status --porcelain` prints after staging are
  expected rather than a dirty branch; `finish.md § 3`'s test is cited
  without that narrowing, which `hooks/dev-branch-guard.sh:302` makes
  with `--untracked-files=no`.

- [x] **The cap leaving's conclusion is true of one file, not two.**
  Ships as written, with this note as its correction: the overstatement
  is in a backlog line whose job is to reach a planner, and that planner
  reads the cap from `scripts/ci/check-code-size.sh` rather than from
  the sentence. Not worth a third count on a branch at 42 commits.
  "The next change to either needs a restructure, a split, or an
  allow-list decision" holds for `scripts/preflight-permissions.sh`,
  which is on the 300-line cap with nothing to spend, and not for
  `scripts/test/preflight-permissions.test.sh`, which has room for an
  ordinary change. Dropping the per-file counts fixed read 1's
  `§ One home per number` gap and took with it the thing that let a
  reader see the two files are in different states.

- [x] **The size-cap leaving states half of the rule it cites.** Ships
  as written, same reasoning. `branch-plan.md § Size cap` reads "warn
  past 20, prompt to split past 30 … subordinate to the short-lived
  governor (`git-workflow.md § Delivery cadence`). Override with stated
  reason in plan header." The leaving names only the 30 prompt, so the
  20 warn passed unremarked too, and its option space - a mechanical
  check or a runner's judgement - omits the override the rule already
  offers and the delivery-cadence subordination that makes the commit
  count a proxy for the real limit. A planner ruling from the backlog
  line alone could build a gate that contradicts its own rule, which is
  why the whole rule is quoted here.
