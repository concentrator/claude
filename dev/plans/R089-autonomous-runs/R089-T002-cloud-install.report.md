# R089-T002 report

## Claims
- Item 1 (source): A full install ships `scripts/ci/check-archival.sh`, the
  gate failing a closed initiative left unarchived, with its self-test.
  Source:
- Item 4 (source): A cloud session gets the toolset from its environment's
  setup script, which shallow-clones the toolset outside `~/.claude` and
  runs the global install, so no command of the session installs it.
  Source:

## Implementer

## Review
