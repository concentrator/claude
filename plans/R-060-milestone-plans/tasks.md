# R-060 tasks - Milestone execution plans

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R060-T###`, counter scoped to this initiative).

## Open

- [x] **R060-T002 [feat]**: own the milestone plan's archival offer -
  `/dev plan milestone <id>` offers the file for archival once every
  entry's task is `[x]`, mirroring the release skill's offer for the
  release plan; `plan.md § Archival` names the trigger.
- [x] **R060-T001 [feat]**: sanction the milestone plan artifact type -
  add the `milestone-<id>.md` row to `plan.md § Where things live` and
  the matching line to the `layout.md` tree, route `milestone <id>` in
  `SKILL.md`'s `/dev plan` table ahead of the `<slug>` row, write
  `plan.md § Milestone plans` (optional, order not scope, existing task
  ids only, `depends-on` authoritative, and the `ROADMAP.md
  § Milestones` map as the boundary's home), add the template to
  `templates.md` (Boundary, Order in waves, Gaps, Notes), and name the
  milestone plan beside the release plan in `plan.md § Templates` and
  `§ Archival`.
