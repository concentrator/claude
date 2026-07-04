# Claude Code Environment

Portable, version-controlled Claude Code configuration: the
instructions, rules, skills, agents, and settings behind a spec-driven
development workflow. Cloned as `~/.claude`, it applies to every
project on the machine.

## Contents

| Path | Role |
|---|---|
| `CLAUDE.md` | Global operating instructions, loaded every session |
| `settings.json` | Global Claude Code config: permissions, hooks, model, plugins |
| `rules/` | Personal convention rules: git discipline, JS style, CLAUDE.md/skill maintenance (path-scoped) |
| `skills/` | Invocable capabilities — `dev/` is the /dev router + its mode-file companions (the DEV toolset); plus reference skills |
| `agents/` | Custom agents (e.g. branch-close code reviewer) |
| `REQUIREMENTS.md` | What this environment is for and how success is judged |
| `DESIGN.md` | Architecture, full tree-map, self-hosting layout |
| `MAINTENANCE.md` | Sanity routine: cleanup, repair, allow-list hygiene, skill audits |
| `plans/` | This repo's own planning artifacts — indexes and per-initiative `R-XXX-<slug>/` dirs (layout: `skills/dev/plan.md`) |

## Workflow

Two modes, defined in `CLAUDE.md`:

- **VIBE** (default) — freestyle, no ceremony.
- **DEV** — entered via `/dev`: initiatives (requirements) → tasks →
  branch plans → commits. Every level traceable
  (`R-XXX → T-XXX → branch`). Execution is manual
  (`/dev code`, one branch at a time) or agentic (`/dev auto`, a batch
  of branches run by subagents between checkpoints, on permission
  rails). See `skills/dev/plan.md` and `skills/dev/branch-plan.md`.

## Self-hosting

This repo manages itself with the same DEV discipline it provides:
changes to the environment flow through `plans/` initiatives like any
other project. Because the repo root *is* the `.claude/` directory, the
foundational files live at the root — see
`DESIGN.md § Self-hosting layout`.

## Setup on a new machine

1. Clone to `~/.claude`.
2. Start any Claude Code session — marketplace plugins re-download and
   local state (caches, `*.local.json` overrides) recreates on first
   run; nothing else to install.
3. Project-specific skills may be symlinked into `skills/` from their
   own repos; clone those repos to matching paths if needed.

## Installing the toolset elsewhere

To give another machine or project the DEV toolset — the `/dev` router, its
mode-file companions, the bundled dependency skills, and the branch-guard
hook — run the installer from a checkout of this repo:

    scripts/install-dev.sh                   # into ~/.claude (global)
    scripts/install-dev.sh --project <path>  # into <path>/.claude

Global install serves a contributor who wants `/dev` everywhere; the
`--project` copy serves a repo's no-global contributors (skill precedence
means a contributor's own global copy still wins). The installer registers
the branch-guard hook in the target `settings.json` idempotently and never
ships the personal convention rules. Re-run it to refresh.
