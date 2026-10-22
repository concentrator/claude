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
  `autoMode` entries a DEV run needs, for the user to copy into their user
  settings: an environment entry, soft_deny entries mirroring the always-ask
  list of `declarations.md § Supervisor bounds`, both exempting only a
  `CLAUDE.md` change confined to `## Layout`, and no allow entry.
  Source: `skills/dev/companions/auto-mode.template.json`, its
   `environment` and `soft_deny` ("DEV Release", "DEV Instruction
   Change", "DEV Customer Data", "DEV History Rewrite", "DEV Red Gate")
   and `allow` lists, each keeping `"$defaults"`, the `allow` list
   holding nothing else;
   `skills/dev/companions/declarations.md § Supervisor bounds`, its
   always-ask list naming the paths DEV Instruction Change names and
   exempting the same `## Layout` line;
   `skills/dev/companions/seat-permissions.md § Auto-mode template`, the
   tiers Claude Code reads `autoMode` from and the user's copy into the
   user tier

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
- Item 3: DEV Instruction Change and the always-ask list keep exempting a
  `CLAUDE.md` change confined to the `## Agent toolchain` and
  `## Layout` lines, the item and its answers dropping only the
  `## Supervision` one.
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
- Item 4: the user's settings edit also runs the pre-flight's `--apply`,
  adding the four allow rules item 2's check reports missing.
- Item 3: the template leaves `autoMode.classifyAllShell` unset, so
  narrow Bash allow rules bind under `auto`.
- Item 2: a user-tier `Bash(*)` counting as cover under `auto` goes to
  the R088 backlog.
- Item 3: after the classifier denied a `claude --settings` load of the
  template, the item finishes without that check; item 4's `claude
  auto-mode config` and `critique` test the template.
- Item 3: soft_deny carries five action-level entries - release, a merge
  changing `CLAUDE.md`, `rules/` or `skills/`, customer data, a rewrite of
  pushed history, a red gate; off-plan work and design decisions stay out,
  no single tool call showing them.
- Item 4: after `claude auto-mode critique`, the template drops its allow
  entry: the classifier reads commands, not their output, so it cannot
  see the CI wait pass or the head sha match. The runner's merge falls to
  the default "Merge Without Review" rule; a redesign goes to the backlog.
- Item 4: DEV Instruction Change exempts no `## Supervision` line, here
  and in `declarations.md § Supervisor bounds`, so no merge changes who
  merges.
- Item 4: DEV Instruction Change also covers `hooks/`, `agents/`,
  `scripts/`, `settings*.json`, `.mcp.json` and CI configuration.
- Item 4: the critique's findings on the user's own `~/.claude` entries
  get drafted wording the user applies; no seat edits them.
- Item 3: the always-ask list in `declarations.md § Supervisor bounds`
  gains the same paths as DEV Instruction Change, so the two still mirror.
- Item 3: no `skills/dev/` text says what the classifier does with an AI
  supervisor's merge; that waits for the backlog redesign.
- Item 4: its text leaves out the `--apply`, which has already run.
- Item 4: the user's edit also sets `attribution.sessionUrl: false`; the
  worker host's copy goes to the R088 backlog.
- Item 3: DEV Instruction Change and the always-ask list exempt only a
  `CLAUDE.md` change confined to `## Layout`; `## Agent toolchain`
  declares the merge and CI-wait commands, so a change to it asks.
- Item 4: the second critique's other soft_deny findings go to the R088
  backlog, and the user's own `~/.claude` entries stay as they are.

## Review
