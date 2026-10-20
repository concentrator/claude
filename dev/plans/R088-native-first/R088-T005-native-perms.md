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
- [ ] The `autoMode` template: an environment entry; no allow entry, so the
  runner's merge meets the default "Merge Without Review" rule; soft_deny
  entries mirroring the always-ask list, both exempting no `## Supervision`
  line and covering `hooks/`, `agents/`, `scripts/`, `settings*.json`,
  `.mcp.json` and CI config. Approach: the template, `declarations.md
  § Supervisor bounds`, `seat-permissions.md § Auto-mode template`.
- [ ] This machine's user tier replaces its copies of the template's
  entries - DEV Supervised Merge removed, DEV Instruction Change updated -
  and sets `permissions.disableBypassPermissionsMode: "disable"`; `claude
  auto-mode config` shows the result. Approach: the user's one
  `settings.json` edit, then `claude auto-mode critique`; for its findings
  on the user's own entries the runner drafts wording the user applies.
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
  `autoMode` entries a DEV run needs, for the user to copy into their user
  settings: an environment entry, soft_deny entries mirroring the always-ask
  list of `declarations.md § Supervisor bounds`, and no allow entry.

## Proven

- none
