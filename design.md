# Environment design

Architecture of the `~/.claude` configuration: the components, how they
relate, and the invariants that keep them coherent.

## Components

- **CLAUDE.md** — global operating instructions, loaded every session.
  Maintenance: `rules/claude-md.md`.
- **rules/** — path/topic-scoped rules (planning, branch-plan,
  project-layout, skills, claude-md), loaded as memory.
- **skills/** — invocable capabilities (workflow + reference). Authoring
  and maintenance: `skills/skill-creator/`, `skills/writing-skills/`,
  `rules/skills.md`.
- **commands/**, **agents/** — optional slash commands and custom agents.
- **settings.json** — global Claude Code config. Project-scoped settings
  for this repo: `.claude/settings.local.json`.
- **plans/** — this environment's own planning hierarchy
  (`rules/planning.md`).
- **maintenance.md** — `.claude/` and project-root sanity routine.

## Self-hosting layout

This repo is consumed as `~/.claude`, so the directory that is `.claude/`
in a normal project is the repo root here. Foundational DEV files
(`requirements.md`, `design.md`, `maintenance.md`, `roadmap.md`,
`tasks.md`, `plans/`) sit at the root, not in a nested `.claude/`. The
nested `.claude/` holds only Claude Code's project settings, whose
location is fixed by the tool.

## Tree-map

All configuration dirs and files. Harness-managed state (`projects/`,
`cache/`, `shell-snapshots/`, `plugins/`, logs, …) is gitignored and
excluded — see `.gitignore`.

```
~/.claude/
├── CLAUDE.md                     # global instructions, every session
├── settings.json                 # global Claude Code config (tracked)
├── .gitignore
├── requirements.md               # foundational requirements
├── design.md                     # this file
├── maintenance.md                # sanity routine (template + repo-specific)
├── .claude/
│   └── settings.local.json       # project-tier local settings (gitignored)
├── roadmap.md                    # planning indexes at root
├── tasks.md                      #   (REQ-002 layout; file moves land with T-002)
├── plans/                        # planning hierarchy
│   ├── REQ-XXX.md                # per-initiative requirements
│   ├── batches/                  # B-XXX manifests (lazy)
│   └── R-XXX-<slug>/             # one dir per roadmap entry (lazy)
│       ├── T-XXX-<slug>.md
│       └── T-XXX-<slug>.findings.md
├── rules/                        # always-loaded rule files
│   ├── branch-plan.md            # branch plan format, agentic rails
│   ├── claude-md.md              # CLAUDE.md maintenance rules
│   ├── js.md                     # JS conventions (path-scoped)
│   ├── planning.md               # REQ/R/T hierarchy, templates
│   ├── project-layout.md         # canonical project .claude/ layout
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

Self-development uses the full four-level hierarchy
(`requirements → roadmap → tasks → branch plan`) per `rules/planning.md`,
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
