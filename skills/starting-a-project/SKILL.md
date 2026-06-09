---
name: starting-a-project
description: Use when scaffolding a new project from scratch.
---

# Starting a Project

One-time setup. Walk top-to-bottom. Scaffold + foundation commits go on the
default branch — exception to the no-commit-to-`main` rule.

(For an existing codebase, use `migrating-to-dev` instead.)

## 1. Requirements

The user supplies a description (text file, prompt, or both). Read it, ask
1–3 clarifying questions if needed. Create `.claude/` if absent, then write
`.claude/requirements.md` with `approved: pending` frontmatter and sections
per `~/.claude/rules/planning.md § Templates → Foundational`. **Do not
proceed until the user approves** — then update `approved:` to today.

The user's seed file (if any) is **not** committed — `requirements.md` is
the project's owned spec.

## 2. Design

Write `.claude/design.md` — initial architecture and design decisions.
**≤1000 words inline**, external refs allowed (diagrams, ADRs). Project
`CLAUDE.md` holds only always-on essentials.

## 3. Scaffold

Files:
- `/init` → project `CLAUDE.md`.
- `README.md` (verify or stub).
- `.gitignore` — `.claude/settings.local.json`, secrets, build artifacts.
- `.claude/plans/` with empty `roadmap.md` and `tasks.md`.
- Project `CLAUDE.md`: stack, base branch, build/test/lint. Don't restate
  global rules.

Ask: **release routine?** Record `release-routine:` in `CLAUDE.md
§ Conventions`. If yes: `CHANGELOG.md`, versioning (default `vX.Y.Z`),
`.claude/plans/release-v0.1.0.md`. Ask about external publishing
(npm/PyPI/etc.); record `publish-external:`. If external, override
`release` at `<project>/.claude/skills/release/SKILL.md`.

Ask: **extended docs?** Record `extended-docs:` (+ path if yes) in
`CLAUDE.md § Conventions`. If yes: create directory with placeholder.

## 4. Quality infrastructure

Set up: lint configured for stack + one passing smoke test + CI workflow
(default GitLab CI) running lint + tests on MR. Document run commands in
`CLAUDE.md`. Ask before each; if user defers any item, record
`quality-deferred: true` in `CLAUDE.md § Conventions`.

## 5. Commit

Commit requirements + design + scaffold + quality config to default
branch.

## 6. Next

Propose: run `/dev plan roadmap` to seed the initial roadmap from
requirements + design. Do not auto-execute.
