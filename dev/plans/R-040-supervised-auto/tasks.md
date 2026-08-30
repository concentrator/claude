# R-040 tasks - Supervisor-orchestrated autonomous DEV

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R040-T###`, counter scoped to this initiative).

## Open

- [x] **R040-T001 [doc]**: capability-bounds declaration - format,
  per-project home, and the batch-scoped-delivery default; extends
  `git-workflow.md § Merge policy` with the delegation clause and its
  escalation list (releases, convention changes, red gates, off-plan
  work).
- [x] **R040-T002 [feat]**: supervisor mode (`/dev supervise` +
  `skills/dev/supervise.md`) - the operating loop: dispatch, monitor,
  boundary verification via existing gates, merge-or-escalate, sync
  reporting from artifacts. Local transport (the default); remote is
  R040-T003. `depends-on: R040-T001`
- [x] **R040-T003 [feat]**: remote transport - superseded: the
  runbook's Variant B runs the supervisor on the worker host beside
  its worker (`companions/supervisor-runbook.md § Two variants`), so
  no second transport exists; session lifetime is `branch-plan.md
  § Session boundary`. `depends-on: R040-T002, R040-T010`
- [x] **R040-T010 [feat]**: worker-host deployment and provisioning - a
  skill plus an idempotent script that creates a Debian 13 VM and takes
  it to a state where a worker session can run a batch. Two execution
  contexts: `gcloud compute instances create` runs on the operator's
  machine, everything after runs on the VM. The instance carries an
  external IP for egress with ingress denied, a firewall tag, and
  serial-console metadata; IAP tunnel access is proven at creation time
  as the break-glass everything later depends on. Then: Node >= 22, `jq`, `tmux`, swap and
  timezone; hardening before any credential lands (listening-socket
  inventory, `exim4` purged, key-only SSH, public ingress closed at the
  VPC so the box is reachable only over Tailscale, `nftables`
  default-deny, unattended security upgrades); SSH keys for both hosts; `glab` and `gh` authenticated
  from a gitignored `.env`; this repo cloned as the worker's
  `~/.claude` with `core.hooksPath` restored; target projects cloned
  into `/opt/wallarm` with their sibling repos adjacent and their gates
  proven to run; and
  each project's `settings.local.json` placed, since it is gitignored
  and does not travel with a clone. Tailscale and Claude Code
  authenticate by SSO and stay human-in-the-loop. Supports both
  session modes - tmux for interactive, a headless launch path beside
  it - and states the headless protected-path limitation rather than
  leaving it to be rediscovered. `depends-on: R040-T002`
- [x] **R040-T004 [test]**: supervised pilot, stage 1 (local) - the
  attack-checker plans/docs migration batch, planned and stamped in
  that repo, dispatched and delivered supervised on the same machine;
  exercises question resolution, the decision ledger, and the prompt
  constraint. `depends-on: R040-T005`
- [x] **R040-T005 [doc]**: the quality-acceptance amendment -
  `supervise.md` gains the question-resolution step (the supervisor
  answers a worker's implementation questions and the run continues;
  design-touching questions escalate), the implementation-vs-design
  decision split, and the decision ledger;
  `companions/declarations.md § Supervisor bounds` adds design and
  architectural decisions to the always-escalated list;
  `companions/report-template.md` gains the supervisor-decisions
  field; the worker-prompt constraint (guaranteed acceptance or
  supervisor-accepted edits) lands beside the transport rules.
- [x] **R040-T006 [test]**: supervised pilot, stage 2 (local) - one
  real task's batch in attack-checker end to end on the same machine,
  user only at sync points; findings feed a fix round before the
  initiative closes. `depends-on: R040-T004`
- [x] **R040-T007 [fix]**: supervisor operational discipline in
  `supervise.md` - the supervisor never runs a git command that moves
  HEAD or creates a branch in a worker's working tree, and
  `§ Boundary verification` gains the batch-ref check, which detects
  that breach for one `git log -1`. Both fixes come from the same
  stage-2 incident: a plan branch cut in the worker's tree took its
  branch tip as base and carried fourteen unreviewed commits to
  `main`, while the batch ref sat at its anchor the whole time saying
  so. `depends-on: R040-T006`
