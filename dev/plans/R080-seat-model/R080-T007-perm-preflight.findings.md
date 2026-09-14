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

- [ ] **The fix item's `Cannot iterate over null` exit code is wrong.**
  The approach says iterating a null "returns 1"; jq exits **5**. The
  consequence it draws holds - the pipeline's `|| return 1` fires either
  way - and the approach is the implementer's to correct while working.

- [ ] **The comment anchor under-covers its sentence.** The approach
  cites `scripts/test/worker-workspace.test.sh:266-267` for case 46's
  comment; the comment runs 266-269 and the `sed` sentence ends on 269.
  The clause to rewrite does sit on 266-267, so the edit is findable.

- [ ] **"Both stay required" has a loose antecedent.** In the close
  item, the preceding sentence names both "every gate on this host" and
  `bash scripts/ci/run-all.sh`, so a reader can take "Both" as the lint
  tier and the CI run and never run `scripts/test/run-all.sh` - which
  `finish.md § 1` requires as the branch's one full local run.

- [ ] **The close item's mark lands before the evidence that can
  falsify it.** Its acceptance makes the pushed CI run the close
  condition, but the implementer ticks the box and writes
  `R080-T007`'s `[x]` at commit time, before that run exists. The item
  resolves it in terms - its commit is the branch's last commit and not
  its close, and a red run reopens and clears the mark again - so this
  is legible rather than broken.

- [ ] **The property's `grep` is a proxy, not a reading.** It matches
  any `${var//pattern/replacement}` in the two scripts, so a literal
  replacement would trip it, and it would miss a pattern half carrying
  `/`. Sound evidence for this property here - run twice, it matches
  exactly the two hazard lines and nothing else - but the acceptance
  calls it a reading of the property.

- [ ] **The close item's claim about this file is now stale.** It says
  the findings entries "are all `[x]` and are not reopened", true when
  written; these six notes are open, and `branch-plan.md § Closing
  routine` 6 asks the close to triage them. Left as the user ruled:
  open, triaged at close, with no acceptance rewritten to make the
  sentence true again.

- [ ] **A fourth assertion is masked on CI by the fixture's location.**
  `preflight-permissions.test.sh:104` ("an `&` path opens no gap to
  apply") survives a mangled `Edit` rule because the fixture lives
  under `/tmp` and the fixture tier carries the template's own
  `Edit(//tmp/**)`, whose literal prefix covers the mangled path. It is
  green on CI today, so it is correctly absent from the fix item's
  acceptance; on a bash-5.2 host whose `mktemp -d` sits elsewhere it
  would fail. The masking is the test's, not the fix's. "Which the 24-character name
  reaches with six spaces" miscounts: siblings put `#` at 34 characters,
  which a 24-character name reaches with two spaces.
