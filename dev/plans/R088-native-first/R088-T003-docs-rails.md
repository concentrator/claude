---
task: R088-T003
type: doc
architecture-changing: true
mode: normal
---

- [x] `MAINTENANCE.md § Doc-sync pairs` is a table of path globs, each row
  naming the doc files an added, removed or renamed matching path must
  update; the Tier-2 Doc sync concern judges only what no row expresses.
  Approach: a row names a doc only if it lists each matching path (`LAYOUT.md`,
  `README.md § Contents`, `SKILL.md`, `DESIGN.md`, `run-all.sh`); then the
  concern's text and the pairs left to it, a moved file's references among them.
- [x] `scripts/ci/check-doc-sync.sh` fails a branch that adds, removes or
  renames a path a row matches without changing each file the row names,
  from the `branch-diff.sh` base, skipping with none; `run-all.sh` runs it,
  `DESIGN.md § Self-enforcement` names it. Approach: parse the table, read
  `git diff --name-status`, prove it on a scratch branch; no self-test, a
  doc task ships none (`skills/dev/plan.md § Proportionality`).
- [x] The docs describe the present: `DESIGN.md`, `REQUIREMENTS.md`,
  `LAYOUT.md`, `MAINTENANCE.md` and `SKILL.md` state no change history, and
  each lists every tracked path its row matches. Approach: `DESIGN.md
  § Decisions` says what admits a plan, not which stamps went; the rest per
  `rules/writing-artifacts.md § State the present`, each row against `git
  ls-files`.
- [x] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- Item 1 (source): `MAINTENANCE.md § Doc-sync pairs` maps each path glob to
  the files that an added, removed or renamed path it matches must
  update.
- Item 2 (source): `scripts/ci/check-doc-sync.sh` fails a branch that adds,
  removes or renames a path a doc-sync row matches without changing every
  file the row names.

## Proven

- CI runs `scripts/ci/run-all.sh` on every pull request:
  `.github/workflows/ci.yml`
- A content check's base is the merge-base of `HEAD` with the first of
  `origin/main`, `origin/master`, `main`, `master` that has one:
  `scripts/ci/branch-diff.sh` `branch_base`
