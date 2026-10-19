# R088-T004 report

## Claims
- Item 1 (source): `/dev plan R` writes an initiative's requirements and
  design, and `/dev plan R<NNN>` writes its task list with a branch plan
  per task.
  Source:
- Item 3 (source): A small change, an initiative of one task, ships its
  requirements, plan and code in one MR/PR, its plan admitted unmerged by
  `approved: yes` in its header.
  Source:

## Implementer

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
