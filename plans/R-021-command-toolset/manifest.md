# R-021 transform manifest

Binding classification for the skills+rules → command+toolset transform
(requirements § Transform manifest). **Approved 2026-07-03** — T-040–T-042
execute strictly per this file. Invocation is router-only: `dev/` files are
mode files the `/dev` router reads, not slash commands.

## Skills (25)

**→ command router** (`commands/dev.md`)
- `dev`

**→ `dev/` mode files** (relocated; short names below)
- `brainstorming`, `writing-plans`, `adding-a-feature`, `fixing-a-bug`,
  `doing-a-refactor`, `finishing-a-branch`, `release`,
  `delegating-to-agents`, `migrating-to-dev`, `starting-a-project`

**→ bundled dependency skills** (stay as skills; the installer ships them)
- `test-driven-development`, `systematic-debugging`,
  `verification-before-completion`, `receiving-code-review`,
  `dispatching-parallel-agents`
- The `dev/` mode files reference these by name. Bundling them in the
  install keeps the toolset self-contained for a contributor without a
  global config, while they still auto-invoke in VIBE.

**→ personal** (never in the toolset)
- `skill-creator`, `writing-skills`, `wallarm-*`

## Rules (9)

**→ `dev/` mode files** (strip `paths:` frontmatter)
- `planning`, `branch-plan`, `planning-templates`, `project-layout`,
  `changelog`

**→ hybrid**
- `git-workflow` — stays a personal global rule **and** ships as
  `dev/git-workflow.md` + the branch-guard hook.

**→ stay global-only**
- `js`, `skills`, `claude-md`. The slice `migrate` needs from `claude-md`
  (CLAUDE.md size/content rules) is **inlined** into `dev/migrate.md`; the
  rule itself stays global.

## Short names (`~/.claude/dev/`)

| From | → | From | → |
|---|---|---|---|
| planning | `plan.md` | adding-a-feature | `feat.md` |
| branch-plan | `branch-plan.md` | fixing-a-bug | `fix.md` |
| planning-templates | `templates.md` | doing-a-refactor | `refactor.md` |
| project-layout | `layout.md` | finishing-a-branch | `finish.md` |
| changelog | `changelog.md` | release | `release.md` |
| git-workflow | `git-workflow.md` | delegating-to-agents | `auto.md` |
| brainstorming | `brainstorm.md` | migrating-to-dev | `migrate.md` |
| writing-plans | `write-plan.md` | starting-a-project | `start.md` |

Companions travel with their mode file (`auto.md` ← verification-policy +
prompt templates; `migrate.md` ← legacy-migration, tbd-migration). The
bundled skills keep their own companions.

## Cleanup

- **`migrate.md` / `start.md`** — remove all embed/vendor instructions
  (the `vendor-toolchain.sh` reference and the R-015 embed opt-in) and
  replace with the new distribution model: global install
  (`scripts/install-dev.sh`) or a per-project `.claude/dev/` override.
- **Installer** (`scripts/install-dev.sh`) ships: `commands/dev.md`,
  `dev/`, `hooks/dev-branch-guard.sh`, the `settings.json` hook
  registration, and the 5 bundled dependency skills.
