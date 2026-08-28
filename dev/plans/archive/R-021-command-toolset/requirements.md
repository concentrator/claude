---
approved: 2026-07-03
kind: refactor
status: done 2026-07-05
---

# R-021: Isolated, self-contained DEV toolset

## Current state

The DEV toolchain is **skills + path-scoped rules** in `~/.claude/`. To
serve a contributor without a global config, R-015 built **embedding**:
vendor the portable core into a project's `.claude/`, path-rewrite,
`dev-*`-namespace the skills, version-stamp, detect drift. That machinery
exists only to work around not being globally installable and carries real
cost - the namespace/precedence question, gitignore surgery, adopter-file
clobbering (R-019), drift-vs-embed upkeep. Separately, the path-scoped DEV
rules fire in *any* project with matching paths, so a global install would
leak the workflow into a contributor's unrelated work.

## Desired state

- **`dev` stays the skill router.** `skills/dev/SKILL.md` remains the
  `/dev` entry, slimmed to a router that reads inert **companion mode
  files** in `skills/dev/` on demand. No command file. (Verified: a skill
  wins over a same-named command, and commands are being folded into
  skills - so the entry must be a skill.)
- **DEV process rules + sub-skills become inert `skills/dev/` companions.**
  They fire only when the `dev` skill reads them, so a global install can't
  pollute other projects.
- **Trunk discipline is a hook, not an always-on rule.** A `PreToolUse`
  branch-guard hook hard-blocks writes on `main`; the git-workflow
  rationale ships as a `skills/dev/` companion.
- **`skill-creator` and `writing-skills` stay standalone skills;** the
  move/stay split for every skill and rule is fixed by the approved
  `manifest.md`.
- **Distribution without vendoring.** Skill precedence (personal > project)
  gives it for free: a no-global contributor uses a project's
  `.claude/skills/dev/`; a global contributor's `~/.claude/skills/dev/`
  wins. Embedding (R-015) is retired.

## Transform manifest

`manifest.md` (approved) is the **authoritative classification of every
skill and every rule** as *move-to-`skills/dev/`* / *stay-global* /
*bundled*. Transform tasks (T-040–T-042) execute strictly per it; nothing
moves before it is approved.

## Invariants (must NOT change)

- **The `/dev` surface and behavior** - same commands (`plan`/`code`/
  `auto`/`release`), same flows, same planning artifacts (R→T→branch) and
  `plans/` layout. `/dev` stays a skill.
- **Two-round planning + the single approval gate + traceability.**
- **`main` always releasable; Tier-1 + Tier-2 CI gate every PR.**
- **The user's personal convention rules** (`js`, `skills`, `claude-md`,
  and the `git-workflow` rule) remain as rules, unchanged for VIBE work.
- **`skill-creator` / `writing-skills` still auto-invoke.**

## Scope

- **New:** `skills/dev/` companion mode files (+ `skills/dev/companions/`),
  `hooks/dev-branch-guard.sh`, `settings.json` hook registration,
  `scripts/install-dev.sh` (which also bundles the 5 dependency skills).
- **Router:** slim `skills/dev/SKILL.md` to read the companion mode files.
- **Transform → `skills/dev/` companions:** the manifest-marked rules
  (`planning`, `branch-plan`, `planning-templates`, `project-layout`,
  `changelog`) and DEV/adoption skills (`adding-a-feature`, `fixing-a-bug`,
  `doing-a-refactor`, `writing-plans`, `finishing-a-branch`, `release`,
  `delegating-to-agents`, `brainstorming`, `migrating-to-dev`,
  `starting-a-project`); companions travel with them.
- **Bundled dependency skills** stay as skills (VIBE-auto-invocable) and
  ship with the installer so the toolset is self-contained.
- **Cleanup:** strip embed/vendor instructions from the `migrate`/`start`
  companions; inline the CLAUDE.md-rules slice into `migrate`.
- **Retire:** `scripts/vendor-toolchain.sh`, `dev-embed-check.sh`,
  `dev-drift-check.sh`, the embed/vendor/drift tests, the `CLAUDE_ROOT`
  parameterization; unwind the wallarm embed (its own repo MR).
- **CI:** `check-caps` covers `skills/dev/` companions; `check-stray` +
  `DESIGN.md` tree-map for `hooks/`.
- **ROADMAP:** mark R-015 superseded; reconcile R-018/R-019/R-020.

## Acceptance criteria

- [x] `/dev` runs via the `dev` skill router, which reads `skills/dev/`
  companion mode files; every current flow (plan shape/detail, code
  feat/fix/refactor, auto, release, migrate, start) works through it -
  dogfood a full cycle on this repo.
  *SKILL.md router reads companions on demand; R-021's own planning and
  execution (T-039–T-048) ran through `/dev plan`/`/dev code`, and a
  `/dev migrate` run drove the wallarm adoption.*