- [x] **R040-T008 [doc]**: supervision beyond `/dev auto` - three
  symptoms of one assumption. `supervise.md § Dispatch` describes only
  a worker running the auto engine on a stamped batch; the merge
  classes in `companions/declarations.md § Supervisor bounds` name
  only batch/member and `plan/` MR/PRs; and the push carve-out in
  `companions/toolchain.md` allows only `batch/*`, stalling any manual
  task branch at push time. Name the manual-branch class or exclude
  it, but stop leaving a supervisor to reason it out per merge.
  `depends-on: R040-T006`
- [x] **R040-T009 [doc]**: verification that can fail - the pilot's
  central result, spread across four texts. `verification-policy.md
  § Models` gains a capacity fallback so a rate limit degrades on a
  documented path instead of escalating; the same file gains the
  unit-of-check rule (a check must count the unit of the thing it
  claims to check) and the discrimination rule (an execution whose
  inputs cannot distinguish the claim from its fallback is a
  demonstration); `companions/documentation.md` gains a gate step that
  reads a doc's preamble before its table, since a doc that redefines
  its own vocabulary passes a compliance check; and the dispatch
  prompts state that an agent verifies before applying a correction
  and reports back one it judges wrong. `depends-on: R040-T006`
- [x] **R040-T011 [feat]**: the agent channel - the pilot drove sibling
  sessions by typing into a terminal pane and paid three ways: an
  escalation printed to scrollback sat unread for roughly an hour, a
  blocked supervisor read identically to a thinking one, and the
  classifier twice refused the injection on a pattern it had allowed
  repeatedly. Scoped originally as three files per scope; measurement
  replaced most of that with configuration, because `SendMessage`
  already carries messages between sessions and **wakes an idle peer**
  rather than only queueing for one already taking turns. What remains:
  start the supervisor under `--remote-control` (the settings key is
  user-scope only, so it cannot be provisioned where `~/.claude` is the
  tracked config repo), commit `isolatePeerMachines`, decide whether the
  operator's own session joins, and correct the keystroke claim this
  initiative wrote into three documents.
  `depends-on: R040-T002`
- [ ] **R040-T012 [mnt]**: the shared config's `Bash(git:*)` grant is wider
  than the per-project templates assume - broad enough that a project's
  `settings.local.json` allow rules are largely redundant on top of it, which
  is why R040-T010 could not build a test that discriminated a placed file
  from a missing one. Narrow the global grant to what a session actually
  needs, so the per-project templates carry the authority they claim to and
  their acceptance tests can discriminate. Routed from
  `R040-T010-worker-host.findings.md`. `depends-on: R040-T010`
- [ ] **R040-T013 [doc]**: decide whether `companions/documentation.md`
  § Verification gate should distinguish a targeted-edit branch from a new or
  rewritten doc. It clears rules and planning prose on the changed claims but
  feature docs on **every** claim, so a sweep touching fourteen docs owes a
  per-claim pass over all fourteen. The wider reading earns its cost - it
  caught a worked example throwing `RangeError` while stamped `verified`, on
  lines that branch never touched - but most of those docs took a single line
  of edit. Evidence both ways is in `R040-T010-worker-host.findings.md`.
  Amending a gate to pass it is not a call to make under delivery pressure,
  which is why this is its own task.

- [x] **R040-T014 [mnt]**: worker edit gate under `acceptEdits` - the
  user-global `defaultMode: acceptEdits` (R056-T002) removed the edit
  prompts `supervise.md` used as a checkpoint (accept in-repo edit
  prompts, halt on any other). Decide the replacement: pin
  `defaultMode: default` in worker-host provisioning, add a
  worker-side guard hook, or accept declared permissions as the only
  gate; update `supervise.md` and the provisioning scripts to match.
  Routed from `R-056-settings-tiering/R056-T002-accept-edits.findings.md`.
  Resolved by "Reconcile supervise.md with the pilot" (R040-T011):
  declared permissions plus supervisor-cleared prompts are the gate,
  `supervise.md § Dispatch` states it, provisioning unchanged.

- [x] **R040-T015 [feat]**: quota-gated Fable review - the tracked
  project tier pins `model: claude-fable-5[1m]`, so every session in
  this repo spends the Fable window on ordinary work, and
  `verification-policy.md § Models` pins branch-close and batch
  full-diff review to `fable` behind a capacity fallback that fires
  only once a dispatch has already failed. Make Opus the default and
  the fallback pre-flight: `scripts/model-quota.sh` reads the session's
  own OAuth credential and the claude.ai usage endpoint, which reports
  a per-model weekly window, so a `fable`-pinned role dispatches on
  Fable only while that window has headroom. Over the ceiling,
  unreadable, or absent, the role dispatches on Opus and records the
  substitution the policy already requires.

