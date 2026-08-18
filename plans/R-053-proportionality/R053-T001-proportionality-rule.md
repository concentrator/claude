---
task: R053-T001
type: doc
---

# R053-T001 - proportionality rule

Branch: `doc/proportionality-rule`.

The rule is planning text, not a gate: it binds shape and detail
rounds where scope is decided, which is where R-050 and R-051 grew
their extra belts.

- [ ] `plan.md`: a new `§ Proportionality` - one observed failure
      earns one fix and one test; deeper proofs (mutant cases,
      unfixed-copy comparisons, vendored-copy assertions) are reserved
      for `dev-secrets-guard` and `dev-branch-guard`; hardening
      against a hazard that has never fired needs explicit user
      approval; a shape round asks what can be deleted before adding.
      `brainstorm.md § Rules` gets one line pointing at it.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
