task: T-003
type: refactor
depends-on: T-001

# refactor/migrate-apijs-plans — migrate wallarm-api-js plans (REQ-002)

Cross-repo documentation migration: commits land on wallarm-api-js
main (plans exception), no branch there. Manual mode only. Run only
between batches (B-002 must not be open). Recommended after T-002
proves the pattern. Record pre-migration file count first.

- [ ] Indexes: `git mv .claude/plans/roadmap.md .claude/roadmap.md`,
      same for `tasks.md`, in wallarm-api-js.
- [ ] Batches: create `.claude/plans/batches/`; `git mv` B-001–B-003
      manifests in (entries reference T-ids/slugs, not paths — verify,
      no content edits expected).
- [ ] R-dirs: for each roadmap entry with child plans, create
      `R-XXX-<slug>/` (slug from entry subject); `git mv` every branch
      plan + `.findings.md` to `T-XXX-<slug>(.findings).md` using the
      task-id mapping from its tasks.md.
- [ ] Strays: plans without a resolvable `task:`→R chain (pre-DEV
      artifacts) stay at `plans/` root, listed in the commit message;
      `release-0.2.0.md` stays at root. Verify file count matches
      pre-migration.
- [ ] Complete the branch: grep wallarm-api-js docs for stale flat
      paths, mark this plan complete (commit here), final verification.
