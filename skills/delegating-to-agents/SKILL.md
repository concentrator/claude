---
name: delegating-to-agents
description: Use when executing an approved batch via subagents (DEV auto mode).
---

# Delegating to Agents

Engine behind `/dev auto`: runs an approved batch via subagents
between checkpoints. Rules: `branch-plan.md`.

Touch `.claude/` files only via Read/Edit/Write tools (edit-class
shell trips the sensitive-file guard).

## Pre-flight

- Batch exists; member plans `agentic: approved`.
- Permissions: `.claude/settings.local.json` holds every
  `auto-permissions.template.json` rule (`__PROJECT_DIR__`/`__HOME__` → abs paths)
  plus the CLAUDE.md `## Agent toolchain` rules, incl. a VCS-host CLI
  (`glab`/`gh`; absent → push-only, manual MR). Missing
  → propose merged file, apply on approval. No toolchain section →
  halt, ask.
- Default branch, clean tree, tests + lint green.
- Tag `pre-B-XXX`; create `batch/B-XXX` off default.

## Per branch, batch order

1. Branch per plan (prefix from `type:`).
2. Per commit checkbox:
   - Dispatch a fresh implementer (`implementer-prompt.md`) with full
     item text + parent-chain context (the R's `requirements.md`
     criteria, `DESIGN.md` excerpts; conventions via its own CLAUDE.md)
     — never have it read plan files.
   - DONE → spec check. DONE_WITH_CONCERNS → resolve first.
     NEEDS_CONTEXT → answer once from requirements/design,
     re-dispatch; unanswerable → halt. BLOCKED → halt.
   - Spec check (`spec-reviewer-prompt.md`): exactly the item; skipped
     for mechanical commits per `verification-policy.md`. Reject → fix
     → recheck; second → halt.
   - Mark `[x]` after the commit lands.
3. Close agentically: `code-reviewer` (branch diff vs plan; skipped
   for small branches per `verification-policy.md`); mechanical fixes
   applied, judgment calls queued. Mandatory final commit (docs
   re-review, cleanup, plan complete). Tests + lint green → merge
   into `batch/B-XXX`; red → halt.
4. Never push mid-batch; keep branch refs until checkpoint.

## Batch close

1. Full-diff review vs default (`code-reviewer`, most capable):
   cross-branch interactions, duplicated helpers, convention drift;
   folded small branches get first-review vs their plans.
2. Fixes land as batch-branch commits; queue judgment calls.
3. Re-run tests + lint; red → halt. Docs coherence pass
   (CHANGELOG/README across member branches).
4. Mark batch + member-task checkboxes; commit on `batch/B-XXX`.

Models + spec-check depth: `verification-policy.md`.

## Checkpoint (batch end or halt)

Write the R's `batches/B-XXX.report.md` per `report-template.md`,
re-verifying acceptance criteria. No report → no accept. Present:

- **Accept** → push `batch/B-XXX` to origin + create the MR per
  `toolchain.md`, description from the report (defer = explicit user
  choice; never default branch). Findings triage, delete member
  refs + `pre-B-XXX` tag.
- **Reject** → delete `batch/B-XXX`;
  member refs preserved for salvage.
- **Halt** → failed item reported, work intact; user resolves,
  re-runs `/dev auto B-XXX`.
