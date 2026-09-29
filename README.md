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
| `.claude/CLAUDE.md` | This repository's own instructions: its `## Agent toolchain`, `## Supervision` and `## Layout` declarations |
| `rules/` | Path-scoped convention rules: the DEV-artifact writing rules (shipped by the installer), JS style, CLAUDE.md/skill maintenance |
| `skills/` | Invocable capabilities - `dev/` is the /dev router + its mode-file companions (the DEV toolset); beside it the bundled dependency skills the installer ships, the personal skills, and the worker-host runbook (`LAYOUT.md` marks each) |
| `agents/` | Subagent definitions for the seats of `/dev run`, one per seat the run dispatches (the roster: `skills/dev/run.md § Seats`): each declares the seat's tools and, where it sets one, its model, and carries its standing instructions. This repository's own - `install-dev.sh` copies none of them |
| `hooks/` | The Claude Code hooks `settings.json` registers - the PreToolUse guards and the session-lifecycle hooks - and the helpers they call; `LAYOUT.md` lists each hook with the event it runs on |
| `scripts/` | The Tier-1 gate - `ci/` the mechanical checks and `test/` the script tests, each behind a `run-all.sh`, which CI runs on every pull request (`DESIGN.md § Self-enforcement`) - and the standalone scripts beside it; `LAYOUT.md` lists each script with what it does, and `skills/worker-host/` documents the worker-host ones |
| `.github/`, `.githooks/`, `.gitignore` | The CI gate on pull requests, its advisory local pre-push mirror, and the ignore rules for harness state |
| `REQUIREMENTS.md` | What this environment is for and how success is judged |
| `DESIGN.md` | Architecture, self-hosting layout |
| `LAYOUT.md` | The repository's actual tree - the layout file `.claude/CLAUDE.md § Layout` declares; `scripts/ci/check-stray.sh` checks every tracked top-level entry against it |
| `MAINTENANCE.md` | The Tier-2 AI review's concerns, plus the sanity routine: cleanup, repair, allow-list hygiene, skill audits |
| `dev/` | This repo's own DEV artifacts: `plans/` (the roadmap index, per-initiative `R<NNN>-<slug>/` dirs, `archive/` for closed initiatives) and the gitignored `session/` and `supervisor/` |

## Workflow

Two modes, defined in `CLAUDE.md`:

- **VIBE** (default) - freestyle, no ceremony.
- **DEV** - entered via `/dev`: initiatives (requirements) → tasks →
  branch plans → commits, every level traceable
  (`R<NNN> → R<NNN>-T<NNN> → branch`). Task ids are composite, with the
  task counter scoped to its initiative, so the id routes to the
  artifacts: task `R<NNN>-T<NNN>` lives in `R<NNN>-<slug>/` under the
  plans tree (§ DEV artifacts; `dev/plans/` here), or in
  `archive/R<NNN>-<slug>/` under it once the initiative closes.

Planning takes two rounds: `/dev plan R` shapes an initiative,
`/dev plan R<NNN>` details its tasks and branch plans. Execution is
`/dev run`: a task, a batch or an initiative runs as dispatched seats -
subagents, each started fresh for one item and shut down at its exit -
under the supervisor the project declares, human or AI, within
declared bounds. Before its first dispatch a run resolves the
permission set the toolset declares against the three settings tiers a
session reads: `scripts/preflight-permissions.sh` reports the tier that
carries each rule, and a gap halts the run for the user to close. When
every gap is a missing allow rule it prints the `--apply` command that
closes them; a missing deny, or any other gap `--apply` cannot write,
is closed by hand. `/dev ship` takes a landed branch (every planned
commit in, nothing uncommitted) to its MR/PR decision - merged,
discarded, or left open awaiting the decision - and a failing local
gate stops it before the MR/PR opens. A task-scoped `/dev run` ends on
the same path once its checkpoint is accepted; `/dev ship` enters it
directly. `/dev handoff` writes the session's hand-off note, which with the PreCompact hook's tree block carries
state across compaction (the SessionStart hook re-injects the last
hand-off block when the session resumes or is compacted). Three
more commands:

