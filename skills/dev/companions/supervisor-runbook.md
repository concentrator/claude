# Supervisor runbook

How to stand a runner up and run one scope to a merged MR/PR. `run.md`
holds the judgement: what may be merged, what must escalate, how a
question is answered. This holds the mechanics.

## Two variants

Keyed by where the runner session lives, independent of the supervisor
mode (`companions/declarations.md § Supervisor bounds`): under either,
the seats are subagents of the runner in its checkout, and the only
session is the runner's.

|  | A: this machine | B: remote host |
|---|---|---|
| Runner runs on | the user's machine | the remote host, under `tmux` |
| Who starts it | the user, in a terminal | the user, over ssh |
| Where the user answers | the same machine | Remote Control (§ Remote Control), or `gcloud compute ssh --tunnel-through-iap` |
| Runner's pane read by | the user | `tmux` (§ tmux recipes) |

Both deliver. Take A for a scope you intend to sit with. Take B when
the work should outlive the laptop, when the user wants the machine
back, or when the host is provisioned for it
(`skills/worker-host/SKILL.md` in the toolset repository).

## The loop

```
   user
      |  Supervisor: human - answers, clears, merges
      |  Supervisor: AI    - answers the always-ask escalations only
      v
 +---------------------------------------------------+
 |  RUNNER SESSION      /dev run <scope>             |
 |  resolves, dispatches, routes questions, verifies |
 +---------------------------------------------------+
      |  Task tool, one seat at a time
      v
 +---------------------------------------------------+
 |  SEAT (subagent)     one plan item                |
 |  implementer / reviewer                           |
 +---------------------------------------------------+
      |
      v
   branch  ->  commits  ->  gates  ->  MR/PR
```

The runner cycles until the scope is delivered:

```
  +--> dispatch the next item's seat
  |         |
  |         +-- DONE?          -> spec check, mark, next ---------------------------+
  |         |                                                                       |
  |         +-- asking?        -> planner change, user approves, fresh implementer -+
  |         |
  |         +-- last item?     -> close, checkpoint, push, MR/PR
  |                                  |
  |                                  v
  |                         verify the boundary (CI + artifacts)
  +----------------------------------+
                                     |
                   merge the green in-class MR/PR, or ask the user
                       (`declarations.md § Supervisor bounds`)
```

## Variant A: this machine

1. **User** opens a session in the project directory - under
   `Supervisor: AI` with `claude --permission-mode auto`, under
   `Supervisor: human` their own session in its usual mode - and runs
   `/dev run <scope>`.
2. **Runner** resolves the scope and the supervisor line, opens the
   ledger (`run.md § Ledger`), and dispatches seats one at a time
   (`run.md § Dispatch per item`).
3. **Runner** routes a seat's question through `run.md § Question
   resolution`: the item halts, the planner changes the plan, the
   **user** approves the change under either supervisor mode, and a
   fresh implementer follows.
4. **Runner** verifies the boundary from CI and artifacts
   (`run.md § Boundary verification`), then merges the green in-class
   MR/PR or asks the user (`run.md § Merge or ask`).

## Variant B: remote host

1. **User** (once per project) connects:
   `gcloud compute ssh <host> --zone=<zone> --project=<project> --tunnel-through-iap`
2. **User** confirms a clean start: no stale `tmux` sessions, the
   project checkout on the trunk with nothing uncommitted. Readiness
   also names which verbs auto-allow in the runner (from the merged
   allow rules and its mode), so a promptless action is a known
   quantity before the first dispatch, not a discovery during one.
3. **User** starts the runner:
   `tmux new -d -s runner-<project> -c <project-dir> claude --remote-control runner-<project> --permission-mode auto`
   The flag joins Remote Control under the name `runner-<project>`
   (§ Remote Control); `tmux` keeps the session alive across a dropped
   tunnel. Two runners on one host never share a name: session and
   Remote Control names carry the project, and every recipe targets
   that name. Escalations reach the user on their own device over
   Remote Control - no session of the user's runs in a host `tmux`.
4. **User** briefs it in one message: `/dev run <scope>` and a pointer
   to `companions/declarations.md § Supervisor bounds` for what it may
   merge and what it must ask. Cite that section, never restate it:
   the copy is what the runner obeys, and a stale copy puts it outside
   its bounds while it believes it is inside.
5. **Runner** runs the loop above: its seats are its subagents, and no
   second session exists on the host.
6. **User** answers the always-ask escalations - over `SendMessage`
   from a connected session, in the runner's pane, or from the phone
   via the Remote Control URL.

### tmux recipes

Read the runner's pane:

```
tmux capture-pane -p -t runner-<project> | tail -30
```

Wait for the session to go quiet. A bare foreground `sleep` is
blocked, so use an until-loop on the footer:

```
until ! tmux capture-pane -p -t runner-<project> | grep -q "esc to interrupt"; do sleep 5; done
tmux capture-pane -p -t runner-<project> | tail -30
```

`esc to interrupt` is in the footer only while the session is working,
and absent both when it is idle and when it is stopped on a prompt, so
the loop returns on either.

Put the loop inside the remote command, not around it:

```
ssh <host> --command='until ! tmux capture-pane -p -t runner-<project> | grep -q "esc to interrupt"; do sleep 5; done
                      tmux capture-pane -p -t runner-<project> | tail -30'
