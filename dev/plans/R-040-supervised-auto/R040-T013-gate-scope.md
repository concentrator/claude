---
task: R040-T013
type: doc
---

Branch: `doc/gate-scope`.

`companions/documentation.md § Verification gate` clears rules, skills
and planning prose on the changed claims, and `dev/docs/` feature docs
on every claim. R040-T010 touched fourteen feature docs by a line each
and owed fourteen per-claim passes; one of them caught a worked example
throwing `RangeError` on lines the branch never touched, while stamped
verified. Both sides are in `R040-T010-worker-host.findings.md`.

The decision this plan encodes: the gate keeps the doc as its unit. A
targeted edit does not narrow the pass, because a claim's source can
change under a line no branch touches, and the only pass that finds
that is one that reads the doc, not the diff. What changes is that the
gate says so, so the next fourteen-doc branch does not relitigate it
under delivery pressure.

## Commits

- [ ] `companions/documentation.md § Verification gate`: one sentence
  after the prose-class split stating that a feature doc's pass covers
  the doc, never the diff, and why - a claim's source can move under an
  untouched line; the R040-T010 `RangeError` catch is the evidence and
  stays in its findings file, not in the rule.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
