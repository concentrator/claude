# R082-T001 report

## Implementer
### Divergences
- Item 2: the `FROM` half of the re-install case in
  `scripts/test/install-dev.test.sh` is replaced, not only dropped: a
  `cmp` of the installed `check-plan-text.sh` against the shipped one
  after re-install pins the item's acceptance, the gate copied as shipped.
- Item 3: the backlog check is a `backlog` function beside `scan`, not
  its `tasks` mode: `scan` holds at 45 lines of the 50-line function cap,
  which item 5's `plan` mode still needs.
- Item 6: R-044's example tag `pre-R042-B-001` is dropped, not reworded:
  the gate reads any `R-?NNN` as an initiative id, so an example id fails
  as another initiative's.
