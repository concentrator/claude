# R088-T003 report

## Claims
- Item 1 (source): `MAINTENANCE.md § Doc-sync pairs` maps each path glob to
  the doc files that an added, removed or renamed path it matches must
  update.
  Source: `MAINTENANCE.md` § Doc-sync pairs, its `Path` | `Update` table
- Item 2 (source): `scripts/ci/check-doc-sync.sh` fails a branch that adds,
  removes or renames a path a doc-sync row matches without changing every
  doc file the row names.
  Source: `scripts/ci/check-doc-sync.sh`, its `rows` parse of the table
  and its `hits` pass over `git diff --name-status -M` from
  `branch_base`

## Implementer
### Divergences
- Item 1: three rows name a file that does not yet list every path the
  glob matches - `DESIGN.md § Self-enforcement` describes the checks by
  what they fail rather than naming each `check-*.sh`, `SKILL.md`
  routes 9 of the 16 other `skills/dev/*.md`, and `LAYOUT.md` maps
  `systematic-debugging/` and `writing-skills/` as directories without
  their `SKILL.md`. The rows stay, since item 3 brings each file to
  list every path its row matches. Result: the table holds the rows
  item 3 checks against `git ls-files`.
- Item 1: the old pairs whose doc lists no path were dropped from the
  table rather than kept as rows: `/dev` command to `LAYOUT.md`,
  `skills/dev/companions/` to `SKILL.md` and `LAYOUT.md`, and `hooks/`
  guard to `README.md § Contents`, none of which lists each such path.
  The rest move to the bullet list the concern judges, with a top-level
  directory added there, since `*` matches root files only. Result: the
  concern's text names the table and judges only what no row
  expresses.
- Item 2: the check also counts an untracked, unignored file as added,
  as `branch-diff.sh` `branch_changed` does, so a run before the commit
  judges the tree the commit will carry. Result: an untracked file a
  row matches fails the check until the row's files change.
- Item 2: proved on the local branch `scratch/r088-t003-doc-sync`, its
  worktree outside the repository: an added, removed, renamed and
  untracked matching path each failed without the row's files and
  passed with them, a rename across two rows answered to both, a plain
  edit passed, and a repository with no default branch skipped. Result:
  the branch is left for the close's cleanup.
- Item 3: of the five docs only `DESIGN.md § Decisions` stated change
  history; `REQUIREMENTS.md` and `MAINTENANCE.md` change nowhere, and
  `LAYOUT.md` and `skills/dev/SKILL.md` only where a row asked. Result:
  `§ Decisions` gives the merge and the cold read as a plan's admission,
  with its reason.
- Item 3: `DESIGN.md § Self-enforcement` names each check in a nested
  list, `check-plan-text.sh` among them, which the prose had described
  by none of its breaks; `skills/dev/SKILL.md` gains `§ Process files`
  for the seven `skills/dev/*.md` its tables route nowhere; `LAYOUT.md`
  maps `SKILL.md` under `systematic-debugging/` and `writing-skills/`.
  Result: every row's file lists each path `git ls-files` gives for its
  glob, `SKILL.md` within its 400-word cap.

## Answers

- Items 1 and 2: a row fires only when a matching path is added, removed
  or renamed; a plain edit stays with the Tier-2 Doc sync concern.
  Requirements outcome 7 reads so.
- Item 3: a one-time rewrite; no check for history wording.
- Item 2: no self-test, the task staying `[doc]`.
- Item 2: the check is this repository's only; `install-dev.sh` does not
  ship it, what an install ships being R088-T006's.

## Review
- [x] Item 3: `LAYOUT.md` claims every directory but maps no
  `skills/writing-skills/examples/` node (Suggestion) - `LAYOUT.md:3`
  Evidence: observed `git ls-files skills/writing-skills/examples` lists
  `CLAUDE_MD_TESTING.md`
- [x] Close review: `scripts/ci/check-doc-sync.sh` is mode 644 where most
  `check-*.sh` are 755; set +x (Suggestion) - `scripts/ci/check-doc-sync.sh`
  Evidence: observed the close review's `git ls-files -s scripts/ci`
