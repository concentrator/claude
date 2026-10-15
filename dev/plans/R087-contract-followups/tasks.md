# R087 tasks - Seat contract follow-ups

Why: the agent contracts closed with backlog lines their rounds did not promote or drop.

## Open

- The implementer prompt says which instructions are in context; it should give only its own context.
- The code-comments rule lives in the global instructions; the implementer needs it in its prompt.
- About a third of the planner prompt is its shell-config section.
- This repo declares a docs path that holds no docs.
- Find where git workflow rules are restated outside the git workflow file.
- The docs gate verifies a whole doc, though older text changes only on request.
- The planner's contract has no input for the user's decisions on a plan change.
- The toolchain rule says commands are declared as allow rules, but the pre-flight wraps each one in `Bash(...:*)`, so a declared rule is wrapped twice.
- The pre-flight passes a chained toolchain command and a top-level `deny`/`allow`/`ask` key in a settings tier without a warning.
- The supervisor seat can only change through a tracked edit; a session cannot pick a seat below the declared one.
- The pre-flight `--apply` resets the local settings tier to mode 644 instead of keeping its mode.
- The branch guard splits a command on newlines as text, so a commit message or heredoc naming `git reset --hard` is refused.
- The pre-flight self-test's `rcn` and `nowant` helpers pass on a run that aborted early.
- The cold reader's definition has no `model:` key; every other seat has one.
- The installer ships no `agents/`, so an installed project's run flow cites seat definitions it lacks.
- The duty table has no row for reviewing, and the reviewer definitions say no cell of it is theirs.
