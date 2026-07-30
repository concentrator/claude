# Starting a Project

One-time setup for a new project (existing codebase → `migrate`).
Bootstrap and protection mechanics live in § 5 Commit.

## 1. Requirements

The user supplies a description; ask 1–3 clarifying questions, create
`.claude/` if absent, then write `.claude/REQUIREMENTS.md` per
`templates.md § Foundational` and **block on user approval**
(`approved:` gate as `migrate.md § 2`). Seed file not committed;
`REQUIREMENTS.md` is the spec.

## 2. Design

As `migrate.md § 3` (architecture and design decisions, from the
user's description rather than existing code).

## 3. Scaffold

Baseline files (`layout.md § Baseline files`):
- `/init` → project `CLAUDE.md` incl. `## Conventions` and `## Agent
  toolchain`, spec per `migrate.md § 4`.
- `README.md` (verify or stub).
- `.gitignore` / `.env.example` - seed from the `companions/*.template`
  files; contents per `layout.md § Baseline files`.
- `.claude/plans/` with `ROADMAP.md`.
- Toolset for no-global contributors: per `migrate.md § 5`.

Full `.claude/` layout + baseline set: `layout.md`.

Ask: **release routine?** Record `release-routine:` in `CLAUDE.md
§ Conventions`. If yes: `CHANGELOG.md`, versioning (default `vX.Y.Z`),
`.claude/plans/release-v0.1.0.md`. Ask about external publishing;
record `publish-external:`. If external, override
`release` at `<project>/.claude/skills/release/SKILL.md`.

Ask: **extended docs?** Record `extended-docs:` (+ path if yes) in
`CLAUDE.md § Conventions`. If yes: create directory with placeholder.

If the project will keep `.claude/docs/` feature docs (`layout.md § Docs`),
record a one-line pointer to `.claude/docs/index.md` in `§ Conventions`.

## 4. Quality infrastructure

Set up the `migrate.md § 5` baseline (lint + smoke test + CI on every
MR/PR; deferral key included), asking before each item. Document run
commands in `CLAUDE.md`.

## 5. Commit

The initial commit (requirements + design + scaffold + quality config)
creates `main` - the bootstrap exception (`git-workflow.md § Trunk`;
untracked mode deltas: `companions/untracked-claude.md`). Then
protect `main` on the host - require MR/PR + passing checks, restrict
direct push (`gh`/`glab`; `git-workflow.md § Trunk`, `§ Enforcement`),
TBD-shaped from commit one; thereafter all work lands via a branch + MR/PR.

## 6. Next

Propose `/dev plan R` to shape the first initiative. Do not auto-execute.
