# Environment design

Architecture of the `~/.claude` configuration: the components, how they
relate, and the invariants that keep them coherent.

## Components

What each part contributes; the inventory itself is § Tree-map.

- **CLAUDE.md** - global operating instructions, loaded every session.
  Maintenance: `rules/claude-md.md`.
- **rules/** - personal convention rules loaded as memory, `git-workflow`
  always-on and the rest path-scoped. The DEV process rules live as
  `skills/dev/` companions, not here.
- **skills/** - invocable capabilities. `skills/dev/` is the `/dev` router
  + its inert mode-file companions (the DEV toolset); the rest are
  standalone reference skills. Authoring: `skills/skill-creator/`,
  `skills/writing-skills/`, `rules/skills.md`.

## Self-hosting layout

This repo is consumed as `~/.claude`, so the directory that is `.claude/`
in a normal project is the repo root here. Foundational DEV files
(`REQUIREMENTS.md`, `DESIGN.md`, `MAINTENANCE.md`) sit at
the root, not in a nested `.claude/`. The nested `.claude/` holds only Claude Code's
project settings, whose location is fixed by the tool. The artifacts
root declared in `CLAUDE.md § Agent toolchain` is the repo root, so
artifacts resolve under the same rule as adopters, not as a special
case.

## Tree-map

All configuration and artifact dirs and files. Harness-managed state (`projects/`,
`cache/`, `shell-snapshots/`, `plugins/`, logs, …) is gitignored and
excluded - see `.gitignore`.

```
~/.claude/
├── CLAUDE.md                     # global instructions, every session
├── delegation.md                 # subagent pre-authorisation (@imported by CLAUDE.md)
├── writing.md                    # writing conventions (@imported by CLAUDE.md)
├── settings.json                 # global Claude Code config (tracked)
├── .gitignore
├── README.md                     # project readme
├── REQUIREMENTS.md               # foundational requirements
├── DESIGN.md                     # this file
├── MAINTENANCE.md                # sanity routine + Tier-2 AI review
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
│   └── test/                     # script tests + run-all.sh
├── .claude/
│   └── settings.local.json       # project-tier local settings (gitignored)
├── plans/                        # planning hierarchy
│   ├── ROADMAP.md                # cross-R index - see skills/dev/plan.md
│   ├── R-XXX-<slug>/             # one dir per roadmap entry (initiative-time)
│   │   ├── requirements.md       # initiative requirements
│   │   ├── tasks.md              # this initiative's task index (lazy)
│   │   ├── R<NNN>-T<NNN>-<slug>.md
│   │   ├── R<NNN>-T<NNN>-<slug>.findings.md
│   │   └── batches/              # B-XXX manifests + reports (lazy)
│   └── archive/                  # closed initiatives, frozen history
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
    │   ├── supervise.md secrets.md docs.md     # supervised delivery, secrets policy, docs layer
    │   ├── brainstorm.md migrate.md start.md   # shape + adoption
    │   └── companions/           # declaration syntax, documentation framework, prompt templates, verification-policy, migration docs, mockup scripts
    ├── test-driven-development/  # bundled dependency skills (installer ships these) + testing-anti-patterns
    ├── systematic-debugging/     # + root-cause-tracing, defense-in-depth, condition-based-waiting, find-polluter.sh
    ├── verification-before-completion/SKILL.md
    ├── receiving-code-review/SKILL.md
    ├── dispatching-parallel-agents/SKILL.md
    ├── skill-creator/SKILL.md    # personal (skill authoring)
    └── writing-skills/           # personal + persuasion-principles, anthropic-best-practices, testing-skills-with-subagents, examples/
```

Project-specific skills symlinked into `skills/` from external repos
(gitignored via `skills/wallarm-*`) are versioned in their own repo, so
the map excludes them.

## Planning model

Self-development uses the planning hierarchy per `skills/dev/plan.md`,
unchanged - structure is never simplified, only description detail.

## Git & delivery model

Trunk-based development: `main` is the protected, always-releasable
trunk; every change lands via a short-lived branch and a CI-gated PR,
no long-lived branches (`skills/dev/git-workflow.md`; repo pin:
`rules/git-workflow.md`).

The unit of delivery is the **batch** - one or more tasks that must land
together to keep `main` coherent, shipped as one PR (a lone task is a
batch of one; coupled tasks integrate on a short-lived
`batch/R<NNN>-B-XXX`). Mode is orthogonal - delivery is uniform,
verification differs (auto: agentic checkpoint; manual: human PR
review). Releases tag the trunk, no release branch
(`skills/dev/branch-plan.md § Agentic execution`).

Standard: Trunk-Based Development / GitHub Flow (trunkbaseddevelopment.com,
dora.dev); tag-on-trunk releases (Pro Git, git-scm.com); coherence via
feature flags / branch-by-abstraction (Fowler); host enforcement per
GitHub Docs.

## Self-enforcement

Two tiers gate every change into `main` (the CI tiers are built for
`~/.claude`; the PreToolUse hooks ship to adopters via `install-dev.sh`):

- **Tier-1 - mechanical CI.** `scripts/ci/*.sh`, and the script tests in
  `scripts/test/`, run together in `.github/workflows/ci.yml` on
  `pull_request` and locally in the advisory `.githooks/pre-push` via
  `core.hooksPath`; either failing blocks the push or the merge. The
  checks hard-fail a PR on:
  a cap violation, a stray top-level file, a plan-integrity break, a
  `TODO`/`FIXME`/`XXX` marker in code, an expired reference, a dated
  accretion marker (`check-accretion`), an oversized code file or
  function (`check-code-size`, with an allowlist), an em dash
  (`check-no-em-dash`), or a stale or unresolvable batch ref, tag or
  branch (`check-batch-tags`, local-only: skips where refs are
  hidden).
- **Tier-2 - AI review.** `MAINTENANCE.md § Tier-2 AI review` applies its
  concern set to the diff as a mandatory step in the branch-close routine
  (`skills/dev/branch-plan.md § Closing routine`). The concerns are
  enumerated there and nowhere else.

The workflow triggers on `pull_request` only, so it never re-judges the
direct-to-main bootstrap history.

Ahead of both tiers, PreToolUse hooks (`dev-branch-guard`,
`dev-secrets-guard`) add a local pre-emptive guard: no writes or commits on
the trunk, and no secrets into tracked files or commits. The branch-guard
judges the real target, not the cwd branch.

## Invariants

- Every skill is reachable, documented, and non-duplicative.
- No workflow contains a dead-end or an unbounded loop.
- Rules and CLAUDE.md reference only existing paths.
- Serial DEV behaviors stay unchanged unless an initiative changes them.

## Decisions

Architecture Decision Records, when needed, live in `adr/` (lazy,
per `skills/dev/layout.md`).
