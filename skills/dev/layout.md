# Project layout

Canonical structure for `.claude/` in a project. Other paths inside
`.claude/` need explicit justification.

## Layout

    .claude/
    ├── REQUIREMENTS.md           # foundational requirements
    ├── DESIGN.md                 # architecture and design (≤1000w inline)
    ├── MAINTENANCE.md            # sanity routine - seeded from template
    ├── plans/                    # planning hierarchy - see plan.md
    │   ├── ROADMAP.md            # initiative index
    │   ├── release-vX.Y.Z.md
    │   ├── R-XXX-<slug>/         # one per roadmap entry (initiative-time)
    │   │   ├── requirements.md   # initiative requirements
    │   │   ├── tasks.md          # this initiative's task index (lazy)
    │   │   ├── T-XXX-<slug>.md
    │   │   ├── T-XXX-<slug>.findings.md
    │   │   └── batches/          # B-XXX.md + B-XXX.report.md (lazy)
    │   ├── archive/              # optional: shipped releases, pre-DEV legacy
    │   └── visual-artifacts/     # brainstorming mockups (lazy, gitignored)
    ├── skills/                   # project skill overrides
    │   └── <name>/SKILL.md
    ├── rules/                    # project-scoped rules (paths: scoped)
    │   └── *.md
    ├── commands/                 # project-specific slash commands (optional)
    ├── agents/                   # project-specific agents (optional)
    ├── hooks/                    # Claude Code hooks (e.g. dev-branch-guard.sh)
    ├── adr/                      # architecture decision records (lazy)
    │   └── NNN-<short-title>.md
    ├── references/               # external docs/specs the agent reads (lazy)
    │   └── *                     # any format
    ├── docs/                     # internal own-code feature docs, kept current (lazy)
    │   └── *.md
    ├── settings.json             # Claude Code shared config
    └── settings.local.json       # Claude Code local (gitignored)

## Baseline files (project root)

Scaffolded at the project root, alongside `.claude/`:

| File | When | Purpose |
|---|---|---|
| `README.md` | required | overview + how to run |
| `CLAUDE.md` | required | stack, base branch, `## Agent toolchain` (host + build/test/lint), conventions |
| `.gitignore` | required | must ignore `.env` and `.claude/settings.local.json`; under untracked mode (`companions/untracked-claude.md`) ignores all of `.claude/` and `CLAUDE.md` |
| `.env.example` | if the project uses env vars | placeholder vars; commit this, never `.env` |

`.env` itself is never committed (kept gitignored). Stack-specific files
(`.dockerignore`, lockfiles) are added per project, not part of the baseline.
`start.md` scaffolds these - `.gitignore` and `.env.example` from the seed
templates in `companions/`, `README.md`/`CLAUDE.md` per its own steps.

## Creation policy

- **Required at scaffold**: `REQUIREMENTS.md`, `DESIGN.md`, `plans/`,
  `settings.json`.
- **Created as workflows need them**: `skills/`, `rules/`, `commands/`,
  `agents/`, `MAINTENANCE.md`, `plans/ROADMAP.md`; `hooks/` (shipped by
  the DEV toolset installer - `dev-branch-guard.sh`).
- **Initiative-time**: `plans/R-XXX-<slug>/` + `requirements.md`,
  created with the ROADMAP entry (`plan.md § Directory
  conventions`).
- **Lazy** (created on first use): `adr/`, `references/`, `docs/`,
  `plans/R-XXX-<slug>/tasks.md` (with the R's first task),
  `plans/R-XXX-<slug>/batches/`, `plans/archive/`,
  `plans/visual-artifacts/` (gitignored - session artifacts, not docs).

## Disallowed in `.claude/`

- Generated/build artifacts
- Cache files (use platform conventions outside `.claude/`)
- Secrets, credentials
- Temporary scratch outside the structures above

## References

`references/` holds external inputs the agent consults: API specs
(OpenAPI), third-party docs, domain knowledge, schema files. Any
format. **Read-only** - the agent never modifies these.

## Docs

`docs/` holds internal documentation of how our own code works: per-feature
docs (data model, interfaces, business rules, edge cases) sitting between
`DESIGN.md` (architecture) and the code (line-level). Feature docs are the
Reference application of the global documentation framework
(`companions/documentation.md`). The bar: from the doc
and its references alone, a fresh agent composes a correct, working
invocation with the full input set - if answering needs the source, the doc
fails. Distinct from `references/` - `references/` is external and read-only,
`docs/` is internal and kept current with the code.

The granularity model - a doc per feature, page, section, or block - is a
per-project choice. Pick the one that fits the project, record it in
`CLAUDE.md § Conventions`, and apply it consistently.

`.claude/docs/index.md` catalogs the docs - one line per doc, its path and
what it covers - consulted before coding to find the feature's doc, and
updated whenever a doc is added. Project `CLAUDE.md § Conventions` carries a
one-line pointer to the index, so it is discoverable from the always-loaded
file without bloating it (`start.md` seeds the pointer, `migrate.md`
backfills it).

The framework's Reference skeleton applied to a feature:

| Section | Holds for a feature |
|---|---|
| 1. Overview | What it does, from the user's / caller's view |
| 2. Model | Entities, fields, types, relationships, invariants |
| 3. Elements | The feature's components -> responsibility |
| 4. Behavior | Business rules and why; edge cases, failure modes, and how each is handled |
| 5. Parameters | Each method / endpoint / event: its outputs, errors, and every input it accepts |
| 6. Reference data | Domain lookups: codes, limits, fixed values |
| 7. References | Sibling docs and the feature's `references/` inputs |

§ Parameters is the feature's detail bar: every input - wired through the
code or not - one row:

    | input | type/shape | req? | default | allowed values | constraints | on invalid/missing | provenance |
    |-------|-----------|------|---------|----------------|-------------|--------------------|------------|

provenance is verified (ran it) / from-spec / unverified; state
"unverified" explicitly - never drop an input in silence.

A project may raise the bar with its own `.claude/rules/feature-docs.md` -
domain specifics and extra required content; the docs audit grades against it
where present.

## ADRs

Architecture Decision Records - one file per decision, sequentially
numbered. Referenced from `DESIGN.md` where relevant.

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
