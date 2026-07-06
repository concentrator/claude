# Starting a Project

One-time setup. The **initial** commit creates `main` (the only bootstrap
step - the branch-guard permits writes on an unborn `main`); protect
`main`, then do all further work via branches + PRs.

(For an existing codebase, use `migrate` instead.)

## 1. Requirements

The user supplies a description; read it, ask 1–3 clarifying questions
if needed. Create `.claude/` if absent, then write
`.claude/REQUIREMENTS.md` with `approved: pending` frontmatter and sections
per `templates.md § Foundational`. **Do not
proceed until the user approves** - then update `approved:` to today.

Seed file not committed; `REQUIREMENTS.md` is the spec.

## 2. Design

Write `.claude/DESIGN.md` - architecture and design decisions.
**≤1000 words inline**, external refs allowed.

## 3. Scaffold

Baseline files (`layout.md § Baseline files`):
- `/init` → project `CLAUDE.md`: stack, base branch, and an `## Agent
  toolchain` section (VCS host + build/test/lint/change-request commands -
  `companions/toolchain.md`); don't restate global rules.
- `README.md` (verify or stub).
- `.gitignore` - seed from `companions/gitignore.template` (ignores `.env`,
  `.claude/settings.local.json`, build output); extend per stack.
- `.env.example` (if the project uses env vars) - seed from
  `companions/env-example.template`; keep `.env` gitignored, never commit it.
- `.claude/plans/` with `ROADMAP.md` (per-R `tasks.md` is lazy).
- For contributors without a global toolset, ship a project copy at
  `.claude/skills/dev/` (or have them install it into `~/.claude/skills/`).

Full `.claude/` layout + baseline set: `layout.md`.

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

## 5. Commit

The initial commit (requirements + design + scaffold + quality config)
creates `main` - the bootstrap exception (`git-workflow.md § Trunk`). Then
protect `main` on the host - require MR/PR + passing checks, restrict
direct push (`gh`/`glab`; `git-workflow.md § Trunk`, `§ Enforcement`),
TBD-shaped from commit one; thereafter all work lands via a branch + PR.

## 6. Next

Propose `/dev plan R` to shape the first initiative. Do not auto-execute.
