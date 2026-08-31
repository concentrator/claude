---
approved: 2026-09-01
status: open
kind: doc
---

# R068: Docs as snapshot

Shaped from a consumer-facing defect the user raised against a project
docs layer: feature docs accumulate development chronology and link
planning artifacts, so a reader gets history instead of state and the
links rot when initiatives archive.

## Current state

`companions/documentation.md` has no link-scope rule and no rule
against chronology. In practice feature docs carry probe-round
narratives (dates, tenants, round-by-round context blocks), link
findings files and live `dev/plans/` paths, and after archival those
links point into `dev/plans/archive/` - which `plan.md § Archival`
already forbids citing, but nothing prevents writing the link while
the plan is live, and the mechanical gates check for dead links only,
so the violation appears silently at initiative close. Observed in one
adopter: 27 of 34 feature docs reference `dev/plans/`, four cite
`archive/` paths directly. The framework's own § Content quality
("Real examples ... cited") and § Evidence and provenance ("says
which version or environment it was verified against") invite exactly
these citations, and `layout.md § Docs` skeleton row 7 points at a
feature's `references/` inputs without defining where adapted
reference material lives.

## Desired state

A doc is a compiled snapshot of the subject's current state. History
belongs to git, planning to plans:

- **Snapshot principle.** A doc states current behavior; no
  development chronology, task or plan ids, round dates, or
  development details. A provenance mark (verified / from-spec /
  unverified / mixed) is a state fact about claim strength and stays;
  the verification chronology behind it does not.
- **Link scope.** A doc links only sibling documents inside the
  project's docs tree, or external URLs. Never plan files (live or
  archived), never findings files, never `.claude/` paths.
- **Reports** (`docs/reports/` or a project-chosen name inside the
  docs tree): a doc type for probe and test reports - the one docs
  location where datetimes and tenant / client identifiers are
  allowed. Main docs may link them plainly; they are useful for hard
  cases, never required. The main doc asserts state without proving
  it.
- **Adapted references** (`docs/references/`): external or codebase
  material extracted and rewritten to project format, carrying exactly
  what docs need; a source URL is allowed inside the adapted file.
  Replaces linking `.claude/references/` from docs.
- **Findings disposition.** At task or initiative close every findings
  file ends as one of: archived uncited, promoted into a doc,
  transformed into a report doc, or spawned into a new plan or task.
  Docs never link findings.
- The framework names the mechanical expectation: a project's docs
  gate fails on a docs-tree file referencing `dev/plans/`, `.claude/`,
  or any path outside the docs tree that is not an external URL.

## Invariants

- Diataxis typing, the Reference skeleton, the detail bar, and the
  verification gate are untouched; only citation targets and link
  scope change.
- Provenance marks stay mandatory and dateless in docs
  (`layout.md § Docs` definitions unchanged in vocabulary).
- `rules/writing-artifacts.md` (one home per finding / number) already
  agrees with this ruleset and is not edited.

## Scope

- `skills/dev/companions/documentation.md` - snapshot principle, link
  scope, the two doc types, amended citation targets in § Content
  quality and § Evidence and provenance, gate expectation.
- `skills/dev/layout.md § Docs` - `reports/` and `references/`
  subdirectories in the docs home, skeleton row 7 reworded to the new
  targets.
- `skills/dev/plan.md § Archival` - findings disposition rewritten to
  the four endings; the no-links rule stated where promotion is
  defined.

Out of scope: any project's docs remediation and per-project rule
files (the user manages those separately); the per-project gate
implementation.

## Acceptance criteria

- [ ] `documentation.md` states the snapshot principle and the link
  scope rule, defines the reports and adapted-references doc types
  with their allowances, and names the link-scope gate expectation.
- [ ] `layout.md § Docs` shows both subdirectories in the docs home
  and row 7 targets sibling docs, reports, and adapted references.
- [ ] `plan.md § Archival` lists the four findings dispositions and
  states that docs never link findings or plan files.
- [ ] No remaining framework text invites a doc to cite planning
  artifacts: the § Content quality example rule and § Evidence and
  provenance point at report docs.
