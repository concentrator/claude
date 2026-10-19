# R088-T005 report

## Claims
- Item 1 (source): Under `Supervisor: human` the user answers a permission
  prompt, and a missing allow rule halts no run.
  Source: `scripts/preflight-permissions.sh`, the verdict's last exit
   test (`[ "$supervisor" = human ]`); `skills/dev/run.md § Seats`, the
   "Clearing a permission prompt" row
  Test: `scripts/test/preflight-permissions.test.sh` ("a missing allow
   rule halts no human-supervised run, the user answering its prompt",
   "a missing allow rule stops an AI-supervised run", "a missing deny
   stops a human-supervised run too")
- Item 2 (source): The permission pre-flight checks only the rules that bind
  in the run's permission mode, each reported with the tier carrying it.
  Source:
- Item 3 (source): `skills/dev/companions/auto-mode.template.json` holds the
  `autoMode` entries a DEV run needs, for the user to merge into their user
  settings: an environment entry, an allow entry for the supervised merge
  and soft_deny entries for the always-ask actions.
  Source:

## Implementer
### Divergences
- Item 1: two spans outside the named sections carried the old rule and
  now name the supervisor mode: `seat-permissions.md § What enforces
  what` ("a gap in it stops the run") and `supervisor-runbook.md § tmux
  recipes`, its keystroke-authority paragraph ("No key goes past a
  permission prompt"). Result: no text in `skills/dev/` states that a
  missing allow rule halts a `Supervisor: human` run.

## Answers

- Item 1: under `Supervisor: human` the user answers a permission prompt
  and the pre-flight reports a gap without failing; `Supervisor: AI`
  keeps the halt.
- Item 3: the soft_deny entries carry the action-level always-ask list
  of `declarations.md § Supervisor bounds`.
- Item 3: the template allows the runner's merge only within the
  declared bounds, CI green on the head sha, against the default "Merge
  Without Review" rule.
- Item 4: the user also sets `permissions.disableBypassPermissionsMode:
  "disable"`; the pre-flight keeps its own never-list check.

## Review
