---
task: R040-T023
type: fix
depends-on: R040-T019
---

Branch: `fix/precompact-trigger`.

`hooks/dev-precompact-state.sh` writes `- trigger: unknown` into every
session file. It takes the reason from `.compaction_trigger` in the
hook's stdin JSON; Claude Code names that field `trigger`, with the
values `manual` and `auto` (code.claude.com/docs/en/hooks). The
session id, read from the same input, is recorded correctly, which is
how the wrong key is known to be the whole defect. The self-test
`scripts/test/dev-precompact-state.test.sh` feeds `compaction_trigger`
in both trigger cases, so it has been agreeing with the hook rather
than with the harness.

## Commits

- [x] The test feeds `trigger` in both cases (lines 44 and 55); it
  fails with `unknown` recorded. The hook reads `.trigger // "unknown"`;
  the test passes. No other field of the hook's input changes.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (code row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit. Closure is checkbox-only; R040-T023 does not close R-040.
