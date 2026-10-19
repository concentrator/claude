# R088-T005 report

## Claims
- Item 1 (source): Under `Supervisor: human` the user answers a permission
  prompt, and a missing allow rule halts no run.
  Source:
- Item 2 (source): The permission pre-flight checks only the rules that bind
  in the run's permission mode, each reported with the tier carrying it.
  Source:
- Item 3 (source): `skills/dev/companions/auto-mode.template.json` holds the
  `autoMode` entries a DEV run needs, for the user to merge into their user
  settings: an environment entry, an allow entry for the supervised merge
  and soft_deny entries for the always-ask actions.
  Source:

## Implementer

## Review
