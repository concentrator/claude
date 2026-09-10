---
task: R080-T009
type: mnt
architecture-changing: true
depends-on: R080-T004
cold-read: passed
---

# R080-T009: declared layout

Branch: `mnt/layout-declaration`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 2, 5 and 9
and the acceptance criterion "Every docs, plans, session or layout path
...".

Paths stop being fixed by the rules. The project's root `CLAUDE.md`
declares its docs home, plans tree, session tree and layout file in a
`## Layout` section; the layout file holds the repository's actual tree;
`skills/dev/layout.md` stays the canonical structure both are seeded
from; and every rule, skill, CI check and hook that named `docs/` or
`dev/` literally names the declared path instead. Three things carry
the word "layout" and every sentence below qualifies which: the
canonical structure (`layout.md`), the project's layout file
(`<layout>`, `.claude/LAYOUT.md` by default) and the declaration
(`CLAUDE.md § Layout`).

Decisions the items rest on, each homed in the item that writes it:

- The declaration is a `## Layout` section after `## Supervision`, or
  directly after `## Agent toolchain` where a project has no
  `## Supervision` (`start.md § 3` and `migrate.md § 4` write none),
  so the declaration blocks are contiguous in that order; four lines
  in the house style of `companions/declarations.md`: `- Docs: docs/`,
  `- Plans: dev/plans/`, `- Session: dev/session/`, `- Layout:
  .claude/LAYOUT.md`. Values are repository-relative, directories with
  a trailing slash. An absent line or block means its default, so a
  project that has not declared keeps working on the defaults
  (`§ Desired state` 5: `docs/` for a new project, and a project keeps
  the home it has). The defaults are written literally in
  `companions/declarations.md § Declared paths` and nowhere else in
  `skills/`, `.claude/LAYOUT.md` included: a rule names the layout
  file `<layout>`; a script that reads the declaration carries its
  default once, as the fallback of the read (`.claude/LAYOUT.md` in
  `scripts/ci/check-stray.sh`), and its comments name the declaration,
  never the value.
- A rule names a declared path by its placeholder - `<docs>`,
  `<plans>`, `<session>`, `<layout>` - so `<plans>/R<NNN>-<slug>/tasks.md`
  reads as before with the root resolved through the declaration
  (`§ Desired state` 9). The structure inside a declared root
  (`R<NNN>-<slug>/`, `archive/`, `index.md`, `reports/`,
  `references/`) is the canonical structure's and stays literal.
- The runner's ledger directory is not declared: it is `supervisor/`
  in the session tree's parent directory (`dev/supervisor/` under the
  default), gitignored like the session tree, so no existing path
  moves and no fifth key is added to the four `§ Desired state` 9
  names.
- This repository is its own project and its `.claude/` is the
  repository root (`DESIGN.md § Self-hosting layout`), so its layout
  file is `LAYOUT.md` at the root and its declaration says so. This
  `CLAUDE.md` loads in every project's session, so the block carries
  the preface its two sibling blocks carry: this repository's own, a
  project's own wins, a project without one is on the defaults. The
  tree that file holds is the one `DESIGN.md § Tree-map` holds today:
  two homes for one tree drift, so the tree moves and `DESIGN.md`
  cites it (`§ Desired state` 9; `rules/writing-artifacts.md § One
  home per number`).

`README.md` is the doc writer's (`run.md § Seats`; `branch-plan.md
§ Commit cadence` 2). The facts it will need: `LAYOUT.md` is a new
tracked root file holding the tree-map `DESIGN.md` held; the DEV
artifacts and docs paths are declared per project in `CLAUDE.md
§ Layout` with `dev/` and `docs/` as the defaults, no longer "the same
in every project"; the installer's and the worker clone's ignore lines
follow the target's declared session tree.

- [x] `companions/declarations.md` defines the path declaration:
  a `## Declared paths` section after `§ Supervisor bounds` giving the
  `## Layout` block's exact form (the four lines above, in that order)
  and its place - after `## Supervision`, or directly after `## Agent
  toolchain` when the project has no `## Supervision` - each key's
  meaning - `Docs:` the one documentation directory (`§ Desired state`
  5), `Plans:` the planning tree, `Session:` the per-session state
  files, `Layout:` the project's layout file - its default, and the
  absence rule (a missing line or block means the default, never a
  halt, unlike `Supervisor:`); the placeholders `<docs>`, `<plans>`,
  `<session>`, `<layout>` as the form every rule uses for a declared
  path - bare in prose (`<docs>`), the slash only before a child
  (`<docs>/index.md`) or on a tree's node line - the structure under a
  declared root staying literal; the
  ledger directory as `supervisor/` in the session tree's parent,
  gitignored like it; and `extended-docs:` retired - one docs
  directory per project, so a second docs path has no key. The
  section's intro names who reads the declaration: rules and seat
  prompts through the placeholders, the Tier-1 checks and the scripts
  that write or use the trees (the state hook, the installer) by
  reading the line. The always-ask exemption for a `CLAUDE.md` change
  confined to declaration lines covers `§ Layout` too, and
  `rules/claude-md.md § Agent toolchain declaration` names the
  `## Layout` section beside `## Supervision`.
  Approach: `declarations.md`'s intro sentence "routine commands in
  `§ Agent toolchain`, supervision in the `§ Supervision` that follows
  it" gains "and paths in the `§ Layout` after them". The new section
  mirrors `§ Supervisor bounds`: one paragraph, a fenced block of the
  four lines, then a paragraph per key in a `- **Key:**` list and the
  placeholder, ledger and retirement paragraphs. The always-ask
  sentence "except a `CLAUDE.md` change confined to the declaration
  lines this file defines (`§ Agent toolchain`, `§ Supervision`)"
  reads "(`§ Agent toolchain`, `§ Supervision`, `§ Layout`)".
  `rules/claude-md.md`'s bullet gains, after the `## Supervision`
  sentence: "A `## Layout` section after it declares the docs home,
  the plans and session trees and the layout file
  (`skills/dev/companions/declarations.md § Declared paths`)."
