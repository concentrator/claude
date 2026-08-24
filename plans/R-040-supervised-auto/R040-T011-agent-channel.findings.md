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
  worker's reply reaches the supervisor. The live run advanced this without
  closing it - the supervisor sent the worker a message and the worker acted on
  it, so the forward leg carries content, but no reply text was observed
  arriving back at the supervisor.
- The operator leg has no transport at all, and a real escalation proved it. Held
  on a design question, the supervisor armed a prompt-only heartbeat, correctly,
  since a timer poll would only spin while the worker is idle by instruction. The
  consequence is that nothing on the host resumes the run: the escalation reached
  the operator by being scraped out of a pane, and the ruling can only return by
  an operator typing it back in. Four consecutive reads showed the same heartbeat
  id, so the session had not woken once in forty minutes and would not have woken
  on its own however long the hold ran. A supervisor that can block on an
  operator needs an addressable inbox for the answer, or the loop's slowest leg
  stays a human reading scrollback.

## From the first remote-transport batch

R-020 B-002 on the worker host, the first batch delivered under the remote
transport with the supervisor driving the worker itself and the operator
watching on a fixed interval. Everything below was read from the two panes or
from read-only refs while the run was live, which is why the failures are
described by their symptom in a pane rather than by a log line.

### The channel is the failure surface

- [x] **A supervisor that polls a pane loses its worker, and did so three
      times by three unrelated routes.** First a readiness wait on
      `"for shortcuts\|Welcome\|>"`, none of which a fresh pane contains: the
      splash carries no "Welcome", `grep -c "for shortcuts"` returns 0, and the
      prompt glyph is `❯`, not ASCII `>`. Then an idle wait that could not
      exit because `capture-pane` returns the whole pane including a stale
      `Waiting for 1 background agent` line, so a worker sitting on a
      permission prompt read as busy; measured at the time with per-pattern
      counts, `esc to interrupt` 0, spinner 0, stale line 1. Then simply
      finishing a turn with no wait armed at all. Each one stalled the batch
      until the operator woke the supervisor by hand.
      The three share a cause worth stating plainly: polling puts the burden of
      noticing on the party that is not doing the work. A blocked worker is
      indistinguishable from a working one in a pane, which is the claim this
      task was opened on, now reproduced under load rather than argued.

- [x] **Pane polling spends the supervisor's context, and the design assumes
      it stays small.** `supervise.md § Monitor` keeps the supervisor at
      report level so one session can span many workers. Two hours in it was
      at 12% before auto-compact, and not from reports: from `capture-pane`
      output, one screenful per check, plus the pane dumps its
      prompt-clearing needed. A message costs a sentence; a pane costs a
      screen. Same cause as the visibility failures above, different symptom.

- [x] **A prompt-clearing script replaces judgement with pattern matching, and
      approved a protected-path edit.** The supervisor wrote
      `clear-prompts.sh`, intending it to fail closed: a DANGER regex stops the
      loop, a read-only whitelist clears the prompt, anything unrecognised
      stops. Its command extractor resets its buffer on a `Bash command`
      header, so an **Edit** prompt, which has no such header, accumulated 400
      lines of unrelated scrollback; the whitelist matched a `grep` from that
      scrollback and approved a request to edit `skills/dev/layout.md`, which
      `declarations.md § Supervisor bounds` escalates under any grant. Nothing
      persisted - the config clone stayed clean at its HEAD - so the breach was
      of authorisation, not of content.
      The general shape: a fail-closed policy implemented by parsing fails open
      on exactly the input its parser does not model, and an auto-approval is
      indistinguishable in the pane from a considered one.

### Blockers the host still carries

- [x] **A third startup dialog blocks a session before its prompt line.** The
      fullscreen-renderer opt-in holds a fresh session the same way the trust
      and auto-mode dialogs do, and is in neither `pitfalls.md` nor the keys
      `worker-workspace.sh settings` writes. Answered "Not now" deliberately:
      the renderer would likely break the `capture-pane` reads the whole
      operator loop depends on. Any future opt-in dialog becomes a headless
      startup hang by default, which is the entry worth writing rather than
      this one dialog.

