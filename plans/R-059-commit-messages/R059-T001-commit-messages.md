task: R059-T001
type: doc

# R059-T001 - Relax the commit-message rule

- [ ] Amend `git-workflow.md § Commit messages`: subject constraints
  (imperative, ~50 chars, no semicolon-joined clauses, WHAT not HOW)
  and the trailer ban stay; an optional compact body is allowed when
  the subject cannot carry the what/why (a no-diff move, a decision,
  a constraint) - short prose, no boilerplate, no restating the diff;
  a routine commit stays subject-only; add one good body example
  beside the existing subject examples
- [ ] Reconcile the restating texts to defer to the rule instead of
  stating the single-line form: `branch-plan.md § Commit cadence`
  step 3, `release.md` step 9, and the commit-message check in
  `companions/spec-reviewer-prompt.md`
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [ ] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
