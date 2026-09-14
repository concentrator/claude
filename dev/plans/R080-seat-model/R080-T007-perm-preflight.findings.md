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
  wrong where the result was not. "Which the 24-character name
  reaches with six spaces" miscounts: siblings put `#` at 34 characters,
  which a 24-character name reaches with two spaces.
