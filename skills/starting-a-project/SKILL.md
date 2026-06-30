---
name: starting-a-project
description: Use when scaffolding a new project from scratch.
---

# Starting a Project

One-time setup. Scaffold + foundation commits go on the default branch —
exception to the no-commit-to-`main` rule.

(For an existing codebase, use `migrating-to-dev` instead.)

## 1. Requirements

The user supplies a description; read it, ask 1–3 clarifying questions
if needed. Create `.claude/` if absent, then write
`.claude/REQUIREMENTS.md` with `approved: pending` frontmatter and sections
per `~/.claude/rules/planning-templates.md § Foundational`. **Do not
proceed until the user approves** — then update `approved:` to today.

Seed file not committed; `REQUIREMENTS.md` is the spec.

## 2. Design

Write `.claude/DESIGN.md` — architecture and design decisions.
**≤1000 words inline**, external refs allowed.

## 3. Scaffold

Files:
- `/init` → project `CLAUDE.md`: stack, base branch, build/test/lint;
  don't restate global rules.
- `README.md` (verify or stub).
- `.gitignore` — `.claude/settings.local.json`, secrets, build artifacts.
- `.claude/plans/` with `ROADMAP.md` (per-R `tasks.md` is lazy).
- Optionally embed the toolchain
  (`~/.claude/scripts/vendor-toolchain.sh <root>`) for contributors
  without `~/.claude`.

Full `.claude/` layout: `~/.claude/rules/project-layout.md`.

Ask: **release routine?** Record `release-routine:` in `CLAUDE.md
§ Conventions`. If yes: `CHANGELOG.md`, versioning (default `vX.Y.Z`),
`.claude/plans/release-v0.1.0.md`. Ask about external publishing;
record `publish-external:`. If external, override
`release` at `<project>/.claude/skills/release/SKILL.md`.

Ask: **extended docs?** Record `extended-docs:` (+ path if yes) in
`CLAUDE.md § Conventions`. If yes: create directory with placeholder.

## 4. Quality infrastructure

Set up: lint for the stack + one passing smoke test + CI running lint +
tests on every MR/PR. Document run commands in `CLAUDE.md`. Ask before
each; if the user defers any, record `quality-deferred: true` in
`CLAUDE.md § Conventions`.

Then protect `main` on the host — require MR/PR + passing checks before
merge, restrict direct push (`gh`/`glab`; `git-workflow.md § Trunk`,
`§ Enforcement`) — TBD-shaped from commit one.

## 5. Commit

Commit requirements + design + scaffold + quality config to default
branch.

## 6. Next

Propose `/dev plan R` to shape the first initiative. Do not auto-execute.