```

One connection waits on the host and returns once; a reconnect per
poll reads a pane `send-keys` has not caught up with.

A hold can raise no prompt at all - a free-form question, a held
dialog - and match no watch pattern. The alarm for those is flatness:
activity counters (token usage, pane output) unchanged past ~15
minutes mean a hold the patterns missed; inspect the pane directly
instead of waiting longer.

**Keystroke authority.** A single key sent to the runner's dialog is
an answer; text typed into its input box is a dispatch. The user may
send `1`, `2` or `Esc` to a runner stopped on a permission prompt:

```
tmux send-keys -t runner-<project> '1'; sleep 1; tmux send-keys -t runner-<project> Enter
```

once they have read the pane and the command being approved is inside
the session's own bounds. They may not type instructions into the
box: that makes the user a second dispatcher, and the transcript
records no channel for any input, so nothing afterwards can tell the
two apart. Nor is a keystroke the fix for a deadlock - a session
stopped because nobody can answer it is a provisioning bug, and the
key buys one turn while leaving the cause in place.

## Remote Control

Join by launch flag or, for a running session, `/remote-control
<name>`, never by settings: `remoteControlAtStartup` is
honoured at user scope only, and on the remote host `~/.claude` is the
tracked config repo. Confirm the join by the `/rc active` marker in
the session footer; an enabled session also prints its own
`https://claude.ai/code/session_...` URL. Leave `autoUploadSessions`
unset: it mirrors sessions to claude.ai view-only, is not required,
and is the one setting here with a data-egress consequence. A
session of the user's own joins too: a host session appears in
`ListAgents` only when both ends are connected, and
`isolatePeerMachines: true` in the tracked `settings.json` gates each
cross-machine send behind explicit approval. The printed URL gives
browser and phone control without joining.

## Modes by seat

| Seat | `Supervisor: AI` | `Supervisor: human` |
|---|---|---|
| Runner | `auto` | the user's session's own mode |
| Planner, implementer, reviewer | inherits the runner's | inherits the runner's |

A dispatched seat is a subagent and has no mode of its own: the run
has one permission mode, the runner's. Under `Supervisor: AI` that is
`auto`: the runner's own tooling is compound shell - until-loops,
pipelines - which prefix rules cannot match, and auto suspends Bash
allow rules and routes every shell command to a classifier that judges
what the command does, so the runner is never blocked. Under
`Supervisor: human` the user is at the keyboard, so their session's
mode governs and its prompts are theirs to clear.

Never `bypassPermissions`: it discards deny rules along with everything
else. Never `dontAsk`: it denies rather than approves, so every prompt
becomes a hard failure instead of a question.

Deny rules survive auto mode. Only Bash *allow* rules are suspended, so
a `git push origin main` or force-push deny still bites.

Every seat holds its commands to `branch-plan.md § Commit cadence`
point 4: print what the step needs, never a file already in context.

## Failure modes

- **The classifier fails closed** ("Auto mode could not evaluate this
  action and is blocking it for safety"): write commands the
  classifier can read - no base64 piped into a shell, no script copied
  to a host and executed.
- **Prompts reappear in a long runner session** ("Auto mode
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
- **A permission dialog mislabels its command** (a read-only command
  labeled as a sensitive-file edit): adjudicate on the command line
  shown, never the label.
- **Composer placeholder text renders as if typed** - dim suggested
  text at the prompt line in a pane capture is never input; leave it.
- **The classifier denies a previously-allowed command**: denials are
  nondeterministic - retry once, identical; a second denial is an
  answer.
- **A watch command wakes falsely after an edit**: digest-based
  dedupe hashes the command's own output shape, so freeze a watch
  command verbatim for the life of its watch.
- **`defaultMode` appears in the tracked `settings.json`** after a
  run starts: do not stage it.
- **The MR view omits the pipeline** (`glab mr view` returns
  `pipeline: null` on a live MR): CI evidence is a direct
  pipelines-endpoint read, its ref and sha matched to the MR head, so
  the green provably belongs to the commit being merged.
- **A usage limit halts the session**: run `date` on the host before
  concluding the wait is over, establish what landed if the
  interrupted step was not idempotent, then resume with a message
  naming where the turn stopped - a resumed session is told where to
  resume, never asked to work it out from its own history.
