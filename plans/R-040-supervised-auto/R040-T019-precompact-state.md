task: R040-T019
type: feat

# State survives compaction

A session file carries two halves of the state a compaction loses: the
tree's, written by a `PreCompact` hook, and the session's intent,
written by the session as a hand-off note at each unit boundary. The
next prompt names the file, so a session compacted mid-branch re-briefs
from both. The branch `feat/precompact-state` already holds a draft of
the hook; the first item reworks it to this plan rather than starting
over.

## Sources

Hook input and environment: code.claude.com/docs/en/hooks.md, read
2026-08-28. A `PreCompact` command receives on stdin `session_id`,
`prompt_id`, `transcript_path`, `cwd`, `permission_mode`,
`hook_event_name` and `compaction_trigger` (`manual` or `auto`); there
is no `trigger` field. `CLAUDE_PROJECT_DIR` is set and holds the
project root; the command runs in the session's current working
directory. Observed need: two supervised fp-remedy tasks compacted with
an uncommitted checkbox (R040-T019 task line).

## Terms used below

- **Session file** - `<artifacts root>/session/<session_id>.md`
  (`dev/session/` in a project; `./session/` in this repository, whose
  root is `./`), the root resolved by `scripts/ci/resolve-root.sh` in
  both hooks; `DEV_STATE_DIR` overrides the directory for tests. The
  directory is gitignored: `install-dev.sh` and `/dev start` add the
  line. When `session_id` is absent the key is the repository root's
  checksum, one file per repository. Two writers append to it; the
  resumed session re-briefs from the file and the tree, never the
  summary, then deletes the file.
- **Identity** - one file per `session_id`. Under the supervisor
  runbook the supervisor, worker and operator are separate `claude`
  processes, so each has its own file. Under `/dev auto` or a worker
  spawned as a subagent, hooks fire with the parent's `session_id`, so
  the run has one file and only the orchestrating session writes
  hand-offs to it; the batch checkpoint report stays the subagent's
  state.
- **Format** - the first writer creates the file with the header
  `# <role> session <session_id>`; the hook, which knows no role,
  writes `# session <session_id>` and the next hand-off fills the role
  in (`worker`, `supervisor`, `operator`, `solo`). Each block is
  `## <kind> <UTC timestamp>` followed by `- key: value` lines,
  appended in time order; the last block of each kind is current.
- **Hand-off note** - kind `hand-off`, written by the session at a unit
  boundary (an initiative closed, a dispatch sent, a ruling received, a
  task branch opened) to the path its own prompt line names: `done`,
  `next`, `branch`, `open` (MR/PR numbers), `rulings` (in force). The
  tree cannot derive intent, so no hook writes this block.
  `/dev handoff` writes one on demand; the boundary rule in
  `branch-plan.md § Session boundary` and `supervise.md § Monitor`
  writes it without being asked.
- **Tree block** - kind `tree`, written by
  `hooks/dev-precompact-state.sh` on `PreCompact`: `trigger`
  (`compaction_trigger`), `repo`, `branch`, `status`
  (`git status --porcelain`), `commits` (last five), and `plan` per
  plan file the branch touched (against the merge base with
  `origin/main`) with the line of its first `- [ ]`. Display only,
  never a decision; silent outside a repository; every read fails open.
- **Root** - `CLAUDE_PROJECT_DIR` when set, else `git rev-parse
  --show-toplevel` from the current directory.
- **Pointer** - `hooks/dev-branch-state.sh` always ends its line with
  `| session-state: <path>`, the session's own file whether or not it
  exists yet, so a session learns where to write without guessing.
- **Registration** - global only: `settings.json` gains a `PreCompact`
  entry running `~/.claude/hooks/dev-precompact-state.sh`; the worker
  hosts run this repository as their global config. Project-scope
  installs copy the hook file without registering it, so the pointer
  resolves there through the one home of the path logic.
- **Housekeeping** - `MAINTENANCE.md § Routine` table gains a row:
  `session/` files whose session is gone, weekly, delete.

## Commits

- [x] `hooks/dev-precompact-state.sh` per § Terms, reworked from the
  draft: session file under the resolved root, header then tree block
  appended, `compaction_trigger` read, `CLAUDE_PROJECT_DIR` root;
  `install-dev.sh` and `skills/dev/start.md` add the `session/` ignore
  line (`install-dev.test.sh` asserts it); `scripts/test/dev-precompact-state.test.sh`
  asserts the file per session under `dev/session/`, the header, a
  `trigger: auto` line, branch, an uncommitted path, the first open plan
  item and its line, a second run appending, the repository-keyed file
  without a session id, silence outside a repository, and that a `cd`
  into a subdirectory before the call still finds the root. `DESIGN.md`
  tree-map and § Self-enforcement name the hook; `README.md § Contents`
  `hooks/` row names it.
- [x] Pointer per § Terms in `hooks/dev-branch-state.sh`;
  `scripts/test/dev-branch-state.test.sh` asserts the path is printed
  with and without the file.
- [x] Hand-off note per § Terms: `skills/dev/handoff.md` (header rule,
  block format, the five keys, the delete-after-re-brief rule) and a
  `/dev handoff` row in `SKILL.md`'s router table; the boundary rule as
  one sentence each in `branch-plan.md § Session boundary` and
  `supervise.md § Monitor` (write the note before the next unit; after
  compaction re-brief from the session file, then delete it; under a
  tenth of context the worker commits locally first); the
  `MAINTENANCE.md § Routine` row. `README.md § Workflow` and the
  `DESIGN.md` tree-map take the new command and file (§ Doc-sync pairs
  rows 1 and 2).
- [x] `skills/dev/auto.md § Pre-flight` gains one bullet: no member
  plan names a target under `.claude/` (config is never a batch's to
  write, `companions/implementer-prompt.md`); every pre-flight check
  runs before any action, failures are reported together in one
  message, and the batch halts with no branch created and no edit
  made. Artifacts under the root need no mention: they left `.claude/`
  with the artifacts root and are edited through Read/Edit/Write.
- [x] Registration per § Terms in `settings.json` (a `~/.claude`
  settings change: user approval on this plan is the approval);
  `scripts/test/dev-precompact-state.test.sh` asserts the entry.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (code and prose rows: `code-reviewer`), Tier-2 compliance
  review, `bash scripts/ci/run-all.sh` green, cleanup, mark plan
  complete, commit.
