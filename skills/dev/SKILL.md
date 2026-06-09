---
name: dev
description: Use to enter DEV mode for spec-driven, planned, reviewed work.
---

# Dev

DEV mode — strict, spec-driven workflow. Default: **VIBE** (no skill).

## Surface

| Command | Purpose |
|---|---|
| `/dev` | Route by state (ask if ambiguous) |
| `/dev plan [<target>]` | Planning — commits to main |
| `/dev code [<slug>]` | Execution — work on a branch |
| `/dev release` | Finalize release |

## `/dev plan <target>`

| Target | Action | Parent required |
|---|---|---|
| `REQ` | Start initiative — new `REQ-XXX.md` | — |
| `REQ-XXX` | Amend existing requirement | REQ-XXX open |
| `roadmap` | Create/extend `roadmap.md` | — |
| `R-XXX` | Add tasks under roadmap item | R-XXX open |
| `T-XXX` | Create branch plan for task | T-XXX open |
| `<slug>` | Adjust existing branch plan | plan exists |
| `release` | Create release plan (next semver) | ≥1 closed task |
| (bare) | Ask | — |

After each step, **propose** next; never auto-execute. See
`~/.claude/rules/planning.md`.

## `/dev code [<slug>]`

- On `main` (no arg): list unassigned plans → ask.
- On `main` + `<slug>`: verify plan → create branch → start.
- On dev branch (no arg / matching): continue from first `[ ]`.
- On dev branch + different `<slug>`: error, switch branch first.
- Orphan (dev branch, no plan file): error, missing
  `.claude/plans/<slug>.md`.

Prefix inherits task tag. Dispatch: `feat`→`adding-a-feature`,
`fix`→`fixing-a-bug`, `refactor`→`doing-a-refactor`. Release branches
go via `/dev release`. See `~/.claude/rules/branch-plan.md`.

## Branching

- Never commit to `main`/`master` except: `.claude/plans/*.md`,
  `.claude/requirements.md`, `.claude/design.md`, initial scaffold.
- Branch: `<prefix>/<slug>`, prefix ∈ `{feat, fix, refactor, release}`,
  slug ≤20 chars.
- One branch = one task. Soft cap 20 commits (warn at 15, prompt at 20).

## `/dev release`

Invokes the project's `release` skill (override or global): tag, CHANGELOG,
publish (if applicable).
