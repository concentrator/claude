# R086-T004 report

## Implementer
### Findings
- [x] Item 3: `README.md`, in the paragraph on the fast-tier append,
  names only the plan-text gate (`check-plan-text.sh`), so it no longer
  matches what a `--project` install appends; the docs are the doc
  writer's at close. Fixed by the doc writer at close.
  Evidence: observed `README.md` lines 220-239 after the item's commit

## Answers
- Review 1: fix - the clause becomes its own sentence after the append
  sentence, in both files.

## Review
- [x] Close review: the "each only where the line does not name it"
  clause splits the append sentence's verb from its object
  (Suggestion) - `skills/dev/migrate.md:102`, `skills/dev/start.md:58`.
  Evidence: observed the sentence at both lines
