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

- **Session file** - `~/.claude/state/session/<session_id>.md`
  (`DEV_STATE_DIR` overrides the directory for tests); when
  `session_id` is absent the key is the repository root's checksum, one
  file per repository. Two writers append to it, each a dated block:
  the session's hand-off note and the hook's tree block. The resumed
  session re-briefs from the file and the tree, never the summary, then
  deletes the file. `state/` joins `.gitignore` under the harness-managed
  state block, since the writes land inside this tracked tree.
- **Hand-off note** - written by the session itself at a unit boundary
  (an initiative closed, a dispatch sent, a ruling received, a task
  branch opened): done, next, current branch, open MR/PR numbers, and
  the rulings in force. The tree cannot derive intent, so no hook
  writes this block. `/dev handoff` writes one on demand; the
  boundary rule in `branch-plan.md § Session boundary` and
  `supervise.md § Monitor` writes it without being asked.
- **Tree block** - written by `hooks/dev-precompact-state.sh` on
  `PreCompact`: time, `compaction_trigger`, repository root, branch,
  `git status --porcelain`, the last five commits, and for each plan
  file the branch touched (against the merge base with `origin/main`)
  the line of its first `- [ ]`. Display only, never a decision; silent
  outside a repository; every read fails open.
- **Root** - `CLAUDE_PROJECT_DIR` when set, else `git rev-parse
  --show-toplevel` from the current directory.
- **Pointer** - `hooks/dev-branch-state.sh` appends
  `| session-state: <path>` to its line while a session file for the
  session (or the repository) exists.
- **Registration** - global only: `settings.json` gains a `PreCompact`
  entry running `~/.claude/hooks/dev-precompact-state.sh`. Project-scope
  installs are not changed: the worker hosts run this repository as
  their global config.

## Commits

- [ ] `hooks/dev-precompact-state.sh` per § Terms, reworked from the
  draft: appends the tree block to the session file, reads
  `compaction_trigger`, roots at `CLAUDE_PROJECT_DIR`; `state/` ignored;
  `scripts/test/dev-precompact-state.test.sh` asserts the file per
  session, `compaction_trigger: auto` recorded, branch, an uncommitted
  path, the first open plan item and its line, a second run appending
  rather than replacing, the repository-keyed file without a session
  id, silence outside a repository, and that a `cd` into a subdirectory
  before the call still finds the root. `DESIGN.md` tree-map and
  § Self-enforcement name the hook; `README.md § Contents` `hooks/` row
  names it.
- [ ] Pointer per § Terms in `hooks/dev-branch-state.sh`;
  `scripts/test/dev-branch-state.test.sh` asserts the pointer while the
  file exists and its absence once deleted.
- [ ] Hand-off note per § Terms: `skills/dev/handoff.md` (the block's
  five fields, the append, the delete-after-re-brief rule) and a
  `/dev handoff` row in `SKILL.md`'s router table; the boundary rule as
  one sentence each in `branch-plan.md § Session boundary` and
  `supervise.md § Monitor` (write the note before the next unit; after
  compaction re-brief from the session file, then delete it; under a
  tenth of context the worker commits locally first). `README.md
  § Workflow` and the `DESIGN.md` tree-map take the new command and
  file (§ Doc-sync pairs rows 1 and 2).
- [ ] Registration per § Terms in `settings.json` (a `~/.claude`
  settings change: user approval on this plan is the approval);
  `scripts/test/dev-precompact-state.test.sh` asserts the entry.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (code and prose rows: `code-reviewer`), Tier-2 compliance
  review, `bash scripts/ci/run-all.sh` green, cleanup, mark plan
  complete, commit.
