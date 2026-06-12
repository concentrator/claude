task: T-010
type: refactor
architecture-changing: true
depends-on: T-009

# refactor/migrate-self — migrate this repo to the flattened layout (REQ-005)

Manual mode only (no agentic stamp): moves the planning indexes the
workflow itself reads. No other planning activity while this branch is
open. Repo root *is* `.claude/` here (self-hosting), so "indexes →
`plans/`" means root → `plans/`. Per REQ-005 invariants, closed
REQ-002/REQ-003 and superseded REQ-004 stay at `plans/` root as
read-only history — stamped, not moved. REQ-005 (open parent of this
work) and pending REQ-006 also stay put; they are out of this task's
scope.

- [x] `git mv ROADMAP.md plans/ROADMAP.md` and
      `git mv TASKS.md plans/TASKS.md`; align both index header blurbs
      with post-T-008 `rules/planning.md` wording (R-rooted entry
      format, closure rule pointer). Doc: the indexes themselves.
- [x] Backfill-verify `plans/REQ-002.md`: check its one remaining `[ ]`
      criterion (scaffold + migration skills produce the new layout)
      against the shipped T-001..T-004 work, tick with one-line
      evidence, then stamp frontmatter `status: done 2026-06-12` per
      the new closure rule. File stays at `plans/` root.
- [ ] Stamp `plans/REQ-003.md` `status: done 2026-06-12` (all criteria
      already `[x]` with B-002 evidence — verify intact); verify
      `plans/REQ-004.md` superseded marking (`superseded-by: REQ-005`
      frontmatter + history note) conforms to post-T-008 planning.md;
      adjust the marker only if the rule requires a different form.
      Both stay at `plans/` root.
- [ ] Migrate open REQ-001 into an R-stub: add open ROADMAP entry
      `R-004: Parallel batch execution for DEV auto mode`, create
      `plans/R-004-parallel-batches/`,
      `git mv plans/REQ-001.md plans/R-004-parallel-batches/requirements.md`;
      keep `approved: pending` and all body sections, retitle to point
      to R-004 (no own REQ id per the new template); update the
      ROADMAP pending-initiatives comment (REQ-001 now R-004; REQ-006
      still pending at `plans/` root, spawns its R-stub on approval).
- [ ] Update `CLAUDE.md § Temporary Files`: planning indexes
      (`ROADMAP.md`, `TASKS.md`) now live in `.claude/plans/`;
      initiative requirements live in their `R-XXX-<slug>/` dir
      (`requirements.md`); foundational specs unchanged at `.claude/`.
- [ ] Update `README.md` Contents table to the now-factual state:
      `ROADMAP.md`/`TASKS.md` row moves under the `plans/` row;
      `plans/` role text reflects in-dir `requirements.md` and
      R-scoped batches; Workflow section chain wording
      (`R-XXX → T-XXX → branch`).
- [ ] Update `DESIGN.md` (architecture commit): tree-map (indexes under
      `plans/`, `R-XXX-<slug>/` with `requirements.md` + `batches/`,
      global `plans/batches/` gone, `R-004-parallel-batches/` real),
      `§ Self-hosting layout` root-file list, `§ Planning model`
      chain wording (R-rooted, single closure point).
- [ ] Update `MAINTENANCE.md` targets to the new paths (plans/ row
      covers `requirements.md` + in-dir `batches/`; root-files check
      list matches DESIGN); then grep this repo's docs for stale
      root-index references (`ROADMAP.md`/`TASKS.md` outside `plans/`,
      `plans/batches/`, `REQ-XXX` template paths) and fix stragglers —
      rules/skills are T-008/T-009 ground, touch only repo docs here.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), relocate any remaining planning files missed
      above, mark plan complete, commit.
