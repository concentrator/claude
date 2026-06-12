task: T-008
type: refactor

# refactor/flatten-rules — define the flattened layout in rules (REQ-005)

Normative definition only: the three rule files describe the R-rooted
layout. Skills follow in T-009; this repo's file migration is T-010,
wallarm-api-js is T-011 (same transitional pattern as R-001's
T-001/T-002 split). Invariants held throughout: requirement template
sections unchanged, `approved:` gating semantics unchanged, closed
REQ-002/003/004 stay at `plans/` root as read-only history.

- [x] planning.md §§ Levels + ID format: three-level R-rooted chain
      (`R-XXX → T-XXX → branch plan`), requirement content as in-dir
      `requirements.md` with no own id (points to its R-XXX); retire
      the per-initiative `REQ-XXX` id (legacy files at `plans/` root
      remain history); T-/B-XXX schemes unchanged.
- [x] planning.md §§ Where-things-live + Directory conventions:
      `ROADMAP.md`/`TASKS.md` move to `plans/`, `requirements.md`
      inside the R-dir, batches at `plans/R-XXX-<slug>/batches/`
      (manifest + report, lazy); R-dir creation moves from lazy
      (first child plan) to initiative-time (entry + dir +
      `requirements.md` in one act). Include transition clause:
      legacy paths resolve until T-010/T-011 close (clause removed
      by T-011, the last migration).
- [x] planning.md § Referential integrity: tasks root at an open
      R-XXX; findings promotion rewritten — no fitting open R →
      create an R stub (ROADMAP entry + dir + requirements draft),
      replacing "promote to REQ-XXX".
- [x] planning.md § Approval + new R-closure rule: `approved:` gate
      relocates to the in-dir `requirements.md` (semantics
      unchanged); an R entry closes only when all child tasks are
      `[x]` AND its acceptance criteria are verified with evidence
      per criterion, stamped `status: done YYYY-MM-DD` in
      frontmatter; run-dependent criteria keep the R open and are
      re-verified at the relevant event (e.g. batch checkpoint).
- [x] planning.md §§ Templates + Adjusting + Archival: per-initiative
      template retitled to in-dir `requirements.md` (sections and
      `kind:` variants unchanged, frontmatter gains the R-XXX
      pointer); `/dev plan REQ-XXX` reference becomes `/dev plan
      R-XXX`; archival notes legacy REQ files stay at `plans/` root
      read-only; `requirements.md` always path-qualified against
      root `REQUIREMENTS.md`.
- [x] branch-plan.md § Agentic execution — Batches: manifest and
      report move to `plans/R-XXX-<slug>/batches/B-XXX[.report].md`,
      global `plans/batches/` removed; single-R scope rule — batch
      members are tasks of exactly one R, so the checkpoint
      validates exactly that R's acceptance criteria; soft cap and
      `depends-on` resolution unchanged.
- [x] branch-plan.md batch-close bookkeeping: the close phase marks
      batch + member-task checkboxes on `batch/B-XXX` before the MR
      (no post-merge direct-to-`main` closure commit; "closes on MR
      merge" holds — the `[x]` lands atomically with the merge;
      reject deletes the branch and the premature marks); genuinely
      post-merge steps (R-closure verification, release-plan
      marking) stay post-merge.
- [x] branch-plan.md residual REQ wording: closing-routine findings
      triage gets the R-stub route, § Scope discoveries blocker text
      ("new REQ" → "new R"), NEEDS_CONTEXT stop condition reads
      "unanswerable from the R's requirements.md/design".
- [x] project-layout.md: canonical tree and creation policy updated —
      indexes under `plans/`, R-dirs with `requirements.md` +
      `batches/`, `plans/REQ-XXX.md` and global `plans/batches/`
      dropped from the tree; R-dirs become initiative-time, in-dir
      `batches/` lazy; transition note mirroring planning.md's.
- [x] Grep sweep of the three rule files: no stale `plans/batches/`,
      `plans/REQ-XXX.md`, or `.claude/ROADMAP.md`-style references
      remain (REQ-005 criteria); hits in skills/docs are deferred to
      T-009/T-010, not fixed here.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
