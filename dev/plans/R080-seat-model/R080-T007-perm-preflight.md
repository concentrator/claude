---
task: R080-T007
type: mnt
depends-on: R080-T004
supervised: approved
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
  its tool set (the seat's agent definition under `agents/` lists the
  tools it may use; the run has one permission mode, the runner's,
  which every dispatched seat inherits) and the allow rules its
  commands need, each rule traced to the seat prompt or the toolchain
  declaration that needs it. A toolchain rule derives as
  `Bash(<prefix>:*)`, the prefix being the declared command up to its
  first placeholder. `auto-permissions.template.json` becomes
  `seat-permissions.template.json`, the rules' machine-readable form
  grouped by seat.
- [ ] `scripts/dev/preflight-permissions.sh`: given a project path and
  a supervisor mode (`human` or `AI`, selecting which seats the run
  dispatches), resolves every seat's set against the tracked tiers
  (user-global `settings.json`, project `.claude/settings.json`) - a
  `Bash` prefix rule is satisfied by a tracked rule whose prefix
  covers it, every other rule by an exact match - and prints one
  report: applied, already present, cannot apply. Without `--apply`
  it only reports; with it, it writes the missing allow rules to the
  project's `.claude/settings.local.json`, preserving the file's other
  keys. Cannot apply, exiting non-zero: a needed rule a tracked tier
  denies (a blanket push deny under `companions/toolchain.md
  § Permission carve-out` with a seat that pushes retires that
  pattern's hand-approval), a tier it cannot write, a missing
  `.claude/` directory. A deny rule is never touched and
  `bypassPermissions` never written. Test in
  `scripts/test/preflight-permissions.test.sh` with fixture trees
  under `mktemp -d` and the user tier path taken from an environment
  variable: a full set passes, a missing rule is written, a covered
  prefix is not rewritten, an unwritable tier is reported and stops
  the run, a deny is left alone.
- [ ] `run.md § Pre-flight`: the runner runs the script in report
  mode before the first dispatch and its report is the pre-flight's;
  a gap stops the run and prints the `--apply` command for the user to
  run, since the `.claude/` guard is a host gate no seat clears. The
  prose permission checks inherited from `auto.md` go, and so does the
  `supervise.md § Dispatch` sentence making prompt clearing the
  supervisor's work. The compound-command rule: a seat's commands are
  shaped to match a declared prefix (no loops, pipelines or `case`
  where a prefix rule must match), so the set predicts every prompt; a
  prompt outside it is recorded in the run's ledger (`run.md
  § Ledger`) as a pre-flight defect and fixed in
  `seat-permissions.md`. `companions/toolchain.md`'s carve-out and
  pre-flight paragraphs re-point to the script.
- [ ] `companions/supervisor-runbook.md`: `§ Two variants` drops the
  who-clears-prompts row in favour of `run.md § Seats` and the
  pre-flight; `§ Modes` cites `seat-permissions.md`; `§ Failure modes`
  keeps the classifier entries and drops every keystroke entry,
  `Keystroke authority` included - a prompt in any seat, the
  supervisor's own too, halts the run as a defect instead of being
  keyed past; `§ tmux recipes` keeps the pane-read and until-loop
  recipes and drops the send-keys ones.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
