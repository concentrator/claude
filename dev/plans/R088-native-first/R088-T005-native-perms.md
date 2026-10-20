---
task: R088-T005
type: mnt
mode: normal
---

- [x] Under `Supervisor: human` the user answers a permission prompt: a
  missing allow rule halts no run, and the pre-flight reports it without
  failing. Approach: `run.md § Seats` prompt row and `§ Dispatch per item`,
  `seat-permissions.md § Prompt classes`, `supervisor-runbook.md § Modes by
  seat`, then `preflight-permissions.sh` with its test.
- [x] The pre-flight checks only what binds in the run's permission mode:
  deny rules, the mode, its never-list and the allow rules that mode reads;
  a rule set the mode drops is neither declared nor checked. Approach: which
  allow rules `auto` keeps, from Claude Code's permission-modes docs; then
  `seat-permissions.md`, the template, `preflight-permissions.sh` with its
  two tests, `worker-workspace.sh`, `toolchain.md § Permission carve-out`.
- [x] The toolset ships an `autoMode` template: a DEV-run environment entry;
  an allow entry, against the default "Merge Without Review" rule, for the
  runner's merge within the declared bounds, CI green on the head sha; and
  soft_deny entries for the action-level always-ask list of `declarations.md
  § Supervisor bounds`. Approach: `companions/auto-mode.template.json`, then
  a `seat-permissions.md` section naming the tiers Claude Code reads it from.
- [ ] This machine's user tier carries the template's entries beside the
  repository's own `autoMode` entries, and `claude auto-mode config` shows
  them; it also sets `permissions.disableBypassPermissionsMode: "disable"`.
  Approach: the user makes both in one `settings.json` edit, the settings
  surface being no seat's; then `claude auto-mode critique` over the result.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- Item 1 (source): Under `Supervisor: human` the user answers a permission
  prompt, and a missing allow rule halts no run.
- Item 2 (source): The permission pre-flight checks only the rules that bind
  in the run's permission mode, each reported with the tier carrying it.
- Item 3 (source): `skills/dev/companions/auto-mode.template.json` holds the
  `autoMode` entries a DEV run needs, for the user to merge into their user
  settings: an environment entry, an allow entry for the supervised merge
  and soft_deny entries for the always-ask actions.

## Proven

- none
