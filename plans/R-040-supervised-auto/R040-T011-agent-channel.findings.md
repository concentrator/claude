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
- The operator's two legs are not equally served, and a real escalation
  separated them. Inbound works: the operator answered the escalation directly
  into the supervisor from the Claude app over Remote Control, and the session
  woke, ruled, closed the question and dispatched the next item without the
  watching session relaying anything. Outbound is the weak leg. The escalation
  itself only left the host because a watcher scraped it out of a pane, and
  while it sat there the supervisor's heartbeat expired, reported no change and
  re-armed - alive and aware, achieving nothing but confirming the hold. So the
  gap to close is notification, not control: an operator who can reach a held
  session still has no way to learn it is held.
  The outbound leg then failed on its own account. One tick's `capture-pane`
  read over the IAP tunnel took about thirty-five minutes to execute: the
  command was dispatched at one time and the host clock inside its own output
  showed another. Nothing was wrong on the host, and the panes were unchanged
  when it landed, so the stall cost no state - but for that half hour the
  operator could not have distinguished a stalled run from a stalled read, and
  the only instrument for telling them apart is the one that stalled.
  Two reading errors of this file's own, both worth keeping. Four consecutive
  reads showing one heartbeat id were reads taken between expiries, and an
  earlier version called that a session that never wakes - the same stale-read
  error the file records against the pane transport, committed while describing
  it. And an earlier version claimed the operator leg had no transport at all,
  written before the operator used it.

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
      Landed, and the shape it took answers a question the entry did not ask.
      `worker-credentials.sh git_identity` requires both `GIT_USER_NAME` and
      `GIT_USER_EMAIL` and refuses to proceed without them, which converts the
      silent case above into a halt at provisioning rather than at the first
      commit. Beyond that it sets a second identity: `committer.*`, which git
      honours as config keys independently of `user.*`, so the author stays the
      human whose work it is and the committer records how it was applied. A
      host that exists to run supervised delivery has that fact to state about
      every commit on it, and prose is the wrong place - `git log --author`,
      shortlog and blame keep answering about the human either way.
      Recorded as a rule in `declarations.md § Supervision signature`, which now
      covers both metadata carriers, the merge label and the committer, and
      excludes supervision from commit and MR/PR prose entirely. The thirteen
      commits written before the identity existed were retrofitted on the
      operator's ruling, by the supervisor, since a history rewrite in the
      worker's checkout is its operation and not the watcher's.

- [x] **Every implementer stalls on reading the declared sibling
      dependency.** `pitfalls.md` already records that `wallarm-api-js` is not
      optional, but the project's permission list grants it as an npm
      dependency and never as a readable path, so each agent prompts for it.
      The supervisor correctly declined the offered persistent grant, since a
      settings change is outside batch-scoped delivery, and named the cost:
      the prompt recurs per agent. Each recurrence needs an awake supervisor,
      which compounds the visibility failures above.

