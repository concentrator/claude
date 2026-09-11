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
| `writing.md` | Universal writing conventions, `@import`ed by `CLAUDE.md` so they load every session |
| `settings.json` | Global Claude Code config: permissions, hooks, plugins, session defaults |
| `.claude/settings.json` | Project-tier Claude Code config: the push deny carve-out, branch-push allows, durable tool allows, model override |
| `rules/` | Path-scoped convention rules: the DEV-artifact writing rules (shipped by the installer), JS style, CLAUDE.md/skill maintenance |
| `skills/` | Invocable capabilities - `dev/` is the /dev router + its mode-file companions (the DEV toolset); beside it the bundled dependency skills the installer ships, the personal skills, and the worker-host runbook (`LAYOUT.md` marks each) |
| `agents/` | Subagent definitions for the seats of `/dev run`, one per seat the run dispatches (the roster: `skills/dev/run.md § Seats`): each declares the seat's tools and, where it sets one, its model, and carries its standing instructions. This repository's own - `install-dev.sh` copies none of them |
| `hooks/` | PreToolUse guards (no trunk writes, commits, or pushes; no secrets into tracked files or commits), the UserPromptSubmit branch-state line, the PreCompact session-state writer, the Stop hand-off nudge, and the SessionStart re-brief |
| `scripts/` | `ci/` the Tier-1 gate (`run-all.sh`) - the mechanical checks CI runs on every pull request; the two tiers: `DESIGN.md § Self-enforcement` - `install-dev.sh`, `context-cost.py` the session context-cost reporter, `model-quota.sh` the pinned-dispatch quota gate, `test/` the script tests, and the worker-host scripts, which `skills/worker-host/` documents: `provision-worker.sh` stands up the host from the operator's machine and sources `forge-keys.sh`, the operator's half of the forge key exchange; `worker-setup.sh` (system setup), `worker-credentials.sh` (forge keys and CLI auth) and `worker-workspace.sh` (repositories and per-project settings) run on the VM |
| `.github/`, `.githooks/`, `.gitignore` | The CI gate on pull requests, its advisory local pre-push mirror, and the ignore rules for harness state |
| `REQUIREMENTS.md` | What this environment is for and how success is judged |
| `DESIGN.md` | Architecture, self-hosting layout |
| `LAYOUT.md` | The repository's actual tree - the layout file `CLAUDE.md § Layout` declares; `scripts/ci/check-stray.sh` checks every tracked top-level entry against it |
| `MAINTENANCE.md` | The Tier-2 AI review's concerns, plus the sanity routine: cleanup, repair, allow-list hygiene, skill audits |
| `dev/` | This repo's own DEV artifacts: `plans/` (the roadmap index, per-initiative `R<NNN>-<slug>/` dirs, `archive/` for closed initiatives) and the gitignored `session/` and `supervisor/` |

## Workflow

Two modes, defined in `CLAUDE.md`:

- **VIBE** (default) - freestyle, no ceremony.
- **DEV** - entered via `/dev`: initiatives (requirements) → tasks →
  branch plans → commits, every level traceable
  (`R<NNN> → R<NNN>-T<NNN> → branch`). Task ids are composite, with the
  task counter scoped to its initiative, so the id routes to the
  artifacts: `R062-T001` lives in `R062-<slug>/` under the plans tree
  (§ DEV artifacts; `dev/plans/` here), or the same path under
  `archive/` once the initiative closes.

Planning takes two rounds: `/dev plan R` shapes an initiative,
`/dev plan R<NNN>` details its tasks and branch plans. Execution is
`/dev run`: a task, a batch or an initiative runs as dispatched seats -
subagents, each started fresh for one step and shut down at its exit -
under the supervisor the project declares, human or AI, within
declared bounds. `/dev ship` takes a landed branch to a merged MR/PR;
`/dev handoff` writes the session's hand-off note, which with the
PreCompact hook's tree block carries state across compaction (the
SessionStart hook re-injects the last hand-off block when the session
resumes or restarts after a compaction).
`/dev start`, `/dev migrate`, and `/dev release` cover
scaffolding a new project, adopting an existing one, and tagging a
release. Command surface and mode files:
`skills/dev/SKILL.md`.

## DEV artifacts

