# R040-T004 findings - supervised pilot, stage 1

Dated evidence log for the stage-1 pilot (B-001, the attack-checker
plans/docs migration, delivered supervised). Feeds the fix round before
R-040 closes (R040-T006).

## 2026-08-15 - duplicate worker dispatch

- Sequence: the user started a local worker (`/dev auto B-001`,
  interactive, acceptEdits), cleared context, then started
  `/dev supervise`. The supervise session ran `supervise.md § Dispatch`
  as written and launched a second headless worker on the same batch.
- Impact: none - the duplicate was killed ~70 s in, still in
  pre-flight, before any git command; the `pre-R023-B-001` tag and the
  batch/member branches belong to the first worker. The exposure was
  real: both workers tag and branch identically, so a later kill would
  have collided on refs.
- Root cause: `§ Dispatch` has no discovery step - it assumes the
  supervisor launches the worker, while the local transport
  (portfolio: interactive worker session, supervised cross-session)
  expects a pre-started worker to be adopted.
- Fix direction: an adopt-before-dispatch rule in `§ Dispatch` - check
  peer sessions rooted in the project path, a running worker process
  on the scope, and the scope's pre-tag / batch branch present with no
  report; adopt (status ping, then monitor) or, if the worker is dead,
  resume `/dev auto B-XXX` over its intact refs; never run two workers
  on one project.

## 2026-08-15 - prompt constraint

- The worker stalled ~45 min on a read-only `cd`-compound Bash prompt
  (`cd <skills dir> && sed -n ... plan.md`): neither pre-accepted by
  the template nor an edit prompt the supervisor may accept, so it sat
  as an escalation - the declared class working as designed, but
  avoidable. Worker-side fix: absolute paths instead of `cd`
  compounds for reads.
- The adopter repo's `settings.local.json` predated the template: the
  auto-permissions rules, the checkpoint-push carve-out, and three
  plan-required commands (`mkdir`, `git mv`, `git grep`) were missing.
  The supervisor applied the merged file on user approval before
  dispatching; the user's worker had started before the merge, so it
  prompted against the old allowlist. Pre-flighting the permission
  merge belongs before the worker starts, whoever starts it.
