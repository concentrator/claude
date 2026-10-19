---
approved: yes
kind: mnt
---

# R088: Native first

## Goal

DEV runs fast and steady on Claude Code's native behavior and features,
with this repository as a light framework installed onto a machine.
Where a rule overrides a default, a native setting, hook, tool or check
carries its intent, or the rule aligns with the default.

## Outcomes

1. No rule tells the model to prevail over a harness instruction.
2. Context survives compaction with no hand-off notes, no ledger and no
   manual step.
3. Waiting on CI ends in one notification that carries pass or fail.
4. An explanation the user gives or a conclusion an agent reaches is
   stored where both find it, and a settled question is not raised again.
5. A review runs at a cost the project controls, and a change is reviewed once.
6. Planning is two steps: requirements and design, then the task list
   with a plan per task; a small change ships in one MR/PR.
7. A table names the doc files a change to each path must update, nothing
   it names is missed, and docs describe the present.
8. Native permission modes, settings and hooks settle permissions.
9. The toolset installs by copying files onto a machine, never
   overwriting the user's own files or settings.
10. A saved workflow carries the run sequence and its loop bound, and a
    seat loads only the text its step needs.
11. A weekly cloud routine audits the repository against the current
    defaults and docs and opens a plan MR/PR adding each new finding as
    a line in the backlog of `MAINTENANCE.md`, never one already listed.

## Constraints

- Tasks group by complexity: the simplest fixes first, then fewer items
  needing more work, then the largest items.