- [x] **`glab` held no host entry for the project's forge, so the batch could
      not have opened its MR.** Cleared by hand before dispatch and filed as
      `R040-T016`: `forge_auth` never runs the `glab auth login` its own
      `--dry-run` text promises, and verifies with an explicit `--hostname`,
      which is the one check shape that cannot detect the omission.

- [x] **No git author identity exists on the host, and commits succeed
      anyway.** No `/etc/gitconfig`, no `~/.gitconfig`, no global config, no
      repo-local `[user]`, no `GIT_AUTHOR_*` export - yet the first commit
      carries the correct author. The implementer supplied it per invocation by
      inference. It was right this time; nothing makes that repeatable, and
      because nothing halts, no run surfaces it.
      Fix belongs in provisioning: `baseline` sets it from the same gitignored
      `.env` that carries the forge tokens, keeping identity something the
      operator moves rather than an agent decides.

- [x] **Every implementer stalls on reading the declared sibling
      dependency.** `pitfalls.md` already records that `wallarm-api-js` is not
      optional, but the project's permission list grants it as an npm
      dependency and never as a readable path, so each agent prompts for it.
      The supervisor correctly declined the offered persistent grant, since a
      settings change is outside batch-scoped delivery, and named the cost:
      the prompt recurs per agent. Each recurrence needs an awake supervisor,
      which compounds the visibility failures above.

### What held under load

- [x] **The supervisor reached the worker with `SendMessage` unprompted.** Not
      instructed to; it addressed the worker as a peer session and the worker
      acted on the message. The settled finding at the top of this file,
      arrived at again independently by the party doing the work.

- [x] **The capacity fallback carried the run instead of halting it.** Two
      consecutive 529s on the pinned implementer degraded one row to Sonnet
      with the substitution recorded; the Fable window was exhausted for every
      verification role for the whole batch, also recorded. Legal under
      `verification-policy.md § Models`, and direct evidence for `R040-T015`:
      the fallback is the normal case here, not the exception, which is the
      argument for checking the quota before dispatch rather than discovering
      it per failure.

- [x] **Bounds discipline held where it cost something.** Offered a persistent
      permission grant that would have removed a recurring prompt, the
      supervisor took the one-time approval and said why: persisting a scope is
      a settings change and no grant of its own covers editing permissions.
      It also declined to treat an observed commit id as final because the
      fixup agent had not reported, and said it would re-verify ids at the
      checkpoint.

- [x] **Verification checked artifacts, not claims.** Item 3's spec check ran
      structure assertions against the committed blob - heading set, mermaid
      block, verified marks, em dashes - rather than against the implementer's
      summary, and checkers were told to return UNPROVEN per limb rather than
      pass softly. `verification-policy.md`'s unit-of-check and discrimination
      rules, applied without being restated at dispatch.

- [x] **Scope discipline held on a real temptation.** A broken sibling-relative
      link turned up in a file outside both members' corpus; the worker routed
      it to the whole-catalog gate task instead of fixing it under a task that
      forbids out-of-corpus changes. `git diff --name-only` against the anchor
      showed `dev/docs` and nothing else for the whole run.

- [x] **A woken session in `auto` mode completes shell actions unattended.**
      Open in this file until now. The supervisor ran its entire monitoring and
      prompt-clearing loop this way, including sending keys to another session,
      with no operator turn between wake and action.

- [x] **File-backed state survives compaction; context-held state does not.**
      The worker moved its decision ledger to a scratchpad file and ticked plan
      checkboxes as it went, then compacted mid-batch and resumed on the
      correct item. The supervisor held its ledger in context and approached
      compaction with it. Routed to `R040-T017`.

- [x] **A hold held, in both directions.** With the batch stopped on a
      design-level escalation, the worker proposed widening the realign into
      `checks.js` and the supervisor refused it as source work the batch has no
      approval for. It then told the worker to stand by rather than look for
      more to verify, which is the harder half: an idle agent under a hold
      invents work, and that work lands outside the scope the hold exists to
      protect. Neither role treated the pause as licence to make progress
      somewhere else.
      It also drew a line worth keeping: it authorised a write, not a commit,
      so the item's findings file sits untracked and folds into the closing
      commit. Untracked is a real loss path if a branch closes over it, and the
      supervisor recorded it as a checkpoint obligation rather than trusting it
      to memory.

