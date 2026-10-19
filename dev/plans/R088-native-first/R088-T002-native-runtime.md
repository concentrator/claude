---
task: R088-T002
type: mnt
architecture-changing: true
mode: normal
---

- [x] On a compacted or resumed start the SessionStart hook injects the tree
  state read at that moment - repo, branch, status, recent commits and the
  first open item of each plan the branch touched - from no session file.
  Approach: move the tree read of `hooks/dev-precompact-state.sh` into
  `hooks/dev-session-brief.sh`, then its test, green, with a compact start
  in a repo whose branch carries an open plan item.
- [x] No hook asks for a hand-off or writes session state: the Stop nudge, the
  PreCompact writer and the context-fill helper are gone, and the
  branch-state line drops its session-state and fill segments. Approach: the
  user first drops the `Stop` and `PreCompact` entries from `settings.json`;
  then the three scripts and their tests, `dev-branch-state.sh` and its
  test, and `install-dev.sh` with its two tests and `LAYOUT.md`.
- [ ] No rule asks for a hand-off note: `handoff.md` and `/dev handoff` are
  gone, and the global `CLAUDE.md` gains compaction instructions naming what
  the summary keeps - the task and plan item in progress, open MR/PRs, and
  user decisions not yet stored. Approach: the instructions' form from the
  Claude Code docs, then `SKILL.md`, every citation of `handoff.md` (`git
  grep`), and `install-dev.sh`'s minimal set with its test.
- [ ] A run keeps no ledger: after compaction the runner re-derives its
  scope's state from plans, task reports, git and MR/PR state, as § Sync
  does. Approach: `run.md` § Ledger, § Resolve 3 and each ledger clause,
  then the citations in `branch-plan.md`, `declarations.md`,
  `report-template.md`, `seat-permissions.md` with the permission
  template, `supervisor-runbook.md` and `agents/dev-implementer.md`.
- [ ] Projects declare no `Session:` tree and keep no `supervisor/`: neither
  the installer nor `worker-workspace.sh` writes an ignore line for them,
  and a project still declaring `Session:` keeps working. Approach:
  `declarations.md § Declared paths`, `plan.md`, `start.md § 3`,
  `rules/claude-md.md`, `MAINTENANCE.md` and its seeded copy, the two
  scripts and their tests, `.gitignore`, `.claude/CLAUDE.md`, `LAYOUT.md`.
- [ ] An explanation the user gives or a conclusion an agent reaches goes,
  on the user's approval, to the home that owns its kind: `CLAUDE.md` for
  conventions and project details, `DESIGN.md` for architecture, the plans
  tree for planned changes, `<docs>` or its references for behavior.
  Approach: `rules/writing-artifacts.md § One home per finding`, then
  `CLAUDE.md § Approval and persistence` citing it; no new file.
- [ ] A question those homes already settle is not raised again: the runner
  and the session check them before asking the user, and the code reviewer
  checks them before raising a finding. Approach: `run.md § Question
  resolution`, `CLAUDE.md § Scope`, `agents/code-reviewer.md § Inputs`.
- [ ] A project declares a `CI wait:` command in `§ Agent toolchain` - `gh pr
  checks <n> --watch` on GitHub, its GitLab form beside it - which the
  permission pre-flight reads with the other declared commands. Approach:
  `declarations.md § Declared commands`, `toolchain.md`, `start.md`,
  `migrate.md`, `seat-permissions.md` and the permission template,
  `preflight-permissions.sh` with its test, then `.claude/CLAUDE.md`.
- [ ] Waiting on CI runs the declared CI wait once, in the background, and
  its exit notification carries pass or fail; no rule polls the state
  check, which stays the read of merged state and head sha. Approach:
  `git-workflow.md § Merge order`, `finish.md § 3` step 3, `run.md
  § Boundary verification` 4, then `supervisor-runbook.md`.
- [ ] The project sets the review's cost: a `review:` line in `CLAUDE.md
  § Conventions` names the code reviewer's model and effort, which the
  runner sets on every reviewer dispatch; absent, the definition's pins
  hold. Approach: `verification-policy.md § Effort mechanics` and
  `§ Models`, `run.md § Close` 1 and `§ Batch close` 1, `migrate.md`'s
  conventions list.
- [ ] A change is reviewed once: the batch-close review covers the folded
  branches and cross-branch concerns, never re-checking a reviewed branch
  against its plan, and a release runs no code review. Approach: `run.md
  § Batch close` 1, `agents/code-reviewer.md § Steps` 4,
  `verification-policy.md § Close folding`, then `release.md` steps 3
  and 4 and § Rules.
- [ ] A weekly cloud routine audits this repository against Claude Code's
  current defaults and docs and opens a plan PR adding each new finding as
  a line in a backlog `MAINTENANCE.md` gains, skipping a line already listed
  and a question item 6's homes settle; no PR when nothing is new.
  Approach: the backlog section and the routine's prompt in
  `MAINTENANCE.md`; the user then creates the routine with `/schedule`.
- [ ] `DESIGN.md` describes the live re-brief in place of the session file,
  the run without a ledger and one review per change.
  Approach: `DESIGN.md` § Self-enforcement and § Git & delivery model.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- Item 1 (source): On a compacted or resumed start, the SessionStart hook
  injects the branch, its working-tree state, its recent commits and the
  first open item of each plan the branch touched.
- Item 2 (drop): The Stop hook nudges a hand-off note, the PreCompact hook
  saves the tree to a session file, and the installer ships both with the
  context-fill helper.
- Item 3 (drop): `/dev handoff` writes the session's hand-off note, and
  `--minimal` ships `handoff.md`.
- Item 4 (drop): The supervisor's ledgers sit in `supervisor/` beside the
  session tree.
- Item 5 (drop): A project declares a `Session:` tree, which a `--project`
  install ignores with `supervisor/` beside it.
- Item 6 (source): An explanation or conclusion goes, on the user's
  approval, to the home owning its kind: `CLAUDE.md`, `DESIGN.md`, the
  plans tree, or the docs home and its references.
- Item 8 (source): A project declares its CI wait command in its
  `§ Agent toolchain`.
- Item 9 (probe): The GitHub CI wait, `gh pr checks <n> --watch`, exits 0
  when every check passes and non-zero when one fails.
- Item 10 (source): A `review:` line in `CLAUDE.md § Conventions` sets the
  code reviewer's model and effort.
- Item 12 (source): A weekly cloud routine audits the repository against
  Claude Code's current defaults and docs and adds each new finding to the
  backlog in `MAINTENANCE.md`, which keeps the routine's prompt.

## Proven

- `dev-session-brief.sh` runs on SessionStart under the `compact|resume`
  matcher: `settings.json`, `scripts/test/dev-session-brief.test.sh`
