---
name: delegating-to-agents
description: Use when executing an approved batch via subagents (DEV auto mode).
---

# Delegating to Agents

Execution engine behind `/dev auto`: runs an approved batch
(`plans/batches/B-XXX.md`) via subagents between checkpoints. Rules:
`branch-plan.md § Agentic execution`.

Touch `.claude/` files only via Read/Edit/Write tools (edit-class
shell trips the sensitive-file guard).

## Pre-flight

- Batch exists; member plans all `agentic: approved`.
- Permissions: `.claude/settings.local.json` holds every
  `auto-permissions.template.json` rule (`__PROJECT_DIR__` → abs path)
  plus the CLAUDE.md `## Agent toolchain` rules, incl. a VCS-host CLI
  (`glab`/`gh`; absent → checkpoint pushes + notes manual MR). Missing
  → propose merged file, apply on approval. No toolchain section →
  halt, ask.
- On default branch, working tree clean, tests + lint green.
- Set rollback tag `pre-B-XXX`; create `batch/B-XXX` off default.

## Per branch, in batch order

1. Branch per plan (prefix from `type:`).
2. Per commit checkbox:
   - Dispatch a fresh implementer (`implementer-prompt.md`) with full
     item text + parent-chain context (REQ criteria, `DESIGN.md`
     excerpts) pasted in — never have it read plan files.
   - DONE → spec check. DONE_WITH_CONCERNS → resolve concerns first.
     NEEDS_CONTEXT → answer once from REQ/design, re-dispatch;
     unanswerable → halt. BLOCKED → halt.
   - Spec check (`spec-reviewer-prompt.md`, fast): exactly the item.
     Reject → fix → recheck; second rejection → halt.
   - Mark `[x]` after the commit lands.
3. Close agentically: `code-reviewer` (branch diff vs plan);
   mechanical fixes applied, judgment calls queued. Mandatory final
   commit (docs re-review, cleanup, plan complete). Tests + lint
   green → merge into `batch/B-XXX`; red → halt.
4. Never push mid-batch; keep branch refs until checkpoint.

## Batch close

1. Full-diff review vs default (`code-reviewer`, most capable):
   cross-branch interactions, duplicated helpers, convention drift.
2. Fixes land as batch-branch commits; queue judgment calls.
3. Re-run tests + lint; red → halt. Docs coherence pass
   (CHANGELOG/README across member branches).

Models: mechanical (1–2 files, complete spec) → fast; multi-file →
standard; reviews → most capable.

## Checkpoint (batch end or halt)

Write `plans/batches/B-XXX.report.md` per `report-template.md`. No
report → no accept. Present it, then:

- **Accept** → push `batch/B-XXX` to origin + create the MR per
  `toolchain.md`, description from the report (defer = explicit user
  choice; never the default branch). Findings triage, delete member
  refs; batch items `[x]` on MR merge.
- **Reject** → delete `batch/B-XXX` (`pre-B-XXX` tag is
  belt-and-braces); member refs preserved for salvage.
- **Halt** → failed item reported, completed work intact; user
  resolves, re-runs `/dev auto B-XXX`.
