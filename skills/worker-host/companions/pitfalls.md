# Things that will bite

Each of these cost a debugging round on a real host.

- **First contact with any new remote fails, then works.** The first IAP
  connection after creation exits 255 while the OS Login key propagates;
  the first forge SSH produces no output while host keys are accepted.
  Retry rather than treating the first failure as a verdict.

- **A non-interactive shell is the dispatch context.** `ssh host command`
  does not read past Debian's interactivity guard in `~/.bashrc`, so
  anything a worker needs - the `claude` binary, the forge tokens - is
  exported *above* that guard. Verify tooling from `bash -c`, never from
  a login shell.

- **Headless sessions cannot edit anything under `.claude/`.** Protected
  paths are denied outright with no prompt to accept, so a task touching
  guarded config cannot be delivered by a headless worker.

- **An untrusted workspace silently drops allow entries.** Claude reports
  "this workspace has not been trusted" and ignores them. `settings` sets
  `projects[<dir>].hasTrustDialogAccepted` in `~/.claude.json`, which
  lives outside the project and arrives with neither the clone nor the
  settings.

- **Sibling repositories are not optional.** `attack-checker` depends on
  `file:../wallarm-api-js`, so `npm ci` fails outright unless both sit
  adjacent under `/opt/wallarm`.

- **A fresh directory blocks session startup on the trust dialog.** A
  session started in a directory Claude has not seen waits on the trust
  question before the prompt appears, which reads as a hang when nobody
  is at the keyboard. `settings` marks the provisioned paths trusted;
  a session started anywhere else answers the dialog first.

- **The auto-mode setup dialog blocks a session it appears over.** A fresh
  auto-mode session offers to scan the repo, recent sessions, shell
  history and other repositories, and waits. On a supervisor that reads
  as a stall with no cause, because the pane shows a dialog rather than
  an error. `settings` dismisses it by setting
  `autoModeEnvSetup.dismissed` in `~/.claude.json`. Auto mode needs no
  setup to function, so nothing is lost by dismissing it; opting into the
  scan stays the operator's deliberate choice.
