# Environment design

Architecture of the `~/.claude` configuration: the components, how they
relate, and the invariants that keep them coherent.

## Components

- **CLAUDE.md** - global operating instructions, loaded every session.
  Maintenance: `rules/claude-md.md`.
- **rules/** - path-scoped convention rules; the DEV process rules live
  in `skills/dev/`, not here.
- **skills/** - invocable capabilities: `skills/dev/`, the `/dev` router
  and its mode files (the DEV toolset), and standalone reference
  skills. Authoring: `rules/skills.md`.

## Self-hosting layout

This repo is consumed as `~/.claude`, so a project's `.claude/` is the
repo root here: `REQUIREMENTS.md`, `DESIGN.md` and `MAINTENANCE.md` sit
at the root, the nested `.claude/` holds only Claude Code's project
settings, and DEV artifacts sit under `dev/` as in every adopter.

## Tree-map

Tracked dirs and notable files; harness-managed state (`projects/`,
`cache/`, `plugins/`, logs) is gitignored.

```
~/.claude/
├── CLAUDE.md                     # global instructions, every session
├── writing.md                    # universal writing conventions (@imported by CLAUDE.md)
├── settings.json                 # global Claude Code config (tracked)
├── .gitignore
├── .env.example                  # worker-host tokens; `.env` is never tracked
├── README.md
├── REQUIREMENTS.md               # foundational requirements
├── DESIGN.md
├── MAINTENANCE.md                # sanity routine + Tier-2 AI review
├── .github/
│   └── workflows/ci.yml          # Tier-1 mechanical CI gate (on PRs)
├── .githooks/
│   └── pre-push                  # advisory local Tier-1 mirror
├── hooks/
│   ├── dev-branch-guard.sh       # PreToolUse: no trunk mutations
│   ├── dev-branch-state.sh       # UserPromptSubmit: branch/tree state
│   ├── dev-context-fill.sh       # context-fill percent helper
│   ├── dev-handoff-nudge.sh      # Stop: hand-off nudge
│   ├── dev-precompact-state.sh   # PreCompact: session state
│   ├── dev-session-brief.sh      # SessionStart: hand-off re-brief
│   ├── dev-secrets-guard.sh      # PreToolUse: secrets guard
│   └── secret-patterns.sh        # the secret predicate, sourced
├── scripts/
│   ├── ci/                       # Tier-1 checks + run-all.sh
│   ├── context-cost.py           # session context cost + attribution
│   ├── install-dev.sh            # toolset installer (global or --project)
│   ├── model-quota.sh            # pinned-dispatch quota gate
│   └── test/                     # script tests + run-all.sh
├── .claude/
│   └── settings.json             # project tier, tracked
├── dev/                          # DEV artifacts (session/, supervisor/ gitignored)
│   ├── plans/                    # planning hierarchy
│   │   ├── ROADMAP.md            # cross-R index: skills/dev/plan.md
│   │   ├── R<NNN>-<slug>/        # one dir per roadmap entry (initiative-time)
│   │   │   ├── requirements.md   # initiative requirements
│   │   │   ├── tasks.md          # this initiative's task index (lazy)
│   │   │   ├── R<NNN>-T<NNN>-<slug>.md
│   │   │   ├── R<NNN>-T<NNN>-<slug>.findings.md
│   │   │   └── batches/          # R<NNN>-B<NNN> manifests + reports (lazy)
│   │   └── archive/              # closed initiatives, frozen history
├── rules/                        # path-scoped convention rules
│   ├── claude-md.md              # CLAUDE.md maintenance rules
│   ├── writing-artifacts.md      # DEV-artifact writing rules (**/*.md; shipped)
│   ├── js.md                     # JS conventions (path-scoped)
│   └── skills.md                 # SKILL.md maintenance rules
├── agents/
│   └── code-reviewer.md          # branch-close quality review agent
└── skills/
    ├── dev/                      # the DEV toolset
    │   ├── SKILL.md              #   the router
    │   ├── plan.md branch-plan.md templates.md layout.md changelog.md git-workflow.md  # process rules
    │   ├── run.md feat.md fix.md refactor.md write-plan.md finish.md handoff.md release.md   # execution
    │   ├── brainstorm.md migrate.md start.md   # shape + adoption
    │   └── companions/           # declarations, docs framework, prompts, verification policy, runbook
    ├── test-driven-development/  # bundled dependency skills (installer ships these)
    ├── systematic-debugging/
    ├── verification-before-completion/SKILL.md
    ├── receiving-code-review/SKILL.md
    ├── dispatching-parallel-agents/SKILL.md
    ├── skill-creator/SKILL.md    # personal (skill authoring)
    └── writing-skills/           # personal