- [x] **The worker's unattended-halt surface is Bash classification, not
      edits.** Inside one item the worker held twice on its own permission
      dialog, ten minutes apart, on two differently shaped commands doing the
      same job: an existence probe over sibling-relative doc links, refused as
      `Contains simple_expansion`, and a three-shape negative-claim sweep over
      the eight realigned docs, refused as `Brace expansion`. Both were
      read-only. `acceptEdits` names edits and covers only edits, so every
      shell command a worker runs goes to the auto classifier, and the mode's
      name advertises a coverage it does not have.
      Two properties make this worse than the sibling-path prompt above.
      Avoiding one refused shape does not clear the class - the second command
      was rewritten and refused for a different reason. And a wider allowlist
      is not the fix, because a loop over an expanded variable has no stable
      pattern to grant.
      The loop does have a resolver, and it is the supervisor. Its ledger
      records thirty-three numbered prompts cleared by hand over the run, each
      classified by kind - read-only greps over `dev/docs/`, verifier subagent
      greps, `node` scratchpad executions against a declared `Bash(node *)` -
      and each with a stated policy: take the one-shot option, never the
      persistent one. Two sibling-repo offers of a standing read grant were
      declined on exactly that ground and cleared one-shot instead, with a note
      to surface it as a scope decision if it recurred. So a worker's dialog is
      not outside the loop's reach; clearing it is routine supervisor work,
      including the third occurrence here, which a subagent raised while the
      worker sat on "Waiting for 3 background agents to finish" and could not
      have answered anything.
      What stopped the run was turn discipline, and the supervisor's own
      account is more precise than anything the panes showed. Its wait loop did
      detect the dialog and printed `PROMPT`; it then appended its ledger entry
      and ended the turn without ever reading that output. Three dialogs had
      stacked up behind the first by the time it resumed, so the queue, not the
      dialog, was the object needing draining. From there the state was stable:
      a worker waiting on a dialog only the supervisor clears, a supervisor
      idle waiting on the worker, a held worker unable to send the message that
      would wake it, and compaction passing through without starting a turn.
      The detector worked and its output went unread, which is the same failure
      as the escalation that sat in scrollback for an hour, one layer further
      in.
      One message ended it. Pasted into the idle supervisor after about seven
      and a half hours, it cleared the worker's dialog inside a minute, went
      back to reading `layout.md` for item 9, and started polling the worker's
      pane on its own initiative - "I am watching your pane continuously now."
      Nothing was repaired and nothing was granted. The pair simply needed a
      turn started from outside itself.
      That makes the failure a liveness property of the pair rather than a
      missing capability, and it changes the fix. Neither a constraint on probe
      shape nor a wider Bash grant addresses it: both reduce how often dialogs
      appear, and the deadlock needs only one to appear at the wrong moment.
      What closes it is a wake path that does not depend on the held role
      taking a turn.
      The same state then recurred and cleared itself, which is the closest
      thing to a controlled test the run produced. About eight hours later the
      supervisor auto-compacted while the worker held a dialog, the exact
      sequence its own account blames. It came back, read its wait output
      first, drained nine dialogs, re-armed the wait and reported item 9's
      progress, all inside one tick. What changed between the two occurrences
      is three invariants the supervisor adopted and wrote down: read the wait
      output before any other work on every notification, never end a turn
      waiting on the worker without a fresh `capture-pane` showing no dialog
      pends, and drain the queue rather than one dialog. They are turn
      discipline rather than capability, they held through the one event most
      likely to break them, and they are what the runbook should carry.
      `R040-T014` owns the edit gate under `acceptEdits`; this is the same
      assumption failing on the other tool, and would be helped by either a
      constraint on probe shape in the dispatch text or a declared Bash surface
      for workers - both of which lower the prompt rate without closing the
      deadlock above.
      The subagent case narrows the options further: probe shape can be
      dispatched to a worker and cannot be dispatched to the agents that worker
      spawns, so a prompt-level constraint does not reach where the third halt
      happened.

### Composed but unsent reads exactly like sent

- [x] **The pane cannot distinguish text typed into an input box from text
      delivered.** Three instances: `check the verifier partial output files`
      in the worker's box, then `keep going` and
      `Retrofit the 13 commits before you push.` in the supervisor's. The last
      one cost a stall. The supervisor had ended its turn saying the retrofit
      call was the operator's; an instruction answering it sat in its own input
      box, unsubmitted; and the worker waited on a dialog only the supervisor
      clears. Two consecutive ticks came back byte-identical, which is what
      distinguished a stall from a long turn.
      The hazard compounds on the way out. Typing a message into that box
      appends to whatever is already there, so delivering anything would have
      submitted the pending line as part of it - an instruction that could not
      be attributed, authorising a thirteen-commit history rewrite. The box had
      to be emptied first, and `C-u` is not bound: `End` followed by enough
      `BSpace` is what clears it. A transport whose write path silently
      concatenates with unattributable text is the strongest argument in this
      file for not typing into panes at all.
      A clear does not stay cleared, either. The same line was pending again at
      the next read, after a clear verified by `capture-pane`, and nothing in
      the pane says whether it was restored as a draft or retyped. That is the
      property that matters: the box's contents cannot be established once and
      relied on, so every write to it has to re-read and re-clear immediately
      beforehand, and a channel needing that is not a channel.

- [x] **`SendMessage` reaches peers within one machine's namespace, and the
      operator is outside it.** The settled finding at the top of this file -
      that the channel already exists and wakes an idle peer - held for the
      supervisor and worker, which are sessions on the same host and messaged
      each other by name all run. It does not extend to the watcher. From the
      operator's machine `ListAgents` lists local peers and nothing on the
      worker host, so the one role that most needed a wake path had only tmux,
      which is why every operator intervention this run went through
      `send-keys` and inherited the hazard above.
      That answers the open question of whether the operator's session joins:
      it must, or the remote transport keeps a keystroke channel on its most
      consequential leg. It also bounds the earlier claim. `SendMessage` closes
      the supervisor-worker deadlock and does not close the operator-supervisor
      one, and the two were being treated as the same finding.

