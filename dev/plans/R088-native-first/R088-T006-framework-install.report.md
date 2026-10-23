# R088-T006 report

## Claims
- Item 2 (source): An install records each file it copies in a manifest in
  the target. It adopts and refreshes a target file whose hash matches its
  manifest record or, unrecorded, any committed version of its path in the
  framework repository; any other differing target file it leaves in place
  and lists.
  Source: `scripts/install-manifest.sh` `copy_shipped`, `owned`,
    `committed`, `install_shipped` and `list_kept`, called from
    `scripts/install-dev.sh` § 5
  Test: `scripts/test/install-dev-manifest.test.sh`
- Item 3 (source): An install writes `settings.json` only to add a missing
  toolset hook entry or to drop a retired one.
  Source:
- Item 4 (source): A full install ships the seat definitions under `agents/`
  and the rules `code-comments.md` and `claude-md.md`.
  Source:
- Item 4 (drop): `agents/` is this repository's own, `install-dev.sh` copying
  none of it.
  Source:
- Item 6 (source): An install ships `dev-instructions.md`, the framework's
  global instructions, and appends a line importing it to the target's
  `CLAUDE.md`.
  Source:
- Item 7 (drop): The repository is cloned as `~/.claude`, with no install step
  of its own, its `settings.json` the machine's global Claude Code config.
  Source:

## Implementer
### Divergences
- Item 2: the manifest's cases went to a new
  `scripts/test/install-dev-manifest.test.sh`, as `install-dev.test.sh`
  sits at `check-code-size.sh`'s 300-line cap; the two named tests carry
  the changed cases - the tuned accretion gate left and listed, retired
  hooks holding committed content, the manifest allowlisted, and minimal
  over full dropping the bundled skills. The split put the ownership
  functions in `scripts/install-manifest.sh`, sourced by `install-dev.sh`
  and listed in `LAYOUT.md`.
- Item 2: retired hooks are removed only where they are the install's
  copies, by the same test as a dropped recorded file, so a retired hook
  the user edited stays and is listed; "its own checkout" is refused as a
  target equal to or under the checkout's physical path, `--project` into
  it and a symlinked target included.
- Item 2: a file the manifest records whose content the user changed loses
  its record, so a later install treats it as unrecorded; a dropped edited
  file is listed once, the install that drops it from the set.

## Answers

- Items 1, 5, 9, 11: the repository's clone lives at `~/src/claude-dev`.
- Items 1, 5: the user clones it before items 2-4 run, so every seat works
  in the clone; item 5 moves `~/.claude/.git` aside and runs the install.
- Item 6: the root `CLAUDE.md` becomes `dev-instructions.md`, shipped
  whole, `## Communication` included, and `@`-imported from the user's
  `CLAUDE.md` like `writing.md`.
- Item 2: a manifest of hashes tells the install's files from the
  user's; an identical file is adopted, a differing one stays and is
  listed, an owned file the set drops is removed.
- Item 2: with no manifest record, a target file whose hash matches any
  committed version of its path in the framework repository is an
  unedited copy, adopted and refreshed; any other differing file is the
  user's.
- Item 2: an edited `check-accretion.sh` is the user's: it stays and is
  listed, with no MARKERS carry-over.
- Item 3: the install writes `settings.json` only to add a missing
  toolset hook entry or drop a retired one, and only on a change.
- Item 7: `settings.json`, `skills/skill-creator/`,
  `skills/writing-skills/` and `rules/js.md` are untracked, the user's
  copies staying in `~/.claude`; `rules/skills.md` stays tracked;
  `check-settings.sh` judges `.claude/settings.json`.
- Item 4: a full install in either scope ships `agents/`,
  `rules/code-comments.md` and `rules/claude-md.md`; `--minimal` ships
  none of them.
- Item 9: the worker host changes in this task.
- Item 1: the plan merges first in its own plan PR, `/dev run` admitting
  only a merged plan for a task of a multi-task initiative; the user
  clones `~/src/claude-dev` from `main` and the run cuts the task branch
  there.
- Items 6, 7: each edits only the `README.md § Contents` rows
  `check-doc-sync.sh` names; the doc writer does the rest at close, and
  the clash between the two rules goes to the R088 backlog.

## Review
