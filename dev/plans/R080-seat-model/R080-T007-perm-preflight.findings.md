# R080-T007 findings

Notes the second cold read still reported and no planner fixed, one
bullet per gap. `write-plan.md` step 6 sends what a last read finds here
rather than to another planner pass. The implementer reads them with the
plan.

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

- **Item 4, the shipped self-test does not run from the install
  location.** The script itself does: a `--project` install into a fresh
  tree runs `.claude/scripts/preflight-permissions.sh` and gets the trust
  verdict (probed). Its copied self-test resolves its subject as
  `$(git rev-parse --show-toplevel)/scripts/preflight-permissions.sh`,
  which is the adopter's repo root rather than their `.claude/`, so it
  fails where it ships - the defect `install-dev.test.sh:42-45` pins for
  the accretion and batch-tags self-tests, whose `BASH_SOURCE`
  resolution the pre-flight test does not copy. Out of item 4's reach:
  the fix edits item 2's test file, and the assertion that would pin it
  needs a line in `install-dev.test.sh`, which item 4 leaves at its
  300-line cap.

## Approach notes

- **Item 4, the LAYOUT node's padding.** "Which the 24-character name
  reaches with six spaces" miscounts: siblings put `#` at 34 characters,
  which a 24-character name reaches with two spaces.