### What held under load

- [x] **The supervisor reached the worker with `SendMessage` unprompted.** Not
      instructed to; it addressed the worker as a peer session and the worker
      acted on the message. The settled finding at the top of this file,
      arrived at again independently by the party doing the work.

- [x] **The pair settled an authority question against the party that raised
      it, without the operator.** The supervisor wrote a script to clear the
      worker's Bash dialogs, guarded to halt rather than clear on any
      persistent-scope offer, any edit-class dialog, and any command touching
      settings, conventions, `git commit/push/merge` or the forge CLI. The
      worker objected on the one ground that holds: a permission dialog in its
      pane is the operator's decision point, and a peer clearing it substitutes
      its own judgment for theirs. It also produced the supervisor's own two
      rulings from earlier in the run, both of which had told it that a prompt
      is correct rather than a thing to engineer around.
      The supervisor had a defensible reading available - its brief says to
      clear the worker's prompts over tmux, and the operator's later
      instruction not to clear protected-path edits by script presupposes
      script-clearing and carves out one class. It declined to use it, on the
      ground that reasoning of the form "the rule says X, but Y is fine here
      because" is the rationalisation its own conventions name. The automation
      was downgraded to detect-only inside one turn: the wait watches the pane
      and wakes the supervisor, and every clear from there is by hand after
      reading the command.
      Two things make this worth keeping. The deadlock fix survived the
      retraction, because the objectionable part was the keystroke and not the
      watching. And the five dialogs the script had already cleared were
      audited on the spot against the criteria they might have carried, found
      to be read-only verifier probes, and declared in the report rather than
      left implicit - the pair's own answer to the question an auditor would
      ask next. The escalation the supervisor then raised asks the operator to
      rule on the mechanism, not to unblock the run, which is the distinction
      the escalation list exists to draw.

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

- [x] **Escalating was right; halting the whole batch was not, and the
      supervisor said so itself.** The ruling came back as "keep the existing
      convention", so an hour and forty minutes bought an answer of carry on as
      you were. The reason it cost that much is structural, not bad luck: the
      disputed mark is written by the item in hand and never read by later
      items, so nothing downstream depended on the answer. The supervisor's own
      escalation had already said the fix would be marks only and a sweep would
      be a relabel rather than a re-derivation, then it halted as though the
      answer were a precondition. Stating that a fix is cheap and treating it as
      blocking is one contradiction, and the worker had argued the other side
      correctly at the time.
      The refinement it proposed, logged as evidence for an ask rather than
      applied: escalate design-level questions immediately, but halt only what
      the question actually gates. That distinction needs a home in
      `supervise.md`, because nothing there currently separates "this needs a
      ruling" from "this cannot proceed".
- [x] **Adding rails moved the cost into the review loop rather than removing
      it.** Item 7 was the first item delivered under the cite-or-delete rail
      and it took one commit plus five amends, against a single amend on each of
      the six items before it. The deltas were 6/1, 16/13, 7/6, 2/1 and 3/3
      lines, netting 25 insertions and 15 deletions on a commit that changed 291
      and 167 - so five review rounds adjusted about a tenth of the item, in
      pieces that got smaller but never stopped. Elapsed cost was roughly forty
      minutes against a steady state near eleven.
      The rail worked: the commit body held, and the defect that did survive
      went to the diagram, the one channel it does not cover. What the run has
      not shown is a net saving. Earlier in this file the amend round looked like
      a check standing in the wrong place; item 7 says the opposite is also
      available, that a stricter standard converges by iteration and each
      iteration is a full round trip through two sessions.
      Neither reading is settled, and the batch has now produced one item's
      evidence for each. What would separate them is per-item elapsed time and
      amend count for the remaining thirteen under the same rail, which this run
      will supply without anyone doing anything extra.
      Item 8 supplied the first of those and went the other way: one commit, no
      amends, 392 insertions and 175 deletions in twenty-five minutes, declared
      clean by the checkpoint on first read. Under the same rail as item 7 the
      review round cost nothing, which reads as a learning cost paid once rather
      than a standard charged per item. One confound keeps it from being a clean
      second sample: item 8's prose was written by a subagent the worker
      dispatched, so the production path differed as well as the rail's age.

