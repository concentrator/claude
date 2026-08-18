# R040-T011 findings - the agent channel

Every item below was verified by running it; the method is stated so a later
reader can re-run rather than trust.

## What is settled

- [x] **`SendMessage` wakes an idle machine-local peer session.** It does not
      merely queue for a session that is already taking turns. Verified on the
      worker host: the worker sat idle at its prompt, the supervisor sent it a
      message, and with no keystroke from anyone the worker reasoned about the
      message and issued the exact command it was asked for. Read in the
      worker's own pane, not taken from the supervisor's report.
      This falsifies the claim, written in three places, that
      supervisor-to-worker must stay on tmux keystrokes because a session only
      acts when handed a turn. For the co-located case it does not.

- [x] **A wake is not a completed action.** The woken worker stopped on a
      permission prompt, because it runs in accept-edits and the probe was a
      shell write. Delivery and the recipient's ability to act are separate
      properties, and a probe that conflates them lies. The probe for a wake
      must be permission-free.
      This defect was in the test design, authored here: had the supervisor
      reported only its poll result, it would have concluded the channel does
      not work and the wrong thing would have been built.

- [x] **Cross-machine peer messaging needs Remote Control at BOTH ends.** A
      session on the worker host running with `--remote-control` did not appear
      in `ListAgents` from the operator's laptop, because the laptop session is
      not itself connected. The settings key `isolatePeerMachines` is the proof
      the path exists at all: "Require explicit approval before SendMessage can
      reach a peer session on another machine via Remote Control."

- [x] **`remoteControlAtStartup` is user-scope only.** Measured with three arms
      against a known-positive control: the key works in
      `~/.claude/settings.json`, is ignored in a project
      `.claude/settings.local.json`, and `~/.claude/settings.local.json` is
      gitignored but never read. On the worker host `~/.claude` IS the tracked
      config repo, so there is no gitignored user-scope path for it.
      Consequence: do not provision the key. Use the launch flag instead, which
      is better anyway - only the supervisor joins, under a chosen name, rather
      than every throwaway session on the box.

- [x] **The only reliable instrument is the `/rc active` footer marker.** An
      enabled session also prints `/remote-control is active` and its own
      `https://claude.ai/code/session_...` URL. Two other candidates give
      confident wrong answers: `claude daemon status` reports "not running"
      while the bridge is plainly active (the daemon serves background
      sessions, not an interactive bridge), and the `/remote-control` hint in
      the splash is a rotating tip, absent from both arms of a comparison.
      The marker was only found by starting a known-positive session first.

- [x] **Remote Control does not change billing.** The host authenticates with
      `claudeAiOauth`, `subscriptionType=team`, scope `user:inference`, and
      carries no API key in the environment, rc files or `.env`. Remote Control
      is a control plane: the session keeps running on the VM under its own
      credentials. The grant already includes `user:sessions:claude_code`, so
      no new scope is needed. What would change billing is a different
      mechanism - cloud-hosted sessions or Managed Agents.

- [x] **No network or hardening change.** The bridge dials out, so ingress
      stays denied, IAP remains the only inbound path, and the nftables ruleset
      already runs `policy accept` on output. No package either: `remote-control`
      is a subcommand of the installed binary.

## What this does to the task

The three-file inbox/outbox/status channel this task originally specified is
**not needed for the co-located case**, which is the arrangement the pilot ran.
`SendMessage` already does it, with delivery semantics a file cannot match.
What remains is configuration plus one decision.

- [ ] Change the supervisor launch line to
      `claude --remote-control supervisor --permission-mode auto`, in
      `companions/supervisor-runbook.md` and wherever the host scripts start it.
      Nothing else on the host changes.
- [ ] Commit `isolatePeerMachines: true` to the tracked `~/.claude/settings.json`.
      It has no CLI flag, so it must come from user-scope settings - but it is a
      security posture rather than a machine-specific choice, so the tracked
      config is its correct home, not a provisioning hack. It carries
      `bypassImmune: true`, so it holds even under `bypassPermissions`.
- [ ] Leave `autoUploadSessions` unset. It mirrors sessions to claude.ai
      view-only, is not required, and is the setting that carries a data-egress
      consequence.
- [ ] Decide, and record, whether the operator's own session joins Remote
      Control. This is the only remaining blocker for cross-machine
      `SendMessage`, it is a change to the operator's session exposure, and it
      routes through claude.ai. The browser and phone path works without it -
      an enabled session prints its own URL - so peer messaging is a
      convenience over that, not the only route.
- [ ] Correct the falsified keystroke claim in `companions/supervisor-runbook.md`
      (the mode table and the driving-over-tmux section) and in this task's own
      plan. `supervise.md` was already corrected on `doc/supervisor-runbook`
      for a different reason and should be re-read for this one.
- [ ] Add a pitfalls entry: a fresh directory blocks session startup on the
      trust dialog, which stalled the positive control until answered.

## Open, not settled

- The wake could not be timed. The prompt was already pending at first read, so
  all that can be said is under 90 seconds; the documented semantics
  ("messages drain at the receiver's next tool round") suggest near-immediate.
- The return leg was authorised but its result was not read back: whether the
  worker's reply reaches the supervisor.
- Whether a woken session in `auto` mode completes a shell action unattended,
  which is the combination a real dispatch would use. The wake test used a
  worker in accept-edits, which is why it stopped.
