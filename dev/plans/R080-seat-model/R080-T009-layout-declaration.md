---
task: R080-T009
type: mnt
architecture-changing: true
depends-on: R080-T004
---

# R080-T009: declared layout

Branch: `mnt/layout-declaration`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 5 and 9 and
the acceptance criterion "Every docs, plans, session or layout path
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

- The declaration is a `## Layout` section directly after
  `## Supervision`, four lines in the house style of
  `companions/declarations.md`: `- Docs: docs/`, `- Plans: dev/plans/`,
  `- Session: dev/session/`, `- Layout: .claude/LAYOUT.md`. Values are
  repository-relative, directories with a trailing slash. An absent
  line or block means its default, so a project that has not declared
  keeps working on the defaults (`§ Desired state` 5: `docs/` for a
  new project, and a project keeps the home it has). The defaults are
  written literally in `companions/declarations.md § Declared paths`
  and nowhere else in `skills/`.
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
  file is `LAYOUT.md` at the root and its declaration says so. The tree
  that file holds is the one `DESIGN.md § Tree-map` holds today: two
  homes for one tree drift, so the tree moves and `DESIGN.md` cites it
  (`§ Desired state` 9; `rules/writing-artifacts.md § One home per
  number`).

`README.md` is the doc writer's (`run.md § Seats`; `branch-plan.md
§ Commit cadence` 2). The facts it will need: `LAYOUT.md` is a new
tracked root file holding the tree-map `DESIGN.md` held; the DEV
artifacts and docs paths are declared per project in `CLAUDE.md
§ Layout` with `dev/` and `docs/` as the defaults, no longer "the same
in every project"; the installer's ignore lines follow the target's
declared session tree.

- [ ] `companions/declarations.md` defines the path declaration:
  a `## Declared paths` section after `§ Supervisor bounds` giving the
  `## Layout` block's exact form (the four lines above, in that order,
  directly after `## Supervision`), each key's meaning - `Docs:` the
  one documentation directory (`§ Desired state` 5), `Plans:` the
  planning tree, `Session:` the per-session state files, `Layout:` the
  project's layout file - its default, and the absence rule (a missing
  line or block means the default, never a halt, unlike
  `Supervisor:`); the placeholders `<docs>`, `<plans>`, `<session>`,
  `<layout>` as the form every rule uses for a declared path, the
  structure under a declared root staying literal; the ledger
  directory as `supervisor/` in the session tree's parent, gitignored
  like it; and `extended-docs:` retired - one docs directory per
  project, so a second docs path has no key. The section's intro
  names who reads the declaration: rules and seat prompts through the
  placeholders, the Tier-1 checks and the state hook by reading the
  line. The always-ask exemption for a `CLAUDE.md` change confined to
  declaration lines covers `§ Layout` too, and `rules/claude-md.md
  § Agent toolchain declaration` names the `## Layout` section beside
  `## Supervision`.
  Approach: `declarations.md`'s intro sentence "routine commands in
  `§ Agent toolchain`, supervision in the `§ Supervision` that follows
  it" gains "and paths in the `§ Layout` after that". The new section
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
- [ ] `layout.md` is the canonical structure with no fixed root: its
  intro and the `§ Artifacts layout`, `§ Docs`, `§ Creation policy` and
  `§ References` sentences name `<plans>`, `<docs>` and `<session>`
  where they named `dev/`, `docs/` and the repository root, the
  defaults cited to `companions/declarations.md § Declared paths`
  rather than repeated; `§ Config layout` lists `LAYOUT.md`; a new
  `§ Layout file` gives `<layout>`'s shape and lifecycle
  (`§ Desired state` 9): a title, one sentence saying it is the
  repository's actual tree, and one fenced tree in the `├── `/`└── `
  style with a `#` role comment per entry, listing every tracked
  top-level entry, the whole `.claude/` tree, and the plans and docs
  trees to the canonical depth (directories and fixed-name files,
  `R<NNN>-<slug>/` for a repeated shape); seeded by `start.md` from
  this file's trees with the declared values substituted and the
  entries the scaffold creates, written by `migrate.md` from the
  inventory, kept current by the branch that adds or removes an entry
  (`branch-plan.md § Architecture-changing branches`), project-owned
  and never written by the installer. `§ Baseline files`' `CLAUDE.md`
  row adds `## Layout`. The file stays within 300 lines and 80 columns
  (table rows and tree lines exempt as today).
  Approach: intro: "agent-authored DEV artifacts under `dev/`" reads
  "agent-authored DEV artifacts under the declared trees"; "and the
  docs tree at `docs/` (§ Docs)" reads "and the docs tree at `<docs>`
  (§ Docs; the keys and defaults: `companions/declarations.md
  § Declared paths`)". `§ Config layout`'s tree gains
  "├── LAYOUT.md             # the repository's actual tree (§ Layout
  file)" after `MAINTENANCE.md`. `§ Artifacts layout`: the heading
  reads "Artifacts layout (`<plans>`, `<docs>`)", the tree roots read
  `<plans>/` and `<docs>/`, and "the planning tree under `dev/`, the
  docs tree at the repository root" reads "the planning tree at
  `<plans>`, the docs tree at `<docs>`". `§ Creation policy`:
  `dev/plans/` reads `<plans>/`, `docs/` reads `<docs>/`, `.claude/`
  required set gains `LAYOUT.md`. `§ Docs`: "`docs/`, at the
  repository root, holds" reads "`<docs>` holds"; `docs/reports/`,
  `docs/references/`, `docs/index.md` read `<docs>/reports/`,
  `<docs>/references/`, `<docs>/index.md`. `§ References`' "`docs/`
  below" reads "`<docs>` below". `§ Layout file` goes after `§ Docs`
  and before `§ ADRs`.