- [x] `layout.md` is the canonical structure with no fixed root: its
  intro and the `§ Artifacts layout`, `§ Docs`, `§ Creation policy` and
  `§ References` sentences name `<plans>`, `<docs>` and `<session>`
  where they named `dev/`, `docs/` and the repository root, the
  defaults cited to `companions/declarations.md § Declared paths`
  rather than repeated; `§ Config layout` lists `<layout>` as a node
  and its `references/` comment no longer reads "docs/specs", so the
  acceptance criterion's grep over `layout.md` finds nothing after
  this commit; a new `§ Layout file` gives `<layout>`'s shape and
  lifecycle (`§ Desired state` 9): a title, one sentence saying it is
  the repository's actual tree, and one fenced tree whose root line is
  the repository directory with a trailing slash - a project's by name
  (`attack-checker/`); this repository's is `~/.claude/`, its fixed
  path, which the `LAYOUT.md` item below keeps - in the
  `├── `/`└── ` style with a `#` role comment on every line, holding
  every directory and every fixed-name file, a collection of same-kind
  files (the skills under a skills directory, the plans under
  `R<NNN>-<slug>/`, the docs under `<docs>`) as its directory with one
  pattern line, never every tracked file - the depth `§ Config
  layout`'s own tree has; seeded by `start.md` from this file's trees
  with the declared values substituted and the entries the scaffold
  creates, written by `migrate.md` from the inventory, kept current by
  the branch that adds or removes an entry (`branch-plan.md
  § Architecture-changing branches`), project-owned and never written
  by the installer. `§ Baseline files`' `CLAUDE.md` row adds
  `## Layout`. The file stays within 300 lines and 80 characters a
  line, tree lines included: `scripts/ci/check-caps.sh` exempts
  `|`-prefixed table rows only, and the `§ Artifacts layout` root line
  sits at the limit today, so the reshaped tree is measured.
  Approach: intro: "agent-authored DEV artifacts under `dev/`" reads
  "agent-authored DEV artifacts under the declared trees"; "and the
  docs tree at `docs/` (§ Docs)" reads "and the docs tree at `<docs>`
  (§ Docs; the keys and defaults: `companions/declarations.md
  § Declared paths`)". `§ Config layout`'s tree gains
  "├── <layout>              # the repository's actual tree (§ Layout
  file)" after `MAINTENANCE.md` (76 characters), and the `references/`
  line's comment reads "# external inputs, read-only (§ References)"
  (73 characters). `§ Artifacts layout`: the heading
  reads "Artifacts layout (`<plans>`, `<docs>`)"; the planning tree's
  root reads `<plans>/` with the `plans/` line's comment and its
  children moved up one level (each line loses four characters, so
  the root line at 80 characters today fits); the docs tree's root
  reads `<docs>/`; "the planning tree under `dev/`, the docs tree at
  the repository root" reads "the planning tree at `<plans>`, the docs
  tree at `<docs>`". `§ Creation policy`: `dev/plans/` reads
  `<plans>`, `docs/` reads `<docs>` (bare, the placeholder spelling
  `declarations.md § Declared paths` fixes), the required set gains
  `<layout>` after `.claude/settings.json`. `§ Docs`: "`docs/`, at the
  repository root, holds"
  reads "`<docs>` holds"; `docs/reports/`, `docs/references/`,
  `docs/index.md` read `<docs>/reports/`, `<docs>/references/`,
  `<docs>/index.md`. `§ References`' "`docs/` below" reads "`<docs>`
  below". `§ Layout file` goes after `§ Docs` and before `§ ADRs`.
