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
  Source: `settings.json` no longer tracked (`git ls-files settings.json`
    empty); `scripts/ci/check-settings.sh:25` judges
    `.claude/settings.json`; `scripts/install-dev.sh:45` refuses a target
    inside its own checkout; `REQUIREMENTS.md § Constraints`
  Test: `scripts/test/check-settings.test.sh` "a root settings.json does
    not stand in for the project tier";
    `scripts/test/install-dev-manifest.test.sh` "global install from
    ~/.claude refused"

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
- Item 7: `dev-branch-state.test.sh` and `dev-session-brief.test.sh`
  checked their hook's entry in the root `settings.json`, which leaves;
  both now check the hook file only, the installer's registration of each
  being pinned by `install-dev.test.sh`.
- Item 7: `check-settings.test.sh` writes its fixtures to
  `.claude/settings.json` and adds two cases, a root `settings.json`
  neither standing in for the project tier nor judged when faulty; the
  gate's comments name the project tier.
- Item 7: `LAYOUT.md`'s tree root reads `claude-dev/`, the clone, and its
  intro drops the gitignored harness state, which the clone never holds.
  The `README.md § Contents` row edited is the `settings.json` row the
  gate names, removed.
- Item 8: `scripts/context-cost.py` defaulted `--last` to the directory
  it sits in, the clone once the checkout is no config directory; it now
  defaults to `~/.claude`, and `context-cost.test.sh` pins the default
  with `CLAUDE_CONFIG_DIR` unset.
- Item 8: the worker host's text stays for item 9, true of the
  `config-clone` it changes: `worker-workspace.sh` and its test,
  `skills/worker-host/`, and the comments of `provision-worker.sh:135-139`,
  `provision-worker.test.sh:175-176` and `worker-credentials.sh:61-63`,
  which call the clone the config repo or `~/.claude/.env` gitignored.
- Item 8: beyond the named spans, the `settings.json` the companions
  called tracked is now `~/.claude/settings.json` or the tracked
  `.claude/settings.json` (`seat-permissions.md` pattern 1 and the guard's
  matcher, `supervisor-runbook.md § Failure modes`), and the
  `MAINTENANCE.md` skill usage audit reads its log and hook under
  `~/.claude`; the `install-dev.sh` § 8 comment no longer calls the global
  target this repo. The weekly audit prompt reads `dev-instructions.md`
  and `.claude/settings.json`, the gap the Item 6 and Item 7 findings name
  for `MAINTENANCE.md:174`.
- Item 9: `config-clone` makes a full clone, not the shallow fetch it used:
  the install adopts an unrecorded file by the clone's history
  (`install-manifest.sh` `committed`). The `.git/info/exclude` credentials
  lines go, the clone holding no Claude Code state.
- Item 9: the operator copies the user settings before `config-clone`, so
  the install adds its hook entries to them; `SKILL.md`, `provisioning.md`
  step 8 and the dry run say so. `SKILL.md`'s body reached the 300-word
  cap, so its closing line is cut to the four scripts not being shipped.
- Item 9: the test's case 30, a clone into the existing `~/.claude`, gives
  way to 49-51: the clone's place, the global install run from it, and a
  failed install failing the step; 31 and 38 share one dry-run home, which
  keeps the file under `check-code-size.sh`'s cap.
- Item 9: beyond the named files, the comments item 8 left
  (`provision-worker.sh`, `provision-worker.test.sh`,
  `worker-credentials.sh`) now name the framework clone, and
  `pitfalls.md` drops the tracked-`settings.json` entry, the worker's
  `settings.json` being untracked.
- Item 10: beyond the two named sections, the intro names the
  `~/.claude` framework rather than the `~/.claude` configuration, and
  `§ Components` names `dev-instructions.md`, the root `CLAUDE.md` being
  gone; `§ Self-enforcement` now cites `dev-instructions.md § Compact
  instructions`, the Item 6 finding on `DESIGN.md:117`.
- Item 10: `§ Self-enforcement` says Claude Code hooks reach a machine
  only through `install-dev.sh`, this one included:
  `.claude/settings.json` registers no hooks, and the global install
  registers `~/.claude/hooks/<name>` (`install-dev.sh:109`).
- Item 10: `DESIGN.md` stood at 999 words under `check-caps.sh`'s
  1000-word cap, so `§ Self-hosting layout` names the manifest script
  without restating what the install writes into `settings.json` and
  `CLAUDE.md`, which `install-dev.sh`'s header and items 2-3 hold.
