# Claude Code Environment

Portable, version-controlled Claude Code configuration: the
instructions, rules, skills, agents, hooks, and settings behind a
spec-driven development workflow. Cloned as `~/.claude`, it applies to
every project on the machine.

## Contents

| Path | Role |
|---|---|
| `README.md` | This file: what the repo is, how to set it up, how the workflow runs |
| `CLAUDE.md` | Global operating instructions, loaded every session |
| `writing.md`, `delegation.md` | Conventions `@import`ed by `CLAUDE.md`, so they load every session: prose rules, subagent pre-authorisation |
| `settings.json` | Global Claude Code config: permissions, hooks, plugins, session defaults |
| `.claude/settings.json` | Project-tier Claude Code config: the push deny carve-out, branch-push allows, durable tool allows, model override |
| `rules/` | Personal convention rules: git discipline, JS style, CLAUDE.md/skill maintenance (path-scoped) |
| `skills/` | Invocable capabilities - `dev/` is the /dev router + its mode-file companions (the DEV toolset); plus reference skills |
| `agents/` | Custom agents (e.g. branch-close code reviewer) |
| `hooks/` | PreToolUse guards (no trunk writes, commits, or pushes; no secrets into tracked files or commits), the UserPromptSubmit branch-state line, and the PreCompact session-state writer |
| `scripts/` | `ci/` the Tier-1 mechanical gate (`run-all.sh`), `install-dev.sh`, `context-cost.py` the session context-cost reporter, `test/` the script tests |
| `.github/`, `.githooks/`, `.gitignore` | The CI gate on pull requests, its advisory local pre-push mirror, and the ignore rules for harness state |
| `REQUIREMENTS.md` | What this environment is for and how success is judged |
| `DESIGN.md` | Architecture, full tree-map, self-hosting layout |
| `MAINTENANCE.md` | The Tier-2 review concerns, plus the sanity routine: cleanup, repair, allow-list hygiene, skill audits |
| `dev/` | This repo's own DEV artifacts: `plans/` (the roadmap index, per-initiative `R<NNN>-<slug>/` dirs, `archive/` for closed initiatives) and the gitignored `session/` |

## Workflow

Two modes, defined in `CLAUDE.md`:

- **VIBE** (default) - freestyle, no ceremony.
- **DEV** - entered via `/dev`: initiatives (requirements) → tasks →
  branch plans → commits, every level traceable
  (`R<NNN> → R<NNN>-T<NNN> → branch`). Task ids are composite, with the
  task counter scoped to its initiative, so the id routes to the
  artifacts: `R062-T001` lives in `dev/plans/R062-<slug>/`, or the same path
  under `archive/` once the initiative closes.

Planning takes two rounds: `/dev plan R` shapes an initiative,
`/dev plan R<NNN>` details its tasks and branch plans. Execution is
manual (`/dev code`, one branch at a time), agentic (`/dev auto`, a
batch of branches run by subagents between checkpoints, on permission
rails), or supervised (`/dev supervise`, scoped delivery within declared
bounds). `/dev ship` takes a landed branch to a merged MR/PR;
`/dev handoff` writes the session's hand-off note, which with the
PreCompact hook's tree block carries state across compaction.
`/dev start`, `/dev migrate`, `/dev docs`, and `/dev release` cover
scaffolding a new project, adopting an existing one, the `dev/docs/`
layer, and tagging a release. Command surface and mode files:
`skills/dev/SKILL.md`.

## DEV artifacts

Two trees: guarded config - what instructs agents - under `.claude/`,
and agent-authored artifacts under `dev/` (`plans/`, `docs/`, the
gitignored `session/`), the same in every project. Structure:
`skills/dev/layout.md`; paths: `skills/dev/plan.md § Where things
live`.

## Self-hosting

This repo manages itself with the same DEV discipline it provides:
changes to the environment flow through `dev/plans/` initiatives like
any other project. Because the repo root *is* the `.claude/` directory,
the foundational files live at the root and the DEV artifacts sit
beside them under `dev/` - see `DESIGN.md § Self-hosting layout`.

## Setup on a new machine

1. Clone to `~/.claude`.
2. Start any Claude Code session - marketplace plugins re-download and
   local state (caches, `*.local.json` overrides) recreates on first
   run; nothing else to install.
3. Arm the advisory local gate: `git config core.hooksPath .githooks`,
   once per clone, so `.githooks/pre-push` runs the Tier-1 checks and the
   test suites before a push leaves the machine.
4. Project-specific skills may be symlinked into `skills/` from their
   own repos; clone those repos to matching paths if needed.

## Installing the toolset elsewhere

To give another machine or project the DEV toolset - the `/dev` router,
its mode-file companions, the bundled dependency skills, the writing
conventions, the project-agnostic Tier-1 checks (code-size, em-dash,
accretion, batch-tags - the last two with self-tests), the two
PreToolUse guards, and the branch-state line - run the installer from a
checkout of this repo:

    scripts/install-dev.sh                   # into ~/.claude (global)
    scripts/install-dev.sh --project <path>  # into <path>/.claude

Global install serves a contributor who wants `/dev` everywhere; the
`--project` copy serves a repo's no-global contributors (skill precedence
means a contributor's own global copy still wins). The installer registers
the branch-guard, secrets-guard, and branch-state hooks in the target
`settings.json` idempotently, copies the session-state writer beside
them unregistered (the branch-state hook asks it for the session file's
path), and never ships the personal convention rules. Re-run it to
refresh.

It also writes outside the target `.claude/`, append-only in both cases:
an `@writing.md` import added to the target `CLAUDE.md`, and - for
`--project` - a `!`-allowlist line in the repo's root `.gitignore` for
each installed path that repo ignores, so the toolset stays committable,
plus an ignore line for `dev/session/`, the per-session
state files (`skills/dev/handoff.md`).
The copied checks are yours to wire into CI; the installer ships them
without registering them.
