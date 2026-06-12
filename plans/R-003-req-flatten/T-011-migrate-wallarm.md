task: T-011
type: refactor
depends-on: T-010

# refactor/migrate-wallarm — migrate wallarm-api-js to the flattened layout (REQ-005)

Cross-repo documentation migration: commits land on wallarm-api-js
main (plans exception), no branch there. Manual mode only. Run only
between batches — verify no `batch/B-XXX` branch is open at start
(B-003 is merged and closed as of planning). All three batches'
members (B-001: T-001/3/4/5/6/7, B-002: T-008..011, B-003:
T-012..014) are R-001 tasks, so the single-R batch scope holds and
everything lands under `R-001-route-sweep/`. Record the pre-migration
tracked file count first: `git ls-files .claude | wc -l` = 40 at
planning time (untracked `permission_prompts.jsonl` excluded — leave
it alone). History is not rewritten: prose mentions of REQ-001 in
closed branch plans and batch reports stay as-is.

- [ ] Indexes: `git mv .claude/ROADMAP.md .claude/plans/ROADMAP.md`,
      same for `TASKS.md` → `.claude/plans/TASKS.md`, in
      wallarm-api-js; align both header blurbs with post-T-008
      `rules/planning.md` wording (R-rooted chain, closure-rule
      pointer) and reformat the R-001 entry to the R-rooted format —
      drop the `(REQ-001)` parent ref; closure note now points at the
      in-dir requirements criteria. Doc: the indexes themselves.
- [ ] Requirements: `git mv .claude/plans/REQ-001.md
      .claude/plans/R-001-route-sweep/requirements.md`; keep
      frontmatter (`approved: 2026-06-10`, `kind: refactor`) and all
      template body sections unchanged; retitle to drop the own
      REQ-001 id and point to R-001 (per the post-T-008 in-dir
      template, mirroring T-010's REQ-001→R-004 retitle). Acceptance
      criteria checkboxes stay untouched — R-001 is still open
      (T-015..T-017).
- [ ] Batches: create `.claude/plans/R-001-route-sweep/batches/`;
      `git mv` all six files (`B-001.md`, `B-001.report.md`, `B-002.md`,
      `B-002.report.md`, `B-003.md`, `B-003.report.md`) in; the global
      `plans/batches/` dir disappears with the move. Manifest entries
      reference T-ids/slugs and reports carry no `plans/batches/`
      self-paths (pre-verified) — re-verify, update any stray path
      reference found, otherwise no content edits.
- [ ] Complete the branch: grep wallarm-api-js docs (`CLAUDE.md`,
      `README.md`, `.claude/**/*.md`) for stale paths
      (`.claude/ROADMAP.md`/`.claude/TASKS.md` as root paths,
      `plans/REQ-001`, `plans/batches/`) and fix stragglers
      (pre-checked clean); verify tracked file count under `.claude/`
      is 40 pre and post; remove the transition clauses from
      `rules/planning.md` and `rules/project-layout.md` (added by
      T-008, obsolete once both migrations are done); re-review docs
      across all commits, cleanup (stale/temp data), mark this plan
      complete (commit here), final verification (3 migration commits
      on wallarm main).
