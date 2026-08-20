# R-059 tasks - Relax the commit-message rule

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R059-T###`, counter scoped to this initiative).

## Open

- [ ] **R059-T001 [doc]**: amend `git-workflow.md § Commit messages` -
  subject constraints and the trailer ban stay; an optional compact
  body carries the what/why the subject cannot; add a body example;
  the restating texts (`branch-plan.md`, `release.md`,
  `spec-reviewer-prompt.md`) defer to the rule.

- [ ] **R059-T002 [mnt]**: set `"includeCoAuthoredBy": false` in the
  tracked user-global `settings.json`, ending the standing conflict
  between the harness default that appends a `Co-Authored-By` trailer
  and the rule's trailer ban. Routed from
  `R059-T001-commit-messages.findings.md`. `depends-on: R059-T001`

Backlog: `git-workflow.md § MR/PR messages` Title bullet restates the
subject constraints (now cosmetically divergent) and enumerates
trailers the commit rule bans as a class - dedupe by pointer at this
R's next round.
