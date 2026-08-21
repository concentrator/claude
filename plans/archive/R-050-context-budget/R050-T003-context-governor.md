---
task: R050-T003
type: feat
depends-on: R050-T001
---

# R050-T003 - context governor hook

Branch: `feat/context-governor`.

Advisory throughout: the hook never emits `decision` or
`permissionDecision`, so a headless `/dev auto` worker can never stall
on it with no operator present. It follows the two existing hooks'
shape - `set -uo pipefail`, JSON on stdin, fail open on anything it
cannot parse.

Read the transcript's tail, never the whole file: `transcript_path`
points at a JSONL that reaches several megabytes in a long session, and
the hook runs after every tool batch.

- [ ] `hooks/dev-context-governor.sh`: read `transcript_path` from the
      `PostToolBatch` payload, recover the most recent assistant
      `usage` record from the file's tail, and sum it as T001's tool
      does. Emit `additionalContext` at 140k ("finish the current
      commit; do not start a new plan item") and at 180k (naming the
      checkpoint the mode is in). `scripts/test/dev-context-governor.test.sh`
      asserts the note above each threshold, silence below the first,
      fail-open on malformed JSON and on an unreadable transcript, and
      the advisory contract - no `decision` and no `permissionDecision`
      key on any path.
- [ ] Subagent tier: when the payload carries `agent_id`, apply 50k and
      80k instead, since a subagent's median start is a quarter of the
      main loop's and its cost is the prefix re-paid per call. The test
      asserts the subagent thresholds apply only with `agent_id`
      present, and that the main-loop thresholds apply without it.
- [ ] `UserPromptSubmit` note: when the submitted prompt opens a new
      delivery unit (`/dev code`, `/dev auto`, `/dev supervise`) and
      the session already holds more than 80k, emit `additionalContext`
      suggesting a fresh session for the unit. The test asserts it
      fires for each unit command in a loaded session, stays silent for
      the same commands in a fresh one, and stays silent for an
      unrelated prompt in a loaded one.
- [ ] `settings.json`: register the hook on `PostToolBatch` and
      `UserPromptSubmit`. The test asserts both registrations resolve
      to an executable path and that a registered event delivers a
      payload the hook parses.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: add `hooks/dev-context-governor.sh` to
      `DESIGN.md § Tree-map` and name it in `§ Self-enforcement`
      alongside the existing PreToolUse guards, re-review docs across
      all commits, cleanup (stale/temp data), mark plan complete,
      commit.