- [ ] `plan.md § Where things live` says the paths are declared:
  DEV artifacts live at the paths the project's root `CLAUDE.md
  § Layout` declares (`companions/declarations.md § Declared paths`) -
  `<plans>` (below), `<session>` (`handoff.md`), the docs tree
  `<docs>` (`layout.md § Docs`) - and the project's actual tree is
  `<layout>`; the sentences "repository-relative and never declared or
  resolved" and the `DEV artifacts root:` Tier-1 sentence go, the
  check no longer existing (item 7); guarded config stays under
  `.claude/`. Every other `dev/plans/` and `docs/` in `plan.md`
  (`§ Levels`, `§ Directory conventions`, `§ Adjusting existing
  plans`, `§ Approval and closure`, `§ Milestone plans`, `§ Archival`)
  reads `<plans>` or `<docs>`.
  Approach: the paragraph reads "DEV artifacts live at the paths the
  project's root `CLAUDE.md § Layout` declares
  (`companions/declarations.md § Declared paths`): `<plans>` (below)
  and `<session>` (`handoff.md`); the docs tree is `<docs>` (`layout.md
  § Docs`) and the repository's actual tree is `<layout>` (`layout.md
  § Layout file`). Guarded config is not an artifact: it stays under
  `.claude/`, `REQUIREMENTS.md` and `DESIGN.md` included (`layout.md
  § Config layout`)." The exclusivity sentence "never place plans or
  specs in `docs/`" reads "in `<docs>`". Each remaining path edits in
  place; `plan.md` is at 241 lines and the placeholders are shorter
  than the paths they replace.
- [ ] `start.md`, `migrate.md` and `companions/root-migration.md`
  write the declaration and the layout file (`§ Desired state` 9).
  `start.md § 3` writes `## Layout` with the four defaults - no
  question, `docs/` being a new project's home (`§ Desired state` 5) -
  and seeds `<layout>` per `layout.md § Layout file`; the "extended
  docs?" question goes; `dev/plans/` and `docs/index.md` read
  `<plans>/` and `<docs>/index.md`. `migrate.md`: the route list names
  `.claude/plans/`, `.claude/docs/` and `dev/docs/` as migration
  sources only and `<plans>`, `<docs>` as destinations; the
  `dev/docs/`-layout route offers the move to `<docs>` or the
  declaration of `dev/docs/` as the home the project keeps, the user's
  call, and writes the declaration either way; "Stale root" becomes
  "Stale declarations" - a `DEV artifacts root:` or `extended-docs:`
  line, each reported with its rewrite to a `§ Layout` key, an
  `extended-docs` path becoming `Docs:` where it is the project's one
  docs tree and otherwise a docs-half move in `root-migration.md`;
  § 4 backfills `## Layout` from the inventory (the docs where they
  sit, the plans tree after the move, the defaults otherwise) and
  writes `<layout>` from `git ls-files` per `layout.md § Layout file`,
  and its `## Conventions` list drops `extended-docs`; § 1 inventories
  `<layout>` and the declaration. `root-migration.md`: the move set's
  destinations read `<plans>` and `<docs>`, the rewrite set's sources
  stay literal, `§ 1 Gaps` names a missing or stale declaration in
  place of the `DEV artifacts root:` Tier-1 sentence, and § 2 step 3
  writes the declaration and `<layout>`.
  Approach: `start.md § 3`, the "Ask: **extended docs?**" paragraph
  reads "Write `## Layout` after `## Supervision` with the defaults
  (`companions/declarations.md § Declared paths`) and seed `<layout>`
  from `layout.md § Layout file`."; the `docs/` pointer sentence
  stays with `<docs>`. `migrate.md`'s intro: "DEV artifacts live at
  `dev/`" reads "DEV artifacts live at the declared paths (`plan.md
  § Where things live`)"; the `.claude/`-layout bullet's "relocate
  onto `dev/`" reads "onto `<plans>`"; the `dev/docs/`-layout bullet
  reads "plans already on `<plans>` but docs under `dev/docs/` with no
  `Docs:` line: offer the move to `<docs>` per
  `companions/root-migration.md` or declare `dev/docs/` as the home
  kept (`companions/declarations.md § Declared paths`), the user's
  call; the declaration is written either way"; the Fresh
  bullet's "under either `dev/` or `.claude/`" reads "under `<plans>`,
  `dev/` or `.claude/`"; the Already-DEV bullet's `dev/plans/ROADMAP.md`
  reads `<plans>/ROADMAP.md`. `§ 4`: "(release-routine,
  publish-external, extended-docs, and a `docs/index.md` pointer if
  the docs layer is used)" reads "(release-routine, publish-external,
  and a `<docs>/index.md` pointer if the docs layer is used), a
  `## Layout` section backfilled from the inventory
  (`companions/declarations.md § Declared paths`) and `<layout>`
  written from `git ls-files` (`layout.md § Layout file`)". `§ 6` and
  `§ 7` read `<plans>` and `<docs>`. `root-migration.md § 1` Gaps
  bullet reads "a missing `## Layout` block or a stale `DEV artifacts
  root:` or `extended-docs:` line in `CLAUDE.md` (`migrate.md`, Stale
  declarations)"; § 2 step 3 reads "**Close the gaps** - write
  `## Layout` and `<layout>`, and the `.gitignore` follow-ups from
  § 1." `migrate.md` stays within 300 lines and 80 columns.
