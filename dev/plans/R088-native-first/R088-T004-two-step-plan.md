---
task: R088-T004
type: mnt
architecture-changing: true
mode: normal
---

- [x] Planning is two steps: `/dev plan R` writes the requirements and
  their design - the standard followed, the components changed - at one
  gate, with no task list; `/dev plan R<NNN>` writes the task list and a
  plan per task. Approach: `plan.md § Planning rounds`, a `## Design`
  section in the `templates.md` requirements template within its 40-line
  cap, `brainstorm.md` steps 5 and 8, then the `R` row of `SKILL.md`.
- [x] A small change - an initiative of one task, which the user picks at
  `/dev plan R` - runs both steps in one session on the task's branch,
  `<prefix>/<slug>` from its tag, carrying its ROADMAP entry,
  requirements, task and plan. Approach: `plan.md § Planning rounds` and
  `§ Where plans live in git`, `brainstorm.md` step 2, `write-plan.md`
  steps 2 and 7, then the `plan` prefix of `git-workflow.md § Trunk`.
- [ ] `/dev run` admits a small change's plan unmerged by `approved: yes` in
  its header, committed on its branch (`branch-plan.md § Header`), which
  `run.md § Resolve` checks and names when missing; the code joins that
  branch: one MR/PR ships requirements, plan and code. Approach: those two,
  `run.md § Pre-flight`, `branch-plan.md`'s opening and `§ Agentic execution`,
  `DESIGN.md § Planning model`, `§ Decisions`; Tier-1 passes a scratch branch.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- Item 1 (source): `/dev plan R` writes an initiative's requirements and
  design, and `/dev plan R<NNN>` writes its task list with a branch plan
  per task.
- Item 3 (source): A small change, an initiative of one task, ships its
  requirements, plan and code in one MR/PR, its plan admitted unmerged by
  `approved: yes` in its header.

## Proven

- none
