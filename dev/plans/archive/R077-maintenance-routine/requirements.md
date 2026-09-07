---
approved: yes
kind: feat
---

# R077: Ship the maintenance routine

## Motivation

`MAINTENANCE.md` says each project's `.claude/MAINTENANCE.md` carries
the generic cleanup Routine, but `install-dev.sh` ships none of it, so
adopters accumulate toolset by-products with no cleanup owner: aikido's
`dev/session/` files outlived their transcripts until the targets table
was added by hand (its MR !219). The toolset creates these by-products;
the installer should deliver the rules that retire them.

## Goals

- **Seed if absent**: a `--project` install appends a "Session and
  planning hygiene" section - the project-agnostic targets table:
  `dev/session/` files whose transcript is gone (weekly), orphaned or
  closed `dev/plans/` artifacts (monthly), settings allow-list review
  (weekly), stray temp content (weekly) - to the target's
  `.claude/MAINTENANCE.md` when no such section exists, creating the
  file when missing.
- **Project-owned after seeding**: a re-install never modifies an
  existing section - the project tunes its copy freely (the accretion
  `MARKERS` precedent).
- **True claim**: the `MAINTENANCE.md` sentence claiming every project
  carries the Routine is reworded to name the seeding mechanism.

## Non-goals

- No automation of the sweeps themselves - no hook or CI step deletes
  anything; the section is rules for an operator or a maintenance
  session.
- No restructuring of this repo's `MAINTENANCE.md` beyond the one
  reworded sentence; its own Routine table stays authoritative here.
- A global install (no `--project`) seeds nothing - this repo is the
  global target and owns its superset already.

## User experience

- Fresh adopter: after `install-dev.sh --project <p>`,
  `<p>/.claude/MAINTENANCE.md` exists and carries the section; the
  installer's summary names it.
- Adopter with a tuned section (aikido): re-install leaves the file
  byte-identical.
- Adopter with a `MAINTENANCE.md` but no section: the section is
  appended, everything already there preserved.

## Acceptance criteria

- [x] `--project` into a target without `.claude/MAINTENANCE.md`
  creates it with the section (install self-test). Evidence:
  "hygiene section seeded on a fresh target", "targets table names
  its rows".
- [x] `--project` into a target whose `MAINTENANCE.md` lacks the
  section appends it and preserves the existing content (install
  self-test). Evidence: "section appended, existing content
  preserved".
- [x] Re-install over a modified section leaves the file byte-identical
  (install self-test). Evidence: "tuned section survives re-install
  byte-identical", "seeding idempotent over re-installs".
- [x] A global install writes no `MAINTENANCE.md` (install self-test).
  Evidence: "global install seeds no MAINTENANCE.md".
- [x] The reworded `MAINTENANCE.md` sentence names the seeding
  mechanism. Evidence: the intro now reads "install-dev.sh --project
  seeds its hygiene subset ... project-owned afterward".
- [x] Tier-1 gate green (`bash scripts/ci/run-all.sh`, script tests
  included). Evidence: `run-all: ALL OK` and `test/run-all: ALL OK` at
  branch close.

## Constraints

- Section detection is by its heading; the seeded heading matches
  aikido's hand-added one ("Session and planning hygiene") so existing
  adopters read as already seeded.
- The seeded content's canonical source lives with the toolset and
  ships like its other assets - exact home is branch-plan detail.
- Seeding respects the R075 pre-write guard: it runs only after the
  guard admits the install.

## Open questions

None.

## References

- R075 (archived) - the pre-write guard this seeding runs behind.
- aikido MR !219 - the hand-added section this mechanism replaces.
- `scripts/test/install-dev.test.sh` - the self-test the criteria
  cite.
