# R089-T004 report

## Claims
- Item 1 (probe): The REST state check prints a pull request's state, merge
  time and head sha from one REST call, making no GraphQL request.
  Call:
  Output:
  Environment:
- Item 2 (probe): The REST CI wait exits 0 when every check passes and
  non-zero when one fails, making no GraphQL request.
  Call:
  Output:
  Environment:
- Item 4 (source): `/dev start` in a repository whose `main` already exists
  delivers the scaffold through a working branch and an MR/PR.
  Source:

## Implementer

## Review
