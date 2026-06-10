---
name: delegating-to-agents
description: Use when executing an approved batch via subagents (DEV auto mode).
---

# Delegating to Agents

Execution engine behind `/dev auto`. Runs an approved batch
(`.claude/plans/B-XXX.md`) of branch plans via subagents, autonomously
between checkpoints. Rules: `~/.claude/rules/branch-plan.md § Agentic
execution`.

## Pre-flight

- Batch exists; every member plan has `agentic: approved`.
- On default branch, working tree clean, tests + lint green.
- Set rollback tag: `git tag pre-B-XXX`.

## Per branch, in batch order

1. Create branch per plan (prefix from `type:`).
2. Per commit checkbox:
   - Dispatch fresh implementer subagent (`implementer-prompt.md`) with
     the full item text + parent-chain context (REQ acceptance criteria,
     `design.md` excerpts) pasted in — never have it read plan files.
   - Status handling: DONE → spec check. DONE_WITH_CONCERNS → resolve
     correctness/scope concerns first. NEEDS_CONTEXT → answer from
     REQ/design once, re-dispatch; unanswerable → halt. BLOCKED → halt.
   - Spec check (`spec-reviewer-prompt.md`, fast model): exactly the
     item, nothing extra. Reject → implementer fixes → recheck; second
     rejection → halt.
   - Mark `[x]` after the commit lands.
3. Close the branch agentically: quality review by `code-reviewer`
   agent (full branch diff vs plan); apply mechanical fixes, queue
   judgment calls for checkpoint. Mandatory final commit (docs
   re-review, cleanup, mark plan complete). Tests + lint green →
   merge to **local** default branch; red → halt.
4. Never push. Keep branch refs until checkpoint validation.

## Model selection

Mechanical item (1–2 files, complete spec) → fast model. Multi-file
integration → standard. Reviews → most capable.

## Checkpoint (batch end, or any halt)

Report per branch: commits, test results, review outcomes, queued
judgment calls, findings. Then:

- **Accept** → post-merge bookkeeping per `finishing-a-branch` §4 for
  each branch, triage accumulated findings, delete branch refs and
  `pre-B-XXX` tag, mark batch items `[x]`. Pushing is the user's call.
- **Reject** → `git reset --hard pre-B-XXX`; branch refs preserved
  for salvage.
- **Halt** reports stop at the failed item with everything completed
  so far intact; user resolves, then re-run `/dev auto B-XXX`.
