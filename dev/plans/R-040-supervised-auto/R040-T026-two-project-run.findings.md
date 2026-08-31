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
  operator` (Claude Code docs, remote-control § From an existing session),
  `/rc active` confirmed by the user - no restart, no hand-off.

Adjacent defects found, not fixed here:

- `project-clone --dry-run` prints "into /opt/wallarm/attack-checker"
  for any `WORKER_PROJECT_REPO`; the clone itself uses the repo
  basename and put aikido in `/opt/wallarm/aikido`.
- `worker-credentials.sh` warns "GIT_USER_NAME or GIT_USER_EMAIL
  absent from ~/.claude/.env ... a worker would halt at its first
  commit" while the host's global git config carries the identity and
  prior worker commits used it; the check greps `.env` only.

## The run, 2026-08-31

One operator (this session, `--permission-mode auto`, operator's
machine) over two supervisor + worker pairs on `claude-worker`. Human
did Variant B steps 1-3 per project; every decision from here.

Delivery - `glab mr list --label supervised --merged`, both verified
from the operator seat:

- aikido: !140 "Report graded feature coverage" (R017-T004), merged
  2026-08-31T12:57:04Z, operator note note_481985.
- wallarm-api-js: !173 (where-predicates), merged 13:42:24Z,
  note_482025; !174 (R017-T001), 15:30:15Z, note_482081; !175
  (R017-T002), 17:00:02Z, note_482175; !176 (R017-T005,
  envelope-hosts), 18:52:22Z, note_482297. !176 carried the R017
  closure marks - the merge closed the initiative.

Every merge: operator's own state-check first (state, conflicts, sha
against the supervisor-verified head), `supervised` label, operator
note naming the deciding seat, then merge. Supervisor CI evidence came
from its direct pipelines-endpoint read after `glab mr view` returned
`pipeline: null` on !175 and !176.

Ledgers, on-host and gitignored (PR #460): wallarm-api-js
`dev/supervisor/R017.md` (1144 lines), aikido
`dev/supervisor/R017-T004.md` (208 lines).

Escalations and who ruled:

- Pre-existing customer-data exposure in the project's `dev/docs` on
  `main`: escalated to the human; the sweep decision stays theirs.
  Redaction delta of every supervised branch against `main` was zero.
- Worker edit straying to `main`-owned `dev/docs` scope in T001:
  operator scope-correction, work re-bounded to the branch.
- String-form `order_by`: worker twice composed a probe whose outcome
  could be a rejection; operator denied both and ruled it stays
  UNPROVEN under the no-error-provocation invariant.
- Supervisor ledger carried invented timestamps early: operator ruled
  `date -u` at write time; supervisor corrected.
- Encoded forms of ids (base64 and otherwise) truncate exactly as
  their plaintext: operator set it as run practice; whether it becomes
  a standing rule is parked for the human.
- Ship gates T004, T001, T002, T005: operator ruled each; T002 and
  T005 rulings went directly into the worker pane (2% context, no
  relay room) with the stop-at-MR boundary restated.
- T002 review fixes: eight on-branch, three backlogged - operator.
- T005: extra per-family reads skipped (recorded rounds carry the
  claims, same logic as the T002 no-re-check ruling); the line-42
  re-wrap defect fixed on-branch before the MR - operator, on the
  supervisor's catch.
- R017 plan-dir archival after closure: operator ruled no archival
  this run - eight doc citations point into the dir and findings
  disposition is reserved for the human's docs-snapshot remediation;
  backlog stays in the project's `tasks.md § Backlog`.
- Parked for the human, none blocking: partial gating in the
  supervisor seat (git commit, glab, node auto-allowed - two T005
  commits landed promptless), the MIXED provenance mark undefined in
  the project's `feature-docs.md`, Remote Control lost at relogin
  (`/rc failed`; human chose the pane channel, which held).

Channel findings:

- The pane channel (tmux capture + send-keys over IAP ssh) carried
  the whole run; the report-only watcher (15 then 10 cycles, 90 s,
  cumulative digest dedupe) woke this session on prompts and notes.
  Lesson held from its false-wake phase: freeze the watcher command
  verbatim - every exclusion-list edit changes the digest and wakes.
- Composer placeholder text renders at the prompt as if typed; it is
  never input. It reappeared at run end as an unsent `/dev handoff`
  in the worker composer; left alone.
- Permission dialogs mislabel read-only commands: `sed -n` reads of
  `.claude/` paths surfaced repeatedly as "edit sensitive file";
  adjudicated on the command line shown, never the label.
- Both seats raced to clear the same gate prompt once; each side's
  verify-pending guard prevented a double send. A keystroke after a
  dialog is gone lands in the composer as input, so every clearing
  send re-verified first, one-time yes only - never a persistent
  rule or mode switch.
- Auto-mode classifier denials are nondeterministic: an identical
  previously-allowed watcher command was denied twice, one identical
  retry passed each time. A watcher variant that auto-cleared prompts
  was denied; report-only kept.
- Silent stalls (flat token counter ~15-20 min) caught two holds the
  prompt patterns missed - T005's verify-question hold among them;
  direct pane inspection resolved both.
- Host monitor: 491 samples, 2026-08-31T10:56:07Z to 19:08:53Z,
  stopped 19:09:38Z. Final tokens aikido 240,860 (flat from ~13:00,
  pair closed after !140), wallarm-api-js 2,063,428. Peak load 1.55
  at 11:05 (both pairs starting), peak mem 2255/3919 MB at 18:24
  (T005 close-review agents); no memory pressure at 4 GB.
