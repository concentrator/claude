---
task: R050-T006
type: feat
depends-on: R050-T001
---

# R050-T006 - shell-composite budget

Branch: `feat/shell-budget`.

The convention lives in the hook's advisory text, not in an always-on
rule: `rules/` loads every session, so a written rule would add
standing context cost to the one initiative meant to remove it, while
the hook's message is paid only when it fires.

What the budget targets is the command string, not the output: Bash
results average a couple of hundred tokens, while banner chains and
inline heredocs put hundreds of characters into context permanently. A
heredoc written to a scratchpad file and invoked by path costs its path
instead of its body. The heredoc line count is authoring advice, not a
threshold the hook computes, so it is stated in the convention rather
than measured.

Advisory only, and fail open, like every other hook here.

- [ ] Calibrate the budget and ship the hook. Measure Bash
      command-string lengths over the transcript corpus with a
      throwaway scratchpad script - `scripts/context-cost.py` records
      tool names only, not inputs, so it cannot supply this - and pick
      the value that separates the long tail from ordinary compounds;
      a guessed threshold would either miss the tail or fire on every
      `&&`. Then `hooks/dev-shell-budget.sh`: a `PreToolUse` hook on
      `Bash` that emits `additionalContext` when a command exceeds
      that budget, with the number and its basis in the header
      comment. The message carries the convention - one purpose per
      call, no `echo` section banners, a heredoc past five lines goes
      to a scratchpad file and runs by path, and a compound command is
      fine when it is one logical operation.
      `scripts/test/dev-shell-budget.test.sh` asserts it warns on a
      known-long composite from the corpus, stays silent on
      `git add -A && npm run lint`, stays silent on a short single
      command, fails open on malformed input, and never emits
      `decision` or `permissionDecision`. Prove the check bites by
      failing it on a known instance first
      (`companions/verification-policy.md § Verification modality`).
- [ ] `settings.json`: register the hook on `PreToolUse` for `Bash`,
      alongside the existing branch and secrets guards. The test
      asserts the registration resolves to an executable path and that
      the three `Bash` hooks compose without one masking another.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: add `hooks/dev-shell-budget.sh` to
      `DESIGN.md § Tree-map` and name it in `§ Self-enforcement`,
      re-review docs across all commits, cleanup (stale/temp data),
      mark plan complete, commit. Closing R-050 is not this branch's
      call: the window criterion is run-dependent and verifies on a
      later session (`plan.md § Approval and closure`).