- [x] **An escalation that carries its own measurement step arrives at a
      sharper question than it left with.** The supervisor did not just hold: it
      told the operator what it would measure while held, then partitioned the
      affected cells by whether the later verification pass could lift each one.
      The count came back lower than its first figure and every remaining cell
      turned out liftable, which moved the question from a permanent gap in the
      vocabulary to whether a guaranteed-temporary state needs a token at all.
      Same decision, far cheaper to make, and the revised figure is the one in
      the report.
      Worth making a habit rather than an accident: an escalation names the
      measurement that would narrow it, and holding time pays for that
      measurement instead of being dead time. The operator-facing cost is that
      the second version supersedes the first, so a relayed figure has to be
      restated rather than left standing.

- [x] **Both roles caught their own crude measurements, unprompted.** In one
      tick the supervisor corrected its own `grep -c` count of precedent cells
      from 19 to 17, naming the two prose uses that inflated it and crediting
      the worker's count over its own; the worker then recounted its 16 on the
      same grounds, and re-ran twelve probes untruncated after realising it had
      described clipped 60-70 character error strings to the supervisor as
      exact. That is `verification-policy.md`'s discrimination rule applied by
      the roles to themselves, against their own reported figures, with no
      operator turn involved.

### Operator error, recorded because the loop should prevent it

- [x] **The dispatch briefing restated merge authority and narrowed it.** The
      supervisor was told to escalate "anything design-level or the merge
      itself" while operating under a declaration granting green batch MRs.
      `supervise.md § Merge or escalate` refuses to restate the merge classes
      for exactly this reason, calling a partial copy the way a supervisor
      comes to believe a class it holds does not exist. The briefing was that
      partial copy. Confirmed live: the supervisor stated it would hold the
      merge.
      A briefing template that summarises authority will keep drifting from the
      declaration that owns it. It should cite instead.

### Throughput

- [x] **First item 50 minutes, steady state about 10.** Three items closed in
      the first hour and fifty minutes, with the first carrying two 529s, a
      model substitution and a rejection round. Rate matters to the channel
      argument: at ten minutes an item a supervisor that loses sight of a
      blocked worker costs a fraction of an item, and at fifty it costs hours.
      The rejection round was not waste - it caught the defect its blocking
      task had been merged to prevent.

### The role whose state the checkpoint reads keeps the least of it

- [x] **The supervisor's ledger survived only because an operator intervened
      one minute before compaction.** The worker had moved its ledger to a file
      early and came back from its own compaction on the correct item. The
      supervisor, whose state the checkpoint actually reads, held its ledger in
      context and ran to 0% remaining. Told to write it out, it produced a
      201-line `supervisor-ledger.md` in its own scratchpad, outside the
      worker's checkout, and compaction began immediately after.
      Two things follow. The asymmetry is backwards: the role with the least
      durable state is the one the merge decision depends on. And the save was
      operator-triggered, so on an unattended run the ledger goes with the
      compaction and no one learns it was lost, because a compacted supervisor
      still answers status questions plausibly.
      Writing outside the checkout is not a detail: a state file in the project
      would break the `git status` scope check the worker uses to prove its
      edits stayed in `dev/docs`, so the two roles cannot share a directory for
      this.

- [x] **Reports drift from the artifacts they describe; artifacts do not.**
      Three instances in one batch: a reviewer caught two arithmetic errors
      present in an implementer's report but absent from the doc it described,
      and a commit body was written "from memory of the work instead of from the
      code". Every spec check in this run was told to verify against source for
      this reason, and each time the artifact was the reliable party.
      This is `verification-policy.md`'s unit-of-check rule with instances
      behind it rather than an argument.

- [ ] **No diagram in the batch was machine-verified, and a member's acceptance
      criterion may require it.** No mermaid tooling is installed on the host,
      so every Model diagram was eye-reviewed. The worker declined to install a
      renderer, on the grounds that adding a browser dependency to a docs-only
      batch is not its call, and recommended routing machine-parsing onward.
      Correct to escalate: `supervise.md § Boundary verification` step 2 needs
      the report to verify each member's criteria, and a criterion no tool
      checked cannot be reported as verified.
      The premise deserves a test before the routing is accepted. A full render
      needs a headless browser; a syntax-level parse may not, and if it does
      not, the criterion is satisfiable in this batch rather than deferred.
      Unresolved at the time of writing.

