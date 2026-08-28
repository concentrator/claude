# Root migration

Move a `.claude/`-layout project's DEV artifacts onto `dev/`
(`plan.md § Where things live`). Invoked from `migrate.md` when the
inventory finds artifacts under `.claude/`. Plan first, then execute:
nothing moves until the user approves the reported move list.

## 1. Move plan

Inventory, then report - touching nothing:

- **Move set** - the `.claude/`-resident artifact trees, listed per
  top-level entry: `.claude/plans/` → `dev/plans/` (ROADMAP.md,
  release plans, `R<NNN>-<slug>/` dirs, `archive/`,
  `visual-artifacts/`) and `.claude/docs/` → `dev/docs/` (feature
  docs + `index.md`). Config stays under `.claude/`: `REQUIREMENTS.md`,
  `DESIGN.md`, `MAINTENANCE.md`, `settings*.json`, `skills/`,
  `rules/`, `commands/`, `agents/`, `hooks/`, `references/`, `adr/`.
- **Rewrite set** - every in-project reference to a moved path: grep
  the whole working tree, tracked or not (in untracked mode the
  reference carriers - project `CLAUDE.md`, settings, project rules -
  are gitignored), for `.claude/plans` and `.claude/docs`; list each
  hit with its replacement.
- **Collisions** - a destination that already exists (`dev/plans/` or
  `dev/docs/`: a partial earlier migration). Report each; § 2 refuses
  to move onto it - merge, rename, or abort is the user's call.
- **Gaps** - a `- DEV artifacts root:` line in `CLAUDE.md § Agent
  toolchain`, which the Tier-1 gate rejects; a `.gitignore` entry for
  `dev/plans/visual-artifacts/` where the moved tree contains
  `plans/visual-artifacts/`; untracked mode, where `dev/` must be
  gitignored too (`untracked-claude.md § Detection`).

Present the full report; **block on user approval**.

## 2. Execute

On a short-lived `mnt/` branch - the diff exceeds planning artifacts
(README, CI, `CLAUDE.md` rewrites), so merge stays the user's call
(`git-workflow.md § Trunk`). Untracked mode: the moved artifacts stay
working-tree-only (`untracked-claude.md § What changes`); only
tracked-file rewrites ride the branch.

1. **Move** - the destination must not exist (§ 1 Collisions; if it
   does, stop and resolve with the user). Tracked:
   `git mv .claude/plans dev/plans` and
   `git mv .claude/docs dev/docs`, creating parent dirs as needed
   and skipping trees the project does not have - `git mv` preserves
   history. Untracked mode: plain `mv` - the tree has no history to
   preserve.
2. **Rewrite** - apply the approved rewrite set, then re-grep the
   whole working tree (tracked and gitignored files alike) for
   `.claude/plans` and `.claude/docs` to confirm zero stale
   references.
3. **Close the gaps** - the `CLAUDE.md` and `.gitignore` follow-ups
   from § 1.
4. **Deliver** - the `mnt/` branch's MR/PR (`git-workflow.md
   § Trunk`).

Verify before delivery: `migrate.md` now classifies the project as
Already-DEV, and a plan-artifact write under `dev/plans/` succeeds
without an interactive prompt.
