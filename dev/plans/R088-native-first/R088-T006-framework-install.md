---
task: R088-T006
type: mnt
architecture-changing: true
mode: normal
---

- [x] USER: the work moves to a clone at `~/src/claude-dev`: once this plan's
  PR merges, clone GitHub `main` there and carry `core.hooksPath`,
  `.claude/settings.local.json` and workspace trust; `/dev run R088-T006`, in
  a runner session started there, cuts the task branch and marks this. No one
  pulls that branch, or a `main` holding it, into `~/.claude`. Approach: the
  user's commands, from wording the runner drafts.
- [x] An install owns only what it copied: a manifest in the target records
  each copied file's hash; an unrecorded file matching any committed version
  of its path is adopted and refreshed, any other differing file is the user's,
  left and listed; a dropped owned file goes, and it refuses its own checkout
  as target. Approach: `install-dev.sh`, split under `check-code-size.sh`'s
  cap, hashes by `git hash-object`, the manifest allowlisted; its two tests.
- [x] An install writes `settings.json` only to add a missing toolset hook
  entry or drop a retired one, leaving the file byte-identical otherwise, and
  writes `CLAUDE.md` only by appending an import line. Approach: the three
  register functions and the retired-hook pass of `install-dev.sh`, then a
  test re-installing over registered, custom-formatted settings.
- [x] A full install ships what a machine needs to run DEV without this
  repository: the seat definitions under `agents/`, and `rules/code-comments.md`
  and `rules/claude-md.md`, which shipped skills cite; `--minimal` ships none
  of them. Approach: `install-dev.sh`, then both tests, the "personal rules
  not shipped" check among them.
- [x] USER: `~/.claude` stops being a git checkout: move `~/.claude/.git`
  aside, every file staying, and run the global install from
  `~/src/claude-dev`, which adopts the copies `~/.claude` holds. Approach: the
  user's commands, from wording the runner drafts; it precedes items 6 and
  7, the first to rename or untrack a file.
- [ ] The root `CLAUDE.md` becomes `dev-instructions.md`, which an install
  ships and imports from the target's `CLAUDE.md` as it does `writing.md`;
  each citation of its sections names the new file. Approach: `git mv`,
  `install-dev.sh` with its tests, the citations under `skills/`, `agents/`,
  `rules/`, then `LAYOUT.md` and the `README.md § Contents` row
  `check-doc-sync.sh` needs.
- [ ] The repository tracks the framework and its own tooling only:
  `settings.json`, `skills/skill-creator/`, `skills/writing-skills/` and
  `rules/js.md` leave it, `.gitignore` drops the harness lines and
  `check-settings.sh` judges `.claude/settings.json`. Approach: `git rm`, the
  gate with its test, `LAYOUT.md`, `REQUIREMENTS.md § Vision` and
  `§ Constraints`, the `README.md § Contents` rows `check-doc-sync.sh` needs.
- [ ] No skill, agent, script or `MAINTENANCE.md` text says this checkout is
  the config directory: each describes a clone installed into `~/.claude`.
  Approach: grep the tree for `~/.claude` and checkout-as-config wording; then
  `agents/dev-implementer.md`'s config paragraph, `seat-permissions.md`'s
  `<config>`, `supervisor-runbook.md § Remote Control`, `migrate.md`,
  `start.md`, `MAINTENANCE.md § Weekly audit`.
- [ ] The worker host installs the framework rather than becoming a clone:
  `config-clone` clones the repository to `~/src/claude-dev` and runs the
  global install, its dry run saying so; the operator copies the worker's user
  settings, as with `.env`. Approach: `worker-workspace.sh` with its test,
  then `skills/worker-host/` and its `companions/provisioning.md`.
- [ ] `DESIGN.md` describes the repository as a clone the installer copies
  into `~/.claude`, the files it did not copy being the user's. Approach:
  `§ Self-hosting layout`, then `§ Self-enforcement` where it names how hooks
  reach a machine.
- [ ] USER: refresh `~/.claude` from `~/src/claude-dev`: run the global
  install, cut `~/.claude/CLAUDE.md` to its import lines and personal text,
  update the `autoMode` entries naming `~/.claude` as the repository, and
  remove the repository-only files left there. Approach: the user's commands
  and `settings.json` edit, from wording the runner drafts; then `claude
  auto-mode config`.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- Item 2 (source): An install records each file it copies in a manifest in
  the target. It adopts and refreshes a target file whose hash matches its
  manifest record or, unrecorded, any committed version of its path in the
  framework repository; any other differing target file it leaves in place
  and lists.
- Item 3 (source): An install writes `settings.json` only to add a missing
  toolset hook entry or to drop a retired one.
- Item 4 (source): A full install ships the seat definitions under `agents/`
  and the rules `code-comments.md` and `claude-md.md`.
- Item 4 (drop): `agents/` is this repository's own, `install-dev.sh` copying
  none of it.
- Item 6 (source): An install ships `dev-instructions.md`, the framework's
  global instructions, and appends a line importing it to the target's
  `CLAUDE.md`.
- Item 7 (drop): The repository is cloned as `~/.claude`, with no install step
  of its own, its `settings.json` the machine's global Claude Code config.

## Proven

- none