- [x] **The supervisor found that one of its own completed audits proved
      nothing.** It had confirmed an item's fixup with `git show <sha>^:<path>`,
      which reads an object by id and succeeds just as well when that commit is
      an orphan, so the command could not have failed for the thing it was
      meant to establish. Existence and branch-reachability are different
      checks and only the first was ever run. It then audited the branch
      properly and found three orphans, one per recorded amendment, with no
      stray rewrites.
      Its own generalisation is the useful part, and it is worth lifting into
      `verification-policy.md` beside the discrimination rule: a command that
      returns output is not evidence unless it could have failed for the claim
      you meant to test. The rule already says this about executions; the
      failure here was a read that returned the right bytes from the wrong
      place, and a supervisor audit is exactly where that goes unnoticed,
      because the check appears to have run.

- [x] **Both roles caught their own crude measurements, unprompted.** In one
      tick the supervisor corrected its own `grep -c` count of precedent cells
      from 19 to 17, naming the two prose uses that inflated it and crediting
      the worker's count over its own; the worker then recounted its 16 on the
      same grounds, and re-ran twelve probes untruncated after realising it had
      described clipped 60-70 character error strings to the supervisor as
      exact. That is `verification-policy.md`'s discrimination rule applied by
      the roles to themselves, against their own reported figures, with no
      operator turn involved.
      Item 9 produced the sharper version of the same move. Auditing provenance
      bars, the supervisor noticed that an exact-match count is silent about
      the near-misses its own exactness excludes, so it grepped for the loose
      pattern minus the exact header and got zero - which is what licenses the
      count to mean "21 and no others" rather than "21 that matched". It also
      conceded a second miscount of its own on-screen output in fourteen
      instances, and kept the corrected value labelled as the minority case
      rather than quietly adopting it.
      This is a check on the shape of a check, invented in the run rather than
      required by the policy, and `verification-policy.md` has no rule that
      would have asked for it: the discrimination rule tests whether an
      execution could have failed, not whether an exact filter is hiding what
      it excludes.
      Then the same audit produced a rule for grading its own errors. The
      worker had excused both of the supervisor's miscounts as the minority
      case; the supervisor overruled that and adopted a test - was the number
      correct for what was measured, as opposed to for what it was used to
      claim - which moved its own tally up rather than down. Under it, a
      `grep -n` line number that is correct for the extracted stream it counted
      and wrong as a file coordinate is the majority case, because nothing
      measured the file; a figure read off the screen as eight when ten were
      there is the minority case, because nothing measured anything. The test
      is worth `verification-policy.md`: it separates the two buckets without
      argument and lets a reader classify the next case unaided.
      Its occasion was the supervisor's own defect. Recommending a change to
      `layout.md`, it cited the file ninety-six lines off, having piped `awk`
      section-extraction into `grep -n` and read the extract's numbering as the
      file's. The worker caught it and named the mechanism unaided. The content
      survived the correction unchanged, which is the part worth keeping: the
      error was in the one channel a reader is most likely to follow to source,
      inside the artifact arguing for the change.
      By the run's end the count reached twenty-four instances, four of them
      the minority case, and the conclusion the pair drew from it is the part
      worth carrying. These are two parties whose entire subject was this
      defect, both able to define it, several of them committing an instance
      within minutes of naming it. So the remedy cannot be vigilance. Of the
      near-misses that were genuinely saved, each was saved by running a
      query, by declining to conclude, or by a constraint that stopped an
      action before it completed - not once by attention. That is an argument
      for mechanism in `verification-policy.md` rather than another rule
      telling a reader to be careful, and it is evidenced rather than
      asserted, which is the standard the same finding demands.
      The worker then supplied the pattern in working form on T-084: handed a
      plausible defect in negated scalar filter values, it scanned all
      twenty-one shipped filter files, found zero, and wrote the claim up as
      theoretical rather than as a bug. The mechanism is one query standing
      between a plausible claim and a committed one.

### Operator error, recorded because the loop should prevent it

