task: T-058
type: fix

# fix/branch-guard-fix - branch-guard precision (R-024)

T-058 of `plans/R-024-confirmation-gates/`. Fix the branch-guard's three
false-positives so it keys off the real target rather than the cwd branch
plus a substring match: (i) a Write/Edit to a gitignored path on main is
allowed (it never touches the tracked trunk); (ii) a `git -C <path> commit`
is judged by <path>'s branch, not the cwd's; (iii) a compound `git checkout
-b X && ... git commit` is allowed (the commit lands on the new branch). The
guard still denies a real direct write/commit on the trunk, and fails open.

Acceptance criteria: see `requirements.md` (guard permits the three
patterns, still denies a real direct-main write/commit, fails open; a test
covers them).

- [ ] Test-first `scripts/test/dev-branch-guard.test.sh`: the three previously-false-blocked patterns are allowed, a real direct-main Write and `git commit` are denied, and malformed input / no-repo fail open. (red)
- [ ] Implement the gitignored-path exemption: a `Write`/`Edit`/`NotebookEdit` whose target path is gitignored (`git check-ignore`) is allowed on main. (green slice)
- [ ] Implement the cross-repo + compound-command fixes: judge `git -C <path>` by <path>'s branch; allow a `git commit` in a command that first creates/switches a branch (`git checkout -b` / `git switch -c`). (green slice)
- [ ] Verify `install-dev.test.sh` still passes (the hook ships unchanged in shape); note the refined behavior in `DESIGN.md` only if materially changed.
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
