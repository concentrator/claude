# Environment design

Architecture of the `~/.claude` configuration: the components, how they
relate, and the invariants that keep them coherent.

## Components

- **CLAUDE.md** — global operating instructions, loaded every session.
  Maintenance: `rules/claude-md.md`.
- **rules/** — path/topic-scoped rules (planning, planning-templates,
  branch-plan, project-layout, skills, claude-md), loaded as memory; the
  planning rules load only in sessions that touch plan artifacts.
- **skills/** — invocable capabilities (workflow + reference). Authoring
  and maintenance: `skills/skill-creator/`, `skills/writing-skills/`,
  `rules/skills.md`.
- **commands/**, **agents/** — optional slash commands and custom agents.
- **settings.json** — global Claude Code config. Project-scoped settings
  for this repo: `.claude/settings.local.json`.
- **plans/** — this environment's own planning hierarchy
  (`rules/planning.md`).
- **MAINTENANCE.md** — `.claude/` and project-root sanity routine.

## Self-hosting layout

This repo is consumed as `~/.claude`, so the directory that is `.claude/`
in a normal project is the repo root here. Foundational DEV files
(`REQUIREMENTS.md`, `DESIGN.md`, `MAINTENANCE.md`, `plans/`) sit at
the root, not in a nested `.claude/`. The nested `.claude/` holds only Claude Code's
project settings, whose location is fixed by the tool.

## Tree-map

All configuration dirs and files. Harness-managed state (`projects/`,
`cache/`, `shell-snapshots/`, `plugins/`, logs, …) is gitignored and
excluded — see `.gitignore`.

```
~/.claude/
├── CLAUDE.md                     # global instructions, every session
├── settings.json                 # global Claude Code config (tracked)
├── .gitignore
├── REQUIREMENTS.md               # foundational requirements
├── DESIGN.md                     # this file
├── MAINTENANCE.md                # sanity routine (template + repo-specific)
├── .claude/
│   └── settings.local.json       # project-tier local settings (gitignored)
├── plans/                        # planning hierarchy
│   ├── ROADMAP.md                # planning indexes — see rules/planning.md
│   ├── TASKS.md
│   ├── REQ-XXX.md                # four-level-era requirements (closed: history; open → R stubs on approval)
│   └── R-XXX-<slug>/             # one dir per roadmap entry (initiative-time)
│       ├── requirements.md       # initiative requirements
│       ├── T-XXX-<slug>.md
│       ├── T-XXX-<slug>.findings.md
│       └── batches/              # B-XXX manifests + reports (lazy)
├── rules/                        # rule files (always-on or path-scoped)
│   ├── branch-plan.md            # branch plan format, agentic rails (path-scoped)
│   ├── changelog.md              # CHANGELOG entry rules (path-scoped)
│   ├── claude-md.md              # CLAUDE.md maintenance rules
│   ├── js.md                     # JS conventions (path-scoped)
│   ├── planning.md               # R/T hierarchy (path-scoped)
│   ├── planning-templates.md     # requirements/release templates (path-scoped)
│   ├── project-layout.md         # canonical project .claude/ layout (path-scoped)
│   └── skills.md                 # SKILL.md maintenance rules
├── agents/
│   └── code-reviewer.md          # branch-close quality review agent
└── skills/
    ├── adding-a-feature/SKILL.md
    ├── brainstorming/
    │   ├── SKILL.md
    │   ├── visual-companion.md
    │   └── scripts/              # mockup server
    │       ├── frame-template.html
    │       ├── helper.js
    │       ├── server.cjs
    │       ├── start-server.sh
    │       └── stop-server.sh
    ├── delegating-to-agents/     # /dev auto engine
    │   ├── SKILL.md
    │   ├── implementer-prompt.md
    │   ├── spec-reviewer-prompt.md
    │   ├── verification-policy.md
    │   ├── report-template.md
    │   ├── toolchain.md
    │   └── auto-permissions.template.json
    ├── dev/SKILL.md              # DEV mode orchestrator
    ├── dispatching-parallel-agents/SKILL.md
    ├── doing-a-refactor/SKILL.md
    ├── finishing-a-branch/SKILL.md
    ├── fixing-a-bug/SKILL.md
    ├── migrating-to-dev/SKILL.md
    ├── receiving-code-review/SKILL.md
    ├── release/SKILL.md
    ├── skill-creator/SKILL.md
    ├── starting-a-project/SKILL.md
    ├── systematic-debugging/
    │   ├── SKILL.md
    │   ├── condition-based-waiting.md
    │   ├── condition-based-waiting-example.ts
    │   ├── defense-in-depth.md
    │   ├── find-polluter.sh
    │   └── root-cause-tracing.md
    ├── test-driven-development/
    │   ├── SKILL.md
    │   └── testing-anti-patterns.md
    ├── verification-before-completion/SKILL.md
    ├── writing-plans/
    │   ├── SKILL.md
    │   └── plan-document-reviewer-prompt.md
    └── writing-skills/
        ├── SKILL.md
        ├── anthropic-best-practices.md
        ├── persuasion-principles.md
        ├── testing-skills-with-subagents.md
        ├── graphviz-conventions.dot
        ├── render-graphs.js
        └── examples/CLAUDE_MD_TESTING.md
```

Project-specific skills symlinked into `skills/` from external repos
(currently the two wallarm-* ones from `~/wallarm_pure/skills`) are not
part of this configuration: gitignored, excluded from the map, versioned
in their own repo.

## Planning model

Self-development uses the planning hierarchy per `rules/planning.md`,
unchanged. The environment is a reference implementation of its own
conventions; structure is never simplified, only description detail.

## Invariants

- Every skill is reachable, documented, and non-duplicative.
- No workflow contains a dead-end or an unbounded loop.
- Rules and CLAUDE.md reference only existing paths.
- Serial DEV behaviors stay behaviorally unchanged unless a REQ changes
  them.

## Decisions

Architecture Decision Records, when needed, live in `adr/` (lazy,
per `rules/project-layout.md`).
