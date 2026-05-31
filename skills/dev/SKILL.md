---
name: dev
description: Use to start, continue, or finish a structured development cycle.
---

# Dev

Entry point for structured development. Two operating modes:
- **Free** — no `/dev` invoked: regular session, light touch.
- **Dev** — `/dev <subcommand>`: planned, tested, reviewed, documented at every step.

## Subcommands

**`/dev`** — ask: project / feature / bug / refactor / release?

**`/dev project <name>`** — new project scaffold → invoke `starting-a-project`.

**`/dev feature|bug|refactor <slug>`**
1. Verify off `main`/`master` (branch if on it).
2. Pre-flight: `git status`, project's build + test commands (see project CLAUDE.md).
3. Plan: `brainstorming` if scope fuzzy → `writing-plans`. Save to `.claude/plans/<slug>.md` as a checkbox list.
4. Create branch: `feat/<slug>`, `fix/<slug>`, or `refactor/<slug>`.
5. If a release plan exists, auto-append the branch entry.
6. Invoke matching L2: `adding-a-feature`, `fixing-a-bug`, or `doing-a-refactor`.

**`/dev release <version>`** — create `.claude/plans/release-<version>.md` with checkbox sections for branches and release tasks. Subsequent `/dev <kind> <slug>` calls auto-append.

**`/dev continue`**
1. Read current branch prefix (`feat/`/`fix/`/`refactor/`).
2. Read `.claude/plans/<slug>.md`.
3. Find first `[ ]`.
4. Dispatch matching L2.

**`/dev finish`**
1. Invoke `simplify` (mandatory; do not skip even if changes look small).
2. Ask "manual testing done?" (yes / n/a / not yet).
3. Scan `.claude/plans/roadmap.md` for entries matching closed work; propose removal.
4. Invoke `finishing-a-development-branch`.

Branch stays `[ ]` in release plan until merged.

**`/dev release-finish`** — invoke `release` (project override if defined, else global).

## Plan format

Three-level hierarchy:

1. **Roadmap** `.claude/plans/roadmap.md` — outstanding work, not yet assigned to a release.
2. **Release plan** `.claude/plans/release-<version>.md` — checkbox list of branches in a release. Mark `[x]` only when the branch is merged into the default branch.
3. **Branch plan** `.claude/plans/<slug>.md` — checkbox list, one entry per commit. Mark `[x]` at commit time.

`/dev continue` reads the branch plan; works the first `[ ]`.
