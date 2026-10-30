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

## Answers

- Item 3: the skill is named `dogfooding`, the gerund
  `rules/skills.md § Naming and location` asks for; item 3's commit
  renames `skills/dogfood/` and its `LAYOUT.md` entry. The user approved
  the rename, `git mv` of its `SKILL.md` included.

## Review