- Review 3: `check-caps.sh` holds `dev-instructions.md` to the root
  `CLAUDE.md`'s 100 lines, its report naming the file, and
  `rules/claude-md.md` loads for `**/dev-instructions.md`, its opening
  line naming the file; `check-caps.test.sh` pins the cap.
- Review 6: `install-dev.sh` names the trees a full install ships whole in
  `TREES`, and with no manifest in the target `install_shipped` judges each
  unshipped file under them, in either set, as it judges a dropped
  recorded one; `install-dev-manifest.test.sh` pins a committed file the
  trees dropped removed and a user's file under `agents/` left and listed.
- Review 7: the fixed-path example is now `~/.config/nvim/`, an editor
  configuration kept as a checkout.
- Review 8: the same phrase in `REQUIREMENTS.md § Constraints` and
  `LAYOUT.md`, which the entry's evidence cites, now reads "cloned outside"
  too.
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
- [ ] Item 7: `rules/skills.md` cites `skills/skill-creator/SKILL.md` and
  `skills/writing-skills/SKILL.md`, and `check-caps.sh`'s reference class
  names `writing-skills`, though the repository no longer tracks either
  skill.
  Evidence: observed rules/skills.md:8-9 and scripts/ci/check-caps.sh:21
- [ ] Item 7: `README.md` still says it is cloned as `~/.claude`, its
  `skills/` row names personal skills, its `.gitignore` row and its setup
  steps the harness state and `plugins/` the file no longer ignores, and
  the weekly audit prompt reads `settings.json`; docs, so the doc
  writer's at close, the last item 8's.
  Evidence: observed README.md:5, README.md:17, README.md:21,
  README.md:184-191 and MAINTENANCE.md:174

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
- Item 9: a worker whose `~/.claude` is a checkout from the earlier
  `config-clone` is reprovisioned from scratch; `config-clone` does not
  move an existing `~/.claude/.git` aside.
- Item 11: `skills/worker-host/` and `rules/skills.md` stay in
  `~/.claude` as the user's files, with `rules/js.md`,
  `skills/skill-creator/` and `skills/writing-skills/`; the other
  repository-only files there go.
- Review 6: fixed - with no manifest in the target, an install also
  examines the unshipped files under its shipped trees (`skills/dev`, the
  bundled skills, `agents`): an unedited committed version is removed,
  any other file is left and listed.
- Review 4: `rules/skills.md` cites the copies at
  `~/.claude/skills/skill-creator/SKILL.md` and
  `~/.claude/skills/writing-skills/SKILL.md`; `check-caps.sh` drops
  `writing-skills` from its reference skills.
- Reviews 1-3, 5, 7, 8: fixed in the close fix round.
- Close: `LAYOUT.md` marks `rules/code-comments.md` and
  `rules/claude-md.md` shipped in the final commit; the Item 3 claim is
  reworded to the code in a plan PR after this branch merges.
- Review 9: the user adds `Edit(//**/dev-instructions.md)` and
  `Edit(//Users/skywalker/src/claude-dev/rules/**)` to the ask list of
  `~/.claude/settings.json`; `MAINTENANCE.md` describes that ask list.
- Review 10: the user removes the two `~/.claude/dev/plans/**` rules from
  `.claude/settings.json` in a commit on the task branch; the other
  `~/.claude` rules stay.
- Reviews 11-15: fixed in the Tier-2 fix round; the settings-copy step
  stays in `provisioning.md`, and `SKILL.md` points to it.

## Review

- [x] Item 2: `MAINTENANCE.md` names `install-dev.test.sh` and
  `install-dev-minimal.test.sh` as the tests asserting the copied sets,
  not the new `install-dev-manifest.test.sh` (Suggestion) -
  MAINTENANCE.md:152
  Evidence: observed MAINTENANCE.md:152-154 lists the two tests only
- [x] Item 2: `migrate.md` tells an adopter to tune the shipped
  `check-accretion.sh` `MARKERS` list without saying a tuned gate is then
  the adopter's file, left and listed by later installs (Suggestion) -
  skills/dev/migrate.md:40
  Evidence: observed skills/dev/migrate.md:38-40 and the Item 2 answer
  that an edited `check-accretion.sh` stays and is listed
