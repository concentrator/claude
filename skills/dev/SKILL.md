---
name: dev
description: Use to enter DEV mode for spec-driven, planned, reviewed work.
---

# Dev

DEV mode — strict, spec-driven workflow. Default: **VIBE** (no skill,
freestyle; ad-hoc subagents and `/code-review` only — agentic
development is DEV-only).

## Surface

| Command | Purpose |
|---|---|
| `/dev` | Route by state (ask if ambiguous) |
| `/dev plan [<target>]` | Planning — commits to main |
| `/dev code [<slug>]` | Manual execution on a branch |
| `/dev auto [B-XXX]` | Agentic execution of an approved batch |
| `/dev release` | Finalize release |

## `/dev plan <target>`

| Target | Action | Parent required |
|---|---|---|
| `REQ` | New `REQ-XXX.md` via `brainstorming` | — |
| `REQ-XXX` | Amend requirement | REQ-XXX open |
| `roadmap` | Create/extend `ROADMAP.md` | — |
| `R-XXX` | Add tasks under roadmap item | R-XXX open |
| `T-XXX` | Branch plan via `writing-plans` | T-XXX open |
| `all` | Branch plans for all open tasks lacking one (parallel subagents, one review pass) | open tasks |
| `batch` | Compose `plans/batches/B-XXX.md`; readiness-review + `agentic:` stamps | plans exist |
| `<slug>` | Adjust branch plan | plan exists |
| `release` | Release plan (next semver) | ≥1 closed task |
| (bare) | Ask | — |

Propose next after each step; never auto-execute. See
`~/.claude/rules/planning.md`.

## `/dev code [<slug>]`

On `main`: no arg → next task from open batch, else list plans and
ask; with `<slug>` → verify plan, branch, start. On a dev branch:
continue from first `[ ]`; different `<slug>` or missing plan file →
error. Pre-flight: re-read plan against current code; concerns →
`/dev plan <slug>` before the first commit.

Dispatch by tag: `feat`→`adding-a-feature`, `fix`→`fixing-a-bug`,
`refactor`→`doing-a-refactor`. See `~/.claude/rules/branch-plan.md`.

## `/dev auto [B-XXX]`

Dispatch `delegating-to-agents` on an approved batch (no arg → first
open; none → refuse). Unattended until checkpoint or halt.

## Branching

Never commit to `main` except plans/requirements/design + scaffold
(planning.md) and batch-local merges (branch-plan.md § Agentic
execution). Branch `<prefix>/<slug>`, prefix ∈ {feat, fix, refactor,
release}, slug ≤20 chars. One branch = one task; warn 15 / prompt 20
commits.

## `/dev release`

Invokes the project's `release` skill (override or global).
