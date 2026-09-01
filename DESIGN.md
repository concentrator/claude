# Environment design

Architecture of the `~/.claude` configuration: the components, how they
relate, and the invariants that keep them coherent.

## Components

What each part contributes; the inventory itself is § Tree-map.

- **CLAUDE.md** - global operating instructions, loaded every session.
  Maintenance: `rules/claude-md.md`.
- **rules/** - convention rules loaded as memory, path-scoped. The DEV
  process rules live as `skills/dev/` companions, not here.
- **skills/** - invocable capabilities. `skills/dev/` is the `/dev` router
  + its inert mode-file companions (the DEV toolset); the rest are
  standalone reference skills. Authoring: `skills/skill-creator/`,
  `skills/writing-skills/`, `rules/skills.md`.

## Self-hosting layout

This repo is consumed as `~/.claude`, so a normal project's `.claude/`
is the repo root here. Foundational DEV files
(`REQUIREMENTS.md`, `DESIGN.md`, `MAINTENANCE.md`) sit at
the root, not in a nested `.claude/`. The nested `.claude/` holds only Claude Code's
project settings, at the path the tool fixes. DEV artifacts
sit under `dev/` as in every adopter.

## Tree-map

Tracked dirs and notable files; harness-managed state (`projects/`,
`cache/`, `shell-snapshots/`, `plugins/`, logs, …) is gitignored.

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
│   ├── dev-branch-guard.sh       # PreToolUse branch-guard (no trunk mutations)
│   ├── dev-branch-state.sh       # UserPromptSubmit ambient branch/tree state
│   ├── dev-precompact-state.sh   # PreCompact session-state writer
│   ├── dev-secrets-guard.sh      # PreToolUse secrets guard
│   └── secret-patterns.sh        # the secret predicate (one home, sourced)
├── scripts/
│   ├── ci/                       # Tier-1 checks + run-all.sh
│   ├── context-cost.py           # session context cost + attribution
│   ├── install-dev.sh            # toolset installer (global or --project)
│   ├── model-quota.sh            # pinned-dispatch quota gate
│   └── test/                     # script tests + run-all.sh
├── .claude/
│   └── settings.json             # project tier, tracked - push carve-out, durable allows, model
├── dev/                          # DEV artifacts (session/, supervisor/ gitignored)
│   ├── plans/                    # planning hierarchy
│   │   ├── ROADMAP.md            # cross-R index - see skills/dev/plan.md
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
    │   ├── feat.md fix.md refactor.md write-plan.md finish.md handoff.md release.md auto.md   # execution
    │   ├── supervise.md docs.md  # supervised delivery, docs layer
    │   ├── brainstorm.md migrate.md start.md   # shape + adoption
    │   └── companions/           # declaration syntax, documentation framework, prompt templates, verification-policy, migration docs, secrets policy
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

Trunk-based development, per `skills/dev/git-workflow.md`.

The unit of delivery is the batch, and mode is orthogonal to it:
delivery is uniform, verification differs
(`skills/dev/branch-plan.md § Agentic execution`). Releases tag the trunk
(`skills/dev/git-workflow.md § Releases`).

Standard: Trunk-Based Development / GitHub Flow (trunkbaseddevelopment.com,
dora.dev); tag-on-trunk releases (Pro Git, git-scm.com); coherence via
feature flags / branch-by-abstraction (Fowler); host enforcement per
GitHub Docs.

## Self-enforcement

Two tiers gate every change into `main` (the CI tiers are built for
`~/.claude`; the hooks ship to adopters via `install-dev.sh`):

- **Tier-1 - mechanical CI.** `scripts/ci/*.sh`, and the script tests in
  `scripts/test/`, run in `.github/workflows/ci.yml` on
  `pull_request` and locally in the advisory `.githooks/pre-push` via
  `core.hooksPath`; either failing blocks the push or the merge. They
  hard-fail a PR on:
  a cap violation, a stray top-level file, a plan-integrity break, an
  unarchived closed initiative (`check-archival`), a
  `TODO`/`FIXME`/`XXX` marker in code, an expired reference, a dated
  accretion marker (`check-accretion`), an oversized code file or
  function (`check-code-size`, allowlist-backed), an em dash
  (`check-no-em-dash`), a tracked secret (`check-secrets`, sharing the
  hook predicate), a stale or unresolvable batch ref
  (`check-batch-tags`, local-only: skips where refs are hidden), or an
  unconfigured context budget or bare `Bash(git:*)` grant
  (`check-settings`). `main` is protected: a
  merge needs a PR with `tier1` green, `enforce_admins` on.
- **Tier-2 - AI review.** `MAINTENANCE.md § Tier-2 AI review` applies its
  concerns to the diff at branch close (`skills/dev/branch-plan.md
  § Closing routine`); they are enumerated there and nowhere else.

PreToolUse hooks (`dev-branch-guard`, `dev-secrets-guard`) guard ahead
of both tiers: no trunk writes, commits, pushes or force pushes, no
secrets into tracked files or commits; the secrets guard fails closed
without its pattern library. `dev-branch-state`
(UserPromptSubmit) keeps branch and tree state in front of the session;
`dev-precompact-state` (PreCompact) saves it to the session file for
the re-brief after compaction (`skills/dev/handoff.md`).

## Context budget

`autoCompactWindow` caps the working context, so cost stops tracking
session length; the gates above judge changes, not sessions.

## Invariants

- Every skill is reachable, documented, and non-duplicative.
- No workflow contains a dead-end or an unbounded loop.
- Rules and CLAUDE.md reference only existing paths.
- Serial DEV behaviors stay unchanged unless an initiative changes them.

## Decisions

Architecture Decision Records, when needed, live in `adr/` (lazy,
per `skills/dev/layout.md`).