- [x] Item 6: `dev-instructions.md` escapes the guards meant for the
  global instructions: `check-caps.sh` caps only a file named `CLAUDE.md`
  at 100 lines, and `rules/claude-md.md` loads only for `**/CLAUDE.md`
  (Important) - scripts/ci/check-caps.sh:53
  Evidence: observed scripts/ci/check-caps.sh:52-54 and the `paths:` of
  rules/claude-md.md:2-3
- [x] Item 7: `rules/skills.md` sends a reader to the untracked
  `skills/skill-creator/` and `skills/writing-skills/`, and `check-caps.sh`
  still lists `writing-skills` as a reference skill (Important) -
  rules/skills.md:8
  Evidence: observed rules/skills.md:8-9, scripts/ci/check-caps.sh:21 and
  `ls skills/` holding neither skill
- [x] Item 9: the `config-clone` dry run says it proves the pre-push hook
  fires, while the step only checks the hook exists and is executable
  (Suggestion) - scripts/worker-workspace.sh:21
  Evidence: observed scripts/worker-workspace.sh:21 and :41
- [x] Close review: a first install over a target with no manifest keeps
  every file the framework has since deleted under its shipped trees -
  unrecorded, unshipped and unlisted - where the removed `rm -rf` of
  `skills/dev` and the bundled skills used to clear it (Important) -
  scripts/install-manifest.sh:96
  Evidence: observed a `--project` install into a fresh repo seeded with
  `.claude/skills/dev/supervise.md` at its last committed content: exit 0,
  the file kept, absent from the manifest and from the install's output
- [x] Close review: `layout.md` gives `~/.claude/` as the tree root of a
  repository consumed at a fixed path, the example this repository no
  longer is (Suggestion) - skills/dev/layout.md:167
  Evidence: observed skills/dev/layout.md:166-168 and LAYOUT.md's tree
  root `claude-dev/`
- [x] Close review: "a clone apart from `~/.claude`" is unclear to a
  reader who has not seen the old layout (Suggestion) - DESIGN.md:18
  Evidence: observed DESIGN.md:18, REQUIREMENTS.md:96 and LAYOUT.md:5
- [ ] Tier-2 review: no ask rule covers an Edit of this clone's `rules/`
  or of `dev-instructions.md`, while `MAINTENANCE.md` and
  `rules/claude-md.md` say governed files ask first (Important) -
  MAINTENANCE.md:69
  Evidence: observed `jq .permissions.ask` printing
  `Edit(//**/CLAUDE.md)`, `Edit(//**/SKILL.md)`, `Edit(//**/.claude/rules/**)`
  and `Edit(//**/.claude/settings*.json)` for `~/.claude/settings.json`
  and `null` for `.claude/settings.json`
- [ ] Tier-2 review: `.claude/settings.json` allows Edit and Read of
  `~/.claude/dev/plans/**`, which no longer exists (Suggestion) -
  .claude/settings.json:14
  Evidence: observed .claude/settings.json:14 and :28, and
  `ls ~/.claude/dev` failing with no such file or directory
- [ ] Tier-2 review: the `config-clone` dry-run test is still labelled
  "proof" after the dry run stopped claiming one (Suggestion) -
  scripts/test/worker-workspace.test.sh:158
  Evidence: observed scripts/test/worker-workspace.test.sh:158 and
  scripts/worker-workspace.sh:20
- [ ] Tier-2 review: `README.md § Installing the toolset elsewhere` does
  not say an install removes target files - a dropped recorded file, a
  retired hook that is its copy, an unedited unshipped file under its
  trees (Suggestion) - README.md:286
  Evidence: observed README.md:286-291 against
  scripts/install-manifest.sh:79-104
- [ ] Tier-2 review: the README `.claude/settings.json` row omits
  `autoCompactEnabled`, which `check-settings.sh` requires (Suggestion) -
  README.md:13
  Evidence: observed README.md:13, .claude/settings.json:3 and
  scripts/ci/check-settings.sh:43
- [ ] Tier-2 review: `MAINTENANCE.md` and `rules/skills.md` name
  `CLAUDE.md` for the global instructions, which `dev-instructions.md`
  holds (Suggestion) - MAINTENANCE.md:18
  Evidence: observed MAINTENANCE.md:18, MAINTENANCE.md:113 and
  rules/skills.md:56
- [ ] Tier-2 review: the step copying the worker's user settings is
  stated in both the worker-host skill and its provisioning companion
  (Suggestion) - skills/worker-host/SKILL.md:33
  Evidence: observed skills/worker-host/SKILL.md:33-34 and
  skills/worker-host/companions/provisioning.md:37-40
