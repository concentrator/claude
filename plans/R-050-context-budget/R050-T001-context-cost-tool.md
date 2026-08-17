---
task: R050-T001
type: feat
---

# R050-T001 - context-cost measurement tool

Branch: `feat/context-cost-tool`.

Python, not shell: the work is a per-record fold over multi-megabyte
JSONL with a segmented identity check, which `jq` can express but not
readably. `python3` is already allowlisted. The tool reports, it does
not gate, so it lives at `scripts/context-cost.py` rather than
`scripts/ci/`. Its test follows the repo's `pass`/`die` shell
convention like every other entry in `scripts/test/`.

- [x] `scripts/context-cost.py` session totals: read a transcript
      JSONL, and for every assistant record carrying `usage`, sum
      billed context as `input_tokens + cache_creation_input_tokens +
      cache_read_input_tokens`. Report API calls, total billed context,
      output tokens, and the median, p90 and maximum context per call.
      `scripts/test/context-cost.test.sh` with a small fixture
      transcript asserts each reported figure against hand-computed
      values, and asserts a transcript with no `usage` records reports
      zero calls rather than failing.
- [x] Source attribution: walk the calls in order, segment at any point
      where context drops (a compaction or a clear), and within each
      segment attribute the growth between consecutive calls to the
      model's own output, to a user turn, or to the named tool whose
      result arrived. Report the table with each source's added tokens
      and its token-turns. The test asserts the identity - attributed
      total equals billed total for the fixture - and proves the check
      bites by failing it on a doctored fixture whose attribution is
      short by a known amount (`companions/verification-policy.md
      § Verification modality`).
- [x] Subagent rollup: fold `<session-id>/subagents/*.jsonl` into their
      parent session, reported as a separate line rather than merged
      into the main-loop figures, since their cost is incurred under a
      different context. The test asserts a fixture subagent's tokens
      appear in the rollup, are excluded from the main-loop total, and
      that a session directory with no subagents still reports.
- [x] CLI surface and usage: `--session <path>` for one transcript,
      `--last N` for the N most recent across all projects, default
      output the per-session table. Usage documented in the script's
      header comment. The test asserts `--last` bounds the set, an
      unreadable path exits non-zero with a message naming the path,
      and a malformed JSONL line is skipped rather than aborting the
      run.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: add `scripts/context-cost.py` to
      `DESIGN.md § Tree-map` (routine upkeep, no
      `architecture-changing` flag per `branch-plan.md
      § Architecture-changing branches`), re-review docs across all
      commits, cleanup (stale/temp data), mark plan complete, commit.
