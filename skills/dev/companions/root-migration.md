# Root migration

Move a `.claude/`-layout project's DEV artifacts onto `<plans>` and its
docs onto `<docs>` (`plan.md § Where things live`, `layout.md § Docs`).
Invoked from `migrate.md` when the inventory finds artifacts under
`.claude/` or docs still under `dev/docs/`; a project already on
`<plans>` runs the docs half alone through `/dev migrate`. Plan first, then
execute: nothing moves until the user approves the reported move list.

## 1. Move plan

Inventory, then report - touching nothing:

- **Move set** - the `.claude/`-resident artifact trees, listed per
  top-level entry: `.claude/plans/` → `<plans>` (ROADMAP.md,
  release plans, `R<NNN>-<slug>/` dirs, `archive/`) and
  `.claude/docs/` or `dev/docs/` → `<docs>` (feature docs +
  `index.md`). Config stays under `.claude/`: `REQUIREMENTS.md`,
  `DESIGN.md`, `MAINTENANCE.md`, `settings*.json`, `skills/`,
  `rules/`, `commands/`, `agents/`, `hooks/`, `references/`, `adr/`.
- **Rewrite set** - every in-project reference to a moved path: grep
  the whole working tree, tracked or not (in untracked mode the
  reference carriers - project `CLAUDE.md`, settings, project rules -
  are gitignored), for `.claude/plans`, `.claude/docs` and `dev/docs`;
  list each hit with its replacement. Two kinds of link need it:
  pointers from outside the docs tree (`CLAUDE.md § Conventions`,
  `README.md`, `DESIGN.md`, among others), and the moved docs' own
  relative links to project files (`config/`, `scripts/`, `src/` -
  `documentation.md § Content quality`), which a move that changes
  depth breaks; grep the tree for `](../` to list them. Links between
  sibling docs survive the move.
- **Collisions** - a destination that already exists (`<plans>` or
  `<docs>`: a partial earlier migration; a `docs/` beside an
  `extended-docs:` path becoming `Docs:`, `migrate.md` Stale
  declarations). Report each; § 2 refuses to move onto it - merge,
  rename, or abort is the user's call.
- **Gaps** - a missing `## Layout` block or a stale `DEV artifacts
  root:` or `extended-docs:` line in `CLAUDE.md` (`migrate.md`, Stale
  declarations); untracked mode, where `<plans>` and `<session>` must
  be gitignored too (`untracked-claude.md § Detection`).

Present the full report; **block on user approval**.

## 2. Execute

On a short-lived `mnt/` branch - the diff exceeds planning artifacts
(README, CI, `CLAUDE.md` rewrites), so merge stays the user's call
(`git-workflow.md § Trunk`). Untracked mode: the moved artifacts stay
working-tree-only (`untracked-claude.md § What changes`); only
tracked-file rewrites ride the branch.

1. **Move** - the destination must not exist (§ 1 Collisions; if it
   does, stop and resolve with the user). Tracked:
   `git mv .claude/plans <plans>` and
   `git mv .claude/docs <docs>` or `git mv dev/docs <docs>`, creating
   parent dirs as needed
   and skipping trees the project does not have - `git mv` preserves
   history. Untracked mode: plain `mv` - the tree has no history to
   preserve.
2. **Rewrite** - apply the approved rewrite set, then re-grep the
   whole working tree (tracked and gitignored files alike) for
   `.claude/plans`, `.claude/docs` and `dev/docs`, and the moved docs
   for `](../`, to confirm zero stale references.
3. **Close the gaps** - write `## Layout` and `<layout>`, and the
   `.gitignore` follow-ups from § 1.
4. **Verify the moved docs** - the verification gate over the moved
   `<docs>/index.md` (`documentation.md § Verification gate`): every
   path it lists resolves, so the catalog is true after the move.
5. **Deliver** - the `mnt/` branch's MR/PR (`git-workflow.md
   § Trunk`).

Verify before delivery: `migrate.md` now classifies the project as
Already-DEV, and a plan-artifact write under `<plans>` succeeds
without an interactive prompt.
