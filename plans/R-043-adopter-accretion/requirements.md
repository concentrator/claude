---
approved: pending
kind: feat
---

# R-043: Ship the accretion check to adopters

## Motivation

Every DEV project needs the accretion gate permanently in CI, but each
adopter currently hand-rolls its own copy (attack-checker R020-T003,
aikido R011-T001) and a freshly scaffolded project gets none. The
em-dash check already solved this shape (R-026: a copyable reference
check shipped at adoption); the accretion check should follow the same
model.

## Goals

- A copyable reference implementation - `check-accretion.sh` and its
  self-test - offered by `start.md` (scaffold) and `migrate.md` (the
  docs-reconcile proposal), with the marker-word list as the only
  per-project tuning.
- The check's contract stated once, adopter-side: dated history
  markers (`<marker-word> 20\d{2}`) in living plan artifacts;
  `archive/` and mandated frontmatter fields exempt; undated terminal
  outcomes legal.

## Non-goals

- Gating other accretion classes (duplicated numbers, data-file
  annotation keys) - rules and per-project checks own those.
- Retrofitting projects that already built theirs.

## Acceptance criteria

- [ ] `start.md` scaffolds the check + self-test into a new project's
      CI alongside the existing shipped checks.
- [ ] `migrate.md`'s reconcile proposal names the reference copy
      instead of describing the check from scratch.
- [ ] A copied check passes its self-test unmodified; tuning the
      marker list is a one-line edit.

## References

`scripts/ci/check-accretion.sh`, `scripts/test/check-accretion.test.sh`
(the reference pair), R-026 (the shipping model), `start.md`,
`migrate.md`.
