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
  Source: `scripts/preflight-permissions.sh`, `resolve` (each rule's
   `present (<tier>)` or `missing` line) and the Bash-rule loop, skipped
   as `dropped (auto)` under `--runner-mode auto` when the user tier sets
   `autoMode.classifyAllShell`; `scripts/worker-workspace.sh`, its seed
   carrying no `node`, `npm` or `npx` rule; `skills/dev/companions/seat-permissions.md
   § What enforces what`
  Test: `scripts/test/preflight-permissions.test.sh` ("an absent Bash
   prefix stops an AI-supervised run", "a dropped rule is not checked",
   "classifyAllShell drops nothing outside auto", "a project tier's
   classifyAllShell, which auto never reads, drops nothing");
   `scripts/test/preflight-permissions-toolchain.test.sh` ("auto keeps a
   narrow toolchain prefix, so it is checked");
   `scripts/test/worker-workspace.test.sh` ("the seed carries no rule
   auto drops")
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
- Item 2: Claude Code's permission-modes and auto-mode-config docs say
  auto keeps narrow allow rules, Bash ones included, and drops only the
  broad ones granting arbitrary code execution (`Bash(*)`, wildcarded
  interpreters, package-manager run commands, `Agent` and `Monitor`
  rules), every Bash allow rule going only under the user tier's
  `autoMode.classifyAllShell: true`. The tree said auto suspends every
  Bash allow rule. Result: the Bash prefix set binds under auto, the
  `inert (auto)` class is gone, and a missing Bash prefix rule stops a
  `Supervisor: AI` run like any other gap; the pre-flight reads
  `classifyAllShell` from the user tier and, set, reports the set
  `dropped (auto)` unchecked. The worker seed drops `Bash(npm *)`,
  `Bash(node *)` and `Bash(npx *)`, auto dropping them. The template is
  unchanged, declaring no rule those docs name as dropped. `run.md
  § Dispatch per item` and `supervisor-runbook.md § Modes by seat`,
  outside the approach, carried the old premise and now state the
  docs'.
### Findings
- [ ] Item 2: this repository's own pre-flight under `Supervisor: AI`
  now reports four missing Bash rules, none of its tiers carrying
  `Bash(git read-tree:*)`, `Bash(glab ci status:*)`,
  `Bash(bash scripts/ci/run-all.sh:*)` or
  `Bash(bash scripts/test/run-all.sh:*)`, so the next run halts until
  the user runs the printed `--apply` line.
  Evidence: observed `scripts/preflight-permissions.sh --project .
  --supervisor AI --runner-mode auto` printing those four `missing`
  lines and the `--apply` remedy

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
