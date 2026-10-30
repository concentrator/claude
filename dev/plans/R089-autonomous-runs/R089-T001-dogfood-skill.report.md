# R089-T001 report

## Claims
- Item 2 (source): `skills/dogfood/` is this repository's own runbook for a
  dogfood run of the toolset, which `install-dev.sh` does not ship.
  Source: `scripts/install-dev.sh`: step 1 ships `skills/dev` and step 2
    only the `BUNDLED` trees (`systematic-debugging`,
    `dispatching-parallel-agents`), the only paths it ships under
    `skills/`; `skills/dogfood/SKILL.md` gives the runbook's purpose,
    and `skills/dogfood/companions/` its steps.

## Implementer
### Divergences
- Item 1: three playbook lines that named the table's old home or the
  first run's figures are reworded to point at `dogfood-runs.md` rather
  than deleted (Finishing step 7, the outputs' row line, criterion 10's
  baseline), so the playbook names no record that no longer exists. The
  history joins `dev-dogfood-report.md` as a `## Setup and review`
  section, the playbook's step numbers spelled out as the steps' names.
  The date and byline header and the budget row stay: the first goes
  with the playbook in item 2, the second is item 4's.
- Item 2: the companions are `requirements`, `preparation`, `brief`,
  `monitoring`, `finishing` and `pitfalls`, one per playbook section as
  `skills/worker-host/` keeps provisioning and pitfalls apart; the skill
  design notes' inputs, outputs and triggers went to `SKILL.md`, the
  reusable-repository note to `preparation.md`, the checks before
  trusting the report to `finishing.md`. The brief is copied byte for
  byte; elsewhere a section reference ("Step 2 of Preparation",
  "Finishing step 3") names its companion file instead. The playbook's
  `## Review findings` section is not carried: it is this task's work
  list, not runbook content, and items 3 and 4 state its open changes in
  full.
- Item 3: the commit carries the `## Answers` rename: `skills/dogfood/`
  moves to `skills/dogfooding/`, its `SKILL.md` `name:` and its
  `LAYOUT.md` entry following. The `skills/dogfood/` mentions in plan
  text (this plan, `tasks.md`, the T002 plan) and in Item 2's claim
  evidence above are left, plan text and another item's claim being no
  implementer's to edit. Finishing steps 2 and 3 keep the retarget, now
  for any stacked pull request rather than every one, since the
  monitoring table still logs stacking the toolset itself may cause.
- Item 4: the `scale` input is renamed `task_count`, matching its
  `<TASK_COUNT>` placeholder as `repo` and `toolset_commit` match
  theirs. Its "a quarter of the cost" becomes "more cheaply": the
  input's longer wording took the body past the 300-word cap, and the
  quarter was an estimate no run has measured.

## Answers

- Item 3: the skill is named `dogfooding`, the gerund
  `rules/skills.md § Naming and location` asks for; item 3's commit
  renames `skills/dogfood/` and its `LAYOUT.md` entry. The user approved
  the rename, `git mv` of its `SKILL.md` included.

## Review

- [ ] Item 2: `README.md § Contents` names the worker-host runbook beside
  the bundled skills but not `skills/dogfooding/` (Important) -
  README.md:16
  Evidence: observed README.md:16; the doc writer's claim covers it
- [ ] Item 4: criterion 10 takes the previous runs-table row as the
  baseline, while `SKILL.md` makes `baseline` an input and
  `dogfood-runs.md` compares only at equal task count (Important) -
  skills/dogfooding/companions/monitoring.md:29
  Evidence: observed monitoring.md:29, SKILL.md:33, dogfood-runs.md:4
- [ ] Item 3: Item 2's claim Source cites `skills/dogfood/`, and the
  `tasks.md` T001 line and the T002 plan name it, after the rename
  (Important) - dev/plans/R089-autonomous-runs/tasks.md:8
  Evidence: observed the report's Source field, tasks.md:8,
  R089-T002-cloud-install.md:27
- [ ] Item 1: `README.md` and `LAYOUT.md` describe `docs/reports/` as
  probe reports only, which the runs table is not (Suggestion) -
  LAYOUT.md:62
  Evidence: observed README.md:27, LAYOUT.md:62
- [ ] Item 4: "the brief's first that many tasks" reads badly cold
  (Suggestion) - skills/dogfooding/SKILL.md:31
  Evidence: observed SKILL.md:31-32
- [ ] Item 2: "twelve criteria" annotates the numbered list with its own
  count in three places (Suggestion) - skills/dogfooding/SKILL.md:10
  Evidence: observed SKILL.md:10, SKILL.md:50, monitoring.md:18
- [ ] Item 2: four companions keep the playbook's unwrapped prose lines
  while `preparation.md` and `SKILL.md` wrap at 80 (Suggestion) -
  skills/dogfooding/companions/finishing.md:1
  Evidence: observed the companions' line lengths
