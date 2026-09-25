---
approved: yes
kind: mnt
---

# R082: Plan-text gate that bites

## Goal

The lean-planning rules take effect in every DEV project, not only
here: plans stay short, findings and answers live in the task report,
and each project's CI enforces it.

## Outcomes

1. The plan-text gate checks every plan file a branch changes, in any
   project, with no per-project cutoff; files the branch leaves alone
   pass. Both initiative naming styles in use are recognised.
2. A project install wires the gate into the project's fast tier.
3. The task report is the only home for findings. A backlog line in
   tasks.md is one line; the gate fails a longer one and a new
   findings file.
4. A user's answer to a halted item goes into the task report; plan
   text stays unchanged during a run.
5. Strict-mode probes and cold-read gaps go into the task report. A
   branch plan holds only its items, each within a line limit the
   gate enforces.
6. A task report exists from the moment its branch plan is committed.
7. tasks.md carries nothing beyond its template.

## Constraints

- Simplification only: each change removes a rule, a place or a step;
  no new artifact type, seat or process step.
