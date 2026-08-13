# Delegation

Standing request: subagents are pre-authorised for the cases below. A
session that needs one spawns it rather than pausing to confirm.
`@import`ed by CLAUDE.md, so it loads every session.

- **Documentation verification gates.** `companions/documentation.md`
  requires an independent verifier, never the author. Self-verification
  does not clear the gate, so a doc the author also verified is unverified.
- **Close-review fan-out.** `/simplify` and `/code-review` dispatch
  parallel reviewers by design; the close review is routed by diff
  content (`skills/dev/branch-plan.md § Closing routine`). Run the
  routed review as written rather than reviewing the diff single-handed
  and noting the deviation.
- **Genuinely wide searches.** Sweeping many files, directories, or naming
  conventions where only the conclusion is wanted, not the file dumps.

Not pre-authorised: a fan-out a single `grep` would answer, and any
delegation whose token cost the task does not justify. Breadth is the
test, not convenience. Verifier conduct is bounded by
`skills/dev/companions/verification-policy.md § Verifier isolation`.
