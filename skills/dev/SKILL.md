---
name: dev
description: Use to enter DEV mode for spec-driven, planned, reviewed work.
---

# Dev

DEV mode - strict, spec-driven, manual (`/dev code`) or agentic (`/dev
auto`). The mode files live beside this file in `skills/dev/`. **Read
the one a command maps to before acting.**

## Surface

| Command | Read | Purpose |
|---|---|---|
| `/dev` | - | Route by state (ask if ambiguous) |
| `/dev plan [<target>]` | per target table below | Planning (plan MR/PRs) |
| `/dev code [<slug>]` | `branch-plan.md` | Manual execution on a branch - rules below |
| `/dev auto [R<NNN>-B<NNN>]` | `auto.md` | Run an approved batch via subagents (no arg → first open); unattended until checkpoint or halt |
| `/dev supervise [project] [scope]` | `supervise.md` | Supervise scoped delivery: dispatch, verify, merge within declared bounds |
| `/dev release` | `release.md` | Finalize + tag the release (project `release` override or this companion) |
| `/dev migrate` | `migrate.md` | Adopt an existing project into DEV: inventory, then route |
| `/dev start` | `start.md` | Scaffold a new project into DEV |
| `/dev docs` | `docs.md` | Audit / build / refresh the docs layer |

## `/dev plan <target>`

| Target | Action | Read |
|---|---|---|
| `R` | Shape a new initiative (requirements + draft tasks, one gate) | `brainstorm.md` |
| `R<NNN>` | Detail an open initiative (tasks + branch plans) | `plan.md` |
| `<task-id>` / `all` | Branch plan(s) for open task(s) | `write-plan.md` |
| `batch` | Compose `R<NNN>-B<NNN>.md`; readiness review + `agentic:` stamps | `branch-plan.md` |
| `milestone <id>` | Milestone plan (cross-initiative order) | `plan.md` |
| `<slug>` | Adjust an existing branch plan | `branch-plan.md` |
| `release` | Release plan (next semver) | `release.md` |
| (bare) | Ask | - |

Two rounds - shape (`R`) then detail (`R<NNN>`); round-gate rules in
`plan.md § Planning rounds`.

## `/dev code [<slug>]`

On `main`: no arg → next task from the open batch, else ask; `<slug>` →
verify plan, branch, start. On a branch: continue from first `[ ]`; wrong
or missing `<slug>` → error. Pre-flight: re-read plan vs code; concerns →
`/dev plan <slug>` first.
Dispatch by tag: `feat`→`feat.md`, `fix`→`fix.md`, `refactor`→`refactor.md`;
`doc`/`test`/`mnt` have no mode file - run `branch-plan.md § Commit
cadence` directly.
Close the branch: `finish.md`.
