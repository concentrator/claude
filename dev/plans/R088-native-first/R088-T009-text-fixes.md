---
task: R088-T009
type: doc
mode: normal
---

- [x] `release.md` step 2 diffs from the last release tag, found with
  `git describe --abbrev=0 --tags --match 'v*'`, so a `pre-R<NNN>-B<NNN>`
  batch anchor never reads as a release, and step 6 names the notes'
  home: the body of the release MR/PR step 8 opens. Approach: those two
  steps, in place.
- [ ] A release leaves an empty `## [Unreleased]` above the block step 4
  stamps, for the doc writer's next entries and the next release's
  pre-condition, and prunes no ROADMAP entry, a closed R's `[x]` being its
  closure record (`plan.md § Approval and closure`). Approach: `release.md`
  step 5 becomes that step in place, so no step renumbers.
- [ ] Under `release-routine: yes`, the detail round adds each planned
  branch to the open release plan, if one exists, as the `templates.md
  § Release plan` entry the closing routine marks. Approach: `write-plan.md`
  step 7, the session's, committing the entry on the branch carrying the
  plan; `templates.md § Release plan` names that step.
- [ ] Under `release-routine: yes`, `start.md` seeds `CHANGELOG.md` with
  `# Changelog` over an empty `## [Unreleased]`, the heading `release.md`'s
  pre-condition requires and the doc writer's entries go under. Approach:
  the release-routine sentence of `start.md § 3`.
- [ ] `branch-plan.md § Header` shows the header as the YAML frontmatter
  every branch plan opens with, between `---` lines. Approach: an opening
  and a closing `---` inside the § Header block, its comments unchanged.
- [ ] The supervision signature names its committer value, `<hostname>
  (supervised)`, the `committer.name` `scripts/worker-credentials.sh` sets
  on the worker host. Approach: the committer sentence of the "Supervision
  signature" paragraph in `declarations.md § Supervisor bounds`.
- [ ] `run.md § Batch close` 2 names the seat that commits each fix: a fresh
  implementer naming that member's plan and the fix's `## Review` entry, as
  `§ Close` 2 does, the entry in the report of the member whose code the
  fix changes, the last in batch order for several. Approach: that step,
  then the § Seats implementer row naming both closes.
- [ ] Commit and MR/PR attribution follows Claude Code's `attribution`
  setting: `dev-instructions.md § Writing` states the no-trailer intent as
  that setting's `commit` and `pr` left empty, never as a rule over a
  harness instruction (requirement outcome 1), and `git-workflow.md § MR/PR
  messages` cites it for its "Generated with" bullet. Approach: both lines.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- none

## Proven

- none
