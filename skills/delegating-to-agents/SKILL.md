---
name: delegating-to-agents
description: Use when executing an approved batch via subagents (DEV auto mode).
---

# Delegating to Agents

Execution engine behind `/dev auto`: runs an approved batch
(`plans/batches/B-XXX.md`) via subagents between checkpoints. Rules:
`branch-plan.md § Agentic execution`.

Touch `.claude/` files only via Read/Edit/Write — edit-class shell
there hits a sensitive-file prompt no allow-rule clears.

## Pre-flight

- Batch exists; member plans all `agentic: approved`.
- Permissions: `.claude/settings.local.json` holds every
  `auto-permissions.template.json` rule (`__PROJECT_DIR__` → abs path)
  plus the CLAUDE.md `## Agent toolchain` rules. Missing → propose
  merged file, apply on approval. No toolchain section → halt, ask.
- On default branch, working tree clean, tests + lint green.
- Set rollback tag `pre-B-XXX`; create `batch/B-XXX` off default.

## Per branch, in batch order

1. Branch per plan (prefix from `type:`).
2. Per commit checkbox:
   - Dispatch a fresh implementer (`implementer-prompt.md`) with full
     item text + parent-chain context (REQ criteria, `DESIGN.md`
     excerpts) pasted in — never have it read plan files.
   - Status handling: DONE → spec check. DONE_WITH_CONCERNS → resolve
     concerns first. NEEDS_CONTEXT → answer from
     REQ/design once, re-dispatch; unanswerable → halt. BLOCKED → halt.
   - Spec check (`spec-reviewer-prompt.md`, fast model): exactly the
     item, nothing extra. Reject → implementer fixes → recheck; second
     rejection → halt.
   - Mark `[x]` after the commit lands.
3. Close the branch agentically: quality review by `code-reviewer`
   agent (full branch diff vs plan); apply mechanical fixes, queue
   judgment calls for checkpoint. Mandatory final commit (docs
   re-review, cleanup, mark plan complete). Tests + lint green →
   merge into `batch/B-XXX`; red → halt.
4. Never push mid-batch; keep branch refs until checkpoint.

## Batch close

1. Full-diff review of `batch/B-XXX` vs default — `code-reviewer`,
   most capable model: cross-branch interactions, duplicated helpers,
   convention drift.
2. Fixes land as batch-branch commits; queue judgment calls.
3. Re-run tests + lint; red → halt. Docs coherence pass
   (CHANGELOG/README across member branches).

## Model selection

Mechanical item (1–2 files, complete spec) → fast; multi-file
integration → standard; reviews → most capable.

## Checkpoint (batch end or halt)

Write `plans/batches/B-XXX.report.md` per `report-template.md` (incl.
`permission_prompts.jsonl` analysis). No report → no accept offer.
Present it, then:

- **Accept** → push flow (T-007), findings triage, delete branch refs,
  mark batch items `[x]` per the MR-merge rule.
- **Reject** → delete `batch/B-XXX` (`pre-B-XXX` tag is
  belt-and-braces); member refs preserved for salvage.
- **Halt** → failed item reported, completed work intact; user
  resolves, re-runs `/dev auto B-XXX`.
