# Project layout

Canonical structure for `.claude/` in a project. Other paths inside
`.claude/` need explicit justification.

## Layout

    .claude/
    ├── requirements.md           # foundational requirements
    ├── design.md                 # architecture and design (≤1000w inline)
    ├── plans/                    # planning hierarchy — see planning.md
    │   ├── roadmap.md
    │   ├── tasks.md
    │   ├── REQ-XXX.md
    │   ├── <slug>.md
    │   ├── <slug>.findings.md
    │   ├── release-vX.Y.Z.md
    │   ├── archive/              # optional, release plans only
    │   └── visual-artifacts/     # brainstorming mockups (lazy, gitignored)
    ├── skills/                   # project skill overrides
    │   └── <name>/SKILL.md
    ├── rules/                    # project-scoped rules (paths: scoped)
    │   └── *.md
    ├── commands/                 # project-specific slash commands (optional)
    ├── agents/                   # project-specific agents (optional)
    ├── adr/                      # architecture decision records (lazy)
    │   └── NNN-<short-title>.md
    ├── references/               # external docs/specs the agent reads (lazy)
    │   └── *                     # any format
    ├── settings.json             # Claude Code shared config
    └── settings.local.json       # Claude Code local (gitignored)

## Creation policy

- **Required at scaffold**: `requirements.md`, `design.md`, `plans/`,
  `settings.json`.
- **Created as workflows need them**: `skills/`, `rules/`, `commands/`,
  `agents/`.
- **Lazy** (created on first use): `adr/`, `references/`, `plans/archive/`,
  `plans/visual-artifacts/` (gitignored — session artifacts, not docs).

## Disallowed in `.claude/`

- Generated/build artifacts
- Cache files (use platform conventions outside `.claude/`)
- Secrets, credentials
- Temporary scratch outside the structures above

## References

`references/` holds external inputs the agent consults: API specs
(OpenAPI), third-party docs, domain knowledge, schema files. Any
format. **Read-only** — the agent never modifies these.

## ADRs

Architecture Decision Records — one file per decision, sequentially
numbered. Referenced from `design.md` where relevant.

Naming: `NNN-<short-title>.md` (e.g. `001-database-choice.md`).

Template:

    # ADR-001: <decision title>

    ## Status
    proposed | accepted | deprecated | superseded by ADR-NNN

    ## Context
    Why is this decision being made? What's the situation?

    ## Decision
    What is the decision?

    ## Consequences
    Positive, negative, neutral effects.