- [x] **R040-T016 [fix]**: `forge-cli` reports success on a host whose
  `glab` cannot reach the project. `forge_auth`
  (`scripts/worker-credentials.sh § forge_auth`) exports `GITLAB_TOKEN` and
  verifies with `glab api user --hostname gl.wallarm.com`, which passes
  on a token whose instance `glab` holds no host entry for. Every
  repo-relative command then fails - "None of the git remotes configured
  for this repository point to a known GitLab host" - so a worker runs a
  batch to completion and cannot open its MR. Two gaps, and the second
  is why the first survived: the subcommand never runs the `glab auth
  login` its `--dry-run` text promises, and the check it does run
  is the one shape that cannot detect the omission. Add `glab auth login
  --hostname <host> --stdin` and verify from inside the project
  checkout, which is where a worker calls it from. The `--dry-run` text's
  other promise, `glab auth status`, stays rejected for the reason the
  comment above `forge_auth` records. Found on `claude-worker` before the R-020 B-002 dispatch, and
  cleared there by hand so that run could proceed.
  `depends-on: R040-T010`

- [x] **R040-T017 [feat]**: the supervisor's working ledger has no rule
  and no durable home. Both places the rules say "ledger"
  (`supervise.md:75`, `declarations.md:63`) mean an entry in the
  report's `## Supervisor decisions` section; no file is defined
  anywhere. The R-020 B-002 supervisor kept one regardless, 330 KB of
  it, in its session scratchpad - the only place its own working state
  lived, and it dies with the session. That is why the worker can be
  told to clear context at its unit boundary (`branch-plan.md
  § Session boundary`) while the supervisor cannot: clearing first
  destroys the state it reasons from. Declare the ledger with four
  properties. A path outside both the project checkout and the config
  repo, so working memory dirties neither tree. Appends the auto-mode
  classifier accepts, since a supervisor needing approval for every
  write is not unattended. Append as a write and never `Edit`, which
  re-reads and rewrites the whole file per entry. And working memory
  only: a decision still lands in the report's `## Supervisor
  decisions`, so the ledger holds evidence and never becomes a second
  home for a finding. Then the supervisor can take the same clearing
  rule the worker already has.
  `depends-on: R040-T011`

- [ ] **R040-T018 [doc]**: the readiness bar is written for a blind
  implementer and applied to a watched one. `branch-plan.md § agentic:
  stamp` admits a plan only when a cold reader can build it with no
  question, because a `/dev auto` subagent has no one to ask; under
  `/dev supervise` a worker has three receivers - supervisor for
  implementation calls, operator for merges and plan-fact corrections,
  human for design - yet `supervise.md § Resolve` demands the same
  stamp, so every plan a supervisor may touch must first pass the
  blind-implementer bar by the human's hand. First supervised task of
  a fresh project: three cold reads to stamp one doc plan, and the one
  real defect (a route method) was caught by the worker at pre-flight,
  not by any of them. Three changes, one PR. First, two stamps:
  `agentic: approved <date>` keeps its bar and its cold read, and stays
  what `/dev auto` needs when no supervisor is listening; `supervised:
  approved <date>` guarantees approved requirements, one commit per
  item and no known design question open, is applied to every plan in
  the R when the human approves the planning round (`plan.md
  § Approval and closure`), and is what `§ Resolve` admits alongside
  `agentic`. A cold read under `supervised` is optional and its
  findings are triaged by receiver, only a human-level one blocks.
  Second, the always-escalated list in `companions/declarations.md
  § Supervisor bounds` carves out a `CLAUDE.md` change confined to
  `§ Agent toolchain`: declaration lines are configuration, and the
  operator delivers them. Third, `§ Operator modes` states that for an
  AI-operated seat the global `CLAUDE.md § Approval and persistence`
  and `§ Communication` are satisfied by the declared bounds - it
  decides merges and plan-wording facts within them, runs
  `--permission-mode auto`, and halts only on the always-escalated
  classes, design-level questions and evidence gaps - and
  `companions/supervisor-runbook.md` gains the operator session's
  launch line and briefing beside the supervisor's.
  `depends-on: R040-T008`
- [x] **R040-T019 [feat]**: state survives compaction. A worker or
  supervisor whose context auto-compacts mid-branch keeps the
  summary's account of the work and loses the tree's: which
  checkboxes are committed, what is uncommitted, which ruling was the
  last one applied. Two supervised tasks each compacted with an
  uncommitted checkbox and were recovered only because the operator
  watched the indicator and briefed by hand. A `PreCompact` hook
  (`hooks/dev-precompact-state.sh`) writes branch, `git status
  --porcelain`, the last commits and the first open plan item to a
  per-session state file; `hooks/dev-branch-state.sh` names that file
  on the next prompt so the resumed session re-briefs from the tree;
  `supervise.md § Monitor` makes the pre-compaction commit and the
  post-compaction re-brief part of the watch. Registered in
  `settings.json`, tested by `scripts/test/dev-precompact-state.test.sh`.
  The tree cannot record intent, so the same file takes a hand-off
  note the session writes at each unit boundary - done, next, branch,
  open MR/PRs, rulings in force - on demand via `/dev handoff` and by
  rule at the boundary.

- [ ] **R040-T021 [doc]**: context burn under execution. A worker's
  window is ~85k tokens of room after compaction (a ~32k cached prefix
  plus ~45k rebuilt on every compaction: summary, re-attached files,
  skill bodies, tool deltas), and a `/dev code` session burns it at
  ~6k tokens a minute, so compaction fires every ~14 minutes (aikido
  session, 2026-08-28, measured with `scripts/context-cost.py`).
  Two-thirds is model output retained across a tool loop; the rest is
  tool I/O the command shape chose: whole-file `cat`s of files already
  in context, unfiltered `grep` results, heredoc rewrites that resend
  the file as a command, and the pre-push hook's full test transcript
  on every `git push`. First check whether Claude Code offers a setting
  or hook that caps or truncates tool output (settings reference and
  hooks reference; a `PostToolUse` hook that rewrites the result
  counts); a verified one is adopted in `settings.json` and the rule
  below shrinks to what it does not cover. Then write the rule once,
  in `branch-plan.md § Commit cadence`, cited by
  `companions/implementer-prompt.md` and the supervisor runbook: a
  command prints only what the step needs - a status word, a count,
  the requested range (`grep -l`/`-c`, `sed -n`, `>/dev/null` on gates
  and pushes with the exit status echoed), never a file already in
  context; edits go through `Edit` on anchors, not heredoc rewrites.
  The rebuilt base is harness behaviour and out of scope; no setting
  controlling the summary's size is verified, so `autoCompactWindow`
  stays where `DESIGN.md § Context budget` sets it and `/compact
  <focus>` remains the one lever on summary content. Acceptance: the
  setting check recorded with its source, the rule text, and one
  re-measurement of a `/dev code` session after it with
  `context-cost.py`.
- [ ] **R040-T022 [refactor]**: the supervisor declarations
  (`Supervisor bounds`, `Operator mode`) move from `CLAUDE.md § Agent
  toolchain`, which `companions/toolchain.md` defines as the build and
  VCS declarations, to a `## Supervision` section of their own;
  `declarations.md`, `supervise.md § Resolve` and the runbook cite the
  new home. Surfaced by the R065-T001 close review.
  `depends-on: R040-T018`
