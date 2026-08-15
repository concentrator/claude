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
- Pilot rule (user-set, 2026-08-15): an unexpected worker block the
  supervisor cannot clear - a modal prompt outside the acceptable
  classes, or any second block of the same kind - is not relayed
  keystroke-by-keystroke: stop the worker immediately, fix the cause,
  restart it over the intact refs, proceed. First application: the
  interactive worker (started under the pre-merge allowlist, so every
  uncovered call raised a modal dialog) was stopped on its second
  block with zero commits and a clean tree; the restart went headless
  under the merged allowlist, where an uncovered call is an
  auto-denial the worker routes around rather than a stall.
  Candidate for `supervise.md` in the R040-T006 fix round.
- The adopter repo's `settings.local.json` predated the template: the
  auto-permissions rules, the checkpoint-push carve-out, and three
  plan-required commands (`mkdir`, `git mv`, `git grep`) were missing.
  The supervisor applied the merged file on user approval before
  dispatching; the user's worker had started before the merge, so it
  prompted against the old allowlist. Pre-flighting the permission
  merge belongs before the worker starts, whoever starts it.

## 2026-08-15 - headless, not the permission mode, bounds the envelope

- `.claude/` is a harness-protected path: the safety check runs before
  settings are evaluated, so no `permissions.allow` rule pre-clears an
  edit there. The rest of the guard's behavior splits on whether the
  session can prompt at all, not on which permission mode it declares.
- Measured, CLI 2.1.233, same three protected files or an isolated
  equivalent:
  - headless (`-p`) + `acceptEdits`: denied - the B-001 worker halted
    on it;
  - headless (`-p`) + `dontAsk`: denied ("running in don't ask mode"),
    while the same edit on an ordinary file in that repo succeeds;
  - interactive + `acceptEdits`: the nine edits landed with no prompt
    shown to the user at all.
- So a headless session resolves any decision that would need a prompt
  into a denial, and the protected-path check is one such decision;
  an interactive session in `acceptEdits` clears it silently. The
  earlier reading - that the guard needs a human approval - was wrong:
  what it needs is a prompt-capable session. `dontAsk` remains the
  safe unattended mode for everything else, auto-denying rather than
  auto-allowing and honoring deny rules.
- B-001 hit this wall: nine `.claude/plans|docs` references in
  `.claude/DESIGN.md`, `.claude/PIPELINE.md`, and
  `.claude/references/vectors-glob-semantics.md` are inside the plan's
  sweep and outside its exemption list, so R-023 AC 2 fails without
  them. The headless worker halted with the move and sweep staged and
  intact (279 paths, project gates green) rather than routing around
  the guard, which `auto.md` forbids; an interactive worker over the
  same staged tree finished the sweep unattended.
- Consequence for the adopter: R-023 keeps `DESIGN.md`, `PIPELINE.md`,
  and `references/` under `.claude/` by design, so any later run that
  must edit them has to be interactive. A supervisor driving headless
  workers cannot deliver such an item at all - it holds no keyboard in
  a worker's session, and applying the edits itself would breach
  `supervise.md`'s never-implements rule. Transport choice is
  therefore a delivery constraint, not just a cost question.