```

Skills symlinked from external repos are versioned there, not mapped.

## Planning model

Self-development uses the planning hierarchy per `skills/dev/plan.md`,
unchanged - structure is never simplified, only description detail. A
plan leaves planning by its cold read (`skills/dev/write-plan.md` step
6), the one record a run requires.

## Git & delivery model

Trunk-based development, per `skills/dev/git-workflow.md`.

Planned work runs through one flow, `skills/dev/run.md`: a runner
session dispatches seats - implementer and reviewer today -
each a subagent in its checkout with fixed inputs and a one-item
lifetime. Who holds the supervisor seat, the user or the runner, is
declared per project (`skills/dev/companions/declarations.md
§ Supervisor bounds`). The unit of delivery is the batch, a lone task a
batch of one (`skills/dev/branch-plan.md § Agentic execution`).
Releases tag the trunk (`skills/dev/git-workflow.md § Releases`).

Standard: Trunk-Based Development / GitHub Flow (trunkbaseddevelopment.com,
dora.dev); tag-on-trunk releases (Pro Git, git-scm.com).

## Self-enforcement

Two tiers gate every change into `main` (hooks ship to adopters via
`install-dev.sh`):

- **Tier-1 - mechanical CI.** `scripts/ci/*.sh`, and the script tests in
  `scripts/test/`, run in `.github/workflows/ci.yml` on
  `pull_request` and locally in the advisory `.githooks/pre-push` via
  `core.hooksPath`; either failing blocks the push or the merge. One
  `check-*.sh` each hard-fails a PR on: a cap violation, a stray
  top-level file, a plan-integrity break, an unarchived closed
  initiative, a `TODO`/`FIXME`/`XXX` marker in code, an expired
  reference, a dated accretion marker, an oversized code file or
  function, an em dash, a tracked secret (the hook's predicate), a
  stale batch ref (local-only), or an unconfigured context budget or
  bare `Bash(git:*)` grant. `main` is protected: a merge needs a PR
  with `tier1` green, `enforce_admins` on.
- **Tier-2 - AI review.** `MAINTENANCE.md § Tier-2 AI review` applies its
  concerns to the diff at branch close (`skills/dev/branch-plan.md
  § Closing routine`); they are enumerated there and nowhere else.

PreToolUse hooks guard ahead of both tiers: no trunk writes, commits
or pushes, force pushes nowhere, no secrets into tracked files or
commits (the secrets guard fails closed without its pattern library).
The state hooks keep branch and tree in view, save them to the session
file before compaction, and re-brief on resume from its last hand-off
block (`skills/dev/handoff.md`).

## Context budget

`autoCompactWindow` caps the working context, so cost stops tracking
session length; the gates judge changes, not sessions.

## Invariants

- Every skill is reachable, documented, and non-duplicative.
- No workflow contains a dead-end or an unbounded loop.
- Rules and CLAUDE.md reference only existing paths.
- DEV behaviors change only through an initiative.

## Decisions

Architecture Decision Records, when needed, live in `adr/` (lazy,
per `skills/dev/layout.md`).

- The `agentic:`/`supervised:` plan stamps went with the second
  runner: each certified readiness for a flow with no one to ask, and
  in one flow whose seats can ask, the cold read at the planner's exit
  is the only admission a plan needs.
