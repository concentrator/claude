# Supervisor runbook

How to stand a supervisor and a worker up and run one scope to a merged
MR/PR. `supervise.md` holds the judgement: what may be merged, what must
escalate, how a question is answered. This holds the mechanics.

## Two variants

|  | A: one machine | B: remote host |
|---|---|---|
| Supervisor runs on | the operator's machine | the worker host |
| Worker runs on | the operator's machine | the worker host |
| Channel | peer messaging (`ListAgents`, `SendMessage`) | peer messaging on the host |
| Who starts the worker | the operator | the supervisor |
| Who clears the worker's prompts | the operator, at the keyboard | the supervisor, over `tmux` |
| Operator's seat | the same machine | Remote Control (§ Remote Control), or `gcloud compute ssh --tunnel-through-iap` |

A message wakes an idle co-located peer rather than queueing for one
already taking turns, so dispatch, questions, and answers ride
`SendMessage` in both variants. `tmux` keystrokes remain only for what
a message cannot do: answering a permission prompt and reading a pane
(§ tmux recipes).

Both deliver. Take A for a single scope you intend to sit with. Take B
when the work should outlive the laptop, when the operator wants the
machine back, or when the host is provisioned for it
(`skills/worker-host/SKILL.md` in the toolset repository).

## The loop

```
   operator
      |  answers escalations, decides merges; nothing else
      v
 +-------------------------------------------------+
 |  SUPERVISOR                          auto mode   |
 |  never blocked, so it can always act             |
 +-------------------------------------------------+
      |  starts, dispatches, unblocks, verifies
      v
 +-------------------------------------------------+
 |  WORKER                          accept-edits    |
 |  /dev code <slug>  or  /dev auto R<NNN>-B<NNN>  |
 +-------------------------------------------------+
      |
      v
   branch  ->  commits  ->  gates  ->  MR/PR
```

The supervisor cycles until the scope is delivered:

```
  +--> read the worker's pane
  |         |
  |         +-- working?   -> wait on the until-loop ---------+
  |         |                                                 |
  |         +-- prompted?  -> send the option number ---------+
  |         |                                                 |
  |         +-- asking?    -> implementation: answer ---------+
  |         |                 design or unclassifiable:
  |         |                 print ESCALATION and stop
  |         |
  |         +-- delivered? -> verify by running the gates
  |                                |
  +--------------------------------+
                                   |
                 hand the green MR/PR up, or escalate
                                   |
                                   v
                 operator merges (`declarations.md § Operator modes`)
```

## Variant A: one machine

0. **Human**, where the project declares `Operator mode: AI operated`
   (`declarations.md § Operator modes`): starts the operator in its
   own terminal, `claude --permission-mode auto`, and briefs it in one
   message - the projects it holds the merge for and a pointer to
   that section for what it decides and what it escalates. Cite,
   never restate, for the reason Variant B step 4 gives. Human
   operated: the person is the seat and this step is theirs.
1. **Operator** opens a second terminal in the project directory and
   starts the worker: `claude --permission-mode acceptEdits`.
2. **Operator** starts the supervisor in another session in auto mode
   and runs `/dev supervise <project> <scope>`.
3. **Supervisor** runs `ListAgents` and adopts the worker peer by name.
   Adopt before dispatch (`supervise.md § Dispatch`): never run two
   workers on one project.
4. **Supervisor** opens the ledger (`supervise.md § Ledger`), then
   dispatches with `SendMessage`, ids only: `/dev code <slug>` for a
   manual task, `/dev auto R<NNN>-B<NNN>` for a batch.
5. **Supervisor** follows to checkpoint with status pings. The operator
   is at the keyboard, so the worker's permission prompts are theirs to
   clear.
6. **Supervisor** verifies the delivered scope from artifacts by running
   them, then hands the green MR/PR to the operator, or escalates.

## Variant B: remote host

1. **Operator** connects:
   `gcloud compute ssh <host> --zone=<zone> --project=<project> --tunnel-through-iap`
2. **Operator** confirms a clean start: no stale `tmux` sessions, the
   project checkout on the trunk with nothing uncommitted.
3. **Operator** starts the supervisor:
   `tmux new -d -s supervisor -c <project-dir> claude --remote-control supervisor --permission-mode auto`
   Where the project declares `Operator mode: AI operated`, the human
   starts the operator the same way first,
   `tmux new -d -s operator -c <project-dir> claude --remote-control operator --permission-mode auto`,
   briefed as Variant A step 0: the projects it holds the merge for
   and a pointer to `declarations.md § Operator modes`.
   The flag joins Remote Control under the name `supervisor`
   (§ Remote Control); `tmux` keeps the session alive across a dropped
   tunnel.
4. **Operator** briefs it in one message: the scope and its branch plan
   path, the command that starts the worker, and a pointer to
   `companions/declarations.md § Supervisor bounds` for what it may
   deliver and what it must escalate. Cite that section, never restate
   it: the copy is what the supervisor obeys, and a stale copy puts it
   outside its bounds while it believes it is inside.
