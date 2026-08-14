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
| `settings.json` | Global Claude Code config: permissions, hooks, model, plugins |
| `rules/` | Personal convention rules: git discipline, JS style, CLAUDE.md/skill maintenance (path-scoped) |
| `skills/` | Invocable capabilities - `dev/` is the /dev router + its mode-file companions (the DEV toolset); plus reference skills |
| `agents/` | Custom agents (e.g. branch-close code reviewer) |
| `hooks/` | PreToolUse guards: no writes or commits on the trunk, no secrets into tracked files or commits |
| `scripts/` | `ci/` the Tier-1 mechanical gate (`run-all.sh`), `install-dev.sh`, `test/` the script tests |
| `.github/`, `.githooks/`, `.gitignore` | The CI gate on pull requests, its advisory local pre-push mirror, and the ignore rules for harness state |
| `REQUIREMENTS.md` | What this environment is for and how success is judged |
| `DESIGN.md` | Architecture, full tree-map, self-hosting layout |
| `MAINTENANCE.md` | The Tier-2 review concerns, plus the sanity routine: cleanup, repair, allow-list hygiene, skill audits |
| `plans/` | This repo's own planning artifacts: the roadmap index, per-initiative `R-XXX-<slug>/` dirs, and `archive/` for closed initiatives |

## Workflow

Two modes, defined in `CLAUDE.md`:

- **VIBE** (default) - freestyle, no ceremony.
- **DEV** - entered via `/dev`: initiatives (requirements) → tasks →
  branch plans → commits, every level traceable
  (`R-XXX → R<NNN>-T<NNN> → branch`). Task ids are composite, with the
  task counter scoped to its initiative, so the id routes to the
  artifacts: `R045-T001` lives in `plans/R-045-<slug>/`, or the same path
  under `archive/` once the initiative closes.

Planning takes two rounds: `/dev plan R` shapes an initiative,
`/dev plan R-XXX` details its tasks and branch plans. Execution is
manual (`/dev code`, one branch at a time), agentic (`/dev auto`, a
batch of branches run by subagents between checkpoints, on permission
rails), or supervised (`/dev supervise`, scoped delivery within declared
bounds). `/dev start`, `/dev migrate`, `/dev docs`, and `/dev release`
cover scaffolding a new project, adopting an existing one, the `docs/`
layer, and tagging a release. Command surface and mode files:
`skills/dev/SKILL.md`.

## Artifacts root

Two trees: guarded config - what instructs agents - under `.claude/`,
and agent-authored artifacts (`plans/`, `docs/`) under the **artifacts
root** a project declares as `DEV artifacts root:` in
`CLAUDE.md § Agent toolchain`. Absent a declaration the root is `dev/`.
Structure: `skills/dev/layout.md`; path resolution:
`skills/dev/plan.md § Where things live`.

## Self-hosting

This repo manages itself with the same DEV discipline it provides:
changes to the environment flow through `plans/` initiatives like any
other project. Because the repo root *is* the `.claude/` directory, the
foundational files live at the root and the declared artifacts root is
the repo root, so `plans/` sits beside them - see
`DESIGN.md § Self-hosting layout`.

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
accretion, batch-tags - the last two with self-tests), and the two
PreToolUse guards - run the installer from a checkout of this repo:

    scripts/install-dev.sh                   # into ~/.claude (global)
    scripts/install-dev.sh --project <path>  # into <path>/.claude

Global install serves a contributor who wants `/dev` everywhere; the
`--project` copy serves a repo's no-global contributors (skill precedence
means a contributor's own global copy still wins). The installer registers
the branch-guard and secrets-guard hooks in the target `settings.json`
idempotently and never ships the personal convention rules. Re-run it to
refresh.

It also writes outside the target `.claude/`, append-only in both cases:
an `@writing.md` import added to the target `CLAUDE.md`, and - for
`--project` - a `!`-allowlist line in the repo's root `.gitignore` for
each installed path that repo ignores, so the toolset stays committable.
The copied checks are yours to wire into CI; the installer ships them
without registering them.
