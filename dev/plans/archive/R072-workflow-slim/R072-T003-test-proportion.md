# R072-T003: Proportional tests

task: R072-T003
type: mnt
depends-on: R072-T001

A test is written when it guards an invariant or pins a fixed bug;
absence is not a finding.

- [x] `plan.md § Proportionality`: state the condition - a test guards
  an invariant or pins an observed failure; doc, config, and plan
  tasks ship none; a test written to satisfy a review expectation is
  scope creep.
- [x] `agents/code-reviewer.md`: the conduct line - a missing test is
  flagged only when system integrity is at risk (an invariant without
  a guard, a fixed bug without a pin); wired after T001's rubric so
  the two edits to the file compose.

> Mark and commit the task `[x]` in the R's `tasks.md`, plus any
> release-plan entry.
>
> Complete the branch: re-review docs across all commits, cleanup
> (stale/temp data), mark plan complete, commit.
