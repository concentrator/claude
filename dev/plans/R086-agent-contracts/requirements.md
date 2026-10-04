---
approved: pending
kind: mnt
---

# R086: Agent contracts

## Goal

Each agent works from one list of steps with only the context its step
needs, and finishing every list meets the project and global conventions.
A claim about an external system is proven in the task that relies on it,
before a doc states it. A new convention binds only work created after it.

## Outcomes

1. A plan lists each claim to prove, with its probe and the values to
   record, and each statement already proven, with its evidence.
2. The planner creates the report with a blank entry per claim; the
   implementer probes, read-only or on test clients, and fills it in.
3. External-system work runs probe, test, probe, code, spec review, docs,
   review; the spec reviewer checks the report against the probe list.
4. The writer and verifier work from the plan and report alone; the writer
   never probes, and a doc cites the test that asserts each claim.
5. Each seat's prompt holds its inputs, steps and outputs, and the global
   instructions hold only what every seat needs, each rule in one place.
6. A new convention applies only to what is created after it, gates check
   only what a branch adds, and older work changes only on request.
7. A check fails on a checkbox in a requirements file a branch adds.
8. A project install skips a hook the global settings already run.
9. Agents branch before the first edit, and the post-merge sync never
   switches onto a tree dirty with changes the branch did not make.

## Constraints

- No new seat, and no probing only to prove an existing doc.
