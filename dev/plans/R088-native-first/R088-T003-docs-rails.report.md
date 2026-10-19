# R088-T003 report

## Claims
- Item 1 (source): `MAINTENANCE.md § Doc-sync pairs` maps each path glob to
  the doc files that an added, removed or renamed path it matches must
  update.
  Source:
- Item 2 (source): `scripts/ci/check-doc-sync.sh` fails a branch that adds,
  removes or renames a path a doc-sync row matches without changing every
  doc file the row names.
  Source:

## Implementer

## Answers

- Items 1 and 2: a row fires only when a matching path is added, removed
  or renamed; a plain edit stays with the Tier-2 Doc sync concern.
  Requirements outcome 7 reads so.
- Item 3: a one-time rewrite; no check for history wording.
- Item 2: no self-test, the task staying `[doc]`.
- Item 2: the check is this repository's only; `install-dev.sh` does not
  ship it, what an install ships being R088-T006's.

## Review
