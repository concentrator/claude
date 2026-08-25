task: R060-T001
type: feat

# R060-T001 - Sanction the milestone plan artifact type

Branch `feat/milestone-plan`. Prose-only: the change is a declaration,
a router row, a rule section and a template; the Tier-1 gate
(`bash scripts/ci/run-all.sh`) is the test for every commit.

- [x] Declare `milestone-<id>.md` at `<root>/plans/`: a row in
      `plan.md § Where things live` beside `release-vX.Y.Z.md`, and the
      matching line in the `layout.md § Artifacts layout` tree.
- [x] Route `milestone <id>` in `SKILL.md`'s `/dev plan` table, placed
      ahead of the `<slug>` row and pointing at `plan.md`; body stays
      within the orchestrator word limit (`rules/skills.md § Size`).
- [ ] Write `plan.md § Milestone plans`: optional (single-initiative
      milestones need none), order not scope, existing task ids only (a
      gap gets a task), `depends-on` authoritative (a contradicting
      order is a defect in the milestone file), the `ROADMAP.md
      § Milestones` map as the boundary's home, authored by `/dev plan
      milestone <id>`. Name the milestone plan beside the release plan
      in `plan.md § Templates` and `§ Archival` (offered for archival at
      milestone completion).
- [ ] Add the milestone-plan template to `templates.md` (Boundary,
      Order in waves, Gaps, Notes), stating the shape once; `plan.md`
      keeps the rules.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
      release-plan entry.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
