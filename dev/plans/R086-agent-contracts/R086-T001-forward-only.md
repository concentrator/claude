---
task: R086-T001
type: mnt
mode: strict
architecture-changing: true
cold-read: passed
---

- [x] A convention binds only work created after it: `CLAUDE.md § Scope`
  says older work changes to meet one only on request, Tier-2 compliance
  judges what the diff adds, and the go-forward bullet of `rules/js.md`
  keeps only its renamed-file clause, citing the rule.
  Approach: `CLAUDE.md § Scope`, then `MAINTENANCE.md § Tier-2 AI
  review`, then `rules/js.md § File names`.
- [x] A sourced `scripts/ci/branch-diff.sh` yields the merge-base (first of
  `origin/main`, `origin/master`, `main`, `master`), the lines added from
  it, untracked files included, and each changed path with its base path;
  with no base, the whole tracked tree. A gate keeps its shell mode, loads
  the helper from beside itself before its `cd`, and fails if it cannot.
  Approach: helper and `scripts/test/branch-diff.test.sh`; `LAYOUT.md`.
- [x] `install-dev.sh` ships the helper beside the checks in the full and
  the minimal set, and `README.md § Installing the toolset elsewhere`
  lists it; no test this branch adds ships.
  Approach: `install-dev.sh`, then `install-dev.test.sh` and
  `install-dev-minimal.test.sh`.
- [x] The em-dash and TODO gates fail only on a line the branch adds; an
  old hit in a file the branch touches passes, and with no base they
  judge the whole tracked tree as they do today.
  Approach: `check-no-em-dash.sh` and `check-todos.sh` on the helper, each
  with a new `scripts/test/` file covering old, added and untracked hits.
- [x] The accretion gate fails only on a line the branch adds, archive
  exempt as today; unborn-repo fixtures keep passing through the
  whole-tree fallback. `check-secrets.sh` neither loads the helper nor
  judges only added lines: it keeps scanning every tracked file.
  Approach: `check-accretion.sh`, adding base-scoped cases to its existing
  test.
- [x] A size cap fails only on a unit the branch adds over it or takes past
  it - file lines and words, a shell function, a SKILL body or
  description - and a mode-file line over 80 characters only when added;
  a unit over its cap at the base may grow. The allowlist is unchanged.
  Approach: `check-caps.sh` with cases in its test, then `check-code-size.sh`
  with a new test.
- [x] The plan-text gate fails only on a violation the base copy of the file
  lacks, keyed by reason and text (an entry by its first line, checkbox
  mark ignored) and counted; a plan without a report fails only when new
  or when its base had one.
  Approach: `check-plan-text.sh`; its test's changed-legacy case flips to
  passing, and an added line in that file fails.
- [x] `DESIGN.md § Self-enforcement` says content checks judge what a branch
  adds and tree checks - stray, plan integrity, archival, references,
  batch tags, settings, secrets - the whole tree, since a branch breaks
  those from outside the failing file and a tracked credential is live at
  any age; with no base, content checks judge it all and plan-text skips.
  Approach: the Tier-1 bullet of `DESIGN.md § Self-enforcement`.
- [x] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
