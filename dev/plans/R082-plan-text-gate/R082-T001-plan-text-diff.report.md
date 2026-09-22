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

## Review
- [ ] An existing or renamed findings file is scanned as a branch plan
  and fails on long items (Important) - scripts/ci/check-plan-text.sh:106
  Evidence: observed `item over 6 lines` on a renamed R080-T005 findings file
- [ ] ROADMAP R-054 reads as if all wildcards went (Important) -
  dev/plans/ROADMAP.md:140
  Evidence: contract R-054 requirements: arbitrary-execution wildcards are gone
- [ ] ROADMAP R-057 lost the no-spawning cap (Suggestion) -
  dev/plans/ROADMAP.md:149
  Evidence: contract R-057 requirements, Desired state
- [ ] ROADMAP R080 lost the planner's cold-read exit (Suggestion) -
  dev/plans/ROADMAP.md:217
  Evidence: contract R080 requirements, outcome 2
- [ ] The diff grows the gate's header comment (Suggestion) -
  scripts/ci/check-plan-text.sh:1
  Evidence: contract CLAUDE.md, Code Comments
