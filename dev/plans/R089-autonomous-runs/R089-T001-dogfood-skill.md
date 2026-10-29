---
task: R089-T001
type: doc
mode: normal
---

- [ ] Run measurements and run history leave the playbook: a new
  `docs/reports/dogfood-runs.md` holds the comparison table, its first row
  citing the tested commit by its merge subject (findings 4, 5), and the
  open questions the next run answers; the first-run history lines, those
  finding 6 quotes among them, join `dev-dogfood-report.md`. Approach: the
  new report, the old one, then the playbook loses those lines.
- [ ] The playbook becomes the repository-only skill `skills/dogfood/`, the
  new `SKILL.md` this plan proposes (`rules/skills.md § Approval`): its body,
  within the § Size cap, gives purpose, triggers, inputs, outputs and the
  companions' order; companions hold the rest, the brief verbatim. Approach:
  `SKILL.md`, then `companions/` split as `skills/worker-host/` splits its
  own, `LAYOUT.md`'s entry, the playbook removed.
- [ ] The brief stops working around what R089 is judged on (finding 1): a
  failing declared host command or a refused merge is recorded with its
  reason and the run goes on as the toolset's text directs, naming no
  `gh api` form and no stacking; the requirements row, the pitfalls' fixes
  and the finishing steps follow. Approach: the brief's step 2, then each
  companion line citing it.
- [ ] The brief takes the task count as a fourth placeholder, the first that
  many of its four named tasks in order, 4 by default (finding 2); the
  pitfalls cite `skills/dev/companions/toolchain.md` (finding 3), and the
  budget row cites `dogfood-runs.md` instead of copying its figures
  (`rules/writing-artifacts.md § One home per number`). Approach: the brief,
  the inputs in `SKILL.md`, then the pitfalls and requirements companions.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- Item 2 (source): `skills/dogfood/` is this repository's own runbook for a
  dogfood run of the toolset, which `install-dev.sh` does not ship.

## Proven

- none
