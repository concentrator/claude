task: R040-T019
type: feat

# State survives compaction

A `PreCompact` hook writes the tree's state to a file the next prompt
names, so a session compacted mid-branch re-briefs from the tree. The
branch `feat/precompact-state` already holds a draft commit; the first
item reworks it to this plan rather than starting over.

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

- **State file** - `~/.claude/state/precompact/<session_id>.md`
  (`DEV_STATE_DIR` overrides the directory for tests); when
  `session_id` is absent the key is the repository root's checksum, one
  file per repository. Content: time, `compaction_trigger`, repository
  root, branch, `git status --porcelain`, the last five commits, and for
  each plan file the branch touched (against the merge base with
  `origin/main`) the line of its first `- [ ]`. Ends with the
  re-brief instruction. Display only, never a decision; silent outside
  a repository; every read fails open.
- **Root** - `CLAUDE_PROJECT_DIR` when set, else `git rev-parse
  --show-toplevel` from the current directory.
- **Pointer** - `hooks/dev-branch-state.sh` appends
  `| precompact-state: <path>` to its line while a state file for the
  session (or the repository) exists; the session deletes the file once
  read, so the pointer disappears.
- **Registration** - global only: `settings.json` gains a `PreCompact`
  entry running `~/.claude/hooks/dev-precompact-state.sh`. Project-scope
  installs are not changed: the worker hosts run this repository as
  their global config. `state/` joins `.gitignore` under the
  harness-managed state block, since the hook writes inside this
  tracked tree.

## Commits

- [ ] `hooks/dev-precompact-state.sh` per § Terms, reworked from the
  draft: `compaction_trigger` read, `CLAUDE_PROJECT_DIR` root, `state/`
  ignored; `scripts/test/dev-precompact-state.test.sh` asserts the file
  per session, `compaction_trigger: auto` recorded, branch, an
  uncommitted path, the first open plan item and its line, the
  repository-keyed file without a session id, silence outside a
  repository, and that a `cd` into a subdirectory before the call still
  finds the root. `DESIGN.md` tree-map and § Self-enforcement name the
  hook; `README.md § Contents` `hooks/` row names it.
- [ ] Pointer per § Terms in `hooks/dev-branch-state.sh`;
  `scripts/test/dev-branch-state.test.sh` asserts the pointer while the
  file exists and its absence once deleted; `dev-precompact-state.test.sh`
  drops its copy of that assertion.
- [ ] Registration per § Terms in `settings.json` (a `~/.claude`
  settings change: user approval on this plan is the approval);
  `scripts/test/dev-precompact-state.test.sh` asserts the entry;
  `skills/dev/supervise.md § Monitor` gains the pre-compaction commit
  and the post-compaction re-brief from the state file, never the
  summary, in three sentences.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (code and prose rows: `code-reviewer`), Tier-2 compliance
  review, `bash scripts/ci/run-all.sh` green, cleanup, mark plan
  complete, commit.
