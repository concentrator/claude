# Delegating to Agents

Engine behind `/dev auto`: runs an approved batch via subagents
between checkpoints. Rules: `branch-plan.md`.

Touch plan and findings files only via Read/Edit/Write tools; never
touch `.claude/` config (edit-class shell there trips the
sensitive-file guard).

## Pre-flight

- Batch exists; member plans `agentic: approved`. No-arg resolution:
  the first manifest with a member task still `[ ]` in its R's
  `tasks.md` and no `R<NNN>-B<NNN>.report.md` - manifest text never carries
  status (`branch-plan.md § Batches`).
- Permissions: every `companions/auto-permissions.template.json` rule
  (`__PROJECT_DIR__`/`__HOME__` → abs paths without their leading
  slash - the rules carry the `//` prefix; `__ARTIFACTS_ROOT__` → the
  normalized root, the whole `__ARTIFACTS_ROOT__/` segment collapsing
  for a repo-root value - `plan.md § Where things live`) plus the
  CLAUDE.md `## Agent toolchain` rules, incl. a VCS-host CLI
  (`glab`/`gh`; absent → push-only, manual MR/PR), is carried by a
  tracked tier (user-global `settings.json`, project
  `.claude/settings.json`) or deliberately narrowed by one
  (`companions/toolchain.md § Permission carve-out`); the rest are
  proposed into `.claude/settings.local.json`, applied on approval.
  No toolchain section → halt, ask.
- Default branch, clean tree, tests + lint green.
- Tag `pre-R<NNN>-B<NNN>` (e.g. `pre-R062-B001`); create
  `batch/R<NNN>-B<NNN>` off default.

## Per branch, batch order

1. Member's task already `[x]` in `tasks.md` → skip, note for the
   checkpoint, never re-implement. Else branch per plan (prefix from
   `type:`).
2. Per commit checkbox:
   - Dispatch a fresh implementer (`companions/implementer-prompt.md`) with full
     item text + parent-chain context (the R's `requirements.md`
     criteria, `DESIGN.md` excerpts; conventions via its own CLAUDE.md)
     - never have it read plan files.
   - DONE → spec check. DONE_WITH_CONCERNS → resolve first.
     NEEDS_CONTEXT → answer once from requirements/design, re-dispatch.
     Halt triggers: `branch-plan.md § Stop conditions`.
   - Spec check (`companions/spec-reviewer-prompt.md`): exactly the item; skipped
     for mechanical commits per `companions/verification-policy.md`.
     Reject → fix → recheck.
   - Mark `[x]` after the commit lands.
3. Close agentically: `code-reviewer` (branch diff vs plan; skipped
   for small branches per `companions/verification-policy.md`); mechanical fixes
   applied, judgment calls queued. Mandatory final commit (docs
   re-review, cleanup, plan complete). Tests + lint green → merge
   into `batch/R<NNN>-B<NNN>`; red → halt.
4. Rails hold throughout (`branch-plan.md § Rails`).

## Batch close

1. Full-diff review vs default (`code-reviewer`, most capable):
   cross-branch interactions, duplicated helpers, convention drift;
   folded small branches get first-review vs their plans.
2. Fixes land as batch-branch commits; queue judgment calls.
3. Re-run tests + lint; red → halt. Docs coherence pass
   (CHANGELOG/README across member branches).
4. Mark member-task checkboxes; commit on `batch/R<NNN>-B<NNN>`
   (`branch-plan.md § Batches`).

Models + spec-check depth: `companions/verification-policy.md`.

## Checkpoint (batch end or halt)

Write the R's `batches/R<NNN>-B<NNN>.report.md` per `companions/report-template.md`,
re-verifying acceptance criteria. No report → no accept. Present:

- **Accept** → push `batch/R<NNN>-B<NNN>` to origin + open the CI-gated
  MR/PR per `companions/toolchain.md`, description from report
  (defer = explicit user choice). Findings triage; ref cleanup per `branch-plan.md
  § Rails` - after the MR/PR merges, post-merge cleanup deletes the
  batch branch, local and origin.
- **Reject** → ref handling per `branch-plan.md § Rails`.
- **Halt** → failed item reported, work intact; the operator - user,
  or supervisor within bounds - resolves, re-runs `/dev auto R<NNN>-B<NNN>`.

The batch is the session's unit (`branch-plan.md § Session boundary`).
