# Planning rules

Three-level hierarchy for DEV mode: `R<NNN> → R<NNN>-T<NNN> → branch plan`,
planned in two rounds (§ Planning rounds). An initiative is any work
foundational `.claude/REQUIREMENTS.md` doesn't already cover.

## Levels

1. **Roadmap** - `plans/ROADMAP.md` (root-relative: § Where things
   live). Initiative index. Items: `R001: description`.
   Each entry owns `plans/R<NNN>-<slug>/`, whose `requirements.md`
   carries the initiative's motivation, goals, and acceptance
   criteria (template: templates.md). Closure: see § Approval
   and closure.
2. **Tasks** - `plans/R<NNN>-<slug>/tasks.md`, one index per
   initiative, created lazily with the R's first task (an R with no tasks
   has none). Concrete units of work. Items:
   `R001-T001 [feat]: description` - the tag in brackets
   (`[feat] | [fix] | [refactor] | [doc] | [test] | [mnt]`) declares task
   type and determines the branch prefix (`git-workflow.md § Trunk`).
   Checkbox closes only when the task's branch is merged.
   The next free id is the highest in this R's `tasks.md` plus one - no
   cross-R lookup (format: § ID format). The id itself routes: the
   task's artifacts live in `plans/R<NNN>-<slug>/`, or the same path
   under `archive/`. `ROADMAP.md` is the cross-R index - there is no
   flat global task list.
   **Right-size**: a task is a coherent, multi-commit deliverable (a
   self-contained capability or fix), not a single edit - commit-sized
   steps live in the branch-plan checklist. E.g. "add the size-scaled
   close-review policy" (rule + skill wiring + cross-refs) is one task;
   "fix a typo in a rule" is a commit within one, never a task.
3. **Branch plan** - `plans/R<NNN>-<slug>/<task-id>-<slug>.md`
   (legacy `T-XXX-<slug>.md`).
   Checkboxes per commit. Header: `task: R008-T001`. Checkbox closes at
   commit (`branch-plan.md`).

## Planning rounds

Two rounds, each emitting several artifact levels at once:

- **Shape** (`/dev plan R`) - produce the initiative's `requirements.md`
  **and** a draft task list (`tasks.md`) together, approved at one gate.
  Deferrable: for a large or uncertain initiative, approve requirements
  and defer the task list to the detail round.
- **Detail** (`/dev plan R<NNN>`) - produce the open R's tasks **and**
  their branch plans together.

**Approval authorizes planning, not code** (gate: § Approval and
closure). Approving a plan delivers its MR/PR and stops: shape-approval
authorizes the detail round; detail-approval authorizes nothing to run.
A plan round ends by proposing `/dev code <slug>`, which the user
invokes explicitly.

## Proportionality

One observed failure earns one fix and one test. Deeper proofs -
mutant cases, unfixed-copy comparisons, vendored-copy assertions - are
reserved for `dev-secrets-guard` and
`dev-branch-guard`. Hardening against a hazard that has never
fired needs explicit user approval. A shape round asks what can be
deleted before it adds.

## ID format

One shape for every id: initiative `R<NNN>`, task `R<NNN>-T<NNN>`,
batch `R<NNN>-B<NNN>` (`branch-plan.md § Agentic execution`). A letter
plus three digits per component, hyphens only between components;
one-indexed, monotonic, T and B counters scoped to the initiative. A
task moving to another initiative closes under its old id with a
one-line tombstone naming the new id; ids are never renumbered. Legacy
shapes - `R-NNN` initiatives, bare `T-NNN` (retired global counter),
`B-NNN` and `R<NNN>-B-NNN` batches - are frozen: valid, never reissued
or renamed. `REQ-XXX` is retired: requirement content carries
its parent's R id (legacy files: § Archival).

## Referential integrity

- Roadmap items are the chain root (dir act: § Directory conventions).
- Tasks reference exactly one parent roadmap item.
- Branch plans reference exactly one parent task (via header).
- Each parent must be **open** (`[ ]`) at the time the child is created.
- Commits inside a branch plan need no external refs.
- Findings promotion too: a finding becomes a task
  only under a fitting open `R<NNN>`. If none exists, create an R stub
  instead - the initiative act per § Directory conventions, shaped
  in a later shape round (`/dev plan R`).
- Only a discovery that blocks the current task's goal becomes a task
  immediately. Anything else is an unnumbered backlog line in the owning
  R's `tasks.md`, promoted to a task - or dropped - at that R's next
  shape/detail round.

## Where things live

Artifact paths resolve against the project's **artifacts root**: a
repo-relative directory outside `.claude/`, declared as `DEV artifacts
root:` in `CLAUDE.md § Agent toolchain` (syntax:
`companions/declarations.md § Artifacts root`); absent, the root is
`dev/`. `./` (or `.`) is the repo root; a trailing slash is
insignificant. Skills never guess the root. `<root>/` marks it in tables
and trees; bare artifact paths in prose (`plans/...`,
`docs/...`) are root-relative; a materialized path (a `.gitignore`
entry, a permission glob, a session dir) carries the resolved value -
for the repo root the segment collapses. Guarded config is not an
artifact: it stays under `.claude/`, `REQUIREMENTS.md` and `DESIGN.md`
included (`layout.md § Config layout`).

