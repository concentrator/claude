# R-021 transform manifest

Binding classification for the skills+rules → skill-router toolset
transform (requirements § Transform manifest). **Approved 2026-07-03
(revised for the skill-router pivot).** T-040–T-042 execute strictly per
this file. The `dev` skill stays the `/dev` entry and router; relocated
rules and sub-skills become **companion mode files inside `skills/dev/`**
that the router reads on demand. No command file; no top-level `dev/`.

## Skills (25)

**→ skill router** (`skills/dev/SKILL.md` - unchanged entry, slimmed to a router)
- `dev`

**→ `skills/dev/` companion mode files** (relocated; short names below)
- `brainstorming`, `writing-plans`, `adding-a-feature`, `fixing-a-bug`,
  `doing-a-refactor`, `finishing-a-branch`, `release`,
  `delegating-to-agents`, `migrating-to-dev`, `starting-a-project`

**→ bundled dependency skills** (stay as their own `skills/<name>/`; installer ships them)
- `test-driven-development`, `systematic-debugging`,
  `verification-before-completion`, `receiving-code-review`,
  `dispatching-parallel-agents`
- The `skills/dev/` companions reference these by name. Bundling keeps the
  toolset self-contained for a no-global contributor, while they still
  auto-invoke in VIBE.

**→ personal** (never in the toolset)
- `skill-creator`, `writing-skills`, `wallarm-*`

## Rules (9)

**→ `skills/dev/` companion mode files** (strip `paths:` frontmatter)
- `planning`, `branch-plan`, `planning-templates`, `project-layout`,
  `changelog`

**→ hybrid**
- `git-workflow` - stays a personal global rule **and** ships as
  `skills/dev/git-workflow.md` + the branch-guard hook.

**→ stay global-only**
- `js`, `skills`, `claude-md`. The slice `migrate` needs from `claude-md`
  (CLAUDE.md size/content rules) is **inlined** into
  `skills/dev/migrate.md`; the rule itself stays global.

## Short names (`~/.claude/skills/dev/`)

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
prompt templates; `migrate.md` ← legacy-migration, tbd-migration), under
`skills/dev/companions/`. The bundled skills keep their own companions.

## Distribution (skill precedence - no vendoring, no prefix)

Skill resolution (personal `~/.claude/skills/` > project `.claude/skills/`)
gives the desired behavior natively:
- **No-global contributor:** a project ships `.claude/skills/dev/` (+ the
  bundled skills) → it works, nothing shadows it.
- **Global contributor:** personal `~/.claude/skills/dev/` wins over any
  project copy → they use their own version.

## Cleanup

- **`migrate.md` / `start.md`** - remove all embed/vendor instructions
  (the `vendor-toolchain.sh` reference and the R-015 embed opt-in) and
  replace with the new model: install into `~/.claude/skills/` or ship
  `.claude/skills/dev/` in the project.
- **Installer** (`scripts/install-dev.sh`) ships: `skills/dev/` (router +
  companions), the 5 bundled dependency skills, and
  `hooks/dev-branch-guard.sh` + its `settings.json` registration.
