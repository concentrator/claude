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

## Review
