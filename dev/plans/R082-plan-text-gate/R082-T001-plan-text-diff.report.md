# R082-T001 report

## Implementer
### Divergences
- Item 2: the `FROM` half of the re-install case in
  `scripts/test/install-dev.test.sh` is replaced, not only dropped: a
  `cmp` of the installed `check-plan-text.sh` against the shipped one
  after re-install pins the item's acceptance, the gate copied as shipped.
