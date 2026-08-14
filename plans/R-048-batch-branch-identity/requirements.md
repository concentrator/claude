---
approved: pending
kind: feat
---

# R-048: Batch branch identity

## Motivation

`batch/B-XXX` branch refs are flat while batch ids are scoped per
initiative, so two initiatives' first batches collide on
`batch/B-001` - the same per-initiative collision R-044 fixed for the
rollback anchor. The branch case is longer-lived: the batch branch is
pushed to origin at checkpoint accept, and `branch-plan.md § Rails`
deletes member branch refs there but not the batch branch itself.
R-044 scoped the branch out on the premise that the tag is the only
global namespace; branch refs are equally flat. Promoted from
R044-T001's close review.

Shaping (goals, non-goals, acceptance criteria) is deferred to this
initiative's shape round.
