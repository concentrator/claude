# R-040 tasks - Supervisor-orchestrated autonomous DEV

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R040-T###`, counter scoped to this initiative).

## Open

- [x] **R040-T001 [doc]**: capability-bounds declaration - format,
  per-project home, and the batch-scoped-delivery default; extends
  `git-workflow.md § Merge policy` with the delegation clause and its
  escalation list (releases, convention changes, red gates, off-plan
  work).
- [x] **R040-T002 [feat]**: supervisor mode (`/dev supervise` +
  `skills/dev/supervise.md`) - the operating loop: dispatch, monitor,
  boundary verification via existing gates, merge-or-escalate, sync
  reporting from artifacts. Local transport (the default); remote is
  R040-T003. `depends-on: R040-T001`
- [ ] **R040-T003 [feat]**: remote transport - `ssh <target>` worker
  sessions on the remote machine under declared permissions, plus the
  per-project `transport:` switch in the portfolio (`local` default);
  the session-lifetime decision lands here.
  `depends-on: R040-T002`
- [x] **R040-T004 [test]**: supervised pilot, stage 1 (local) - the
  attack-checker plans/docs migration batch, planned and stamped in
  that repo, dispatched and delivered supervised on the same machine;
  exercises question resolution, the decision ledger, and the prompt
  constraint. `depends-on: R040-T005`
- [x] **R040-T005 [doc]**: the quality-acceptance amendment -
  `supervise.md` gains the question-resolution step (the supervisor
  answers a worker's implementation questions and the run continues;
  design-touching questions escalate), the implementation-vs-design
  decision split, and the decision ledger;
  `companions/declarations.md § Supervisor bounds` adds design and
  architectural decisions to the always-escalated list;
  `companions/report-template.md` gains the supervisor-decisions
  field; the worker-prompt constraint (guaranteed acceptance or
  supervisor-accepted edits) lands beside the transport rules.
- [ ] **R040-T006 [test]**: supervised pilot, stage 2 (local) - one
  real task's batch in attack-checker end to end on the same machine,
  user only at sync points; findings feed a fix round before the
  initiative closes. `depends-on: R040-T004`

## Backlog

Unnumbered until R-040's next planning round (`plan.md § Referential
integrity`). Observed while supervising attack-checker's R-023
follow-ups - real supervised delivery, but manual `/dev code` branches
rather than the batch stage 2 calls for, so they are evidence toward
T006 without closing it.

- **The unit of a check has to match the unit of the thing checked.**
  One error recurred three times in R-023: a narration exemption drawn
  per file when the thing exempted was an entry, twice over, then a
  site count taken per line when the thing counted was an occurrence.
  Each passed its own verification and each hid live breakage. A
  supervisor reviewing a verify step should ask what unit it counts
  before trusting that it is green.
- **`supervise.md` describes only `/dev auto` workers.** `§ Dispatch`
  has the worker run the auto engine on a stamped batch, and the merge
  classes in `companions/declarations.md § Supervisor bounds` name
  batch/member and `plan/` MR/PRs. Four merges in this run were manual
  task branches carrying neither a batch report nor a `plan/` prefix.
  They were merged under the grant's stated rationale with the reading
  recorded in the MR comment, but the text should either name the
  class or exclude it rather than leaving a supervisor to reason it
  out per merge.
- **A doc can redefine the vocabulary it is judged by.** Needs
  re-homing: this is a documentation-framework defect, not a
  supervisor one, and R-032 and R-033 which own the provenance column
  and the conventions are both closed, so it is parked here rather
  than lost. `layout.md:138` defines the detail-bar column as
  "verified (ran it) / from-spec / unverified". A doc realigned under
  attack-checker T-085 stated in its own `§ Parameters` preamble that
  "`provenance: verified` means a cited test ... or a cited line of
  shipped source", then marked four cells `verified` on source reading
  alone - fully compliant with the standard it had just rewritten. A
  stale mark is a false claim; a redefined vocabulary makes the claim
  unfalsifiable and defeats any reviewer checking compliance rather
  than definitions. The fix is a line in `layout.md § Docs` forbidding
  a doc from restating or narrowing the provenance definitions, and a
  verification-gate step that reads the preamble before the table.
- **`verification-policy.md § Models` has no capacity fallback.** The
  table pins spec checks and both reviews to Fable 5 with no second
  choice, so every rate limit becomes a user escalation rather than a
  documented degrade path. It has now happened on both pilot batches,
  and the supervisor cannot resolve it either way: substituting a
  model unilaterally defies a written rule, while halting stops
  delivery on a capacity event that has nothing to do with the work.
  The second escalation was the larger call - R-023's items were
  mechanical and pinned by deterministic gates, while R-020's are
  judgment-heavy doc authoring where the gates prove nothing about
  whether a claim is true, so the rationale that justified the first
  deviation does not transfer. A fallback belongs in the table, with
  the substitution recorded automatically rather than negotiated per
  batch.
- **The push carve-out is batch-shaped.** `companions/toolchain.md`
  narrows the deny to allow `git push -u origin batch/*`, which stalls
  any manual task branch at push time - discovered mid-run, pre-flighted
  by widening the adopter's allowlist to the task-branch prefixes. The
  template should cover the prefixes a project actually uses.
