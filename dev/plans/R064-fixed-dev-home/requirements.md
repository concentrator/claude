---
approved: 2026-08-29
kind: refactor
status: done 2026-08-29
---

# R064: Fixed dev/ home

Shaped from the path spellings R040-T019 left behind: one directory
named four ways across four files, because the DEV artifacts root is a
per-project setting and this repository is the one project that sets
it.

## Current state

DEV artifacts live under a configurable **artifacts root**, declared
as `- DEV artifacts root: <dir>/` in `CLAUDE.md § Agent toolchain`,
default `dev/` (R-045). Every adopter checked on this machine
(`~/wallarm_pure/*`, `~/wallarm/*`) takes the default; this repository
alone declares `./`, so its plans sit at `plans/` while every other
project's sit at `dev/plans/`. The machinery that exists to carry that
one non-default value: `scripts/ci/resolve-root.sh` and fourteen
callers (Tier-1 checks, the installer, the worker workspace, both
session hooks, the server scripts), the `__ARTIFACTS_ROOT__`
permission placeholder, `companions/declarations.md § Artifacts root`,
`companions/root-migration.md`, and a `<root>/` notation in thirteen
skill and maintenance files.

The word "root" therefore carries two meanings - the repository root
and the artifacts root - and a materialized path reads differently in
each file that spells it: `MAINTENANCE.md` writes `<root>/session/`,
`start.md` writes `dev/session/` beside `<root>/plans/`, `.gitignore`
writes `/session/`, the gitignore template `/dev/session/`. Each is
correct on its own terms; together they confuse the reader and cost
every example a special case.

## Desired state

`dev/` is the one home of DEV artifacts in every project, this
repository included: `dev/plans/`, `dev/docs/`, `dev/session/`. Paths
are written repository-relative, in that spelling, everywhere; nothing
is declared, resolved, or substituted. A `- DEV artifacts root:` line
left in any `CLAUDE.md` fails the Tier-1 gate with one line naming the
move, so an adopter learns of the change from the gate rather than
from a silently ignored setting.

## Invariants

- The planning hierarchy, ids, file formats and gates are unchanged;
  only locations and the prose that names them move.
- Guarded config stays where it is: `.claude/`, and in this repository
  `REQUIREMENTS.md`, `DESIGN.md`, `rules/`, `skills/`, `hooks/`,
  `scripts/`, `agents/` at the repository root.
- Archived plans keep their text (`writing.md § State the present`);
  they move with the directory and are otherwise untouched.
- `.gitignore` patterns stay anchored (`/dev/session/`): the leading
  slash is gitignore syntax, not a path spelling.
- Every Tier-1 gate is green on each merged branch, including between
  the two tasks.

## Scope

- This repository's artifacts: `plans/` → `dev/plans/`, `session/` →
  `dev/session/`, the `./` declaration in `CLAUDE.md`, and every
  tracked reference to the moved paths outside the archive.
- The DEV system source: `scripts/ci/resolve-root.sh` and its callers
  under `scripts/ci/`, `scripts/test/`, `scripts/`, `hooks/`,
  `skills/dev/companions/scripts/`; `skills/dev/plan.md § Where things
  live`, `layout.md`, `start.md`, `migrate.md`, `handoff.md`, `auto.md`;
  `companions/declarations.md`, `root-migration.md`, `toolchain.md`,
  `untracked-claude.md`, `visual-companion.md`,
  `auto-permissions.template.json`, `gitignore.template`.
- `README.md`, `DESIGN.md` (tree-map, § Self-enforcement),
  `MAINTENANCE.md`, `CLAUDE.md § Agent toolchain`.

Out of scope: adopter repositories (none declares a root; re-installs
are the owning projects' work), and `REQUIREMENTS.md` / `DESIGN.md`
placement.

## Acceptance criteria

- [x] `dev/plans/` holds every plan, archive included, and `plans/`
  no longer exists at the repository root; `DESIGN.md`'s tree-map
  matches (`scripts/ci/check-stray.sh`).
- [x] No tracked file outside `dev/plans/archive/` contains
  `resolve-root`, `__ARTIFACTS_ROOT__`, `DEV artifacts root`, or
  `<root>` (verified by grep at close); `scripts/ci/resolve-root.sh`
  is gone and every former caller names `dev/` directly.
- [x] A `CLAUDE.md` carrying `- DEV artifacts root:` fails
  `bash scripts/ci/run-all.sh` with one line naming `dev/` as the home
  (a `scripts/test/` case asserts it).
- [x] The session file's directory is spelled `dev/session/` in prose
  and `/dev/session/` in both gitignore writers (`.gitignore`,
  `gitignore.template`, `install-dev.sh`), and the hook writes there
  (`dev-precompact-state.test.sh`, `install-dev.test.sh`).
- [x] `start.md`, `migrate.md` and `root-migration.md` describe one
  destination, `dev/`, with no resolution step.
- [x] Tier-1 gate green after each of the two merges.

## Constraints

- Two branches in order: the move of this repository first, while the
  resolver still serves the default, then the removal of the
  configurable root; neither merge leaves the gate red.
- Prose citations of plan paths in commit and PR history are not
  rewritten (`writing.md § Name things by their durable id`).

## Open questions

None.

## References

- `dev/plans/archive/R-045-dev-artifacts-root/requirements.md` - the
  decision this initiative reverses, and its non-goal of moving this
  repository's artifacts.
- R040-T019 close review - the four spellings that surfaced the
  problem.