- [x] **A briefing that restated merge authority beat the declaration that
      holds it, for the whole run.** `declarations.md § Supervisor bounds`
      grants batch-scoped delivery the merge of a green batch or member MR/PR
      whose checkpoint report verifies the task's acceptance criteria, and
      attack-checker declares exactly that. T-083 is that class. Yet the
      supervisor was briefed to print `ESCALATION:` and stop "for the merge
      itself", so it never treated the merge as its own, and the watcher
      repeated the same claim to the operator until the operator said for the
      fifth time that the supervisor merges.
      The source was `supervisor-runbook.md`'s Variant B briefing recipe,
      which summarised authority in the step that composes the briefing rather
      than citing the section that holds it - and summarised it wrong,
      contradicting its own next step two lines later. Nobody read the
      declaration, because a briefing arrives as an instruction and a
      declaration has to be looked up: the copy is what the supervisor obeys.
      That makes the fix structural rather than textual. Authority has one
      home, and any document that helps compose a briefing must point at it
      instead of paraphrasing it, since a paraphrase is a second source that
      wins on arrival and drifts silently. The recipe now cites the section
      and says why.
      Cost: every supervised run briefed from that recipe stopped one step
      short of delivery and handed a merge back to the operator the grant had
      already covered.

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
      Tested later in the same run. Told to disregard the briefing clause and
      act on the declaration, the supervisor read the file, reported that it
      granted more than the briefing had, and pushed the corrected rule to the
      worker in one message. So the repair is cheap once someone notices, and
      the whole cost sits in the noticing: a summary that under-grants produces
      a supervisor that behaves correctly by its own lights while holding work
      it was authorised to deliver, which no gate catches and no report flags.

- [x] **The watcher repeated the supervisor's scope claim for eight consecutive
      reports without once testing it.** Every tick during the hold said E1 was
      gating items 7 through 20, taken from the escalation's own framing and
      never checked against the batch manifest. It was false, and it was
      checkable at any point: the disputed mark is written per item and read by
      none of the later ones. Repetition made it sound established, and the
      operator was deciding under a stated urgency that did not exist.
      The rule the watcher was already applying to the agents is the one it
      skipped on itself. A verified report and a relayed report are different
      objects, and a relayed claim about scope needs the same source check as
      a relayed claim about content.

- [x] **The watcher diagnosed a halt from panes while the answer sat in a file
      it had already been reading.** Across four ticks it reported that no role
      in the loop could clear a worker's permission dialog, escalated for
      authority to clear them itself, and wrote the claim into this file three
      times. The supervisor's ledger, on disk and read by this same watcher
      earlier in the run, was numbering those clears as it made them - thirty
      three of them, with their classes and a standing policy on persistent
      grants. The pane showed a dialog; it could not show who answers dialogs,
      and the watcher inferred the second from the first.
      The escalation was the expensive part. It asked the operator to grant a
      permission the run did not need, four times, using time the operator was
      spending on the wrong question. What the run needed was for someone to
      notice that both roles were waiting on each other.
      The general form is the one this file already states about panes and now
      states about itself: a transport shows you a state, never the mechanism
      that produces it. Where a durable artifact for that mechanism exists, it
      outranks the pane, and here it existed, was known, and went unread.
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
      Then the gap produced a defect. Item 7's commit body held up under the new
      cite-or-delete rail, and the error moved to the one channel that rail does
      not cover: its diagram. The item stayed unticked pending a redraw and a
      spec check, so nothing shipped wrong, but the sequence is the argument. A
      claim in prose now gets a citation opened and confirmed before it is
      written, while a claim drawn as a diagram gets an eye. Defects go where
      the checking is thinnest, and this batch has demonstrated it rather than
      predicted it.

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
- [x] The project's permission list grants reading the declared sibling
      repository. Done: `worker-workspace.sh settings` now grants read on the
      projects root, the parent of the project directory, because that is
      where provisioning puts sibling repositories and it needs no per-project
      list. The need is structural rather than incidental: a verifier
      settled a claim in `validate-hit.md` only from `../wallarm-api-js`,
      because the doc's subject calls into it. Five persistent-scope offers
      were declined and cleared one-shot instead, which is the right answer to
      a scope question arriving through a dialog.
- [ ] `verification-policy.md`: a negative search is evidence only from an
      instrument whose failure is distinguishable from its success. The bare
      `grep` these sessions invoke is a wrapper around `ugrep -I`; on a file it
      judges binary it prints nothing and exits 1, which is byte-identical to a
      genuine no-match. GNU grep on the same file exits 0 and warns on stderr.
      A verifier charter that asks for exhaustive negative searches therefore
      buys false negatives that read as proof of absence, and the discrimination
      rule already in that file is the one this violates.
- [x] The briefing recipe cites the declaration rather than summarising it.
      Done, and the merge-authority entry above is why it mattered.
