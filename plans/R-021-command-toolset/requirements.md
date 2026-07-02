---
approved: 2026-07-03
kind: refactor
---

# R-021: Command-driven, isolated DEV toolset

## Current state

The DEV toolchain is **skills + path-scoped rules** in `~/.claude/`. To
serve a contributor without a global config, R-015 built **embedding**:
vendor the portable core into a project's `.claude/`, path-rewrite,
`dev-*`-namespace the skills, version-stamp, detect drift. That machinery
exists only to work around not being globally installable and carries
real cost — the namespace/precedence question, gitignore surgery,
adopter-file clobbering (R-019), drift-vs-embed upkeep. Separately, the
path-scoped DEV rules fire in *any* project with matching paths, so a
global install would leak the workflow into a contributor's unrelated
work.

## Desired state

- **One command is the sole global surface.** `commands/dev.md` (`/dev`)
  resolves its instruction dir at runtime — `.claude/dev/` (project
  override) → `~/.claude/dev/` (global) via a sentinel file — and reads
  inert mode files on demand.
- **DEV process rules + sub-skills become inert mode files** under
  `dev/`. They fire only when `/dev` reads them, so a global install
  can't pollute other projects.
- **Trunk discipline is a hook, not an always-on rule.** A `PreToolUse`
  branch-guard hook hard-blocks writes on `main`; the git-workflow
  rationale ships as a `dev/` mode file.
- **`skill-creator` and `writing-skills` stay standalone skills;** the
  other general-purpose skills join the toolset as mode files. The exact
  move/stay split for **every** skill and rule is fixed by a
  user-approved manifest (§ Transform manifest) — not assumed here.
- **Distribution without vendoring** — install the toolset globally, or
  pin per-project via `.claude/dev/`. Embedding (R-015) is retired.

## Transform manifest

Before any skill or rule moves, the detail round (`/dev plan R-021`)
produces `plans/R-021-command-toolset/manifest.md` — the **authoritative
classification of every skill and every rule** as *move-to-`dev/`* or
*stay-global* — and blocks on explicit user approval. Transform tasks
(T-040–T-042) execute strictly per the approved manifest.

- **Skills:** the full list is enumerated and each entry approved before
  the move (not moved on the current provisional classification).
- **Rules:** some rules **stay global-only** (the personal conventions —
  `git-workflow`, `js`, `skills`, `claude-md`, `changelog` — provisionally;
  confirmed in the manifest). Only the rules the manifest marks for move
  become `dev/` mode files.

## Invariants (must NOT change)

- **The `/dev` surface and behavior** — same commands (`plan`/`code`/
  `auto`/`release`), same flows, same planning artifacts (R→T→branch) and
  `plans/` layout.
- **Two-round planning + the single approval gate + traceability.**
- **`main` always releasable; Tier-1 + Tier-2 CI gate every PR.**
- **The user's personal convention rules** (`git-workflow`, `js`,
  `skills`, `claude-md`, `changelog`) remain as rules, unchanged for VIBE
  work.
- **`skill-creator` / `writing-skills` still auto-invoke.**

## Scope

- **New:** `commands/dev.md`, `dev/` (mode files + `companions/`),
  `hooks/dev-branch-guard.sh`, `settings.json` hook registration,
  `scripts/install-dev.sh`.
- **Transform → `dev/` mode files:** rules `planning`, `branch-plan`,
  `planning-templates`, `project-layout`; DEV sub-skills
  (`adding-a-feature`, `fixing-a-bug`, `doing-a-refactor`,
  `writing-plans`, `finishing-a-branch`, `release`,
  `delegating-to-agents`); the assigned general skills (`brainstorming`,
  `test-driven-development`, `systematic-debugging`,
  `verification-before-completion`, `receiving-code-review`,
  `dispatching-parallel-agents`) and adoption skills (`migrating-to-dev`,
  `starting-a-project`); companions travel with them.
