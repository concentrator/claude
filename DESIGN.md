# Environment design

Architecture of the `~/.claude` configuration: the components, how they
relate, and the invariants that keep them coherent.

## Components

- **CLAUDE.md** — global operating instructions, loaded every session.
  Maintenance: `rules/claude-md.md`.
- **rules/** — personal convention rules (`git-workflow` always-on; `js`,
  `skills`, `claude-md` path-scoped), loaded as memory. The DEV process
  rules now live as `skills/dev/` companions.
- **skills/** — invocable capabilities. `skills/dev/` is the `/dev` router
  + its inert mode-file companions (the DEV toolset); the rest are
  standalone reference skills. Authoring: `skills/skill-creator/`,
  `skills/writing-skills/`, `rules/skills.md`.
- **commands/**, **agents/** — optional slash commands and custom agents.
- **settings.json** — global Claude Code config. Project-scoped settings
  for this repo: `.claude/settings.local.json`.
- **plans/** — this environment's own planning hierarchy
  (`skills/dev/plan.md`).
- **MAINTENANCE.md** — sanity routine + the Tier-2 AI review
  (`## Self-enforcement`).
- **scripts/ci/**, **.github/**, **.githooks/**, **maintenance.jsonl** —
  the self-enforcement layer (`## Self-enforcement`).

## Self-hosting layout

This repo is consumed as `~/.claude`, so the directory that is `.claude/`
in a normal project is the repo root here. Foundational DEV files
(`REQUIREMENTS.md`, `DESIGN.md`, `MAINTENANCE.md`, `plans/`) sit at
the root, not in a nested `.claude/`. The nested `.claude/` holds only Claude Code's
project settings, whose location is fixed by the tool.

## Tree-map

All configuration dirs and files. Harness-managed state (`projects/`,
`cache/`, `shell-snapshots/`, `plugins/`, logs, …) is gitignored and
excluded — see `.gitignore`.

```
~/.claude/
├── CLAUDE.md                     # global instructions, every session
├── settings.json                 # global Claude Code config (tracked)
├── .gitignore
├── .gitattributes                # maintenance.jsonl merge=union (append-only ledger)
├── README.md                     # project readme
├── REQUIREMENTS.md               # foundational requirements
├── DESIGN.md                     # this file
├── MAINTENANCE.md                # sanity routine + Tier-2 AI review
├── maintenance.jsonl             # Tier-2 review ledger (append-only, union-merged)
├── .github/
│   └── workflows/ci.yml          # Tier-1 mechanical CI gate (on PRs)
├── .githooks/
│   └── pre-push                  # advisory local Tier-1 mirror
├── hooks/
│   ├── dev-branch-guard.sh       # PreToolUse branch-guard (no writes on trunk)
│   └── dev-secrets-guard.sh      # PreToolUse secrets guard (no secrets in tracked files or commits)
├── scripts/
│   ├── ci/                       # Tier-1 checks + run-all.sh
│   ├── install-dev.sh            # toolset installer (global or --project)
│   └── test/                     # script tests (install-dev.test.sh)
├── .claude/
│   └── settings.local.json       # project-tier local settings (gitignored)
├── plans/                        # planning hierarchy
│   ├── ROADMAP.md                # cross-R index — see skills/dev/plan.md
│   ├── REQ-XXX.md                # four-level-era requirements (closed: history; open → R stubs on approval)
│   └── R-XXX-<slug>/             # one dir per roadmap entry (initiative-time)
│       ├── requirements.md       # initiative requirements
│       ├── tasks.md              # this initiative's task index (lazy)
│       ├── T-XXX-<slug>.md
│       ├── T-XXX-<slug>.findings.md
│       └── batches/              # B-XXX manifests + reports (lazy)
├── rules/                        # personal convention rules
│   ├── claude-md.md              # CLAUDE.md maintenance rules
│   ├── git-workflow.md           # trunk/branch/commit/PR discipline (always-on)
│   ├── js.md                     # JS conventions (path-scoped)
│   └── skills.md                 # SKILL.md maintenance rules
├── agents/
│   └── code-reviewer.md          # branch-close quality review agent
└── skills/
    ├── dev/                      # the /dev router + inert mode-file companions (the DEV toolset)
    │   ├── SKILL.md              #   the router
    │   ├── plan.md branch-plan.md templates.md layout.md changelog.md git-workflow.md  # process rules
    │   ├── feat.md fix.md refactor.md write-plan.md finish.md release.md auto.md        # execution
    │   ├── brainstorm.md migrate.md start.md   # shape + adoption
    │   └── companions/           # prompt templates, verification-policy, migration docs, mockup scripts
    ├── test-driven-development/  # bundled dependency skills (installer ships these) + testing-anti-patterns
    ├── systematic-debugging/     # + root-cause-tracing, defense-in-depth, condition-based-waiting, find-polluter.sh
    ├── verification-before-completion/SKILL.md
    ├── receiving-code-review/SKILL.md
    ├── dispatching-parallel-agents/SKILL.md
    ├── skill-creator/SKILL.md    # personal (skill authoring)
    └── writing-skills/           # personal + persuasion-principles, anthropic-best-practices, testing-skills-with-subagents, examples/
```

Project-specific skills symlinked into `skills/` from external repos
(currently the two wallarm-* ones from `~/wallarm_pure/skills`) are not
part of this configuration: gitignored, excluded from the map, versioned
in their own repo.

## Planning model

Self-development uses the planning hierarchy per `skills/dev/plan.md`,
unchanged — structure is never simplified, only description detail.

## Git & delivery model

Trunk-based development: `main` is the protected, always-releasable
trunk; every change lands via a short-lived branch and a CI-gated PR,
no long-lived branches (`rules/git-workflow.md`).

The unit of delivery is the **batch** — one or more tasks that must land
together to keep `main` coherent, shipped as one PR (a lone task is a
batch of one; coupled tasks integrate on a short-lived `batch/B-XXX`).
Mode is orthogonal — delivery is uniform, verification differs (auto:
agentic checkpoint; manual: human PR review). Releases tag the trunk, no
release branch (`skills/dev/branch-plan.md § Agentic execution`).

Standard: Trunk-Based Development / GitHub Flow (trunkbaseddevelopment.com,
dora.dev); tag-on-trunk releases (Pro Git, git-scm.com); coherence via
feature flags / branch-by-abstraction (Fowler); host enforcement per
GitHub Docs.

## Self-enforcement

Two tiers gate every change into `main` (built for `~/.claude` only;
adopter infra is a later initiative):

- **Tier-1 — mechanical CI.** `scripts/ci/*.sh` (run by
  `.github/workflows/ci.yml` on `pull_request`, and locally by the
  advisory `.githooks/pre-push` via `core.hooksPath`) hard-fail a PR on:
  a cap violation, a stray top-level file, a plan-integrity break, a
  `TODO`/`FIXME`/`XXX` marker in code, an expired reference, or a
  missing ledger stamp.
- **Tier-2 — AI review.** `MAINTENANCE.md § Tier-2 AI review` applies the
  rule set (compliance, cross-file integrity, cleanup, reference
  freshness) to the diff and appends a stamp to `maintenance.jsonl` — an
  append-only ledger keyed by content-tip SHA (union-merged, so
  concurrent stamps don't conflict). `check-ledger.sh` (Tier-1) refuses
  any PR whose delivered tree lacks a clear stamp.

The workflow triggers on `pull_request` only, so it never re-judges the
direct-to-main bootstrap history.

Ahead of both tiers, PreToolUse hooks (`dev-branch-guard`,
`dev-secrets-guard`) add a local pre-emptive guard: no writes or commits on
the trunk, and no secrets into tracked files or commits.

## Invariants

- Every skill is reachable, documented, and non-duplicative.
- No workflow contains a dead-end or an unbounded loop.
- Rules and CLAUDE.md reference only existing paths.
- Serial DEV behaviors stay behaviorally unchanged unless a REQ changes
  them.

## Decisions

Architecture Decision Records, when needed, live in `adr/` (lazy,
per `skills/dev/layout.md`).