- [x] **A conflict between two rails is a routing decision, and the supervisor
      surfaced one without blocking on it.** A realigned doc duplicated nine
      values from a doc not yet realigned, putting the member's "a realign
      deletes no claim" against `writing.md § One home per number`. It routed
      the resolution to the later commit that has both docs in view, required
      that commit to rule explicitly, deleted nothing unilaterally, and offered
      the operator the alternative. Worth recording as the shape a
      near-design-level call should take: decide, name the alternative,
      continue.

- [x] **Every commit in the batch was amended once, and three of the four
      amends changed the document.** Measured from the member branch's reflog:
      each item was committed, reviewed, then amended. All four amends rewrote
      the commit message; three of those also edited the doc, the first item's
      by 86 insertions and 36 deletions. So the review round is not a formality
      that rewords commit bodies: it does rewrite every message, and on three
      items out of four it also supplies doc content, the first item's about a
      third of the file. It fires on every item rather than occasionally.
      After item 4 the supervisor added a pre-commit pass that verifies each
      claim against source. Across the two items that followed, one committed
      clean and one still took an amend, so the rate went from four of four to
      one of two. That is not evidence the round was removed, and an earlier
      reading of this file said it was: item 6 was measured before its amend
      landed, which is the same mistake as reading a pane mid-write.
      What the run has actually shown is narrower. Five of the first six items
      needed an amend, every amend rewrote the commit message, and most also
      changed the doc, so the round is a near-fixed cost per item. Whether
      moving verification ahead of the commit reduces it is still open, and one
      clean item out of two is too thin to answer either way. It stays worth
      testing because the cost is real, not because this run settled it.
      History rewriting was safe here only because nothing was pushed.

- [x] **The worker's account of its own amends inverts them, in the direction
      that makes the review round look cosmetic.** Its pane states that in all
      three amendments the doc was right and only the commit message was wrong.
      The refs say the opposite: the three amends it is describing each edited
      the doc, and the single message-only amend is the one it leaves out of the
      count. Verified by naming the changed path in each amend, not by trusting
      either account.
      The direction is what makes this more than a slip. A supervisor that takes
      this at report level records a review round that fixes commit bodies,
      when what it actually does is supply doc content, and the checkpoint then
      certifies the weaker claim. It is the same failure the entry above
      describes, caught this time in the worker's reasoning about commits it had
      just made rather than in a report about older work, which is the strongest
      case yet for `verification-policy.md`'s rule that a check counts the unit
      of the thing it claims to check.
      The supervisor then adopted the worker's framing, calling the defect "the
      three false commit bodies" one tick later, and built its remediation on
      that reading. The remediation is sound anyway - a pre-commit pass that
      verifies each claim against source, which catches a wrong doc as readily
      as a wrong message - but it was chosen from a diagnosis the refs do not
      support, and the count it names is short by one.
      That is the transmission path worth fixing, not the arithmetic: a
      worker's characterisation of its own work reached the checkpoint's
      reasoning without ever being checked against the commits it described.

### Routed out of this file

- [ ] `R040-T017` - durable role state. Drafted, not yet filed.
- [ ] The worker-side notification hook: a blocked worker wakes its supervisor
      rather than waiting to be noticed. This is what the channel should be,
      and it replaces every wait recipe below.
- [ ] Replace the runbook's wait recipes: footer-only busy detection, an
      affirmative wake on a pending prompt, and a hard `timeout` on every loop.
      Provisional until the notification hook lands, which removes the need.
- [ ] Take a position on prompt-clearing scripts at all. If permitted, classify
      the prompt type before parsing any command, and stop unconditionally on a
      protected-path edit.
- [ ] `pitfalls.md`: the fullscreen-renderer dialog, and the general rule that
      a new opt-in dialog is a headless startup hang.
- [ ] Provisioning sets `git config --global user.name/user.email` from `.env`,
      documented in `.env.example`.
- [ ] The project's permission list grants reading the declared sibling
      repository.
- [ ] The briefing recipe cites the declaration rather than summarising it.