- **Retire:** `scripts/vendor-toolchain.sh`, `dev-embed-check.sh`,
  `dev-drift-check.sh`, the embed/vendor/drift tests, the `CLAUDE_ROOT`
  parameterization; unwind the wallarm embed (its own repo MR).
- **CI:** `check-caps` mode-file caps; `check-stray` + `DESIGN.md`
  tree-map for `dev/`, `commands/`, `hooks/`.
- **ROADMAP:** mark R-015 superseded; reconcile R-018/R-019/R-020.

## Acceptance criteria

- [ ] `/dev` runs via `commands/dev.md`, resolving `$DEV_DIR`
  (`.claude/dev/` → `~/.claude/dev/`) and reading mode files; every
  current flow (plan shape/detail, code feat/fix/refactor, auto, release,
  migrate, start) works through it — dogfood a full cycle on this repo.
- [ ] A user-approved transform `manifest.md` (every skill + every rule
  classified move-to-`dev/` vs stay-global) exists before any transform
  task runs; the executed moves match it exactly.
- [ ] No DEV process rule fires outside `/dev`: the rules the manifest
  marks for move no longer live in `~/.claude/rules/`; editing `plans/`
  files in a non-DEV project triggers no DEV rule.
- [ ] Isolated install: cloning to a path **outside `~`** and installing
  the toolset into an empty `CLAUDE_CONFIG_DIR` lets `/dev` run from the
  command + `dev/` alone, with no `~/.claude` leakage.
- [ ] The branch-guard hook blocks a write/commit on `main`/`master` and
  permits it on a branch (both self-hosted and installed).
- [ ] git-workflow rationale is available as a `dev/` mode file; the
  installer ships no always-on git rule.
- [ ] `skill-creator` and `writing-skills` remain standalone skills and
  still auto-invoke; personal convention rules (`js`, `skills`,
  `claude-md`, `changelog`) unchanged.
- [ ] Project-override precedence: a project's `.claude/dev/` takes
  precedence over `~/.claude/dev/`, verified with a divergent test file.
- [ ] R-015 machinery removed (vendor/embed/drift scripts + tests +
  `CLAUDE_ROOT` gone); Tier-1 gate green without them; the wallarm embed
  unwound in its repo.
- [ ] CI updated: `check-caps` enforces mode-file caps; `check-stray` +
  `DESIGN.md` tree-map include `dev/`, `commands/`, `hooks/`; full gate
  green.
- [ ] DEV surface/behavior unchanged: `/dev` commands, planning
  artifacts, and `plans/` layout identical (regression: run an existing
  flow and compare).

## Constraints

- **Self-hosting** — changes the workflow the repo runs on itself:
  branch-by-abstraction migration, `main` releasable throughout, `/dev`
  keeps working until cut-over (precedent: R-003, R-014, R-016).
- **Verify `/dev` command-vs-skill precedence early** — it determines
  cut-over safety.
- **No skill or rule moves before `manifest.md` is approved** (§ Transform
  manifest); transform tasks execute strictly per it. Some rules stay
  global-only.
- Stay within trunk-based delivery (`git-workflow.md`).
- **Supersedes R-015**; the wallarm repo unwind is a separate MR there.

## Open questions

- git-workflow duplication (personal rule vs toolset mode file): keep
  both, or drop the always-on rule and rely on hook + mode file for VIBE
  too? Default keep both — settle in detail.
- Mode-file granularity/naming (one per current skill vs consolidated) —
  settle in detail.
- Installer hook registration idempotency across an existing
  `settings.json` — detail.

## References

- **Supersedes R-015** (embeddable-dev). Absorbs part of **R-020**
  (`finishing-a-branch` → mode file; restore the verify gate). Moots
  **R-019** (vendor clobber). Relates **R-018** (bootstrap exception).
- Reference model: MDD (github.com/TheDecipherist/mdd) — command router +
  lazy mode files + branch-guard hook.
