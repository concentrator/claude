# R082-T002 report

## Implementer
### Divergences
- Item 1: the fast-tier cases live in a new
  `scripts/test/install-dev-fast-tier.test.sh`, not in
  `scripts/test/install-dev.test.sh`: appended there, the file reached
  314 lines, over the code-size gate's 300-line cap.
- [ ] Item 2: the item's cases also live in
  `scripts/test/install-dev-fast-tier.test.sh`, for the same cap. The
  absent-line notice prints from step 7 as the install runs, not from
  the closing echo: deferring it cost two lines and put
  `scripts/install-dev.sh` over the cap.
  Evidence: observed - `check-code-size` reported `scripts/install-dev.sh is 301
  lines > 300` with the deferred form.

### Findings
- [ ] `scripts/install-dev.sh` sits one line under the code-size cap
  after item 2; item 3's CI notice line takes it to the cap.
  Evidence: observed - `wc -l scripts/install-dev.sh` prints 299.
