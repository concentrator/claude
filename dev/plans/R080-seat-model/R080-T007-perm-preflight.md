---
task: R080-T007
type: mnt
depends-on: R080-T004
---

# R080-T007: deterministic permission pre-flight

Branch: `mnt/perm-preflight`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 7,
`§ Invariants`.

Every seat's permissions are declared once and settled before the run.
The pre-flight reads the declaration, the toolchain and the tracked
settings tiers, applies what is missing, and refuses to start on
anything it cannot apply. A prompt during the run is a defect in the
declared set, not an event for someone at a keyboard.

- [ ] `companions/seat-permissions.md`: the declared set per seat -
  its mode (`auto` for the supervisor, `acceptEdits` for the working
  seats, per `companions/supervisor-runbook.md § Modes`) and the allow
  rules its commands need, each rule traced to the seat prompt or the
  toolchain declaration that needs it; `auto-permissions.template.json`
  becomes the rules' machine-readable form, grouped by seat.
- [ ] `scripts/dev/preflight-permissions.sh`: given a project path and
  a supervisor mode, resolves every seat's set against the tracked
  tiers (user-global `settings.json`, project `.claude/settings.json`)
  and the carve-outs (`companions/toolchain.md § Permission
  carve-out`), writes the missing rules to the project's
  `.claude/settings.local.json`, sets each seat's mode, and prints one
  report - applied, already present, cannot apply - exiting non-zero on
  the last; a deny rule is never touched and `bypassPermissions` never
  written. Test in `scripts/test/preflight-permissions.test.sh`: a
  full set passes, a missing rule is written, an unwritable tier is
  reported and stops the run, a deny is left alone.
- [ ] `run.md § Pre-flight`: the script runs before the first dispatch
  and its report is the pre-flight's; the prose permission checks
  inherited from `auto.md` go. The compound-command rule: a seat's
  commands are shaped to match a declared prefix (no loops, pipelines
  or `case` where a prefix rule must match), so the set predicts every
  prompt; a prompt outside it is ledgered as a pre-flight defect and
  fixed in `seat-permissions.md`.
- [ ] `companions/supervisor-runbook.md`: `§ Two variants` drops the
  who-clears-prompts row in favour of the duties table and the
  pre-flight; `§ Modes` cites `seat-permissions.md`; `§ Failure modes`
  keeps the classifier entries and drops the keystroke ones the
  pre-flight makes unreachable; `§ tmux recipes` keeps only what a
  message cannot do and the pre-flight cannot prevent.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
