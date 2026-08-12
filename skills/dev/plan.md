# Planning rules

Three-level hierarchy for DEV mode: `R-XXX → R<NNN>-T<NNN> → branch plan`,
planned in two rounds (§ Planning rounds). An initiative is any work
foundational `.claude/REQUIREMENTS.md` doesn't already cover.

## Levels

1. **Roadmap** - `plans/ROADMAP.md` (root-relative: § Where things
   live). Initiative index -
   business-level features over time. Items: `R-001: description`.
   Each entry owns `plans/R-XXX-<slug>/`, whose `requirements.md`
   carries the initiative's motivation, goals, and acceptance
   criteria (template: templates.md). Closure: see § Approval
   and closure.
2. **Tasks** - `plans/R-XXX-<slug>/tasks.md`, one index per
   initiative, created lazily with the R's first task (an R with no tasks
   has none). Concrete units of work. Items:
   `R001-T001 [feat]: description` - the tag in brackets
   (`[feat] | [fix] | [refactor]`) declares task type and determines the
   branch prefix. Checkbox closes only when the task's branch is merged.
   Task ids are composite (`R<NNN>-T<NNN>`) with the T counter scoped to
   the initiative: the next free id is the highest in this R's
   `tasks.md`, plus one - no cross-R lookup. The id itself routes: the
   task's artifacts live in `plans/R-<NNN>-<slug>/`, or the same path
   under `archive/`. Legacy bare `T-XXX` ids (the retired global
   counter) stay valid and are never renumbered; they drain out through
   archival. `ROADMAP.md` is the cross-R
   index (initiative granularity) - there is no flat global task list.
   **Right-size**: a task is a coherent, multi-commit deliverable (a
   self-contained capability or fix), not a single edit - commit-sized
   steps live in the branch-plan checklist, not as separate tasks. E.g.
   "add the size-scaled close-review policy" (the rule + its skill wiring
   + doc cross-refs) is one task; "fix a typo in a rule" is a commit
   within a task, never a task of its own.
3. **Branch plan** - `plans/R-XXX-<slug>/<task-id>-<slug>.md`
   (e.g. `R008-T001-ip-verify.md`; legacy `T-XXX-<slug>.md`).
   Checkboxes per commit. Header: `task: R008-T001`. Checkbox closes at
   commit time. See `branch-plan.md`.

## Planning rounds

Two rounds; each command emits multiple artifact levels at once:

- **Shape** (`/dev plan R`) - produce the initiative's `requirements.md`
  **and** a draft task list (`tasks.md`) together, approved at one gate.
  Deferrable: for a large or uncertain initiative, approve requirements
  and defer the task list to the detail round.
- **Detail** (`/dev plan R-XXX`) - produce the open R's tasks **and**
  their branch plans together.

**Approval authorizes planning, not code** (gate: § Approval and
closure). Approving a plan delivers its
MR/PR and stops: shape-approval authorizes the detail round; detail-approval
authorizes nothing to run. A plan round never starts implementation - it
ends by proposing `/dev code <slug>`, which the user invokes explicitly.

## ID format

- Initiatives (roadmap): `R-001`, `R-002`, ...
- Tasks: `R001-T001`, `R001-T002`, ... - composite, T counter scoped to
  the initiative. A task moving to another initiative closes under its
  old id with a one-line tombstone naming the new id; ids are never
  renumbered. Legacy bare `T-XXX` (retired global counter): valid,
  frozen, never reissued.
- Batches: `B-001`, `B-002`, ... (execution grouping, not a level -
  see `branch-plan.md § Agentic execution`)
- One-indexed, three digits, monotonic within their scope.
- `REQ-XXX` is retired: requirement content carries its parent's
  R-XXX id (legacy files: § Archival).

## Referential integrity

- Roadmap items are the chain root (dir act: § Directory conventions).
- Tasks reference exactly one parent roadmap item.
- Branch plans reference exactly one parent task (via header).
- Each parent must be **open** (`[ ]`) at the time the child is created.
- Commits inside a branch plan need no external refs.
- This applies to findings promotion too: a finding becomes a task
  only under a fitting open `R-XXX`. If none exists, create an R stub
  instead - the initiative act per § Directory conventions, shaped
  in a later shape round (`/dev plan R`). Never create a task with a
  closed, missing, or unrelated parent.
- Only a discovery that blocks the current task's goal becomes a task
  immediately. Anything else is an unnumbered backlog line in the owning
  R's `tasks.md`, promoted to a task - or dropped - at that R's next
  shape/detail round.

## Where things live

Artifact paths resolve against the project's **artifacts root**: a
repo-relative directory outside `.claude/`, declared on its own line
as `DEV artifacts
root:` in `CLAUDE.md § Agent toolchain` (syntax:
`companions/toolchain.md § Artifacts root`); when the declaration is
absent, the root is `dev/`. `./` (or `.`) resolves to the repo root;
a trailing slash is insignificant. Skills never guess the root.
`<root>/` marks it in path tables and tree drawings; bare artifact
paths in prose (`plans/...`, `docs/...`) are root-relative; in a
materialized path (a `.gitignore` entry, a permission glob, a session
dir) `<root>/` stands for the resolved value - for the repo root the
segment collapses entirely. Guarded config -
what instructs agents - is not an artifact: it stays under
`.claude/`, foundational `REQUIREMENTS.md` and `DESIGN.md` included
(`layout.md § Config layout`).

