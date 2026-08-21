# Delegation

Standing request: subagents are pre-authorised for the cases below. A
session that needs one spawns it rather than pausing to confirm.
`@import`ed by CLAUDE.md, so it loads every session.

- **Documentation verification gates.** `companions/documentation.md`
  requires an independent verifier, never the author. Self-verification
  does not clear the gate, so a doc the author also verified is unverified.
- **Capped close review.** The close review is routed by diff content
  (`skills/dev/branch-plan.md § Closing routine`) and dispatched by
  the session itself, never delegated onward: a subagent never invokes
  `/code-review` and never spawns further subagents.
- **Genuinely wide searches.** Sweeping many files, directories, or naming
  conventions where only the conclusion is wanted, not the file dumps.

Not pre-authorised: a fan-out a single `grep` would answer, and any
delegation whose token cost the task does not justify. Breadth is the
test, not convenience. Verifier conduct is bounded by
`skills/dev/companions/verification-policy.md § Verifier isolation`.
