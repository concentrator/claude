task: R063-T002
type: fix

# Hook paths from any directory; secrets guard fails closed

## Sources

`CLAUDE_PROJECT_DIR` is set for every hook command and holds the
project root while the command runs in the session's current working
directory; `"$CLAUDE_PROJECT_DIR"/.claude/hooks/<name>.sh` is the
documented project-tier form (code.claude.com/docs/en/hooks.md, read
2026-08-28). The global tier keeps `~/.claude/hooks`, which the shell
expands regardless of directory.

## Terms used below

- **Project prefix** - `scripts/install-dev.sh` line 44:
  `hp="\"$CLAUDE_PROJECT_DIR\"/.claude/hooks"` for project scope, so
  the registered command reads
  `"$CLAUDE_PROJECT_DIR"/.claude/hooks/dev-branch-guard.sh`.
  `register_hook` and `register_prompt_hook` match on the exact string,
  so an existing relative entry is not replaced by the idempotence
  check: the installer removes the old relative form before adding the
  new one, and only that form.
- **Closed path** - `hooks/dev-secrets-guard.sh` line 24: when
  `secret-patterns.sh` is missing or fails to source, print one line
  `dev-secrets-guard: secret-patterns.sh missing beside the hook;
  denying` to stderr and emit the deny decision naming the same reason.
  Missing `jq` and malformed input still fail open (unchanged, tested).
  The header comment names the closed path and the two open ones.

## Commits

- [x] Project prefix per § Terms with the old-form removal;
  `scripts/test/install-dev.test.sh`: project install writes the
  `$CLAUDE_PROJECT_DIR` form for all three hooks, a re-install over a
  settings file holding the relative form ends with one entry per hook
  in the new form, the global form is unchanged, and a hook fired
  through the registered command from a subdirectory still denies a
  trunk write (the test runs the command string through `bash -c` with
  `CLAUDE_PROJECT_DIR` set and `cwd` a subdirectory).
- [ ] Closed path per § Terms; `scripts/test/secrets-guard.test.sh`: a
  copy of the guard with no `secret-patterns.sh` beside it denies and
  writes the one stderr line; `missing jq fails open` stays green.
  `DESIGN.md § Self-enforcement` sentence on the guards names the
  closed path in one clause.
- [ ] Re-install into fp-remedy: `bash scripts/install-dev.sh
  /Users/skywalker/wallarm-claude/fp-remedy` on a fp-remedy branch
  `fix/hook-paths`; the diff is the five hook paths in
  `.claude/settings.json` plus the refreshed hook copies; run
  fp-remedy's `run-all.sh`; MR and supervised merge. No other project
  is re-installed (user ruling 2026-08-28).
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (code row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