- Backlog: a worker-side notification hook - a blocked worker wakes its
  supervisor instead of waiting to be read; until it lands, the
  runbook's wait recipes take a hard `timeout` on every loop
  (`R040-T011-agent-channel.findings.md`).

- [x] **R040-T023 [fix]**: `hooks/dev-precompact-state.sh` records
  `trigger: unknown` on every compaction. It reads
  `.compaction_trigger` from the hook's stdin, and Claude Code sends the
  reason as `trigger` (`manual` or `auto`, code.claude.com/docs/en/hooks),
  so the `// "unknown"` default always wins; the self-test feeds the
  same wrong key, so it passes. Read `.trigger`, and feed it in the
  test. Observed in a session file of 2026-08-28. `depends-on: R040-T019`

- [x] **R040-T024 [fix]**: `verification-policy.md § Models` calls the
  gate as `model-quota.sh "Fable 5"`, and the usage endpoint names the
  model `Fable`, so the gate exits 2 on every call and every
  `fable`-pinned review routes to Opus - the outage the gate's own
  diagnostic was built to expose, and it did, on the first close review
  after R040-T015 merged (`R040-T023-precompact-trigger.findings.md`).
  Cite `"Fable"` in the policy and in the gate's test fixtures.
  `depends-on: R040-T015`

- Next: R040-T021, R040-T013, R040-T012, R040-T018, R040-T022.
