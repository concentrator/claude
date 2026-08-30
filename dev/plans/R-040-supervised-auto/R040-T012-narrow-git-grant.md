---
task: R040-T012
type: mnt
depends-on: R040-T010
---

Branch: `mnt/narrow-git-grant`.

The user-global `settings.json` allows `Bash(git:*)`, so on any host that
carries the config clone every git subcommand is granted before a
project's own `settings.local.json` is read. The per-project template
(`companions/auto-permissions.template.json`) grants twelve git
subcommands and assumes that list is what keeps a worker from stalling;
under the global grant it does nothing, which is why R040-T010 could not
build a test that told a placed file from a missing one
(`R040-T010-worker-host.findings.md`). The deny rules still bite - deny
beats allow across tiers - so the branch guard and the push denies are
unaffected either way.

## Terms used below

- **Inventory** - the git subcommands the toolset itself runs: every
  `git <sub>` in `skills/dev/*.md`, `skills/dev/companions/*.md`,
  `hooks/*.sh` and `scripts/**/*.sh`, plus what the last ten sessions of
  this repo ran (`scripts/context-cost.py --last 10` names the
  transcripts; `grep -o '"command":"git [a-z-]*'` over them). One list,
  recorded in `R040-T012-narrow-git-grant.findings.md` with the source
  of each entry.
- **Narrowed grant** - the inventory as `Bash(git <sub>:*)` entries in
  the global allow list, replacing `Bash(git:*)`; subcommands the
  template already grants stay in the template.

## Commits

- [x] Inventory per § Terms, in the findings file; the list is the
  branch's evidence and the next item's input.
- [x] Replace `Bash(git:*)` in `settings.json` with the narrowed grant;
  `scripts/ci/check-settings.sh` gains one rule - the tracked
  `settings.json` grants no bare `Bash(git:*)` - with its case in
  `scripts/test/check-settings.test.sh`. `README.md § Contents` row for
  `settings.json` is unchanged unless it names the grant.
- [x] Run one `/dev code` step in this repo under the narrowed grant
  (the branch's own close, which pushes and opens a PR) and record in
  the findings file every git prompt it raised; a prompt on a
  subcommand the inventory missed is added to the grant in the same
  commit.
- [x] Config hygiene in the same tree: drop `fallbackModel` from
  `.claude/settings.json` (it equals `model` since R040-T015 pointed
  the project tier at Opus, and the tiering that owned it, R-056, is
  closed); anchor the portfolio's ignore in `.gitignore` to
  `/supervisor/` under its own comment naming `portfolio.md`, out of
  the `# OS` block. `scripts/ci/run-all.sh` green.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (config row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
