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
- Item 3 (probe): The REST merge merges a pull request with a merge commit
  from one REST call, making no GraphQL request, and exits non-zero when the
  host refuses the merge.
  Call:
  Output:
  Environment:
- Item 4 (source): Each rule the pre-flight derives from a REST line reaches
  no `gh api` write but the declared merge.
  Source:
- Item 5 (source): `/dev start` in a repository whose `main` already exists
  delivers the scaffold through a working branch and an MR/PR.
  Source:

## Implementer

## Review