- `/dev start` scaffolds a new project into DEV.
- `/dev migrate` adopts an existing project into DEV.
- `/dev release` finalizes and tags a release.

Command surface and mode files: `skills/dev/SKILL.md`.

## DEV artifacts

Two trees: guarded config - what instructs agents - under `.claude/`,
and agent-authored artifacts at the paths the project's `§ Layout`
declares, one line per key: `Docs:` the docs tree, `Plans:` the
planning tree, `Session:` the gitignored per-session state files,
`Layout:` the layout file holding the repository's actual tree. A
missing path line or `§ Layout` block means that key's default, so a
project that has not declared keeps working. The supervisor's ledgers
sit in `supervisor/` beside the session tree, gitignored like it.

All of a project's declarations - the `§ Agent toolchain` commands, the
`§ Supervision` seat and the `§ Layout` paths - sit in its own
instructions, the root `CLAUDE.md` or `.claude/CLAUDE.md`, each key
once across the two and the `§ Agent toolchain` block whole in one of
them; the global instructions hold none. A script or hook that reads a
path reads both files, the root one first, and takes the first line
found; the `/dev run` permission pre-flight reads the `§ Agent
toolchain` section of each file. Declaration form:
`skills/dev/companions/declarations.md`, the path defaults in its
`§ Declared paths`; canonical structure: `skills/dev/layout.md`; paths:
`skills/dev/plan.md § Where things live`.

## Self-hosting

This repo manages itself with the same DEV discipline it provides:
changes to the environment flow through initiatives in its plans tree
like any other project. Because the repo root *is* the `.claude/`
directory, the root `CLAUDE.md` is the global instructions every
session loads, and this repository's own instructions, its
declarations, sit in the nested `.claude/CLAUDE.md`. The foundational
files live at the root, `LAYOUT.md` among them, so `.claude/CLAUDE.md
§ Layout` declares `LAYOUT.md` there and keeps `Docs:`, `Plans:` and
`Session:` at their defaults: the DEV artifacts
sit beside the root files under `dev/` - see `DESIGN.md § Self-hosting
layout`.

## Setup on a new machine

1. Clone to `~/.claude`.
2. Start any Claude Code session; the toolset itself has no install
   step, the clone being `~/.claude`. The clone carries
   `settings.json`, which names the `claude-plugins-official`
   marketplace and the enabled plugins, but not the plugins themselves:
   `.gitignore` keeps `plugins/` out of the repo, with the harness
   caches and the `*.local.json` overrides.
3. Arm the advisory local gate: `git config core.hooksPath .githooks`,
   once per clone, so `.githooks/pre-push` runs Tier-1 - the checks and
   the test suites - before a push leaves the machine.
4. For each skill you keep in its own repository, clone that
   repository and link the skill's directory into `skills/`:
   `ln -s <clone>/<skill-dir> ~/.claude/skills/<name>`. `.gitignore`
   tracks only the skills `LAYOUT.md` maps, so the clone carries none
   of these links.

## Installing the toolset elsewhere

To give another machine or project the DEV toolset, run the installer
from a checkout of this repo:

    scripts/install-dev.sh                   # into ~/.claude (global)
    scripts/install-dev.sh --project <path>  # into <path>/.claude

A full install ships:

- `skills/dev/` whole: the `/dev` router and its mode-file companions.
- The bundled dependency skills the companions reference by name, the
  `BUNDLED` list in `scripts/install-dev.sh`.
- `writing.md`, the writing conventions, and from `rules/` only
  `writing-artifacts.md`, the DEV-artifact writing rule.
- The project-agnostic Tier-1 checks, into `scripts/ci/`:
  - `check-code-size.sh`, plus an empty `code-size-allow.txt` when the
    target has none.
  - `check-no-em-dash.sh`.
  - `check-accretion.sh`, with its self-test.
  - `check-batch-tags.sh`, with its self-test.
  - `check-plan-text.sh`, with its self-test.