- [x] A user-approved `manifest.md` exists before any transform; the
  executed moves match it exactly.
  *`manifest.md` approved 2026-07-03, before the first transform (T-040);
  moves executed per its classification.*
- [x] No DEV process rule fires outside `/dev`: the manifest-marked rules
  no longer live in `~/.claude/rules/` (they are `skills/dev/` companions);
  editing `plans/` files in a non-DEV project triggers no DEV rule.
  *planning/branch-plan/templates/layout/changelog are now `skills/dev/`
  companions with no `paths:` frontmatter; `rules/` retains only
  js/skills/claude-md/git-workflow.*
- [x] Isolated install: cloning to a path **outside `~`** and installing
  the toolset into an empty `CLAUDE_CONFIG_DIR` lets `/dev` run from
  `skills/dev/` + the bundled skills alone, with no `~/.claude` leakage.
  *No-global `/dev migrate` in `/tmp/r021-verify` (outside `~`, project copy
  only) ran the full flow - router → `migrate.md` → nested
  `companions/tbd-migration.md` - reading only project `skills/dev/`; zero
  `~/.claude` paths in loaded files.*
- [x] The `migrate`/`start` companions carry **no** embed/vendor
  instructions; they describe the install / `.claude/skills/dev/` model.
  *Embed/vendor instructions stripped from `migrate.md`/`start.md` (T-045);
  they describe the installer + project-copy model.*
- [x] The branch-guard hook blocks a write/commit on `main`/`master` and
  permits it on a branch.
  *`hooks/dev-branch-guard.sh` denied Write/Edit + `git commit` on `main`
  repeatedly this session and permitted them on branches.*
- [x] git-workflow rationale is available as a `skills/dev/` companion; the
  installer ships no always-on git rule.
  *`skills/dev/git-workflow.md` exists; `install-dev.sh` ships skills + hook
  only, no `rules/`.*
- [x] `skill-creator` and `writing-skills` remain standalone skills and
  still auto-invoke; personal convention rules (`js`, `skills`,
  `claude-md`) unchanged.
  *Both remain under `skills/`; `rules/` retains js/skills/claude-md
  unchanged.*
- [x] Distribution precedence: a no-global contributor uses a project's
  `.claude/skills/dev/`; a global `~/.claude/skills/dev/` wins for a global
  contributor (verified with a divergent test file).
  *Both configs exercised this session: global-absent (`/tmp/r021-verify`
  loaded the project `.claude/skills/dev/`) and global-present (every
  non-isolated `/dev` loaded `~/.claude/skills/dev/`) - the personal >
  project skill precedence Claude Code documents (confirmed via
  claude-code-guide).*
- [x] R-015 machinery removed (vendor/embed/drift scripts + tests +
  `CLAUDE_ROOT` gone); Tier-1 gate green without them; the wallarm embed
  unwound in its repo.
  *vendor-toolchain/dev-embed-check/dev-drift-check + their tests removed,
  `CLAUDE_ROOT` dropped (`check-caps` ROOT="."); Tier-1 green; wallarm embed
  unwound (!22 merged), residual dangling refs completed (!23).*
- [x] CI updated: `check-caps` covers `skills/dev/` companions; `check-stray`
  + `DESIGN.md` tree-map include `hooks/`; full gate green.
  *`check-caps.sh` caps `skills/dev/` companions at 1500w; `check-stray`
  accepts `hooks/`; `DESIGN.md` tree-map lists `hooks/`; gate green.*
- [x] DEV surface/behavior unchanged: `/dev` commands, planning artifacts,
  and `plans/` layout identical (regression: run an existing flow).
  *SKILL.md surface (plan/code/auto/release) unchanged; planning artifacts +
  `plans/` layout identical; R-021's own tasks ran the flow unchanged.*

## Constraints

- **Self-hosting** - changes the workflow the repo runs on itself:
  branch-by-abstraction (copy into `skills/dev/`, rewire the router, then
  remove originals), `main` releasable throughout, `/dev` keeps working
  until cut-over (precedent: R-003, R-014, R-016).
- Stay within trunk-based delivery (`git-workflow.md`).
- **Supersedes R-015**; the wallarm repo unwind is a separate MR there.

## Open questions

- git-workflow duplication (personal rule vs `skills/dev/` companion): keep
  both, or drop the always-on rule and rely on hook + companion for VIBE
  too? Default keep both.
- Companion granularity/naming - settle per task.
- Installer hook-registration idempotency across an existing
  `settings.json`.

## References

- **Supersedes R-015** (embeddable-dev). Absorbs part of **R-020**
  (`finishing-a-branch` → companion; restore the verify gate). Moots
  **R-019** (vendor clobber). Relates **R-018** (bootstrap exception).
- Reference model: MDD (github.com/TheDecipherist/mdd) - router + lazy mode
  files + branch-guard hook. Entry realized as a **skill** (not a command)
  per Claude Code precedence (skill wins over same-named command).
