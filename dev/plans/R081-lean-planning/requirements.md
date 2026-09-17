---
approved: yes
kind: mnt
---

# R081: Lean planning

## Goal

Keep the DEV chain (requirements, initiative, tasks, plan, code) and
make it cheap: token use per task drops at least 2x, ideally 3-5x, and
agents stop spiralling through plan, review and fix loops.

## Outcomes

1. Agents do only what was asked. No invented problems, unasked tests,
   edge cases or requirement extensions. An unknown fact is asked, not
   guessed or probed. A theoretical question gets an answer, not an
   action.
2. Requirements state the outcome, inputs and outputs, no
   implementation detail unless the user supplied it. They are read for
   meaning, not wording.
3. ROADMAP, requirements and tasks.md stay short and stable: what (and
   why once), never how, and no links, numbers, dates or probe results.
4. Two plan modes. Normal: the planner says what and suggests how, the
   implementer probes and decides. Strict: the planner proves the plan
   with working draft code and records what worked, errors hit, traps
   and sources. Plans are working files, edited freely unless the task
   itself changes.
5. One report per task: the implementer's divergences and findings,
   then the reviewer's issues as checkboxes the task close resolves.
6. Review and fix loops are bounded and come back to the user instead
   of repeating.
7. Code carries no comments by default; a consumer-facing library API
   may keep trimmed type docs.
8. The DEV rules get smaller, not larger.
