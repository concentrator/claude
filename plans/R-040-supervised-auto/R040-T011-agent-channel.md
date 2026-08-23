---
task: R040-T011
type: feat
depends-on: R040-T002
---

Branch: `feat/agent-channel`.

Wire the operator and the supervisor onto a channel that survives being ignored,
and stop driving sibling sessions with keystrokes. The pilot exchanged everything
by typing into a terminal pane and paid three ways: an escalation printed to
scrollback sat unread for roughly an hour, a blocked supervisor read identically
to a thinking one, and the auto-mode classifier twice refused the injection on a
pattern it had allowed repeatedly in the same session.

This task originally specified building that channel as three files per scope.
Measurement replaced most of it with configuration: `SendMessage` already carries
messages between sessions and, critically, **wakes an idle peer** rather than
merely queueing for one that is already taking turns. The evidence and its limits
are in `R040-T011-agent-channel.findings.md`; the work below is what remains once
they are taken into account.

- [ ] Start the supervisor with `claude --remote-control <name> --permission-mode
      auto` and record the name it takes. Do **not** provision
      `remoteControlAtStartup`: it is honoured only at user scope, and on a worker
      host `~/.claude` is the tracked config repo, so setting it there dirties the
      repo and no gitignored user-scope path is read. The flag is also the better
      shape - only the supervisor joins, under a chosen name, instead of every
      throwaway session on the box.
- [ ] Commit `isolatePeerMachines: true` to the tracked `settings.json`. It has no
      CLI flag, so it must come from user-scope settings, but it is a security
      posture rather than a per-machine choice and the tracked config is its
      correct home. It carries `bypassImmune: true`, so it holds even under
      `bypassPermissions` - which is what makes opening a hardened host to a
      cross-machine channel defensible rather than merely convenient.
- [x] Leave `autoUploadSessions` unset, and say so where the setting is described.
      It mirrors sessions to claude.ai view-only, is not required for Remote
      Control, and is the one setting here with a data-egress consequence.
- [x] Settle the operator end, which is the only remaining blocker for
      cross-machine messaging: a remote-controlled session on the host does not
      appear in the operator's `ListAgents` unless the operator's own session is
      connected too. This is a change to the operator's session exposure and
      routes through claude.ai, so it is a decision to record, not a default to
      set. Note the fallback in the same place: an enabled session prints its own
      `https://claude.ai/code/session_...` URL, so browser and phone control work
      whether or not peer messaging is wired.
- [x] Add `companions/supervisor-runbook.md`, the pilot's operating recipes: the
      per-variant mode and channel table, driving over tmux, reading panes,
      answering permission prompts.
- [x] Reconcile `supervise.md` with what the pilot ran: correct the headless-dispatch
      claim (a headless worker cannot edit protected `.claude/` paths or answer a
      prompt, so a blocked one is dead; both delivered runs were interactive) and
      the prompt-free claim (Bash allow rules match a command prefix, so a compound
      command escalates under any allowlist); point both passages at the runbook,
      and stop restating the merge classes - their one home is
      `declarations.md § Supervisor bounds`.
- [x] Replace the tmux driving idioms in `companions/supervisor-runbook.md` for the
      co-located case, and correct the claim - carried in the runbook, in this
      plan's first draft, and in `supervise.md` - that supervisor-to-worker must
      stay on keystrokes because a session only acts when handed a turn. It does
      not. Keep the tmux recipes for reading a pane and for answering a permission
      prompt, which no message can do.
- [x] Record the instrument, because two obvious ones lie. `claude daemon status`
      reports "not running" while the bridge is active, and the `/remote-control`
      line in the splash is a rotating tip present in neither arm of a comparison.
      The reliable marker is `/rc active` in the footer, and it was only found by
      starting a known-positive session first.
- [x] Add to `skills/worker-host/companions/pitfalls.md`: a fresh directory blocks
      session startup on the trust dialog, which stalled the positive control in
      this task's own measurements until it was answered.
- [x] Add the `GITLAB_HOST` pitfall to `skills/worker-host/companions/pitfalls.md`:
      bare `glab` calls target gitlab.com regardless of which host
      `glab auth status` reports logged in, so a valid token reads as
      "Unauthenticated" - this branch's own key rotation hit it. Every scripted
      call pins `GITLAB_HOST`.
- [ ] Extend `scripts/provision-worker.sh` with a `keys-install` subcommand:
      read both public keys from the VM over IAP, install each on its forge
      through the CLI's API, and retire stale `claude-worker` keys - a key left
      by a previous host is standing access for a machine that no longer
      exists, and nothing else removes it. Operator-side, `--dry-run`,
      idempotent, TDD; the skill table, `companions/provisioning.md` step 5 and
      the operator-only list follow.
- [ ] Complete the branch: gates green, mark this plan's checkboxes, and route what
      the build turns up. Closure is checkbox-only; R040-T011 does not close R-040.

Relation to `R040-T003`: that task carries the remote transport for a worker on a
different machine. This one settles the operator-to-supervisor link and the
co-located supervisor-to-worker link, which between them are the arrangement the
pilot actually ran. Its `ssh <target>` framing should be re-read against these
findings before it is executed - a peer message that wakes an idle session is a
different mechanism from a shell over ssh, and may make most of T003 unnecessary
too.
