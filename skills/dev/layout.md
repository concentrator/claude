# Project layout

Canonical project structure, three locations: guarded config under
`.claude/`, agent-authored DEV artifacts under the declared trees
(`plan.md § Where things live`), and the docs tree at `<docs>` (§ Docs;
the keys and defaults: `companions/declarations.md § Declared paths`).
Other paths inside any of them need explicit justification.

## Config layout (`.claude/`)

What instructs agents.

    .claude/
    ├── REQUIREMENTS.md       # foundational requirements
    ├── DESIGN.md             # architecture and design (≤1000w inline)
    ├── MAINTENANCE.md        # Tier-2 review concerns + sanity routine
    ├── <layout>              # the repository's actual tree (§ Layout file)
    ├── skills/               # project skill overrides
    │   └── <name>/SKILL.md
    ├── rules/                # project-scoped rules (paths: scoped)
    │   └── *.md
    ├── commands/             # project-specific slash commands (optional)
    ├── agents/               # project-specific agents (optional)
    ├── hooks/                # Claude Code hooks
    ├── adr/                  # architecture decision records
    │   └── NNN-<short-title>.md
    ├── references/           # external inputs, read-only (§ References)
    │   └── *                 # any format
    ├── settings.json         # Claude Code shared config
    └── settings.local.json   # Claude Code local (gitignored)

## Artifacts layout (`<plans>`, `<docs>`)

What agents author: the planning tree at `<plans>`, the docs tree at
`<docs>`.

    <plans>/                  # planning hierarchy - plan.md § Where things live
    ├── ROADMAP.md
    ├── release-vX.Y.Z.md
    ├── milestone-<id>.md
    ├── R<NNN>-<slug>/        # one per roadmap entry
    │   ├── requirements.md
    │   ├── tasks.md
    │   ├── <task-id>-<slug>.md
    │   ├── <task-id>-<slug>.findings.md
    │   └── batches/
    └── archive/

    <docs>/                   # the project's documentation (§ Docs)
    ├── index.md
    ├── *.md
    ├── reports/              # probe and test reports (§ Docs)
    └── references/           # adapted external material (§ Docs)

## Baseline files (project root)

Scaffolded at the project root, alongside `.claude/`:

| File | When | Purpose |
|---|---|---|
| `README.md` | required | overview + how to run |
| `CLAUDE.md` | required | stack, base branch, `## Agent toolchain` (host + build/test/lint), `## Layout`, conventions |
| `.gitignore` | required | must ignore `.env` and `.claude/settings.local.json`; under untracked mode (`companions/untracked-claude.md`) ignores all of `.claude/` and `CLAUDE.md` |
| `.env.example` | if the project uses env vars | placeholder vars; commit this, never `.env` |

Stack-specific files (`.dockerignore`, lockfiles) are added per
project, not part of the baseline.
`start.md` scaffolds these - `.gitignore` and `.env.example` from the seed
templates in `companions/`, `README.md`/`CLAUDE.md` per its own steps.

## Creation policy

- **Required at scaffold**: `.claude/REQUIREMENTS.md`,
  `.claude/DESIGN.md`, `.claude/settings.json`, `<layout>`, `<plans>`.
- **Created as workflows need them**: `.claude/skills/`,
  `.claude/rules/`, `.claude/commands/`, `.claude/agents/`,
  `.claude/MAINTENANCE.md`; `<plans>/ROADMAP.md`;
  `.claude/hooks/` (shipped by the DEV toolset installer).
- **Initiative-time**: `<plans>/R<NNN>-<slug>/` + `requirements.md`
  (`plan.md § Directory conventions`).
- **Lazy** (created on first use): `.claude/adr/`,
  `.claude/references/`, `<docs>`,
  `<plans>/R<NNN>-<slug>/tasks.md` and `batches/` (`plan.md
  § Levels`, `§ Directory conventions`), `<plans>/archive/`.

## Disallowed in both trees

- Generated/build artifacts
- Cache files (use platform conventions outside both trees)
- Secrets, credentials
- Temporary scratch outside the structures above

## References

`.claude/references/` holds external inputs the agent consults: API specs
(OpenAPI), third-party docs, domain knowledge, schema files. Any
format. **Read-only** - the agent never modifies these; `<docs>` below
is the project's own, kept-current counterpart.

## Docs

`<docs>` holds the project's documentation - internal and external
audiences under one contract, outside the planning tree. Its per-feature
docs (data model, interfaces, business rules, edge cases)
sit between `DESIGN.md` (architecture) and the code (line-level), and
are the Reference application of the global documentation framework
(`companions/documentation.md`). Their author is the doc-writer seat, at
each branch's close (`run.md § Seats`). The bar: from the doc
and its references alone, a fresh agent composes a correct, working
invocation with the full input set - if answering needs the source, the doc
fails.

Two subdirectories hold the docs tree's other types
(`companions/documentation.md § Diataxis typing`): `<docs>/reports/`
for probe and test reports, `<docs>/references/` for adapted
external or codebase material.

The granularity model - a doc per feature, page, section, or block - is a
per-project choice. Pick the one that fits the project, record it in
`CLAUDE.md § Conventions`, and apply it consistently.

`<docs>/index.md` catalogs the docs - one line per doc, its path and
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
| 7. References | Sibling docs, report docs, and adapted references |

§ Parameters is the feature's detail bar: every input - wired through the
code or not - one row:

    | input | type/shape | req? | default | allowed values | constraints | on invalid/missing | provenance |
    |-------|-----------|------|---------|----------------|-------------|--------------------|------------|

provenance is verified (ran it) / from-spec / unverified / mixed;
state "unverified" explicitly - never drop an input in silence.
`mixed` is for a row whose claims differ in strength - part executed,
part read from source - and it names which part is which rather than
rounding the row to its strongest or weakest claim. A doc may not
restate or narrow these definitions in its own preamble: a local
redefinition makes a false mark unfalsifiable, since a reviewer
checking the table against the doc's own wording finds compliance.
Cite this line instead.

`verified` means the behaviour was executed and the execution could
have failed. A run whose inputs cannot distinguish the documented
behaviour from its fallback is a demonstration, not a verification -
choose inputs that would have produced a different result had the
claim been wrong.

A project may raise the bar with its own `.claude/rules/feature-docs.md` -
domain specifics and extra required content; the docs audit grades against it
where present.

## Layout file

`<layout>` holds the repository's actual tree; the trees above are the
canonical structure it is seeded from. Its shape: a title, one sentence
saying it holds the repository's actual tree, and one fenced tree whose
root line is the repository directory with a trailing slash - a
project's by its own name, `attack-checker/`; a repository consumed
at a fixed path uses that path, `~/.claude/` - drawn in the
`├── `/`└── ` style with a `#` role comment on every line. It carries
every directory and every fixed-name file; a collection of same-kind
files - the skills under a skills directory, the plans under
`R<NNN>-<slug>/`, the docs under `<docs>` - is that directory and one
pattern line, never every tracked file. It goes to the depth of the
tree in § Config layout.

`start.md` seeds it from the trees above, with the declared values
substituted and the entries the scaffold creates; `migrate.md` writes it
from an existing repository's inventory; the branch that adds or removes
an entry keeps it current (`branch-plan.md § Architecture-changing
branches`). It is project-owned - the DEV toolset installer never
writes it.

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