- [ ] The mode files name declared paths by placeholder: `write-plan.md`
  (intro, `§ Inputs`, steps 1 and 2), `branch-plan.md` (intro,
  `§ Commit cadence` 2 and `§ Batches`), `finish.md § 1`,
  `release.md` steps 1, 7 and 12, `templates.md` (the per-initiative
  heading and `§ Archival` cite), `handoff.md § The file` (the session
  file at `<session>/<session_id>.md`, the ledger at `supervisor/`
  beside `<session>`) and `run.md § Ledger` (the same ledger sentence).
  `branch-plan.md § Commit cadence` 2 drops "`extended-docs: yes` per
  project `CLAUDE.md § Conventions`" and `§ Architecture-changing
  branches`' tree-map upkeep names `<layout>` (`layout.md § Layout
  file`) in place of `DESIGN.md § Tree-map`. `git grep -n -E
  '(^|[^A-Za-z/._-])(docs/|dev/)' -- skills/dev/*.md` then finds only
  `dev/docs/` in `migrate.md`'s route and `layout.md`'s cite of the
  defaults' home. Every touched file stays within 300 lines and 80
  columns.
  Approach: `write-plan.md`: `dev/plans/R<NNN>-<slug>/...` reads
  `<plans>/R<NNN>-<slug>/...` at its four sites and "the changed
  feature's `docs/` doc" reads "`<docs>` doc". `branch-plan.md` line
  3, `§ Commit cadence` 2 ("`docs/` with its index" reads "`<docs>`
  with its index"; the `extended-docs` clause and its dash go, the
  list's last member becoming "`README.md` for new public surface"),
  `§ Architecture-changing branches` ("tree-map upkeep (adding a new
  file to `DESIGN.md § Tree-map`)" reads "layout upkeep (adding a new
  entry to `<layout>`, `layout.md § Layout file`)"), `§ Batches`'
  manifest path. `finish.md § 1` first bullet. `release.md` 1, 7, 12.
  `templates.md`: the heading "## Per-initiative
  `<plans>/R<NNN>-<slug>/requirements.md`" (the `§ Per-initiative`
  cite in `brainstorm.md` still resolves) and line 121. `handoff.md`:
  "`dev/session/<session_id>.md`, gitignored" reads
  "`<session>/<session_id>.md` (`CLAUDE.md § Layout`), gitignored";
  "its ledger, `dev/supervisor/<scope>.md`" reads "its ledger,
  `supervisor/<scope>.md` beside `<session>`". `run.md § Ledger`: "is
  `dev/supervisor/<scope>.md` in the checkout, beside `dev/session/`
  and ignored like it" reads "is `supervisor/<scope>.md` in the
  session tree's parent directory (`companions/declarations.md
  § Declared paths`), beside `<session>` and ignored like it" -
  `run.md` is at 300 lines, so the two lines this adds come from
  rewrapping `§ Ledger`'s paragraph, which has slack.
- [ ] The companions and the reviewer agent name declared paths by
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
  `<plans>` and `<session>`, and `.claude/LAYOUT.md` gitignored with
  the tree), `agents/code-reviewer.md` (three sites). After it,
  `git grep -n -E '(^|[^A-Za-z/._-])(docs/|dev/)' -- skills rules
  agents` finds a literal path only in `companions/declarations.md
  § Declared paths` and in the migration sources (`dev/docs/`,
  `.claude/docs/`), which is the acceptance criterion's grep.
  Approach: `documentation.md`: "Feature docs (`docs/`)" reads
  "Feature docs (`<docs>`)"; "(`docs/reports/`)" and
  "(`docs/references/`)" read "(`<docs>/reports/`)" and
  "(`<docs>/references/`)"; the two "`docs/` feature docs" read
  "`<docs>` feature docs". `doc-writer-prompt.md`: "- Docs: `docs/`
  with its index `docs/index.md`" reads "- Docs: `<docs>`, the docs
  home the project's root `CLAUDE.md § Layout` declares, with its
  index `<docs>/index.md`"; Job 2's "the `docs/` doc and its
  `docs/index.md` line" reads "the `<docs>` doc and its
  `<docs>/index.md` line" and ", and `extended-docs: yes` per the
  project's `CLAUDE.md § Conventions`" goes. `implementer-prompt.md`
  line 59: "`docs/`, `README.md`" reads "`<docs>` (the docs home
  `CLAUDE.md § Layout` declares), `README.md`"; line 92: "(under the
  artifacts root - `plan.md § Where things live`)" reads "(under
  `<plans>` - `plan.md § Where things live`)". `docs-adoption.md`
  lines 29, 36, 44. `report-template.md` line 3 path and line 37.
  `legacy-migration.md` lines 15, 29; `tbd-migration.md` lines 4, 31
  ("against `skills/dev/layout.md`" reads "against `<layout>` and the
  canonical `skills/dev/layout.md`"), 38, 55. `untracked-claude.md`:
  "and the DEV artifacts root (`plan.md § Where things live`)" reads
  "and the declared trees (`plan.md § Where things live`)"; "verify
  `dev/` is gitignored too (`git check-ignore -q dev`)" reads "verify
  `<plans>` and `<session>` are gitignored too (`git check-ignore -q`
  on each)"; the two `dev/` at lines 41 and 43 read "the declared
  trees"; `§ What changes` gains "`<layout>` is gitignored with the
  rest of `.claude/`". `agents/code-reviewer.md` lines 15, 48, 60.
- [ ] The Tier-1 plan checks read the plans tree from the declaration
  (`§ Desired state` 9; the criterion's `scripts/ci/` grep):
  `check-plan-integrity.sh`, `check-archival.sh`, `check-accretion.sh`
  and `check-batch-tags.sh` each set `P` from the `- Plans:` line of
  the root `CLAUDE.md`, default `dev/plans`, trailing slash stripped -
  the checks already `cd` to `git rev-parse --show-toplevel`, where
  the root `CLAUDE.md` is - and their header comments say so where
  they said the home is fixed; `check-plan-integrity.sh`'s
  `DEV artifacts root:` refusal goes, a stale line being `migrate.md`'s
  to report. Each check's test gains one case: a fixture whose
  `CLAUDE.md` declares `- Plans: var/plans/` with the tree there
  passes, and a violation there is caught (`plan.md
  § Proportionality`: one behavior change, one case per check);
  `check-plan-integrity.test.sh` case 14 becomes that case. The two
  shipped checks (`check-accretion.sh`, `check-batch-tags.sh`) keep
  their vendoring shape - no shared helper file, the read is a
  two-line snippet in each - so `install-dev.sh` copies them
  unchanged.
  Approach: the snippet, after the `cd`: `P=$(sed -n 's/^- Plans: *//p'
  CLAUDE.md 2>/dev/null | head -1); P=${P:-dev/plans}; P=${P%/}`;
  `check-batch-tags.sh` uses `$P` in its `ls-tree` and comment,
  `check-archival.sh` in its `for` glob and the two messages,
  `check-accretion.sh` in `files=` and its message,
  `check-plan-integrity.sh` in `P=` with the `grep -q '^- DEV
  artifacts root:'` line and its message deleted and the "Plans live
  at dev/plans/ in every project" comment reading "Plans live at the
  tree `CLAUDE.md § Layout` declares, `dev/plans` by default
  (skills/dev/plan.md § Where things live)". Tests: each `mkrepo`
  stays on the default; the new case writes `- Plans: var/plans/` to
  the fixture's `CLAUDE.md`, the tree under `var/plans/`, asserts
  `ok_in`, then a violation under it and `fails_with`; case 14's
  "fixed at dev/" assertion goes with the check it tested.