- [x] `plan.md § Where things live` says the paths are declared:
  DEV artifacts live at the paths the project's root `CLAUDE.md
  § Layout` declares (`companions/declarations.md § Declared paths`) -
  `<plans>` (below), `<session>` (`handoff.md`), the docs tree
  `<docs>` (`layout.md § Docs`) - and the project's actual tree is
  `<layout>`; the sentence "repository-relative and never declared or
  resolved" goes, and the `DEV artifacts root:` Tier-1 sentence
  becomes the stale-line sentence: a `CLAUDE.md` still carrying a
  `DEV artifacts root:` or `extended-docs:` line is `migrate.md`'s to
  report with its rewrite (Stale declarations, the next item). Order:
  the check's refusal retires at the Tier-1 item below; until then it
  refuses a line this rule no longer names, a stricter gate than the
  rule for three commits, and the branch is consistent at its close.
  Guarded config stays under `.claude/`. Every other `dev/plans/` and
  `docs/` in `plan.md` (`§ Levels`, `§ Directory conventions`,
  `§ Adjusting existing plans`, `§ Approval and closure`, `§ Milestone
  plans`, `§ Archival`) reads `<plans>` or `<docs>`.
  Approach: the paragraph reads "DEV artifacts live at the paths the
  project's root `CLAUDE.md § Layout` declares
  (`companions/declarations.md § Declared paths`): `<plans>` (below)
  and `<session>` (`handoff.md`); the docs tree is `<docs>` (`layout.md
  § Docs`) and the repository's actual tree is `<layout>` (`layout.md
  § Layout file`). A `CLAUDE.md` still carrying a `DEV artifacts
  root:` or `extended-docs:` line is stale; `migrate.md` (Stale
  declarations) reports each with its rewrite. Guarded config is not
  an artifact: it stays under `.claude/`, `REQUIREMENTS.md` and
  `DESIGN.md` included (`layout.md § Config layout`)." The
  exclusivity sentence "never place plans or specs in `docs/`" reads
  "in `<docs>`". Each remaining path edits in place; `plan.md` is at
  241 lines and the placeholders are shorter than the paths they
  replace.
- [x] `start.md`, `migrate.md`, `companions/root-migration.md` and
  `companions/gitignore.template` write the declaration and the layout
  file (`§ Desired state` 9). `start.md § 3` writes `## Layout` with
  the four defaults directly after `## Agent toolchain` (the scaffold
  writes no `## Supervision`) - no question, `docs/` being a new
  project's home (`§ Desired state` 5) - seeds `<layout>` per
  `layout.md § Layout file`, and appends the session tree's two
  anchored ignore lines - `<session>` and `supervisor/` in its parent,
  the lines `install-dev.sh` step 7 writes - to the `.gitignore` it
  seeded, so `gitignore.template` carries no session or ledger lines
  and the defaults keep their one home; the "extended docs?" question
  goes; `dev/plans/` (the scaffold bullet and the release plan) and
  `docs/`, `docs/index.md` read `<plans>`, `<docs>`, `<docs>/index.md`.
  `migrate.md`: the intro probes `<plans>` (its default, absent a
  declaration) and the legacy `.claude/`, bare `dev/` surviving
  nowhere in the file; the route list names `.claude/plans/`,
  `.claude/docs/` and `dev/docs/` as migration sources only and
  `<plans>`, `<docs>` as destinations; the `dev/docs/`-layout route
  offers the move to `<docs>` or the declaration of `dev/docs/` as the
  home the project keeps, the user's call, and writes the declaration
  either way; "Stale root" becomes "Stale declarations" - a `DEV
  artifacts root:` or `extended-docs:` line, each reported with its
  rewrite to a `§ Layout` key: an `extended-docs:` path becomes
  `Docs:`, the home the project keeps, and a `docs/` beside it is a
  collision `root-migration.md § 1 Collisions` names for the user to
  resolve as it does every other (merge, rename or abort), never a
  move `root-migration.md` performs; § 1 inventories `<docs>`,
  `<layout>` and the `## Layout` block; § 4 backfills `## Layout` from
  the inventory (the docs where they sit, the plans tree after the
  move, the defaults otherwise), after `## Supervision` where present
  and after `## Agent toolchain` otherwise, and writes `<layout>` from
  `git ls-files` per `layout.md § Layout file`, and its
  `## Conventions` list drops `extended-docs`; § 6 and § 7 read
  `<plans>` and `<docs>`. `root-migration.md`: its intro, move set,
  Collisions, Gaps, § 2 steps 1, 3 and 4 and the closing verify
  sentence name `<plans>` and `<docs>` where they named `dev/`,
  `dev/plans/` and `docs/`; the rewrite set's and step 2's sources
  (`.claude/plans`, `.claude/docs`, `dev/docs`) stay literal; `§ 1
  Gaps` names a missing or stale declaration in place of the `DEV
  artifacts root:` Tier-1 sentence and its untracked-mode line names
  `<plans>` and `<session>`; § 2 step 3 writes the declaration and
  `<layout>`.
  Approach: `start.md § 3`: line 28 reads "- `<plans>` with
  `ROADMAP.md`."; line 35 reads `<plans>/release-v0.1.0.md`; the "Ask:
  **extended docs?**" paragraph reads "Write `## Layout` after
  `## Agent toolchain` with the defaults (`companions/declarations.md
  § Declared paths`), seed `<layout>` from `layout.md § Layout file`,
  and append `<session>` and `supervisor/` in its parent to
  `.gitignore`, anchored, as `install-dev.sh` step 7 writes them."; the
  `docs/` pointer sentence (lines 42-43) stays with `<docs>` and
  `<docs>/index.md`. `gitignore.template` lines 10-15 (the "DEV
  session state" and "Supervisor ledger" pairs and the blank after
  them) go, line 9's blank then separating the Claude Code block from
  the dependencies block. `migrate.md`'s
  intro (lines 4-6): "DEV artifacts live at `dev/` (`plan.md § Where
  things live`); probe both `dev/` and the legacy `.claude/`
  locations" reads "DEV artifacts live at the declared paths (`plan.md
  § Where things live`); probe `<plans>` - its default, absent a
  declaration - and the legacy `.claude/` locations"; the
  `.claude/`-layout bullet's "whether or not `dev/` also exists (a
  both-trees state is a partial migration; a `dev/`-side destination
  that already exists" reads "whether or not `<plans>` also exists
  (...; a destination that already exists" and "relocate onto `dev/`"
  reads "onto `<plans>`"; the `dev/docs/`-layout bullet reads "plans
  already on `<plans>` but docs under `dev/docs/` with no `Docs:`
  line: offer the move to `<docs>` per `companions/root-migration.md`
  or declare `dev/docs/` as the home kept (`companions/declarations.md
  § Declared paths`), the user's call; the declaration is written
  either way"; the Fresh bullet's "no `plans/` or `docs/` under either
  `dev/` or `.claude/`" reads "nothing at `<plans>` or `<docs>` and no
  `plans/` or `docs/` under `.claude/`"; the Already-DEV bullet's
  `dev/plans/ROADMAP.md` reads `<plans>/ROADMAP.md`; the "Stale root"
  paragraph (lines 40-43) reads "**Stale declarations** - a project set
  up before the paths were declared may carry a `- DEV artifacts
  root:` or `extended-docs:` line in `CLAUDE.md`, or `<root>` and
  "artifacts root" wording in its own docs. Report each hit with its
  rewrite - the root line to `- Plans:` naming the plans tree under
  it, an `extended-docs:` path to `- Docs:` as the home kept, a
  `docs/` beside it a collision (`companions/root-migration.md § 1`);
  apply on approval." `§ 1`
  line 48: "`docs/`" reads "`<docs>`, `<layout>`, the `## Layout`
  block". `§ 4`: "(release-routine, publish-external, extended-docs,
  and a `docs/index.md` pointer if the docs layer is used)" reads
  "(release-routine, publish-external, and a `<docs>/index.md` pointer
  if the docs layer is used), a `## Layout` section after
  `## Supervision` where present and after `## Agent toolchain`
  otherwise, backfilled from the inventory (`companions/declarations.md
  § Declared paths`), and `<layout>` written from `git ls-files`
  (`layout.md § Layout file`)". `§ 6` line 93 and `§ 7` line 101 read
  `<plans>` and `<docs>`. `root-migration.md`: lines 3-4 "onto `dev/`
  and its docs onto `docs/`" read "onto `<plans>` and its docs onto
  `<docs>`"; line 6 "already on `dev/`" reads "already on `<plans>`";
  line 15 "→ `dev/plans/`" reads "→ `<plans>`"; line 17 "→ `docs/`"
  reads "→ `<docs>`"; lines 32-33 "(`dev/plans/` or `docs/`: a partial
  earlier migration)" read "(`<plans>` or `<docs>`: a partial earlier
  migration; a `docs/` beside an `extended-docs:` path becoming
  `Docs:`, `migrate.md` Stale declarations)"; the Gaps
  bullet (35-39) reads "a missing `## Layout` block or a stale `DEV
  artifacts root:` or `extended-docs:` line in `CLAUDE.md`
  (`migrate.md`, Stale declarations); untracked mode, where `<plans>`
  and `<session>` must be gitignored too (`untracked-claude.md
  § Detection`)"; step 1's commands (53-54) read "`git mv
  .claude/plans <plans>` and `git mv .claude/docs <docs>` or `git mv
  dev/docs <docs>`"; step 3 reads "**Close the gaps** - write
  `## Layout` and `<layout>`, and the `.gitignore` follow-ups from
  § 1."; step 4's `docs/index.md` reads `<docs>/index.md`; line 72
  "under `dev/plans/`" reads "under `<plans>`". `migrate.md` stays
  within 300 lines and 80 columns.