Two trees: guarded config - what instructs agents - under `.claude/`,
and agent-authored artifacts at the paths the project's root
`CLAUDE.md § Layout` declares, one line per key: `Docs:` the docs tree,
`Plans:` the planning tree, `Session:` the gitignored per-session state
files, `Layout:` the layout file holding the repository's actual tree.
A missing line or block means that key's default, so a project that
has not declared keeps working. The supervisor's ledgers sit in
`supervisor/` beside the session tree, gitignored like it. This repo's
global `CLAUDE.md` carries a block of its own (§ Self-hosting); a
project's block wins, and a project without one is on the defaults,
not this block's values. Declaration form and the defaults:
`skills/dev/companions/declarations.md § Declared paths`; canonical
structure: `skills/dev/layout.md`; paths: `skills/dev/plan.md § Where
things live`.

## Self-hosting

This repo manages itself with the same DEV discipline it provides:
changes to the environment flow through initiatives in its plans tree
like any other project. Because the repo root *is* the `.claude/`
directory, the foundational files live at the root, `LAYOUT.md` among
them, so its `CLAUDE.md § Layout` declares `LAYOUT.md` there and keeps
`Docs:`, `Plans:` and `Session:` at their defaults: the DEV artifacts
sit beside the root files under `dev/` - see `DESIGN.md § Self-hosting
layout`.

## Setup on a new machine

1. Clone to `~/.claude`.
2. Start any Claude Code session; the toolset itself has no install
   step, the clone being `~/.claude`. `settings.json` names the
   marketplace and the enabled plugins; `plugins/`, the caches and the
   `*.local.json` overrides are gitignored harness state. That the
   harness re-downloads the plugins and recreates that state on a
   fresh machine's first run is unverified: not run on a fresh machine.
3. Arm the advisory local gate: `git config core.hooksPath .githooks`,
   once per clone, so `.githooks/pre-push` runs the Tier-1 checks and the
   test suites before a push leaves the machine.
4. Project-specific skills may be symlinked into `skills/` from their
   own repos; clone those repos to matching paths if needed.

## Installing the toolset elsewhere

To give another machine or project the DEV toolset - the `/dev` router,
its mode-file companions, the bundled dependency skills, the writing
conventions and the DEV-artifact writing rule, the project-agnostic Tier-1 checks (code-size, em-dash,
accretion, batch-tags - the last two with self-tests), the two
PreToolUse guards, the branch-state line, the hand-off nudge, the
SessionStart re-brief, and the seeded maintenance hygiene section (project installs, when absent) - run
the installer from a checkout of this repo:

    scripts/install-dev.sh                   # into ~/.claude (global)
    scripts/install-dev.sh --project <path>  # into <path>/.claude

A `--project` install into a git repo refuses a dirty tracked tree or a
default-branch HEAD, so the copy ships as its own reviewable change;
`--force` bypasses the guard.

Global install serves a contributor who wants `/dev` everywhere; the
`--project` copy serves a repo's no-global contributors (skill precedence
means a contributor's own global copy still wins). The installer registers
the branch-guard, secrets-guard, branch-state, handoff-nudge, and
session-brief hooks in the target `settings.json` idempotently, copies
the session-state writer and the context-fill helper beside them unregistered (the
registered hooks call them for the session file's path and the fill
percent), and from `rules/` ships only `writing-artifacts.md`. Re-run it to
refresh.

Beyond the copied files it appends, in both cases, an `@writing.md`
line to the install directory's `CLAUDE.md` (`~/.claude/CLAUDE.md`;
`<path>/.claude/CLAUDE.md` under `--project`), and - for `--project` -
to the repo's root `.gitignore`: a `!`-allowlist line for each
installed path that repo ignores, so the toolset stays committable,
plus two anchored ignore lines for runtime state:
the session tree the repo's root `CLAUDE.md § Layout` declares, where
the per-session state files live (`skills/dev/handoff.md`), and
`supervisor/` beside it, the supervisor's ledgers (`skills/dev/run.md
§ Ledger`) - `/dev/session/` and `/dev/supervisor/` for a project
without a declaration. An install leaves the declaration and the layout file
exactly as it found them: they are the project's.
The copied checks are yours to wire into CI; the installer ships them
without registering them.