| File | Location |
|---|---|
| `ROADMAP.md` | `<root>/plans/` |
| `requirements.md` (per initiative) | `<root>/plans/R-XXX-<slug>/` |
| `tasks.md` (per initiative, lazy) | `<root>/plans/R-XXX-<slug>/` |
| `<task-id>-<slug>.md` (branch plans) | `<root>/plans/R-XXX-<slug>/` |
| `<task-id>-<slug>.findings.md` | beside its branch plan |
| `B-XXX.md`, `B-XXX.report.md` (batches) | `<root>/plans/R-XXX-<slug>/batches/` |
| `release-vX.Y.Z.md` | `<root>/plans/` |

These locations are exclusive - never place plans or specs in
`docs/` or other project directories.

## Directory conventions

- One plan directory per roadmap entry: `plans/R-XXX-<slug>/`, created
  at initiative time - a new initiative is one act: ROADMAP entry +
  dir + `requirements.md` (`approved: pending`). Slug derives from the
  roadmap entry subject, is fixed at creation, and is never renamed on
  roadmap rewording.
- Findings sit beside their branch plan (§ Where things live). Branch
  naming: `git-workflow.md § Trunk`.
- `R-XXX-<slug>/batches/` is created with the R's first batch
  manifest; batches are scoped to that single R (`branch-plan.md
  § Batches`).

## Where plans live in git

Planning artifacts - requirements, design, roadmap, tasks, branch
plans, release plans - live on `main` so they are visible across all
branches, reaching it via a plan branch + MR/PR like any change
(`git-workflow.md § Trunk`). A single planning act still commits each artifact type separately -
`requirements.md` distinct from the `ROADMAP` / per-R `tasks.md` index
edits.

## Cross-plan dependencies

A branch plan may declare `depends-on: T-012` in its header. `/dev code`
refuses to start the branch until the dependency is merged.

## Adjusting existing plans

After the shape/detail rounds, adjust in place:

- **Initiative requirements** (`plans/R-XXX-<slug>/requirements.md`):
  `/dev plan R-XXX` to extend.
- **Branch plan (`<slug>`)**: `/dev plan <slug>` to add commits after
  the final.
- **Roadmap items, tasks** (single-line entries): direct file edit.
- Never rewrite history retroactively.

## Approval and closure

`.claude/REQUIREMENTS.md` and each initiative's
`plans/R-XXX-<slug>/requirements.md` carry an `approved:` field in
YAML frontmatter. New: `approved: pending`. After user confirmation:
`approved: YYYY-MM-DD`. Nothing downstream proceeds while
`approved: pending`.

An R entry closes (`[x]` in ROADMAP) only when **both** hold:

- all child tasks are `[x]`, and
- every acceptance criterion in its `requirements.md` is verified,
  with one-line evidence per criterion, stamped
  `status: done YYYY-MM-DD` in that file's frontmatter.

The check runs on the branch completing the R's last open task, in its
mandatory final commit (`branch-plan.md § Closing routine`), judged
against `tasks.md` re-read from `main` - the closure lands with that
branch's merge. A closure the final commit could not run - concurrent
branches racing past the check, or run-dependent criteria (verifiable
only by a later event) - keeps the R open and ships later via its own
plan MR/PR once verified (e.g. a batch checkpoint -
`branch-plan.md § Batches`).

## Archival

Closing archives, in two steps. **Promote**: any durable fact the
task's artifacts established moves to its permanent home - component
behavior to docs, external-system facts to references, binding limits
to where they bind. **Archive**: the branch plan and findings then move
to `plans/archive/R-XXX-<slug>/`; the `tasks.md` line stays as
the index. Findings follow their consumers, not the task's checkbox: a
closed task's findings still cited as evidence by open tasks stay
beside them until the last consumer closes; a living doc citing them
operatively means that fact's promotion is due at the citation. When
an initiative closes, its whole directory moves under `archive/` - the
backstop for retained findings. A living doc never cites `archive/` for operative content -
if it needs a fact from there, promotion missed it; move the fact.
(Closure-evidence stamps citing archived findings are historical
pointers, not operative content.)

Also archived, at the user's option: release plans after the release
ships (offered by the `release` skill) and pre-DEV legacy artifacts
(completed plan files with no `task:` chain). Legacy `REQ-XXX` content:
folded into foundational `REQUIREMENTS.md`, files removed (§ ID format).

## Templates

Planning-artifact templates (foundational `REQUIREMENTS.md`,
per-initiative `requirements.md` by `kind:`, release plan) live in
`templates.md` - path-scoped to load only when editing the
files they instantiate.