| File | Location |
|---|---|
| `ROADMAP.md` | `<root>/plans/` |
| `requirements.md` (per initiative) | `<root>/plans/R<NNN>-<slug>/` |
| `tasks.md` (per initiative, lazy) | `<root>/plans/R<NNN>-<slug>/` |
| `<task-id>-<slug>.md` (branch plans) | `<root>/plans/R<NNN>-<slug>/` |
| `<task-id>-<slug>.findings.md` | beside its branch plan |
| `R<NNN>-B<NNN>.md`, `R<NNN>-B<NNN>.report.md` (batches) | `<root>/plans/R<NNN>-<slug>/batches/` |
| `release-vX.Y.Z.md` | `<root>/plans/` |
| `milestone-<id>.md` (§ Milestone plans) | `<root>/plans/` |

These locations are exclusive - never place plans or specs in
`docs/` or other project directories.

## Directory conventions

- One plan directory per roadmap entry: `plans/R<NNN>-<slug>/`, created
  at initiative time - a new initiative is one act: ROADMAP entry +
  dir + `requirements.md` (`approved: pending`). Slug derives from the
  roadmap entry subject, is fixed at creation, and is never renamed on
  roadmap rewording.
- Branch naming: `git-workflow.md § Trunk`.
- `R<NNN>-<slug>/batches/` is created with the R's first batch
  manifest; batches are scoped to that single R (`branch-plan.md
  § Batches`).

## Where plans live in git

Planning artifacts (§ Where things live) live on `main`, visible from
every branch, reaching it via a plan branch + MR/PR like any change
(`git-workflow.md § Trunk`). A single planning act still commits each
artifact type separately - `requirements.md` apart from the `ROADMAP`
/ `tasks.md` index edits.

## Cross-plan dependencies

A branch plan may declare `depends-on: R008-T001` in its header. `/dev code`
refuses to start the branch until the dependency is merged.

## Adjusting existing plans

After the rounds, adjust in place:

- **Initiative requirements** (`plans/R<NNN>-<slug>/requirements.md`):
  `/dev plan R<NNN>` to extend.
- **Branch plan (`<slug>`)**: `/dev plan <slug>` to add commits after
  the final.
- **Roadmap items, tasks** (single-line entries): direct file edit.
- Never rewrite history retroactively.

## Approval and closure

`.claude/REQUIREMENTS.md` and each initiative's
`plans/R<NNN>-<slug>/requirements.md` carry a frontmatter `approved:`
field: `pending` when new, `YYYY-MM-DD` once the user confirms.
Nothing downstream proceeds while pending.

An R entry closes (`[x]` in ROADMAP) only when **both** hold:

- all child tasks are `[x]`, and
- every acceptance criterion in its `requirements.md` is verified,
  with one-line evidence per criterion, stamped
  `status: done YYYY-MM-DD` in that file's frontmatter.

The check runs on the branch completing the R's last open task, in its
mandatory final commit (`branch-plan.md § Closing routine`), judged
against `tasks.md` re-read from `main` - the closure lands with that
branch's merge. A closure the final commit could not run - concurrent
branches racing past the check, or run-dependent (later-verified)
criteria - keeps the R open and ships later via its own plan MR/PR
once verified (e.g. a batch checkpoint - `branch-plan.md § Batches`).

## Milestone plans

A milestone spanning several initiatives may carry
`plans/milestone-<id>.md` - the second root-level cross-initiative
plan beside the release plan, written via `/dev plan milestone <id>`
(template: `templates.md`). Optional: a milestone inside one
initiative is ordered by that `tasks.md`.

- **Order, never scope.** The boundary lives in an optional
  `ROADMAP.md § Milestones` map - one row per milestone, a one-line
  boundary, citing its plan where one exists; the plan cites the row.
- **Existing task ids only.** A gap the plan names gets a task
  (§ Referential integrity), never a note.
- **`depends-on` is authoritative.** The plan reads the edges into
  waves (a wave has no internal edges, so it runs in parallel) and
  never restates or overrides them; a contradicting order is a defect
  in the milestone file.

## Archival

Archival runs at **initiative** close; a closing task promotes but
never moves files. **Promote**: any durable fact the
task's artifacts established moves to its permanent home - component
behavior to docs, external-system facts to references, binding limits
to where they bind. A finding another initiative's open task still
cites is promoted before its own R closes. **Archive**:
when the initiative closes, its whole directory moves to
`plans/archive/R<NNN>-<slug>/` - requirements, task index, branch plans,
and findings together.
A living doc never cites `archive/` for operative content -
if it needs a fact from there, promotion missed it; move the fact.
(Closure-evidence stamps citing archived findings are historical, not
operative.)

Also archived at the user's option: release plans after the release
ships (offered by the `release` skill), milestone plans with every
entry `[x]` (offered by `/dev plan milestone <id>`), and pre-DEV
legacy artifacts (plan files with no `task:` header). Legacy
`REQ-XXX`: folded into `REQUIREMENTS.md`, files removed (§ ID format).

## Templates

Planning-artifact templates (foundational `REQUIREMENTS.md`,
per-initiative `requirements.md` by `kind:`, release plan, milestone
plan) live in `templates.md` - path-scoped to load only when editing
the files they instantiate.
