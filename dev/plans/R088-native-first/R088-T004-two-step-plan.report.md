# R088-T004 report

## Claims
- Item 1 (source): `/dev plan R` writes an initiative's requirements and
  design, and `/dev plan R<NNN>` writes its task list with a branch plan
  per task.
  Source: `skills/dev/plan.md § Planning rounds` (Shape and Detail),
   `skills/dev/templates.md § Per-initiative` (`## Design`),
   `skills/dev/SKILL.md` (`/dev plan <target>`, rows `R` and `R<NNN>`)
- Item 3 (source): A small change, an initiative of one task, ships its
  requirements, plan and code in one MR/PR, its plan admitted unmerged by
  `approved: yes` in its header.
  Source:

## Implementer
### Divergences
- Item 1: `brainstorm.md § Rules` also changed, outside the named steps:
  its altitude bullet sent architecture to `DESIGN.md`, against the
  answer that the design lives in `requirements.md`. It now names the
  requirements' `## Design` for the planned architecture, `DESIGN.md`
  for the present one, and the detail round for the task split.
- Item 2: `brainstorm.md` steps 5 and 8 also changed, outside the named
  step 2: step 5 cut "the plan branch", which a small change does not
  have, and step 8 only proposed the detail round, which a small change
  runs in the same session. Step 5 now cuts "the branch" per
  `plan.md § Where plans live in git`, and step 8 runs the detail round
  for a small change.

## Answers

- Item 1: the design lives in an optional `## Design` section of the
  initiative's `requirements.md`, within its 40-line cap; `DESIGN.md`
  describes only the present architecture.
- Item 2: a small change is an initiative of exactly one task, which the
  user picks at `/dev plan R`.
- Item 3: a small change's plan is admitted unmerged by a recorded mark,
  `approved: yes` in the plan header committed on its branch, which
  `run.md § Resolve` checks and names when missing.

## Review
- [ ] Item 3: no step writes the `approved: yes` mark item 3 admits by;
  `write-plan.md` step 7, where the user confirms the plan, is its
  natural writer and item 3 does not name it (Important) -
  `skills/dev/write-plan.md` step 7
  Evidence: observed item 2's implementer report
- [ ] Item 2: `write-plan.md` step 6 commits the cold read's header edit
  "on the plan branch", which a small change does not have (Suggestion) -
  `skills/dev/write-plan.md:49`
  Evidence: observed `grep -n "plan branch" skills/dev/write-plan.md`
