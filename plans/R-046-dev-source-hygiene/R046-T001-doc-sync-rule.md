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
- [x] `DESIGN.md § Self-enforcement`: cite the concern set rather than
      restating it, so adding the doc-sync concern does not leave a
      second, short list behind (close-review finding, in-scope per
      `branch-plan.md § Scope discoveries`).
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
- [x] The id-convention row names every canon file that states the
      convention, not only `plan.md` and `layout.md` - a dry run of the
      table against `d232338` (the commit that adopted composite ids)
      reached three of the five docs that drifted.
- [x] Route the drift the same dry run found in
      `DESIGN.md § Self-enforcement` (the accretion gate, added by
      `6631f83`, never reached the Tier-1 list) to R046-T002, which owns
      that file.
- [ ] Complete the branch: re-review the added commits, mark plan
      complete, commit.