- [ ] The state hook and the installer follow the declaration and the
  installer touches neither the declaration nor `<layout>`
  (`§ Desired state` 9, "untouched by a tools refresh"; the
  criterion's refresh): `hooks/dev-precompact-state.sh` resolves the
  session directory as `DEV_STATE_DIR`, else the `- Session:` line of
  `$root/CLAUDE.md` (`$root` is already the project root the hook
  resolves from `CLAUDE_PROJECT_DIR`), else `dev/session`, and
  `scripts/test/dev-precompact-state.test.sh` gains one case: a
  declared `- Session: var/state/` puts the file at
  `var/state/s1.md`. `scripts/install-dev.sh` step 7 writes the two
  ignore lines from the target project's declared session tree - the
  tree and `supervisor/` in its parent - defaulting to
  `/dev/session/` and `/dev/supervisor/`, and step 8's seeded hygiene
  rows name the trees by their `CLAUDE.md § Layout` key rather than a
  literal path; `scripts/test/install-dev.test.sh` asserts the seeded
  rows name the keys, that a target declaring `- Session: var/state/`
  gets `/var/state/` and `/var/supervisor/`, and that a target's
  `CLAUDE.md § Layout` block and `.claude/LAYOUT.md` are byte-identical
  across a re-run.
  Approach: hook lines 29-31: the comment reads "Session dir: the
  tree the root CLAUDE.md § Layout declares, dev/session by default
  (skills/dev/handoff.md); DEV_STATE_DIR overrides it for tests." and
  `dir=${DEV_STATE_DIR:-$root/dev/session}` becomes a `sed -n 's/^-
  Session: *//p' "$root/CLAUDE.md"` read into `decl`, then
  `dir=${DEV_STATE_DIR:-$root/${decl:-dev/session}}` with the trailing
  slash stripped. Installer step 7: read `decl` the same way from
  `$proj/CLAUDE.md`, `sess=${decl:-dev/session/}`, lines
  `/${sess%/}/` and `/$(dirname "${sess%/}")/supervisor/` normalised so
  a one-segment tree yields `/supervisor/`; the comment names
  `CLAUDE.md § Layout`. Step 8's rows: "| `dev/session/` |" reads
  "| the `Session:` tree (`CLAUDE.md § Layout`) |" and
  "| `dev/plans/` |" reads "| the `Plans:` tree (`CLAUDE.md
  § Layout`) |". `install-dev.test.sh` line 244's two greps read
  `Session:` and `Plans:`; the two new cases use a fresh `mktemp -d`
  project each, the second with a `CLAUDE.md` carrying the block and
  a `.claude/LAYOUT.md`, `cmp` after the second install.
- [ ] This repository declares its layout and holds its tree in
  `LAYOUT.md`: `CLAUDE.md` gains `## Layout` after `## Supervision`
  with `- Docs: docs/`, `- Plans: dev/plans/`, `- Session:
  dev/session/`, `- Layout: LAYOUT.md` (the root, per `DESIGN.md
  § Self-hosting layout`; the file stays within its 100-line cap,
  `scripts/ci/check-caps.sh`); `LAYOUT.md` at the root holds the tree
  `DESIGN.md § Tree-map` held, shaped per `layout.md § Layout file`,
  with `LAYOUT.md` as a node; `DESIGN.md § Tree-map` becomes one
  sentence citing `LAYOUT.md`; `scripts/ci/check-stray.sh` reads the
  layout file from the `- Layout:` line, default `.claude/LAYOUT.md`,
  and its messages name it. One commit, so the fast tier is green
  before and after (`branch-plan.md § Rails`: no commit on a red
  tier).
  Approach: `LAYOUT.md`: "# Layout", one sentence ("The repository's
  tree: tracked directories and notable files; harness-managed state
  (`projects/`, `cache/`, `plugins/`, logs) is gitignored. Skills
  symlinked from external repos are versioned there, not mapped."),
  then the fenced block moved verbatim from `DESIGN.md` with
  "├── LAYOUT.md                     # the repository's tree (this
  file)" after `DESIGN.md`. `DESIGN.md § Tree-map` reads "The tree is
  `LAYOUT.md` (`skills/dev/layout.md § Layout file`)." and the two
  sentences around the block go. `check-stray.sh`: after the `cd`,
  `L=$(sed -n 's/^- Layout: *//p' CLAUDE.md 2>/dev/null | head -1);
  L=${L:-.claude/LAYOUT.md}`; `DESIGN.md` in the `grep` and the
  message reads `"$L"`; the header comment's "DESIGN.md tree-map"
  reads "the layout file `CLAUDE.md § Layout` declares".
- [ ] `DESIGN.md`, `MAINTENANCE.md` and `REQUIREMENTS.md` state the
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
  the targets rows 58, 59 and 65 read "the `Session:` tree
  (`CLAUDE.md § Layout`)" and "the `Plans:` tree (`CLAUDE.md
  § Layout`)". `REQUIREMENTS.md` lines 33-36: "(`dev/plans/R<NNN>-
  <slug>/`)" reads "(`R<NNN>-<slug>/` under the declared plans tree)"
  and "lives at `dev/plans/`" reads "lives at that tree's root".
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, cleanup (stale/temp
  data), mark plan complete, mark the task `[x]` in `tasks.md`,
  commit.
  Approach: the close review reads every quoted sentence above
  against the tree and runs the acceptance criterion's grep over
  `rules/`, `skills/`, `scripts/ci/`; then the marks and the commit.