5. **Supervisor** opens the ledger (`supervise.md § Ledger`), starts
   the worker
   (`tmux new -d -s worker -c <project-dir> claude --permission-mode acceptEdits`),
   adopts it by name over `ListAgents`, and dispatches one line and
   nothing else by `SendMessage`: `/dev code <slug>`.
6. **Supervisor** follows: answers implementation questions over the
   channel, clears the worker's permission prompts over `tmux`.
7. **Supervisor** verifies by running the gates, then hands the green
   MR/PR to the operator citing its evidence, or escalates.
8. **Operator** decides the handed-over MR/PR and answers escalations -
   over `SendMessage` from a connected session, or in the supervisor's
   pane.

### tmux recipes - what a message cannot do

Read a pane:

```
tmux capture-pane -p -t worker | tail -30
```

Answer a permission prompt:

```
tmux send-keys -t worker '1'; sleep 1; tmux send-keys -t worker Enter
```

Wait for a session to go quiet. A bare foreground `sleep` is blocked, so
use an until-loop on the footer:

```
until ! tmux capture-pane -p -t worker | grep -q "esc to interrupt"; do sleep 5; done
tmux capture-pane -p -t worker | tail -30
```

`esc to interrupt` is in the footer only while the session is working,
and absent both when it is idle and when it is stopped on a prompt, so
the loop returns on either.

Put the loop inside the remote command, not around it:

```
ssh <host> --command='until ! tmux capture-pane -p -t worker | grep -q "esc to interrupt"; do sleep 5; done
                      tmux capture-pane -p -t worker | tail -30'
```

One connection waits on the host and returns once; a reconnect per
poll reads a pane `send-keys` has not caught up with.

**Keystroke authority.** A single key sent to another session's dialog
is an answer; text typed into its input box is a dispatch. The operator
may send `1`, `2` or `Esc` to a supervisor stopped on a permission
prompt, once it has read the pane and the command being approved is
inside that session's own bounds. It may not type instructions into the
box: that makes the operator a second dispatcher, and the transcript
records no channel for any input, so nothing afterwards can tell the
two apart. Nor is a keystroke the fix for a deadlock - a session
stopped because nobody can answer it is a provisioning bug, and the
key buys one turn while leaving the cause in place.

## Remote Control

Join by launch flag, never by settings: `remoteControlAtStartup` is
honoured at user scope only, and on the worker host `~/.claude` is the
tracked config repo. Confirm the join by the `/rc active` marker in
the session footer; an enabled session also prints its own
`https://claude.ai/code/session_...` URL. Leave `autoUploadSessions`
unset: it mirrors sessions to claude.ai view-only, is not required,
and is the one setting here with a data-egress consequence. The
operator's own session joins too: a host session appears in
`ListAgents` only when both ends are connected, and
`isolatePeerMachines: true` in the tracked `settings.json` gates each
cross-machine send behind explicit approval. The printed URL gives
browser and phone control without joining.

## Modes, and why each role gets one

| Role | Mode | Reason |
|---|---|---|
| Supervisor | `auto` | Its own tooling is compound shell - until-loops, pipelines - which prefix rules cannot match. Auto suspends Bash allow rules and routes every shell command to a classifier that judges what the command does, so the supervisor is never blocked and can always answer the worker. |
| Operator, AI operated | `auto` | It merges and polls through the host CLI, compound shell like the supervisor's, and decides within declared bounds (`declarations.md § Operator modes`). |
| Worker | `acceptEdits` | Edits land without a prompt. The shell prompts it still raises are cleared by whoever holds the keyboard for that variant. |

Never `bypassPermissions`: it discards deny rules along with everything
else. Never `dontAsk`: it denies rather than approves, so every prompt
becomes a hard failure instead of a question.

Deny rules survive auto mode. Only Bash *allow* rules are suspended, so
a `git push origin main` or force-push deny still bites.

Both seats hold their commands to `branch-plan.md § Commit cadence`
point 4: print what the step needs, never a file already in context.

## Failure modes

- **The classifier fails closed** ("Auto mode could not evaluate this
  action and is blocking it for safety"): write commands the
  classifier can read - no base64 piped into a shell, no script copied
  to a host and executed.
- **Prompts reappear in a long supervisor session** ("Auto mode
  classifier transcript exceeded context window - falling back to
  manual approval"): the classifier transcript overflowed, not a mode
  change.
- **Over ssh**, use a `pkill` pattern that cannot match its own shell
  (`pkill -f '[r]esmon'`) and run a long-lived helper in its own
  `tmux` session, never with `&`
  (`skills/worker-host/companions/pitfalls.md` in the toolset
  repository).
- **Sending keys to a fresh session**: wait for the prompt line, and
  confirm the text landed before pressing Enter.
- **`defaultMode` appears in the tracked `settings.json`** after a
  supervised run starts: do not stage it.
- **A usage limit halts the session**: run `date` on the host before
  concluding the wait is over, establish what landed if the
  interrupted step was not idempotent, then resume with a message
  naming where the turn stopped - a resumed session is told where to
  resume, never asked to work it out from its own history.
