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
| `rules/` | Memory rules: planning hierarchy + templates, branch plans, project layout (path-scoped to plan sessions), CLAUDE.md/skill maintenance |
| `skills/` | Invocable capabilities — the DEV workflow engine and supporting skills |
| `agents/` | Custom agents (e.g. branch-close code reviewer) |
| `REQUIREMENTS.md` | What this environment is for and how success is judged |
| `DESIGN.md` | Architecture, full tree-map, self-hosting layout |
| `MAINTENANCE.md` | Sanity routine: cleanup, repair, allow-list hygiene, skill audits |
| `plans/` | This repo's own planning artifacts — indexes and per-initiative `R-XXX-<slug>/` dirs (layout: `rules/planning.md`) |

## Workflow

Two modes, defined in `CLAUDE.md`:

- **VIBE** (default) — freestyle, no ceremony.
- **DEV** — entered via `/dev`: initiatives (requirements) → tasks →
  branch plans → commits. Every level traceable
  (`R-XXX → T-XXX → branch`). Execution is manual
  (`/dev code`, one branch at a time) or agentic (`/dev auto`, a batch
  of branches run by subagents between checkpoints, on permission
  rails). See `rules/planning.md` and `rules/branch-plan.md`.

## Self-hosting

This repo manages itself with the same DEV discipline it provides:
changes to the environment flow through `plans/` initiatives like any
other project. Because the repo root *is* the `.claude/` directory, the
foundational files live at the root — see
`DESIGN.md § Self-hosting layout`.

## Embedding into a project

To give a project a self-contained copy of the DEV toolchain — so a
contributor without this global `~/.claude` can run `/dev` from the
project alone — vendor the portable core into its `.claude/`:

    scripts/vendor-toolchain.sh <target-project>

Run it from a checkout of this repo at the version you want to pin. It
copies the portable rules and skills plus a generic `CLAUDE.md` backbone
into `<target>/.claude/`, rewrites `~/.claude/…` paths to `.claude/…`,
namespaces the embedded skills `dev-*` (the `/dev` command is preserved),
excludes the self-hosting layer, and writes a version stamp
(`git describe`) for drift detection. The portable set is defined in
`plans/R-015-embeddable-dev/manifest.md`.

A contributor who also has this global `~/.claude` still gets the
project's pinned version: the global `dev` is embed-aware (it detects
`.claude/.dev-toolchain.json` and routes `/dev` into the project's
`dev-*` skills). After cloning, run `.claude/scripts/dev-embed-check.sh`
to confirm the global `dev` is recent enough.

To check whether an embedded project lags this toolchain, run
`scripts/dev-drift-check.sh <project>` from here. To update it in place,
re-vendor with `scripts/vendor-toolchain.sh --update <project>` — it
replaces the managed files (rules, `dev`/`dev-*` skills, check, stamp)
and leaves the project's own additions and `CLAUDE.md` untouched (a
refreshed backbone is written to `CLAUDE.md.new` if it changed).

## Setup on a new machine

1. Clone to `~/.claude`.
2. Start any Claude Code session — marketplace plugins re-download and
   local state (caches, `*.local.json` overrides) recreates on first
   run; nothing else to install.
3. Project-specific skills may be symlinked into `skills/` from their
   own repos; clone those repos to matching paths if needed.