- `scripts/preflight-permissions.sh`, the `/dev run` permission
  pre-flight, with its self-test.
- The hooks below.
- On a `--project` install, the maintenance hygiene section, seeded
  into the target's `MAINTENANCE.md` when that heading is absent.

The installer registers these hooks in the target `settings.json`,
idempotently:

| Hook | Event | Matcher |
|---|---|---|
| `dev-branch-guard.sh` | PreToolUse | `Write\|Edit\|NotebookEdit` and `Bash` |
| `dev-secrets-guard.sh` | PreToolUse | `Write\|Edit\|NotebookEdit` and `Bash` |
| `dev-branch-state.sh` | UserPromptSubmit | none |
| `dev-handoff-nudge.sh` | Stop | none |
| `dev-session-brief.sh` | SessionStart | `compact\|resume` |

It copies three files beside them unregistered, each used by a
registered hook:

- `dev-precompact-state.sh`, the session-state writer: the branch-state
  hook asks it for the session file's path.
- `dev-context-fill.sh`: the branch-state and hand-off-nudge hooks call
  it for the context-fill percent.
- `secret-patterns.sh`, the secret predicate the secrets guard sources.

`--minimal` serves contributors who work a project's existing plans
without `/dev`. It ships the full set less two parts of `skills/`: no
bundled dependency skills, and from `skills/dev/` only these files:

- `finish.md`
- `handoff.md`
- `git-workflow.md`
- `companions/declarations.md`
- `companions/toolchain.md`
- `companions/untracked-claude.md`
- `companions/secrets.md`
- `companions/auto-permissions.template.json`, the permission
  pre-flight's input

A `--project` install into a git repo refuses a dirty tracked tree or a
default-branch HEAD, so the copy ships as its own reviewable change;
`--force` bypasses the guard.

Global install serves a contributor who wants `/dev` everywhere; the
`--project` copy serves a repo's no-global contributors (skill precedence
means a contributor's own global copy still wins). Re-run the installer
to refresh.

Beyond the copied files it appends, in both cases, an `@writing.md`
line to the install directory's `CLAUDE.md` (`~/.claude/CLAUDE.md`;
`<path>/.claude/CLAUDE.md` under `--project`), and - for `--project` -
to the repo's root `.gitignore`: a `!`-allowlist line for each
installed path that repo ignores, so the toolset stays committable,
plus two anchored ignore lines for runtime state:
the session tree the repo's `Session:` line declares, read from the
repo root's `CLAUDE.md` and `.claude/CLAUDE.md`, where the per-session
state files live (`skills/dev/handoff.md`), and
`supervisor/` beside it, the supervisor's ledgers (`skills/dev/run.md
§ Ledger`) - `/dev/session/` and `/dev/supervisor/` for a project
without a declaration. A `--project` install into a git repo, full or
`--minimal`, also wires the plan-text gate into the fast tier: it appends
`` , then `bash <prefix>.claude/scripts/ci/check-plan-text.sh` `` to the
repo's `Test (fast):` line, else to its `Test:` line, in whichever of
the repo root's `CLAUDE.md` and `.claude/CLAUDE.md` holds it, the root
one's when both do (the last line of a wrapped one, its closing period
dropped), keeping the file's mode. `<prefix>` is `<path>` relative to
the repo root: empty when `<path>` is the root, `sub/` for `--project
<repo>/sub`. A line already naming `check-plan-text.sh` on any of its
lines stays as it is; with neither line in either file, no fast-tier
line is written and the install prints one line naming both files and
the line to add. A global or non-git install touches no fast-tier line;
its only `CLAUDE.md` write is the `@writing.md` line above. Past the
`@writing.md` line and that fast-tier append, an install leaves the
declarations and the layout file exactly as it found them: they are the
project's.
The copied checks are yours to wire into CI; the installer ships them
without registering them and edits no CI config. A `--project` install into
a git repo prints one line saying the project's CI must run the fast tier,
which is what runs the plan-text gate there.
