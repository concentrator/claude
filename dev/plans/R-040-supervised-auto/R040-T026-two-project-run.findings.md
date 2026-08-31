# R040-T026 findings

## Host readiness, 2026-08-31

Host `claude-worker` (35.246.88.227), all commands over
`gcloud compute ssh --tunnel-through-iap`.

- Probe: `~/.claude` 262 behind origin/main, clean; wallarm-api-js on
  `main`, clean, 125 behind; aikido absent from `/opt/wallarm`; stale
  `tmux` sessions `supervisor` (Aug 24) and `worker` (Aug 26), both
  captured idle at an empty prompt before removal.
- `git merge --ff-only origin/main`: `~/.claude` to the R040-T026 plan
  merge (PR #461), wallarm-api-js to its ledger-ignore merge - the
  user's prep MR, so the pull ran after their task landed.
- `tmux kill-session` on both stale sessions; `tmux ls` then reports
  no server.
- `WORKER_PROJECT_REPO=support/aikido worker-workspace.sh
  project-clone`: cloned, `npm test` green, `npm run lint` clean,
  forge-cli proves glab 1.114.0 and gh 2.98.0 against the checkout.
- `worker-workspace.sh settings` for aikido and wallarm-api-js: 48
  allow rules each, workspace trusted.
- Permission pre-flight (the aikido allow-list finding: its tracked
  `settings.json` grants npm, `node --test` and three glab verbs, no
  git): every needed rule matched in the written
  `settings.local.json` of both projects - git cycle verbs, `git push
  -u origin` for the branch prefixes, `npm *`, `node *`, `glab *`.
  Compound commands still prompt by design; those are the
  supervisor's to clear (`supervise.md`).
- `.git/info/exclude` of both checkouts carries `dev/session/` and
  `dev/supervisor/` (PR #460 behavior).
- wallarm-api-js gates on the host after the pull: `npm ci`,
  `npm test` green, `npm run lint` clean.
- Remote Control: this session joined in place by `/remote-control
  operator` (docs `remote-control.md § From an existing session`),
  `/rc active` confirmed by the user - no restart, no hand-off.

Adjacent defects found, not fixed here:

- `project-clone --dry-run` prints "into /opt/wallarm/attack-checker"
  for any `WORKER_PROJECT_REPO`; the clone itself uses the repo
  basename and put aikido in `/opt/wallarm/aikido`.
- `worker-credentials.sh` warns "GIT_USER_NAME or GIT_USER_EMAIL
  absent from ~/.claude/.env ... a worker would halt at its first
  commit" while the host's global git config carries the identity and
  prior worker commits used it; the check greps `.env` only.
