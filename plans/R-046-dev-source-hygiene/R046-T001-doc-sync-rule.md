---
task: R046-T001
type: doc
---

# R046-T001 - the doc-sync obligation

Branch: `doc/doc-sync-rule`.

- [x] `MAINTENANCE.md § Tier-2 AI review`: the doc-sync concern, written
      generic so it seeds into adopter projects - a change that alters a
      documented surface updates the doc documenting it in the same
      branch, and staleness the change induces in files the diff does
      not touch is in scope for the review.
- [x] `MAINTENANCE.md § This environment`: the change-to-doc pair table.
      Triggers: the `/dev` command surface, the `skills/dev/` file set,
      tracked root entries, what `install-dev.sh` copies and registers,
      the `scripts/ci/` and `hooks/` sets, planning-layout and id or
      naming conventions, and any moved or renamed file (inbound
      references).
- [x] `MAINTENANCE.md § Routine`: the stale-reference row covers the
      root docs (`README.md`, `REQUIREMENTS.md`, `DESIGN.md`) alongside
      `rules/` and `CLAUDE.md`.
- [x] `branch-plan.md § Closing routine`: cite the concern set in
      `MAINTENANCE.md § Tier-2 AI review` rather than restating it with
      a count, so the set has one home
      (`writing.md § One home per number`).
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
