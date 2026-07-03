---
name: dev
description: Use to enter DEV mode for spec-driven, planned, reviewed work.
---

# Dev

DEV mode — strict, spec-driven, manual (`/dev code`) or agentic (`/dev
auto`). Default: **VIBE** — freestyle, no skill.

The mode files live beside this file in `skills/dev/`. **Read the ones a
command maps to before acting** — they carry the rules and procedures.

## Surface

| Command | Purpose |
|---|---|
| `/dev` | Route by state (ask if ambiguous) |
| `/dev plan [<target>]` | Planning (doc PRs) |
| `/dev code [<slug>]` | Manual execution on a branch |
| `/dev auto [B-XXX]` | Agentic execution of an approved batch |
| `/dev release` | Finalize release |
| `/dev migrate` | Adopt an existing project into DEV |
| `/dev start` | Scaffold a new project into DEV |

## `/dev plan <target>` — read `plan.md` (+ `templates.md` when writing specs)

| Target | Action | Read |
|---|---|---|
| `R` | Shape a new initiative (requirements + draft tasks, one gate) | `brainstorm.md` |
| `R-XXX` | Detail an open initiative (tasks + branch plans) | `plan.md` |
| `T-XXX` / `all` | Branch plan(s) for open task(s) | `write-plan.md` |
| `batch` | Compose `B-XXX.md`; readiness review + `agentic:` stamps | `branch-plan.md` |
| `<slug>` | Adjust an existing branch plan | `branch-plan.md` |
| `release` | Release plan (next semver) | `release.md` |
| (bare) | Ask | — |

Two rounds — shape (`R`) then detail (`R-XXX`). Propose next; never
auto-execute.

## `/dev code [<slug>]` — read `branch-plan.md`

On `main`: no arg → next task from the open batch, else ask; `<slug>` →
verify plan, branch, start. On a branch: continue from first `[ ]`; wrong
or missing `<slug>` → error. Pre-flight: re-read plan vs code; concerns →
`/dev plan <slug>` first.
Dispatch by tag: `feat`→`feat.md`, `fix`→`fix.md`, `refactor`→`refactor.md`.
Close the branch: `finish.md`.

## `/dev auto [B-XXX]` — read `auto.md`

Run an approved batch via subagents (no arg → first open; none → refuse).
Unattended until checkpoint or halt.

## `/dev release` — read `release.md`

Finalize + tag the release (project `release` override or this companion).

## `/dev migrate` — read `migrate.md`

Adopt an existing project into DEV: inventory, then route (legacy / fresh /
already-DEV).

## `/dev start` — read `start.md`

Scaffold a new project into DEV from scratch.
