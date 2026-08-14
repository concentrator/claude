---
approved: 2026-08-14
kind: feat
status: done 2026-08-15
---

# R-043: Ship the accretion check to adopters

## Motivation

Every DEV project needs the accretion gate permanently in CI, but each
adopter currently hand-rolls its own copy (attack-checker R020-T003,
aikido R011-T001) and a freshly scaffolded project gets none. The
em-dash check already solved this shape (R-026: a copyable reference
check shipped at adoption); the accretion check should follow the same
model.

aikido's copy took three initiatives to get right, and its review
record is a free audit of our reference: a bare-year match
(`<verb> 20\d{2}`) is indistinguishable from key lengths, counts, and
ids, and the machinery compensating for that produced most of the
defects its reviews found - requiring a full ISO date removes the
surface; `git ls-files` under default `core.quotePath` quotes
non-ASCII filenames, which the reference then silently skips; and its
measured recall audit names marker verbs our list lacks. The reference
is hardened with those findings before it is multiplied across
adopters.

## Goals

- The reference pair - `check-accretion.sh` and its self-test - carries
  aikido's fixes: a marker fires only with a full `YYYY-MM-DD` date on
  the line, quoted (non-ASCII) filenames are still scanned, and the
  marker list gains the verbs the recall audit found (`supersedes`,
  `delivered`, `restored`, `revised`, `deferred`, `complete`).
- A copyable reference implementation offered by `install-dev.sh`
  (alongside the R-026 checks), `start.md` (scaffold), and `migrate.md`
  (the docs-reconcile proposal), with the marker-word list as the only
  per-project tuning. `check-batch-tags.sh` (R-044/R-048) and their
  shared `resolve-root.sh` ship in the same set.
- The check's contract stated once, adopter-side: dated history
  markers (`<marker-word> YYYY-MM-DD`) in living plan artifacts;
  `archive/` and mandated frontmatter fields exempt; undated terminal
  outcomes legal.

## Non-goals

- Gating other accretion classes (duplicated numbers, data-file
  annotation keys) - rules and per-project checks own those.
- Retrofitting projects that already built theirs (aikido and
  attack-checker keep their JS implementations).
- Prose-recall machinery the full-date rule exists to avoid: wrap
  windows, flexible date formats, markdown-context awareness.

## Acceptance criteria

- [x] A marker with a bare year and no full date passes; the same
      marker with `YYYY-MM-DD` fails (test cases "bare year and
      embedded verbs pass" and the full-date fail cases, PR #298)
- [x] A plan file with a non-ASCII name is scanned, not skipped (test
      cases "quoted filename scanned" / "quoted archive filename
      exempt", PR #298)
- [x] The recall verbs fire: a `supersedes` marker followed by a full
      date is caught (test case "supersedes + deferred + completed
      caught", PR #298)
- [x] `install-dev.sh` copies the accretion and batch-tags checks,
      their self-tests, and `resolve-root.sh`; its test asserts the
      copied set and that a tuned `MARKERS` line survives re-install
- [x] `start.md` scaffolds the checks into a new project's CI;
      `migrate.md`'s reconcile proposal names the reference copy
      instead of describing the check from scratch
- [x] A copied check passes its self-test unmodified (both copied
      self-tests ran green from a fresh `--project` install at close;
      the installer test permanently asserts the copied gates bite
      from the install location); tuning the marker list is a
      one-line edit (the named `MARKERS` variable)
- [x] Tier-1 green (`tier1` on the delivery PRs; local
      `run-all: ALL OK`)

## References

`scripts/ci/check-accretion.sh`, `scripts/test/check-accretion.test.sh`
(the reference pair), R-026 (the shipping model), `start.md`,
`migrate.md`; aikido R-013/R-014 (the defect record and the
structural rule), attack-checker (the rule's origin).
