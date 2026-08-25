---
approved: 2026-08-25
kind: refactor
status: done 2026-08-26
---

# R-061: Unified plan ids

## Current state

The three plan ids have three shapes. An initiative is `R-061`, a task
is `R061-T001`, a batch is `B-001` and appears in refs as
`R061-B-001`. The same initiative is written `R-061` in `ROADMAP.md`
and its directory name but `R061` inside every task id, so one id
appears in two spellings within a single path
(`plans/R-061-<slug>/R061-T001-<slug>.md`). Batches carry a bare
per-initiative counter whose scope is visible only from the directory
holding the file, and the composite ref form `R<NNN>-B-XXX` mixes both
styles in one token.

Every reader - human or agent - re-derives which hyphens belong where,
and the two CI gates that parse ids (`scripts/ci/check-plan-integrity.sh`,
`scripts/ci/check-batch-tags.sh`) each carry their own regex per shape.

## Desired state

One shape for every plan id: an uppercase letter and three digits, with
composite ids joined by a single hyphen and no hyphen inside a
component.

| Level | Form | Example |
|---|---|---|
| Initiative | `R<NNN>` | `R062` |
| Task | `R<NNN>-T<NNN>` | `R062-T001` |
| Batch | `R<NNN>-B<NNN>` | `R062-B001` |

The form is fixed: it applies to every artifact created after this
initiative's gate task merges - `ROADMAP.md` entries, initiative
directories (`plans/R062-<slug>/`), task ids, batch manifests and
reports (`batches/R062-B001.md`), batch refs (`batch/R062-B001`,
`pre-R062-B001`), plan branches (`plan/r062-t001`, unchanged in shape).
Existing ids are legacy: frozen, valid, never renumbered or renamed,
draining out through archival like the bare `T-XXX` counter before
them.

## Invariants

- No existing id, directory, file, ref, or citation changes. A rename
  would break every prose citation (`writing.md § Name things by their
  durable id`).
- Both gates keep accepting every legacy shape for as long as legacy
  artifacts exist on `main` or under `archive/`.
- The rule has one home (`plan.md § ID format`); every other file
  shows the form by example and cites it.

## Scope

- `plan.md § ID format`, `§ Levels`, `§ Where things live`,
  `§ Directory conventions`; `branch-plan.md § Batches`, `§ Rails`;
  `git-workflow.md § Trunk`; `write-plan.md`; `templates.md`;
  `layout.md`; `brainstorm.md`; `auto.md`; `supervise.md`;
  `finish.md`; `migrate.md`; `SKILL.md`; `companions/` files naming a
  shape; `README.md`, `REQUIREMENTS.md § Planning discipline`,
  `DESIGN.md`, `MAINTENANCE.md`, `agents/code-reviewer.md`.
- `scripts/ci/check-plan-integrity.sh`, `scripts/ci/check-batch-tags.sh`
  and their tests under `scripts/test/`.
- Out of scope: the hooks (`hooks/*.sh` cite initiative ids only in
  comments); this initiative's own directory and id, created under the
  legacy shape because the gate rejects the new one until the gate task
  merges.

## Acceptance criteria

- [x] `plan.md § ID format` states the one shape above and names every
      legacy shape (`R-NNN`, `T-NNN`, `B-NNN`, `R<NNN>-B-NNN`) as frozen.
      Evidence: the section, commit "State the unified id shape in plan.md".
- [x] No tracked file outside `plans/` shows a legacy shape except where
      it is labelled legacy: `grep -rnE 'R-XXX|R-<NNN>|B-XXX|B-<NNN>'`
      over `git ls-files` minus `plans/` returns only lines containing
      `legacy`. Evidence: the grep returns zero unlabelled lines on the
      `doc/id-shape-docs` branch (close review, R061-T002).
- [x] `check-plan-integrity.sh` resolves an initiative written `R062`
      in `ROADMAP.md` to a directory `plans/R062-<slug>/`, reads
      `R062-T001` task ids under it, and still passes on the current
      tree; `scripts/test/check-plan-integrity.test.sh` covers a
      new-shape fixture and a mixed tree. Evidence: test cases 18-23,
      PR "Teach the id gates the unified shape" (R061-T001).
- [x] `check-batch-tags.sh` judges `batch/R062-B001` and `pre-R062-B001`
      against `plans/R062-<slug>/batches/R062-B001.report.md`, and
      still judges the legacy `R<NNN>-B-XXX` refs;
      `scripts/test/check-batch-tags.test.sh` covers both. Evidence:
      test cases 17-22, same PR.
- [x] `bash scripts/ci/run-all.sh` is green. Evidence: exit 0 on every
      commit of both branches; CI `tier1` on both PRs.

## Constraints

- Single home per rule (R-039); proportional (R-053): the shape
  changes, no new subsystem, no migration of existing artifacts.
- The gate task merges before the doc task, so no doc instructs an
  agent to create an artifact the gate would reject.

## Open questions

- None.

## References

- `skills/dev/plan.md § ID format`; `scripts/ci/check-plan-integrity.sh`;
  `scripts/ci/check-batch-tags.sh`.
- R-014 - composite task ids, the shape this initiative extends to
  initiatives and batches.
- R-044, R-048 - the batch tag and branch forms this initiative
  respells.
