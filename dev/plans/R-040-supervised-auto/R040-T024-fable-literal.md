---
task: R040-T024
type: fix
depends-on: R040-T015
---

Branch: `fix/fable-literal`.

`verification-policy.md § Models` tells the dispatcher to run
`model-quota.sh "Fable 5"`. The usage endpoint's `display_name` for the
model is `Fable`: observed live on 2026-08-30, when the gate answered
`no weekly window scoped to Fable 5 (seen: Fable)` and, called as
`"Fable"`, reported 28 percent of the window used. Under the policy as
written the gate exits 2 forever and every `fable`-pinned review runs on
Opus, recorded each time as a substitution. The self-test's fixtures
carry the same string; they agree with each other, so they pass, but
they no longer describe the endpoint.

## Commits

- [x] `verification-policy.md § Models` cites `"Fable"`;
  `scripts/test/model-quota.test.sh` names `Fable` in its fixtures and
  in the argument `gate()` passes. Test first: the fixtures change, the
  suite stays green (it is self-consistent), and the proof is the
  policy line matching the fixture string - one `grep` for `"Fable 5"`
  over `skills/` and `scripts/` prints nothing.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose row: `code-reviewer`; the gate, called as this branch
  writes it, decides its model), Tier-2 compliance review, `bash
  scripts/ci/run-all.sh` green, cleanup, mark plan complete, commit.
  Closure is checkbox-only; R040-T024 does not close R-040.
