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
  Source: `scripts/install-dev.sh` § 3 `edit_settings`, `register` and the
    retired-hook pass
  Test: `scripts/test/install-dev-settings.test.sh`
- Item 4 (source): A full install ships the seat definitions under `agents/`
  and the rules `code-comments.md` and `claude-md.md`.
  Source: `scripts/install-dev.sh` § 2, `ship_tree agents` and
    `CITED_RULES`, under `set = full`
  Test: `scripts/test/install-dev.test.sh` "seat definitions and cited
    rules shipped, personal rules not" and "global install copies toolset,
    seat definitions included"; `scripts/test/install-dev-minimal.test.sh`
- Item 4 (drop): `agents/` is this repository's own, `install-dev.sh` copying
  none of it.
  Source: `scripts/install-dev.sh` § 2, `ship_tree agents`
  Test: `scripts/test/install-dev.test.sh` "seat definitions and cited
    rules shipped, personal rules not"
- Item 6 (source): An install ships `dev-instructions.md`, the framework's
  global instructions, and appends a line importing it to the target's
  `CLAUDE.md`.
  Source: `scripts/install-dev.sh` § 5, `IMPORTS` shipped and each
    appended as an `@` line when absent
  Test: `scripts/test/install-dev.test.sh` "writing.md and
    dev-instructions.md copied", "writing.md and dev-instructions.md
    imported in CLAUDE.md" and "global install copies toolset, seat
    definitions included, and imports the instructions";
    `scripts/test/install-dev-settings.test.sh`;
    `scripts/test/install-dev-minimal.test.sh`
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
- Item 3: the cases went to a new `scripts/test/install-dev-settings.test.sh`,
  `install-dev.test.sh` sitting at the 300-line cap. The three register
  functions share `register`, and they and the retired-hook pass write
  through `edit_settings`, which replaces `settings.json` only when the jq
  value changes; replacing a relative-form `.claude/hooks/<name>` entry
  stays, as dropping a retired form of a toolset entry.
- Item 3: the filters now drop an entry or event only when removing a
  toolset command empties it; a user entry with an empty `hooks` list in a
  touched event was dropped before, and the test pins it kept.
- Item 3: `CLAUDE.md` needed no change, § 5 only appending `@writing.md`
  when the line is absent; the test pins it byte-identical on a re-install
  and only the import line added when missing.
- Item 4: § 6 also allowlists `.claude/agents/` for a project install, as
  it does every other shipped path, so the seat definitions stay committable
  under a restrictive `.gitignore`; the committability case checks one. The
  manifest test's expected count takes in `agents/` and the two rules.
- Item 4: `install-dev.test.sh` sits at the 300-line cap, so the full-set
  checks extend its existing rules check and global-install check, each one
  line, rather than adding lines.
- Item 6: `dev-instructions.md` ships in the minimal set too, as
  `writing.md` does, and its import line follows `@writing.md`'s; a project
  install allowlists `.claude/dev-instructions.md` beside `.claude/writing.md`.
  `install-dev.test.sh` sits at the 300-line cap, so its copy, import,
  idempotence, global-install and committability checks each extend an
  existing line.
- Item 6: the citations moved are those of the root file's sections in
  `agents/`, `rules/` and `skills/dev/`, `rules/js.md` included though item
  7 untracks it; `plan.md § Proportionality` rewraps for the mode files'
  80-character line. The `LAYOUT.md` line and `README.md § Contents` row of
  `writing.md` still say an import from `CLAUDE.md`, which holds for an
  installed target, and stay.
### Findings
- [ ] Item 6: `DESIGN.md § Self-enforcement` cites `CLAUDE.md § Compact
  instructions`, a section now in `dev-instructions.md`; a doc, so the doc
  writer's at close.
  Evidence: observed DESIGN.md:117
- [ ] Item 6: `check-caps.sh` holds only a file named `CLAUDE.md` to 100
  lines, and `rules/claude-md.md` loads by the path `**/CLAUDE.md`, so
  `dev-instructions.md` is under neither.
  Evidence: observed scripts/ci/check-caps.sh:53-54 and
  rules/claude-md.md:2-4
- [ ] Item 6: the `MAINTENANCE.md § Weekly audit` prompt tells the routine
  to read `CLAUDE.md`, which the repository no longer has; item 8 edits
  that section.
  Evidence: observed MAINTENANCE.md:174

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
- Item 3: the `CLAUDE.md` clause covers the `@writing.md` import append
  only; a project install's wiring of `check-plan-text.sh` and
  `check-code-size.sh` into the `- Test (fast):` line stays as it is.
- Item 7: the user adds `"autoCompactEnabled": true` to
  `.claude/settings.json` in a commit on the task branch before the item
  runs; `check-settings.sh` keeps its checks unchanged.
- Item 7: the harness lines `.gitignore` drops are the harness-managed
  state and cache blocks, `plugins/`, the machine-local harness output
  block, the credentials and `downloads/` block, and the `/skills/*`
  block; `*.local.json`, `*.local.md`, the `.claude/*` project tier,
  `.env*`, `__pycache__/` and `.DS_Store` stay.

## Review

- [ ] Item 2: `MAINTENANCE.md` names `install-dev.test.sh` and
  `install-dev-minimal.test.sh` as the tests asserting the copied sets,
  not the new `install-dev-manifest.test.sh` (Suggestion) -
  MAINTENANCE.md:152
  Evidence: observed MAINTENANCE.md:152-154 lists the two tests only
- [ ] Item 2: `migrate.md` tells an adopter to tune the shipped
  `check-accretion.sh` `MARKERS` list without saying a tuned gate is then
  the adopter's file, left and listed by later installs (Suggestion) -
  skills/dev/migrate.md:40
  Evidence: observed skills/dev/migrate.md:38-40 and the Item 2 answer
  that an edited `check-accretion.sh` stays and is listed
- [ ] Item 6: `dev-instructions.md` escapes the guards meant for the
  global instructions: `check-caps.sh` caps only a file named `CLAUDE.md`
  at 100 lines, and `rules/claude-md.md` loads only for `**/CLAUDE.md`
  (Important) - scripts/ci/check-caps.sh:53
  Evidence: observed scripts/ci/check-caps.sh:52-54 and the `paths:` of
  rules/claude-md.md:2-3
