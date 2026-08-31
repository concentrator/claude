---
task: R040-T026
type: test
depends-on: R040-T022
supervised: approved 2026-08-31
---

Branch: `test/two-project-run`.

Acceptance criterion 9 of `requirements.md` has a model behind it and
no run: attack-checker and fp-remedy were each supervised in their own
session, never two under one operator. This run puts one AI operator -
this session, on the operator's machine, `--permission-mode auto` -
over two supervisor + worker pairs on the worker host `claude-worker`
(35.246.88.227, `companions/supervisor-runbook.md § Variant B`): aikido
delivering `R017-T004` and wallarm-api-js delivering `R017` whole. Both
projects declare `Operator mode: AI operated` and carry
`supervised: approved` plans. The human does Variant B steps 1-3 for
each project; the operator briefs, decides and answers from here.

## Commits

- [ ] `companions/supervisor-runbook.md`: Variant B with two pairs on
  one host and the operator's seat off-host - `tmux` and Remote
  Control names carry the project (`supervisor-<project>`,
  `worker-<project>`) and the recipes target by that name; no
  operator `tmux` session on the host - the operator's own session
  joins Remote Control from its machine, adopts every supervisor by
  name over `ListAgents`, and each cross-machine send clears the
  `isolatePeerMachines` approval (§ Remote Control). Step 1's
  "steps 1-3 are theirs" holds per project.
- [ ] Host readiness, recorded in
  `R040-T026-two-project-run.findings.md` with the commands run and
  their result: `~/.claude` on the host pulled to `main`; aikido
  cloned by `scripts/worker-workspace.sh project-clone` (its sibling
  handling probed first - aikido has none); `settings.local.json`
  written for aikido and wallarm-api-js by the `settings` subcommand;
  then, per project, every command the run is known to need - the
  `CLAUDE.md § Agent toolchain` commands, the worker's git cycle
  through the push of its own branch prefix, `glab mr create` and
  `glab mr view` - matched against the merged allow rules, so a known
  command never prompts the worker; a miss lands in
  `settings.local.json` before any supervisor starts (raised by the
  aikido allow-list, which grants npm, `node --test` and three glab
  verbs but no git); wallarm-api-js pulled after the user's own task
  lands; no stale
  `tmux` session; each project's gates green on the host; this
  session's Remote Control join confirmed (`/rc active`), or the run
  restarted from a session launched `--remote-control operator` after
  a hand-off note (`handoff.md`).
- [ ] The run: the human starts `supervisor-aikido` and
  `supervisor-wallarm-api-js` on the host (Variant B steps 1-3); this
  session briefs each in one message (step 4: scope, branch plan
  path, worker start command, pointer to `declarations.md
  § Supervisor bounds`), decides every handed-over MR with local
  `glab`, answers implementation-level escalations, raises the rest
  to the human. Evidence into the findings file: per project,
  `glab mr list --label supervised --merged`, the operator's merge
  comments, the ledger `dev/supervisor/<scope>.md`, and every
  escalation with who ruled on it.
- [ ] Closure: criterion 9 `[x]` with that evidence, `status: done`
  in `requirements.md`, R-040 `[x]` in `ROADMAP.md`; a finding that
  changes a rule goes to the owning artifact, one that does not stays
  in the findings file.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