- [x] The mode files name declared paths by placeholder: `write-plan.md`
  (intro, `§ Inputs`, steps 1 and 2), `branch-plan.md` (intro,
  `§ Commit cadence` 2 and `§ Batches`), `finish.md § 1`,
  `release.md` steps 1, 7 and 12, `templates.md` (the per-initiative
  heading and `§ Archival` cite), `handoff.md § The file` (the session
  file at `<session>/<session_id>.md`, the ledger at `supervisor/`
  beside `<session>`) and `run.md § Ledger` (the same ledger sentence).
  `branch-plan.md § Commit cadence` 2 drops "`extended-docs: yes` per
  project `CLAUDE.md § Conventions`" and `§ Architecture-changing
  branches`' tree-map upkeep names `<layout>` (`layout.md § Layout
  file`) in place of `DESIGN.md § Tree-map` while keeping its rule
  that an unflagged branch does not touch `DESIGN.md`. `git grep -n -E
  '(^|[^A-Za-z/._-])(docs/|dev/)' -- skills/dev/*.md` then finds only
  `dev/docs/` in `migrate.md`'s route. Every touched file stays within
  300 lines and 80 columns.
  Approach: `write-plan.md`: `dev/plans/R<NNN>-<slug>/...` reads
  `<plans>/R<NNN>-<slug>/...` at its four sites (lines 3, 15, 29, 33)
  and "the changed feature's `docs/` doc" reads "`<docs>` doc".
  `branch-plan.md` line 3; `§ Commit cadence` 2: "`docs/` with its
  index" reads "`<docs>` with its index", and the comma after "new
  public surface" and the `extended-docs` clause go, so the list ends
  "`README.md` for new public surface - is the doc writer's", the dash
  closing the pair opened at "ships -"; `§ Architecture-changing
  branches`' second sentence (lines 148-150, "Other branches touch
  `DESIGN.md` only for tree-map upkeep ...") reads "Other branches
  never touch `DESIGN.md`; any branch that adds or removes an entry
  keeps `<layout>` current (`layout.md § Layout file`), foldable into
  the final commit without the flag.", the paragraph rewrapped within
  80 columns (`branch-plan.md` is at 252 lines, so a fifth line fits);
  `§ Batches`'
  manifest path (line 188). `finish.md § 1` first bullet. `release.md`
  1, 7, 12.
  `templates.md`: the heading "## Per-initiative
  `<plans>/R<NNN>-<slug>/requirements.md`" (the `§ Per-initiative`
  cite in `brainstorm.md` still resolves) and line 121. `handoff.md`:
  "`dev/session/<session_id>.md`, gitignored" reads
  "`<session>/<session_id>.md` (`CLAUDE.md § Layout`), gitignored";
  "its ledger, `dev/supervisor/<scope>.md`" reads "its ledger,
  `supervisor/<scope>.md` beside `<session>`". `run.md § Ledger`: "is
  `dev/supervisor/<scope>.md` in the checkout, beside `dev/session/`
  and ignored like it" reads "is `supervisor/<scope>.md` beside
  `<session>` (`companions/declarations.md § Declared paths`), ignored
  like it" - 21 characters more; `run.md` is at 300 lines, so the
  paragraph (lines 270-283) is rewrapped to fill its 14 lines, which
  it does at 12 lines of 80 columns.
- [x] The cold read has two bounds (`§ Desired state` 2): `write-plan.md`
  step 6 states them, and its restatements in
  `companions/verification-policy.md § Comprehension check` and
  `companions/planner-prompt.md § Exit` say the same. Delta read: the
  first read covers the whole plan; a later read is scoped, in the
  reader's dispatch, to the items the planner changed and the lines
  the previous read's gaps named. Two-read cap: the second read is the
  last - an acceptance gap it still reports goes to the task's
  findings file, `<task-id>-<slug>.findings.md` beside the plan
  (`implementer-prompt.md § Plan & Findings Files`; created if
  absent), as a note the implementer reads, one bullet per gap with
  the gap's text; the header then records `cold-read: passed` and no
  planner is re-dispatched for it. Restart: a planner change made
  after the pass is recorded - one `run.md § Question resolution` or
  `plan.md § Adjusting existing plans` sends to step 6 - starts its
  own count of two reads, scoped to what it changed. The session
  writes the notes with the header edit, in the bookkeeping commit
  step 6 already gives it.
  An approach gap is fixed once with no re-read, as step 6 has it.
  `implementer-prompt.md § Inputs`' Plan bullet names the findings
  file beside the plan, so the notes reach the implementer as an
  input, its three-input rule intact. `tasks.md`'s R080-T009 backlog
  paragraph drops the clause "the cold read (`skills/dev/write-plan.md`
  step 6) needs a stopping rule - two rounds, then judgment-level gaps
  go to the findings file", the rule now carrying it. Every other site
  that names the loop stays as it is, none stating a round: `run.md
  § Question resolution` (lines 130-137) and `§ Sync` (298-299) send a
  changed plan to step 6, so `run.md` stays at 300 lines untouched;
  `plan.md § Adjusting existing plans` and `§ Approval and closure`,
  `branch-plan.md § Header` and `§ Agentic execution`, `run.md
  § Seats` and `write-plan.md § Bulk mode` cite step 6 or the record;
  `planner-prompt.md` Job 3 draws the acceptance/approach split. `git
  grep -n -E 're-runs the read|re-read|cold read' -- skills/dev` after
  the commit hits only those sites, the three rewritten ones and four
  uses of the words outside the loop (`plan.md § Approval and closure`'s
  `tasks.md` re-read, `branch-plan.md § Session boundary`'s doc loading,
  `write-plan.md § Readiness checklist`, `implementer-prompt.md § When
  You're in Over Your Head`).
  `write-plan.md` is capped at 300 lines of 80 columns
  (`scripts/ci/check-caps.sh`, the mode-file loop); the companions
  are exempt from it.
  Approach: `write-plan.md` step 6, after "an approach gap is fixed
  once and re-runs no read (`run.md § Seats`)", continues: "Two
  bounds: the first read covers the whole plan, a later one only the
  items the planner changed and the lines the previous read's gaps
  named; and the second read is the last - an acceptance gap it still
  reports goes to `<task-id>-<slug>.findings.md` beside the plan
  (created if absent) as a note the implementer reads, and no planner
  is re-dispatched. A planner change made after the pass is recorded
  starts a count of its own, scoped to what it changed. When the read
  reports none, or at the second read, the header records
  `cold-read: passed`. The session commits that header edit and the
  notes on the branch the planner committed to - the record is
  bookkeeping, not plan text." - the sentence "when it reports none
  the header records `cold-read: passed`. The session commits that
  header edit on the branch the planner committed to - the record is
  bookkeeping, not plan text" going in its favour; the step grows
  from 14 to 18 lines and the file from 120 to 124.
  `verification-policy.md § Comprehension check`: "an acceptance gap
  re-runs the read per `write-plan.md` step 6," reads "an acceptance
  gap re-runs the read once, over the change, per `write-plan.md` step
  6, which sends what the second read still finds to the findings
  file;". `planner-prompt.md § Exit`: "re-dispatches a planner with the
  gap's text and re-runs the read, an approach gap once with no second
  read," reads "re-dispatches a planner with the gap's text and re-runs
  the read over the change - once, what the second read still finds
  going to the findings file (step 6) - an approach gap once with no
  second read,". `implementer-prompt.md § Inputs`, the Plan bullet,
  gains a third sentence: "Its `<task-id>-<slug>.findings.md`, where
  one exists, carries the read's open notes: read them with it."
  `tasks.md` lines 89-93: "questions; the cold read (...) needs a
  stopping rule - two rounds, then judgment-level gaps go to the
  findings file - and a plan change should stay" reads "questions; a
  plan change should stay", rewrapped.
- [x] The companions and the reviewer agent name declared paths by
  placeholder, seat prompts naming the declaration at the first use so
  a dispatched seat resolves it without `declarations.md`:
  `companions/documentation.md` (five sites), `doc-writer-prompt.md`
  (the Docs input, Job 2, which also drops "`extended-docs: yes` per
  the project's `CLAUDE.md § Conventions`"), `implementer-prompt.md`
  (the `## Conventions` sentence and `§ Plan & Findings Files`'
  "artifacts root"), `docs-adoption.md` (three sites),
  `report-template.md` (the report path; "README / extended docs"
  reads "README"), `legacy-migration.md` and `tbd-migration.md` (the
  flat-index and archive paths; `tbd-migration.md § 2` diffs the trees
  against `<layout>` and `layout.md`), `untracked-claude.md` (the
  artifacts root sentence, the `dev/` gitignore checks naming
  `<plans>` and `<session>`, and `<layout>` gitignored with the
  tree), `agents/code-reviewer.md` (three sites). The permissions
  template - `companions/auto-permissions.template.json`, or
  `seat-permissions.template.json` once R080-T007 renames it - drops
  its two `dev/plans/**` rules, `Read` and `Edit` (`§ Desired state`
  9: a literal `dev/` path in a rule): the blanket
  `Edit(//__PROJECT_DIR__/**)` above them covers the edit, and the
  template grants `Read` only outside the project directory, the code
  under it being read under no rule, so the plans tree is read as the
  code is. No test asserts the two lines
  (`scripts/test/worker-workspace.test.sh` case 13 checks the
  template's name and substitutions only); a tracked tier's absolute
  copy of either rule is allow-list hygiene (`MAINTENANCE.md
  § Routine`), never a plan target (`run.md § Pre-flight`). After it,
  `git grep -n -E '(^|[^A-Za-z/._-])(docs/|dev/)' -- skills/dev rules
  agents` finds a literal path only in `companions/declarations.md
  § Declared paths`, in the migration source `dev/docs/`
  (`migrate.md`'s route, `root-migration.md`'s move and rewrite sets)
  and in the prose that names a project's own `docs/` as a legacy
  location or a collision - `migrate.md`'s Fresh bullet ("no `plans/`
  or `docs/` under `.claude/`") and Stale declarations ("a `docs/`
  beside it a collision") and `root-migration.md § 1 Collisions` ("a
  `docs/` beside an `extended-docs:` path") - which names a directory
  of the project, never a default, and stays; `.claude/plans/` and
  `.claude/docs/` never match, the `/` before them excluding them;
  `git grep -n 'dev/' --
  skills/dev/companions/'*.json'` finds nothing; and `git grep -n
  'LAYOUT.md' -- skills rules agents` finds the literal default only in
  `companions/declarations.md § Declared paths`. The criterion's sweep of
  all of `skills/` adds two hits in skills outside the toolset, which
  stay: `skills/test-driven-development/testing-anti-patterns.md`
  (bundled, "docs/examples") and
  `skills/writing-skills/anthropic-best-practices.md` (personal).
  Approach: `documentation.md`: line 6 "Feature docs (`docs/`)" reads
  "Feature docs (`<docs>`)"; lines 26 and 31 "(`docs/reports/`)" and
  "(`docs/references/`)" read "(`<docs>/reports/`)" and
  "(`<docs>/references/`)"; line 131 "for `docs/`, `README.md` and the
  CHANGELOG" reads "for `<docs>`, `README.md` and the CHANGELOG", the
  "never the author" the sentence turns on kept; line 145 "`docs/`
  feature docs" reads "`<docs>` feature docs".
  `doc-writer-prompt.md`: "- Docs: `docs/` with its
  index `docs/index.md`" reads "- Docs: `<docs>`, the docs home the
  project's root `CLAUDE.md § Layout` declares, with its index
  `<docs>/index.md`"; Job 2's "the `docs/` doc and its `docs/index.md`
  line" reads "the `<docs>` doc and its `<docs>/index.md` line" and
  ", and `extended-docs: yes` per the project's `CLAUDE.md
  § Conventions`" goes, the "and" moving before "`README.md` for new
  public surface" so the three-item list closes there. The template's
  lines 6-8 (the `dev/plans/**` pair and the blank after it) go.
  `implementer-prompt.md` line 59: "`docs/`,
  `README.md`" reads "`<docs>` (the docs home `CLAUDE.md § Layout`
  declares), `README.md`"; lines 93-94: "(under the artifacts root -
  `plan.md § Where things live`)" reads "(under `<plans>` - `plan.md
  § Where things live`)". `docs-adoption.md` lines 29, 36, 44.
  `report-template.md` line 3 path and line 37. `legacy-migration.md`
  lines 15, 29; `tbd-migration.md` lines 4, 31 ("against
  `skills/dev/layout.md`" reads "against `<layout>` and the canonical
  `skills/dev/layout.md`"), 38, 55. `untracked-claude.md`: "and the
  DEV artifacts root (`plan.md § Where things live`)" reads "and the
  declared trees (`plan.md § Where things live`)"; "verify `dev/` is
  gitignored too (`git check-ignore -q dev`)" reads "verify `<plans>`
  and `<session>` are gitignored too (`git check-ignore -q` on each)";
  the two `dev/` at lines 41 and 43 read "the declared trees";
  `§ What changes` gains "`<layout>` is gitignored with the rest of
  `.claude/`". `agents/code-reviewer.md` lines 15 - where the plans
  tree also names `CLAUDE.md § Layout`, the reviewer being a dispatched
  seat (`run.md § Seats`) - 48 and 60.
- [x] The Tier-1 plan checks read the plans tree from the declaration
  (`§ Desired state` 9; the criterion's `scripts/ci/` grep):
  `check-plan-integrity.sh`, `check-archival.sh`, `check-accretion.sh`
  and `check-batch-tags.sh` each set `P` from the `- Plans:` line of
  the root `CLAUDE.md`, default `dev/plans`, trailing slash stripped -
  the checks already `cd` to `git rev-parse --show-toplevel`, where
  the root `CLAUDE.md` is - and a repository without a `CLAUDE.md`
  gets the default under `set -euo pipefail` (the read is guarded; a
  bare `sed | head` there exits 2 under `pipefail` and kills the
  script). `check-batch-tags.sh` lists the trunk's tree under the `P`
  the worktree's `CLAUDE.md` declares: the branch's declaration is the
  one its tags resolve against, and a trunk whose tree sits elsewhere
  is a migration in flight that moves tree and declaration together
  (`root-migration.md § 2`). Each check's header comment names the
  declaration where it said the home is fixed and never repeats the
  default, which the fallback line beneath shows; that fallback,
  `P=${P:-dev/plans}`, is the one `dev/plans` in each of the four
  checks, and the criterion's grep never matches it, the `-` before
  `dev/` being a character its regex excludes, so the grep returns no
  `scripts/ci/` line. `check-plan-integrity.sh`'s `DEV artifacts
  root:` refusal goes, a stale line being `migrate.md`'s to report.
  Each check's test gains one case: a fixture whose `CLAUDE.md`
  declares `- Plans: var/plans/` with the tree there passes, and a
  violation there is caught (`plan.md § Proportionality`: one behavior
  change, one case per check); `check-plan-integrity.test.sh` case 14
  becomes that case. The two shipped checks (`check-accretion.sh`,
  `check-batch-tags.sh`) keep their vendoring shape - no shared helper
  file, the read is a two-line snippet in each - so `install-dev.sh`
  copies them unchanged.
  Approach: the snippet, after the `cd`: `P=$(sed -n 's/^- Plans: *//p'
  CLAUDE.md 2>/dev/null | head -1 || true); P=${P:-dev/plans};
  P=${P%/}` - probed under `set -euo pipefail` in a directory without
  `CLAUDE.md` (yields `dev/plans`, exit 0) and with `- Plans:
  var/plans/` (yields `var/plans`). `check-batch-tags.sh`: `"$P"` in
  the `ls-tree` (line 40), the comments at 14-15 and 49 name the
  declaration; `check-archival.sh`: `$P` in the `for` glob (13) and
  the message (34), the header (3-5) reads "leaves the plans tree
  `CLAUDE.md § Layout` declares"; `check-accretion.sh`: the `P=` line
  (21) and the header (4); `check-plan-integrity.sh`: the `P=` line
  (18) with the `grep -q '^- DEV artifacts root:'` line and its
  message (19-20) deleted and the comment (12-14) reading "Plans live
  at the tree the root CLAUDE.md § Layout declares (skills/dev/plan.md
  § Where things live)". Tests: each `mkrepo` stays on the default -
  three fixtures have no `CLAUDE.md`, `check-batch-tags.test.sh`'s
  commits one holding `fixture` and no `- Plans:` line (lines 22-23) -
  and the new case writes `- Plans: var/plans/` to the fixture's
  `CLAUDE.md` (overwriting that line there) and the tree under
  `var/plans/`, then asserts with each test's own helpers: `ok_in`
  then `fails_with` in `check-plan-integrity.test.sh` (case 14, whose
  "fixed at dev/" assertion goes with the check it tested) and
  `check-archival.test.sh`; `check_in` then `hits_in` in
  `check-accretion.test.sh`; `out_in` in `check-batch-tags.test.sh`,
  whose fixture commits the `CLAUDE.md` and a `var/plans/` batch dir on
  trunk as `mklive` and `mkstale` do under `dev/plans/`.
- [x] The state hook and the installer follow the declaration and the
  installer touches neither the declaration nor `<layout>`
  (`§ Desired state` 9, "untouched by a tools refresh"; the
  criterion's refresh): `hooks/dev-precompact-state.sh` resolves the
  session directory as `DEV_STATE_DIR`, else the `- Session:` line of
  `$root/CLAUDE.md` (`$root` is already the project root the hook
  resolves from `CLAUDE_PROJECT_DIR`), else `dev/session`, and finds
  the branch's plan files under the `- Plans:` tree read the same way,
  default `dev/plans`, in place of the `plans/` substring, so a
  declared tree without `plans/` in its name still fills the tree
  block's `- plan:` line; `scripts/test/dev-precompact-state.test.sh`
  gains one case: a fixture declaring `- Session: var/state/` and
  `- Plans: var/tracks/` with an open plan committed under
  `var/tracks/` puts the file at `var/state/<id>.md` with a `- plan:
  var/tracks/...` line and no `dev/plans/` one. `scripts/install-dev.sh`
  step 7 writes the two ignore lines from the target project's
  declared session tree - the tree and `supervisor/` in its parent -
  defaulting to `/dev/session/` and `/dev/supervisor/`, and step 8's
  seeded hygiene rows name the trees by their `CLAUDE.md § Layout` key
  rather than a literal path; `scripts/test/install-dev.test.sh`
  asserts the seeded rows name the keys, that a target declaring
  `- Session: var/state/` gets `/var/state/` and `/var/supervisor/`,
  and that a target's `CLAUDE.md § Layout` block and
  `.claude/LAYOUT.md` are byte-identical across a re-run. The
  installer fixtures are git repositories on a work branch, as fixture
  `G` is: step 7 runs only for a git repository and the pre-write
  guard refuses a default-branch HEAD.
  Approach: hook lines 29-31: the comment reads "Session dir: the
  tree the root CLAUDE.md § Layout declares (skills/dev/handoff.md);
  DEV_STATE_DIR overrides it for tests." and
  `dir=${DEV_STATE_DIR:-$root/dev/session}` becomes a `sed -n 's/^-
  Session: *//p' "$root/CLAUDE.md" 2>/dev/null | head -1` read into
  `decl`, then `dir=${DEV_STATE_DIR:-$root/${decl:-dev/session}}` with
  the trailing slash stripped (the hook runs `set -uo pipefail`, no
  `-e`, so the read needs no guard); the same read of `- Plans:` into
  `plans_dir` - `plans` names the result two lines on, and one name for
  two meanings is a trap - default `dev/plans`, and the filter
  `grep -E '(^|/)plans/.*\.md$'` (line 49) reads
  `grep -E "^$plans_dir/.*\.md$"`. The test's
  new case goes after the clean-tree case (line 80) and before the
  `cd "$D"` at line 82, where the fixture sits on `main` with the
  dirty change stashed: it runs `git -C "$R" checkout -q work`, writes
  the `CLAUDE.md`, `mkdir -p var/tracks/R`, a plan file with an open
  box, `git add -A` and commits on `work`, runs the hook with session
  id `s6`, and asserts `var/state/s6.md` exists, carries a `- plan:
  var/tracks/R/...` line as case 1 does (line 53) and no `dev/plans/`
  line - `dev/plans/R/T1.md` is in the branch's diff too, so the old
  `plans/` filter would list it. Placed earlier, a second `s1` write
  would land at `var/state/` and break the append count at line 56;
  the fixture comment at line 36 "as install-dev.sh
  and the template leave a real repo" reads "as install-dev.sh leaves
  a real repo", the template no longer carrying the line. Installer
  step 7: read the same way from `$repo/CLAUDE.md` - the git
  toplevel line 214 resolves, where the `.gitignore` it writes is -
  with `|| true` (the installer runs under `set -e`), into `sess`,
  default `dev/session`, trailing slash stripped; the parent goes to
  `parent=$(dirname "$sess")` with `if [ "$parent" = "." ]; then
  parent=""; fi` in place of a `/./` string fixup, since an explicit
  empty parent reads plainly and cannot trip `set -e`, and the lines
  are `/$sess/` and `/${parent:+$parent/}supervisor/` (probed under
  `set -e`: `var/state/` yields `/var/state/` and `/var/supervisor/`,
  `state/` yields `/state/` and `/supervisor/`, and no `CLAUDE.md`
  yields the two defaults); the comment names `CLAUDE.md § Layout`.
  Step 8's
  rows: "| `dev/session/` |" reads "| the `Session:` tree (`CLAUDE.md
  § Layout`) |" and "| `dev/plans/` |" reads "| the `Plans:` tree
  (`CLAUDE.md § Layout`) |". `install-dev.test.sh` line 244's two
  greps read `Session:` and `Plans:`; both new assertions share one
  fixture rather than taking a project each - the file stands at 291
  lines against check-code-size's 300-line cap, and two fixtures do not
  fit - a `git init` project on `checkout -qb work` (lines 273-274's
  shape) whose root `CLAUDE.md` carries the block and whose
  `.claude/LAYOUT.md` is `cmp`d after the second install. The same cap
  merges fixture `G`'s two "ignored once" counts into one assertion,
  its anchoring checks untouched; the file lands at 299.
- [x] The worker clone excludes the declared session tree:
  `scripts/worker-workspace.sh`'s project-clone step reads the
  `- Session:` line of each cloned checkout's root `CLAUDE.md`, default
  `dev/session/`, and writes that tree and `supervisor/` in its parent
  to the checkout's `.git/info/exclude` (the sibling repository has no
  declaration and gets the default); its dry-run text and comment name
  `CLAUDE.md § Layout` in place of the literal pair;
  `scripts/test/worker-workspace.test.sh` case 45 asserts the dry-run
  names `CLAUDE.md § Layout` and `info/exclude`, an assertion the
  current text fails. `project_clone()` stays under
  `scripts/ci/check-code-size.sh`'s 50-line function cap (48 today).
  Approach: the exclude block (lines 105-109, comment included) moves
  out of `project_clone()` into a helper `exclude_session_tree()`
  defined directly above it, called as `exclude_session_tree
  "$root/$name"` in its place, and line 97 reads `local name`; the
  function then has 44 lines. The helper's comment reads "run.md
  § Ledger appends to supervisor/ beside the session tree CLAUDE.md
  § Layout declares and handoff.md to that tree while a worker may run
  git add -A, so both must be ignored whatever the cloned .gitignore
  says"; its body: `local ex="$1/.git/info/exclude" sess sup`, the
  hook's `sed -n 's/^- Session: *//p' "$1/CLAUDE.md" 2>/dev/null |
  head -1` read into `sess` (default `dev/session/`, slash stripped),
  `sup=$(dirname "$sess")/supervisor` with a leading `./` stripped,
  and the write `grep -q "^$sup/$" "$ex" 2>/dev/null || printf
  '%s/\n%s/\n' "$sess" "$sup" >> "$ex"` (the script runs `set -uo
  pipefail`, no `-e`). Lines 87-88's dry-run pair becomes three
  `printf` lines: "  - exclude the session tree CLAUDE.md § Layout
  declares and supervisor/", "    beside it in each checkout via
  .git/info/exclude - the ledger must" and "    not dirty the tree";
  the test's comment (225-226) reads "the harness writes the declared
  session tree and its supervisor/ sibling" and its grep (227) reads
  `grep -q 'CLAUDE.md § Layout' <<<"$out" && grep -q 'info/exclude'
  <<<"$out"`.
- [x] This repository declares its layout and holds its tree in
  `LAYOUT.md`: `CLAUDE.md` gains `## Layout` after `## Supervision`,
  opening with the preface its two sibling blocks carry - this
  repository's own declarations; a project's own `## Layout` wins, and
  a project without one is on the defaults - then `- Docs: docs/`,
  `- Plans: dev/plans/`, `- Session: dev/session/`, `- Layout:
  LAYOUT.md` (the root, per `DESIGN.md § Self-hosting layout`; the
  file stays within its 100-line cap, `scripts/ci/check-caps.sh`);
  `LAYOUT.md` at the root holds the tree `DESIGN.md § Tree-map` held,
  shaped per `layout.md § Layout file` - title, one sentence, one
  fenced tree with a role comment on every line and each collection
  of same-kind files as one pattern line - with `LAYOUT.md` as a node;
  `DESIGN.md § Tree-map`
  becomes one sentence citing `LAYOUT.md`; `scripts/ci/check-stray.sh`
  reads the layout file from the `- Layout:` line, default
  `.claude/LAYOUT.md`, guarded as the plan checks' read is, and its
  messages and header name it; `.github/workflows/ci.yml`'s locale
  comment names the layout file's nodes where it named the tree-map's.
  One commit, so the fast tier is green before and after
  (`branch-plan.md § Rails`: no commit on a red tier).
  Approach: `CLAUDE.md` after line 42: a blank line, "## Layout", a
  blank line, "This repository's own declarations; a project's own
  `## Layout` wins, and a project without one is on the defaults.", a
  blank line, the four lines. `LAYOUT.md`: "# Layout", the sentence
  "The repository's actual tree - every directory and fixed-name file,
  a collection of same-kind files as one pattern line
  (`skills/dev/layout.md § Layout file`); harness-managed state
  (`projects/`, `cache/`, `plugins/`, logs) is gitignored, and skills
  symlinked from external repos are versioned there, not mapped.",
  then the fenced block from `DESIGN.md` lines 28-91 with three
  changes. One: "├── LAYOUT.md                     # the repository's
  tree (this file)" after `DESIGN.md`. Two: the sixteen lines without
  a comment get one - `.gitignore` "ignore rules for harness state",
  `README.md` "overview and install", `DESIGN.md` "architecture
  (≤1000 words)", `.github/` "the Tier-1 CI gate", `.githooks/`
  "advisory local gate (core.hooksPath)", `hooks/` "Claude Code hooks,
  wired in settings.json", `scripts/` "installer, checks, tests, host
  tooling", `.claude/` "this repository's project settings",
  `R<NNN>-T<NNN>-<slug>.md` "branch plans, one per task",
  `R<NNN>-T<NNN>-<slug>.findings.md` "task findings", `agents/`
  "dispatched agents", `skills/` "the DEV toolset and the skills
  beside it", and `systematic-debugging/` and the three `*/SKILL.md`
  entries "bundled" - aligned to the `#` column their siblings use,
  except the five whose name already runs past that column (the two
  `R<NNN>-T<NNN>-<slug>` plan lines and the three long `*/SKILL.md`
  entries), which align on a column one past their own run's longest
  name.
  Three: the three `skills/dev/` file-list lines (DESIGN.md 80-82)
  fold into one pattern line "*.md" with the comment "modes and
  process rules, routed by SKILL.md", between the `SKILL.md` and
  `companions/` lines. No check caps `LAYOUT.md`'s line length. `DESIGN.md
  § Tree-map` reads "The tree is `LAYOUT.md` (`skills/dev/layout.md
  § Layout file`)." and the two sentences around the block go.
  `check-stray.sh`: after the `cd`, `L=$(sed -n 's/^- Layout: *//p'
  CLAUDE.md 2>/dev/null | head -1 || true); L=${L:-.claude/LAYOUT.md}`;
  `DESIGN.md` in the `grep` and the message reads `"$L"`; the header
  comment's "DESIGN.md tree-map" reads "the layout file `CLAUDE.md
  § Layout` declares". `ci.yml` line 12: "check-stray matches UTF-8
  tree-map nodes" reads "check-stray matches UTF-8 layout-file nodes".
- [x] `DESIGN.md`, `MAINTENANCE.md` and `REQUIREMENTS.md` state the
  declared layout for this repository: `DESIGN.md § Self-hosting
  layout` lists `LAYOUT.md` among the root files and says the DEV
  artifacts sit at the declared paths, `dev/` here; `MAINTENANCE.md`'s
  Tier-2 cross-file line, its `§ Routine` targets table (the generic
  rows name the `Session:` and `Plans:` trees as the installer's seed
  does) and the `§ Doc-sync pairs` rows name `LAYOUT.md` where they
  named the `DESIGN.md` tree-map; `REQUIREMENTS.md § Planning
  discipline`'s first bullet names the declared plans tree (the
  doc-sync pair "Planning layout ..." obliges it). `DESIGN.md` stays
  within 1000 words.
  Approach: `DESIGN.md § Self-hosting layout`: "`REQUIREMENTS.md`,
  `DESIGN.md` and `MAINTENANCE.md` sit at the root" reads
  "`REQUIREMENTS.md`, `DESIGN.md`, `MAINTENANCE.md` and `LAYOUT.md`
  sit at the root", and "DEV artifacts sit under `dev/` as in every
  adopter" reads "DEV artifacts sit at the paths `CLAUDE.md § Layout`
  declares, `dev/` here". `MAINTENANCE.md` line 24: "the `DESIGN.md`
  tree-map matches the tree" reads "`LAYOUT.md` matches the tree";
  rows 129-131 and 134: "`DESIGN.md` tree-map" reads "`LAYOUT.md`";
  row 134's trailing "§ Self-enforcement" loses its anchor with that
  rewrite, so it reads "`DESIGN.md § Self-enforcement`";
  the targets rows 58, 59 and 65 read "the `Session:` tree
  (`CLAUDE.md § Layout`)" and "the `Plans:` tree (`CLAUDE.md
  § Layout`)". `REQUIREMENTS.md` lines 33-36: "(`dev/plans/R<NNN>-
  <slug>/`)" reads "(`R<NNN>-<slug>/` under the declared plans tree)"
  and "lives at `dev/plans/`" reads "lives at that tree's root".
- [ ] The declaration's prose states each default once and admits this
  repository's root: `companions/declarations.md § Declared paths`'
  `Docs:` bullet no longer restates the `docs/` default the fenced
  block above it is the one home of (the first item's rule), so the
  criterion's grep finds `docs/` in `declarations.md` only in that
  block; `layout.md § Layout file`'s root-line sentence admits the
  root `LAYOUT.md` carries - a repository consumed at a fixed path
  uses that path, `~/.claude/` (`DESIGN.md § Self-hosting layout`; the
  `LAYOUT.md` item above) - beside a project's own name;
  `companions/untracked-claude.md § What changes` says `<layout>` sits
  under `.claude/` by default and is gitignored with it, the sentence
  no longer holding for every declared value; and
  `scripts/test/check-accretion.test.sh`'s header names the declared
  plans tree the gate scans in place of `dev/plans/**/*.md`, the
  check's own header (the Tier-1 item above) already saying so. The
  three rule files stay within 300 lines and 80 columns. One commit:
  four sentence fixes to prose about the declaration; the test comment
  rides with them as prose about the same read, not with the tree.
  Approach: `declarations.md` lines 133-135, the `Docs:` bullet, read
  "- **`Docs:`** the project's one documentation directory, internal
  and external audiences under one contract (`layout.md § Docs`); the
  default for a new project, and a project keeps the home it has."
  `layout.md` lines 171-174: "one fenced tree whose root line is the
  repository directory with a trailing slash - a project's by its own
  name, `attack-checker/` - drawn in" reads "one fenced tree whose
  root line is the repository directory with a trailing slash - a
  project's by its own name, `attack-checker/`; a repository consumed
  at a fixed path uses that path, `~/.claude/` - drawn in", the
  paragraph rewrapped (the file is at 209 lines). `untracked-claude.md`
  lines 44-45: "`<layout>` is gitignored with the rest of `.claude/`"
  reads "`<layout>` sits under `.claude/` by default and is gitignored
  with it". `check-accretion.test.sh` lines 3-4: "(the gate scans
  dev/plans/**/*.md only, so this test source never trips it)" reads
  "(the gate scans only the plans tree the root CLAUDE.md § Layout
  declares, so this test source never trips it)".
- [ ] `LAYOUT.md` carries every tracked entry `layout.md § Layout file`
  requires: under `scripts/`, the worker-host tooling `forge-keys.sh`,
  `provision-worker.sh`, `worker-credentials.sh`, `worker-setup.sh`
  and `worker-workspace.sh`; under `skills/`, `worker-host/` with its
  `SKILL.md` and `companions/`. Each line carries a role comment taken
  from the file's own header comment or title, aligned to the `#`
  column its siblings use; `companions/` is one line with its two
  files named in the comment, as `skills/dev/companions/` is drawn,
  the depth `§ Layout file` sets by `§ Config layout`. Entries keep
  the file's order: alphabetical under `scripts/`, and `worker-host/`
  last under `skills/`, after the bundled and personal skills, as the
  one skill that is this repository's own operations. `git ls-files
  scripts skills/worker-host` then lists no first- or second-level
  entry the file lacks. No root entry is added, so `MAINTENANCE.md
  § Doc-sync pairs` obliges no `README.md § Contents` row, and
  `check-stray.sh` matches first-level nodes only, so the fast tier is
  green before and after. No check caps `LAYOUT.md`'s line length.
  Approach: under `scripts/`, after `context-cost.py`: "forge-keys.sh
  # forge key exchange, the operator's half (sourced by
  provision-worker.sh)"; after `model-quota.sh`: "provision-worker.sh
  # stands up the worker host, run on the operator's machine"; after
  `test/`, whose `└──` becomes `├──`: "worker-credentials.sh # worker
  forge keys and CLI auth, run on the VM", "worker-setup.sh # worker
  host system setup, run on the VM" and, as the block's new `└──`,
  "worker-workspace.sh # worker repositories and per-project settings,
  run on the VM". Under `skills/`, `writing-skills/`'s `└──` becomes
  `├──` and the block ends "└── worker-host/ # GCP worker host runbook,
  this repository's own", "├── SKILL.md #   the four scripts and where
  each runs", "└── companions/ #   provisioning order, pitfalls", the
  children indented as the `dev/` block's are. Padding is collapsed in
  the quotes above: each `#` lands on the column `context-cost.py`'s
  and `dev/`'s do.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, cleanup (stale/temp
  data), mark plan complete, mark the task `[x]` in `tasks.md`,
  commit. The acceptance criterion's grep over `rules/`, `skills/`,
  `scripts/ci/` accepts exactly: the defaults in
  `companions/declarations.md § Declared paths`' fenced block;
  `dev/docs/` as a migration source in `migrate.md` and
  `root-migration.md`; the `docs/` the legacy-location and collision
  prose names in `migrate.md`'s Fresh bullet and Stale declarations
  and in `root-migration.md § 1 Collisions`; the two hits in skills
  outside the toolset named in the companions item. It returns no
  `scripts/ci/` line: the `dev/plans` fallback in each of the four
  plan checks exists and the grep never matches it, the `-` before it
  excluding it (the Tier-1 item). The literal `.claude/LAYOUT.md`,
  which that grep never matches either, is accepted in
  `declarations.md § Declared paths` and `check-stray.sh`'s fallback
  and nowhere else in `skills/`, `rules/`, `agents/`, `scripts/ci/`;
  the permissions template, which a `/` shields from that grep too,
  carries no `dev/` path. Anything else is a defect the close review
  fixes before the marks.
  Approach: the close review reads every quoted sentence above
  against the tree and runs the acceptance criterion's grep over
  `rules/`, `skills/`, `scripts/ci/`, `git grep -n 'LAYOUT.md' --
  skills rules agents scripts/ci` and `git grep -n 'dev/' --
  skills/dev/companions/'*.json'`, comparing each output to the
  residue list; then the marks and the commit.
