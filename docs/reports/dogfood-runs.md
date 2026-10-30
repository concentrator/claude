# DEV toolset dogfood runs

One row per dogfood run of the toolset, appended when the run's judgement
is written, so run-to-run deltas show regressions. Cost and tokens compare
only at equal task count. Each run's own report holds its evidence; the
first run's is [`dev-dogfood-report.md`](dev-dogfood-report.md).

## Comparison

| Date | Toolset commit | Tasks | Wall minutes | Cost USD | Tokens processed | Output tokens | Seats | Denials | Stalls | Pass / partial / fail |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-10-29 | `d1a854d` "Merge pull request #612" | 4 | 55 | 28 | 63.7M | 259k | 37 | 10 | 0 | 2 / 5 / 5 |

## Open questions for the next run

- Whether a merge rule for the declared merge command is enough for `auto`
  mode to let a seat merge, or whether the classifier refuses regardless;
  the next run with the rule shipped answers it.
- Whether the project install (`--project`) is also refused as external
  code; the first run tried only the global one.
