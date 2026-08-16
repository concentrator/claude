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
- [ ] **R040-T003 [feat]**: remote transport - `ssh <target>` worker
  sessions on the remote machine under declared permissions, plus the
  per-project `transport:` switch in the portfolio (`local` default);
  the session-lifetime decision lands here.
  `depends-on: R040-T002, R040-T010`
- [ ] **R040-T010 [feat]**: worker-host deployment and provisioning - a
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
