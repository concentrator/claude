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
| `rules/` | Always-loaded rules: planning hierarchy, branch plans, project layout, CLAUDE.md/skill maintenance |
| `skills/` | Invocable capabilities — the DEV workflow engine and supporting skills |
| `agents/` | Custom agents (e.g. branch-close code reviewer) |
| `requirements.md` | What this environment is for and how success is judged |
| `design.md` | Architecture, full tree-map, self-hosting layout |
| `maintenance.md` | Sanity routine: cleanup, repair, allow-list hygiene, skill audits |
| `plans/` | This repo's own planning artifacts (`REQ-XXX`, roadmap, tasks) |

## Workflow

Two modes, defined in `CLAUDE.md`:

- **VIBE** (default) — freestyle, no ceremony.
- **DEV** — entered via `/dev`: requirements → roadmap → tasks →
  branch plans → commits. Every level traceable
  (`REQ-XXX → R-XXX → T-XXX → branch`). Execution is manual
  (`/dev code`, one branch at a time) or agentic (`/dev auto`, a batch
  of branches run by subagents between checkpoints, on permission
  rails). See `rules/planning.md` and `rules/branch-plan.md`.

## Self-hosting

This repo manages itself with the same DEV discipline it provides:
changes to the environment flow through `plans/REQ-XXX` like any other
project. Because the repo root *is* the `.claude/` directory, the
foundational files live at the root — see
`design.md § Self-hosting layout`.

## Setup on a new machine

1. Clone to `~/.claude`.
2. Start any Claude Code session — marketplace plugins re-download and
   local state (caches, `*.local.json` overrides) recreates on first
   run; nothing else to install.
3. Project-specific skills may be symlinked into `skills/` from their
   own repos; clone those repos to matching paths if needed.
