---
approved: yes
kind: mnt
---

# R086: Agent contracts

## Goal

Each agent works from one list of steps with only the context its step
needs, and finishing every list meets the project and global conventions.
A claim about an external system is proven in the task that relies on it,
before a doc states it. A new convention binds only work created after it.

## Outcomes

1. A plan lists each claim its docs will make with the evidence to record:
   source code for the app's logic, a probe and its values for an external
   system. It lists each statement already proven, with its evidence.
2. The planner creates the report with a blank entry per claim; the
   implementer fills each in, probing read-only or on test clients.
3. External-system work runs probe, test, probe, code, spec review, docs,
   review; the spec reviewer checks the report against the plan.
4. The writer and verifier work from the plan and report alone; the writer
   never probes, and a doc cites the source or test behind each claim, or
   a report kept in the docs' reports folder, which is never archived.
5. A doc explains an existing piece of the app's code, or only the part of
   an external system the app uses. A branch that adds, changes or deletes
   a feature updates its docs, with the evidence in its report.
6. Each seat's prompt holds its inputs, steps and outputs, and the global
   instructions hold only what every seat needs, each rule in one place.
7. A new convention applies only to what is created after it, content
   gates check only what a branch adds, and older work changes on request.
8. A check fails on a checkbox in a requirements file a branch adds.
9. A project install skips a hook the global settings already run.
10. Agents branch before the first edit, and the post-merge sync never
    switches onto a tree dirty with changes the branch did not make.
11. No new seat is added, and nothing probes only to prove an existing doc.
