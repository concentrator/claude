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
(`skills/worker-host/SKILL.md`).

## The loop

```
   operator
      |  answers escalations; nothing else
      v
 +-------------------------------------------------+
 |  SUPERVISOR                          auto mode   |
 |  never blocked, so it can always act             |
 +-------------------------------------------------+
      |  starts, dispatches, unblocks, verifies
      v
 +-------------------------------------------------+
 |  WORKER                          accept-edits    |
 |  /dev code <slug>   or   /dev auto B-XXX         |
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
                    merge within bounds, or escalate
```

## Variant A: one machine

1. **Operator** opens a second terminal in the project directory and
   starts the worker: `claude --permission-mode acceptEdits`.
2. **Operator** starts the supervisor in another session in auto mode
   and runs `/dev supervise <project> <scope>`.
3. **Supervisor** runs `ListAgents` and adopts the worker peer by name.
   Adopt before dispatch (`supervise.md § Dispatch`): never run two
   workers on one project.
4. **Supervisor** dispatches with `SendMessage`, ids only: `/dev code
   <slug>` for a manual task, `/dev auto B-XXX` for a batch.
5. **Supervisor** follows to checkpoint with status pings. The operator
   is at the keyboard, so the worker's permission prompts are theirs to
   clear.
6. **Supervisor** verifies the delivered scope from artifacts by running
   them, then merges within bounds or escalates.

## Variant B: remote host

1. **Operator** connects:
   `gcloud compute ssh <host> --zone=<zone> --project=<project> --tunnel-through-iap`
2. **Operator** confirms a clean start: no stale `tmux` sessions, the
   project checkout on the trunk with nothing uncommitted.
3. **Operator** starts the supervisor:
   `tmux new -d -s supervisor -c <project-dir> claude --remote-control supervisor --permission-mode auto`
   The flag joins Remote Control under the name `supervisor`
   (§ Remote Control); `tmux` keeps the session alive across a dropped
   tunnel.
4. **Operator** briefs it in one message: the scope and its branch plan
   path, the command that starts the worker, and the instruction to
   print `ESCALATION:` and stop for anything design-level or for the
   merge itself.
5. **Supervisor** starts the worker
   (`tmux new -d -s worker -c <project-dir> claude --permission-mode acceptEdits`),
   adopts it by name over `ListAgents`, and dispatches one line and
   nothing else by `SendMessage`: `/dev code <slug>`.
6. **Supervisor** follows: answers implementation questions over the
   channel, clears the worker's permission prompts over `tmux`.
7. **Supervisor** verifies by running the gates, then merges within
   bounds or escalates.
8. **Operator** answers escalations - over `SendMessage` from a
   connected session, or in the supervisor's pane.

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

## Remote Control

The supervisor joins by launch flag, never by settings:
`remoteControlAtStartup` is honoured only at user scope, and on the
worker host `~/.claude` is the tracked config repo, so provisioning it
would dirty the repo. The flag is also the better shape - only the
supervisor joins, under a chosen name, instead of every throwaway
session on the box.

## Modes, and why each role gets one

| Role | Mode | Reason |
|---|---|---|
| Supervisor | `auto` | Its own tooling is compound shell - until-loops, pipelines - which prefix rules cannot match. Auto suspends Bash allow rules and routes every shell command to a classifier that judges what the command does, so the supervisor is never blocked and can always answer the worker. |
| Worker | `acceptEdits` | Edits land without a prompt. The shell prompts it still raises are cleared by whoever holds the keyboard for that variant. |

Never `bypassPermissions`: it discards deny rules along with everything
else. Never `dontAsk`: it denies rather than approves, so every prompt
becomes a hard failure instead of a question.

Deny rules survive auto mode. Only Bash *allow* rules are suspended, so
a `git push origin main` or force-push deny still bites.

## Failure modes

- **The classifier fails closed.** "Auto mode could not evaluate this
  action and is blocking it for safety." Opaque commands are refused:
  base64 piped into a shell, a script copied to a host and executed.
  Write commands the classifier can read.
- **Auto mode reverts to prompting.** "Auto mode classifier transcript
  exceeded context window - falling back to manual approval." A long
  supervisor session loses the property that makes it unattended. Treat
  reappearing prompts as this, not as a mode change.
- **`pkill -f <pattern>` matches its own shell.** Run over
  `ssh host command`, the remote shell's command line contains the
  pattern, so `pkill -f resmon.sh` kills the connection and `ssh` exits
  255. Use a pattern that cannot self-match: `pkill -f '[r]esmon'`.
- **Backgrounding with `&` inside an ssh command drops the connection.**
  Run a long-lived helper in its own `tmux` session instead.
- **A fresh session ignores keys sent during its splash.** Wait for the
  prompt line before sending, and confirm the text landed before
  pressing Enter.
- **Claude Code writes `defaultMode` into the tracked `settings.json`.**
  A supervised run dirties the config repo by starting. Do not stage it.
