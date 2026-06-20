task: T-024
type: feat

# feat/delivery-cadence — coherent-unit delivery cadence (R-011)

T-024 of `plans/R-011-delivery-cadence/requirements.md`. States the
delivery-cadence rule so branches/MRs carry a coherent unit of work, not
one atomic edit. One coherent branch (dogfoods R-011). Not
architecture-changing (behavior rule; no DESIGN/tree-map change).

Cadence home (settled): the full rule in `git-workflow.md`; a concise
operative line in `CLAUDE.md § Session Workflow` (always-loaded) so the
agent follows it reflexively. The CLAUDE.md edit is approval-gated
(`rules/claude-md.md`) — within this task's approved scope. The
topic-switch prompt lives in the cadence rule, not `finishing-a-branch`
(which stays at its 299/300w cap).

- [x] Add the delivery-cadence rule to `git-workflow.md` (§ Coherent
      delivery, or a new § Delivery cadence): one branch = one coherent
      unit of work (topic/session), never one atomic edit; no
      MR-per-change; VIBE applies → waits → delivers at a work boundary,
      confirming the merge first; an unrelated edit → flag + ask to
      deliver the current branch first; DEV inherits the principle
      (task/batch + finishing-a-branch / auto-merge gates unchanged);
      within short-lived / ≤3-active / merge-within-a-day. Host-neutral.
- [x] Add a concise operative cadence to `CLAUDE.md § Session Workflow`
      (always-loaded): apply → wait → deliver at a boundary + confirm;
      unrelated edit → flag + ask; pointer to `git-workflow.md` for the
      full rule. Verify `wc -w CLAUDE.md` ≤ 400.
- [x] Update `skills/migrating-to-dev/tbd-migration.md` — the
      structure-reconcile area delivers its fixes as one MR (not one per
      change), per the cadence rule.
- [x] Complete the branch: re-review across commits; run
      `bash scripts/ci/run-all.sh` green; mark the plan complete + T-024
      `[x]` in `TASKS.md` (rides this PR); triage findings; commit. Stamp
      follows per the ledger protocol; hand off to `finishing-a-branch`
      (feat → user review + merge).
