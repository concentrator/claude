task: R064-T001
type: mnt

# This repository moves onto dev/

The DEV artifacts of this repository move from its root to `dev/`,
the default every other project already uses, and the `./`
declaration that made it the exception goes. The resolver keeps
running throughout: with no declaration it answers `dev`, so every
Tier-1 check finds `dev/plans/` and the gate stays green on each
commit. Rewriting the DEV system's own prose and removing the
resolver is R064-T002's work; this branch touches only what names
this repository's actual files.

## Terms used below

- **Move** - `git mv plans dev/plans`, archive included; the
  untracked `session/` directory is moved by hand to `dev/session/`
  (it is gitignored, so nothing is staged).
- **Concrete reference** - a path in a tracked file that names a file
  of this repository (`plans/R-040-.../tasks.md`, `plans/ROADMAP.md`),
  as opposed to the root-relative shorthand the skills use for any
  project (`plans/R<NNN>-<slug>/`), which stays valid under
  `plan.md § Where things live` until R064-T002 rewrites it. Archived
  plans are exempt (`writing.md § State the present`).
- **Tree-map** - `DESIGN.md`'s tree gains a first-level `dev/` node
  holding `plans/` and `session/`, replacing the first-level `plans/`
  node; `scripts/ci/check-stray.sh` matches first-level nodes only.

## Commits

- [x] The move, in one commit so the gate never sees a half state:
  `git mv plans dev/plans`; `CLAUDE.md § Agent toolchain` drops the
  `- DEV artifacts root: ./` line; `.gitignore` ignores
  `/dev/session/`; the `DESIGN.md` tree-map takes the `dev/` node;
  `bash scripts/ci/run-all.sh` green.
- [x] Concrete references follow: `README.md` (§ Contents row,
  § Workflow, § Self-hosting), `MAINTENANCE.md § Routine`
  (`dev/session/`, `dev/plans/`, `dev/plans/visual-artifacts/`),
  `DESIGN.md § Self-hosting layout`; verified by
  `grep -rn '\bplans/' --exclude-dir=dev` showing only root-relative
  shorthand and fixtures that declare `./`. `REQUIREMENTS.md`,
  `agents/code-reviewer.md`, the hook's plan-file regex and the open
  R-040/R063 plans hold shorthand only and are untouched.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose rows: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
