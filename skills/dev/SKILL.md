---
name: dev
description: Use to enter DEV mode for spec-driven, planned, reviewed work.
---

# Dev

DEV mode — strict, spec-driven, manual (`/dev code`) or agentic (`/dev
auto`). Default: **VIBE** — freestyle, no skill; agentic development is
DEV-only.

## Surface

| Command | Purpose |
|---|---|
| `/dev` | Route by state (ask if ambiguous) |
| `/dev plan [<target>]` | Planning (doc PRs) |
| `/dev code [<slug>]` | Manual execution on a branch |
| `/dev auto [B-XXX]` | Agentic execution of an approved batch |
| `/dev release` | Finalize release |

## `/dev plan <target>`

| Target | Action | Parent required |
|---|---|---|
| `R` | Shape a new initiative — requirements + draft tasks, one gate (deferrable) — `brainstorming` | — |
| `R-XXX` | Detail an open initiative — its tasks + their branch plans (also extends requirements) | R-XXX open |
| `T-XXX` | Branch plan for one task via `writing-plans` | T-XXX open |
| `all` | Branch plans for all open tasks lacking one (parallel; one review pass) | open tasks |
| `batch` | Compose `B-XXX.md`; readiness-review + `agentic:` stamps | plans exist |
| `<slug>` | Adjust branch plan | plan exists |
| `release` | Release plan (next semver) | ≥1 closed task |
| (bare) | Ask | — |

Two rounds — shape (`R`) then detail (`R-XXX`); `T-XXX`/`all` write
branch plans within detail. Propose next; never auto-execute. See
`~/.claude/rules/planning.md`.

## `/dev code [<slug>]`

On `main`: no arg → next task from the open batch, else ask; `<slug>` →
verify plan, branch, start. On a branch: continue from first `[ ]`;
wrong or missing `<slug>` → error. Pre-flight: re-read plan vs code;
concerns → `/dev plan <slug>` first.

Dispatch by tag: `feat`→`adding-a-feature`, `fix`→`fixing-a-bug`,
`refactor`→`doing-a-refactor`. See `~/.claude/rules/branch-plan.md`.

## `/dev auto [B-XXX]`

Dispatch `delegating-to-agents` on an approved batch (no arg → first
open; none → refuse). Unattended until checkpoint or halt.

## `/dev release`

Invokes the project's `release` skill (override or global).
