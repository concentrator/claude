task: T-003
type: refactor
depends-on: T-004

# refactor/migrate-apijs-plans — migrate wallarm-api-js plans (REQ-002)

Cross-repo documentation migration: commits land on wallarm-api-js
main (plans exception), no branch there. Manual mode only. Run only
between batches (B-002 must not be open). Recommended after T-002
proves the pattern. Record pre-migration file count first.

- [x] Indexes: `git mv .claude/plans/roadmap.md .claude/ROADMAP.md`,
      same for `tasks.md` → `.claude/TASKS.md` (move + uppercase per
      Amendment 1), in wallarm-api-js.
- [x] Uppercase any other foundational docs present in its `.claude/`
      (`requirements.md`, `design.md`, `maintenance.md`) via `git mv`;
      skip those absent. (requirements + design present and renamed;
      no maintenance.md yet.)
- [x] Batches: create `.claude/plans/batches/`; `git mv` B-001–B-003
      manifests in (entries reference T-ids/slugs, not paths — verify,
      no content edits expected).
- [x] R-dirs: for each roadmap entry with child plans, create
      `R-XXX-<slug>/` (slug from entry subject); `git mv` every branch
      plan + `.findings.md` to `T-XXX-<slug>(.findings).md` using the
      task-id mapping from its tasks.md. (`R-001-route-sweep/`: 14
      plans + 5 findings.)
- [x] Strays: plans without a resolvable `task:`→R chain (pre-DEV
      artifacts) stay at `plans/` root — aasm-charts,
      attackcount-domain, multi-value-filters, sec-charts;
      `release-0.2.0.md` and `REQ-001.md` stay at root. File count 30
      pre and post — verified.
- [x] Remove the transition clause from `rules/planning.md` — the last
      adopter is migrated; legacy flat paths no longer exist anywhere.
- [x] Complete the branch: grep wallarm-api-js docs for stale flat
      paths (clean), mark this plan complete (commit here), final
      verification (30 files, 4 migration commits on wallarm main).
