task: T-074
type: fix

# fix/guard-scope - allow foreign-path writes on a trunk cwd (R-034)

T-074 of `plans/R-034-guard-path-scope/`. The branch-guard's Write/Edit arm
collapses `git check-ignore`'s three outcomes to ignored/not-ignored, so a
path outside the cwd repo (exit 128) falls through to the trunk deny. Deny
only on exit 1 - inside the repo and not ignored, the sole case that can
land on this trunk; 0 (ignored) and 128 (outside / error) allow, preserving
fail-open.

Acceptance criteria: see `requirements.md` (foreign path allowed on a trunk
cwd; ignored-inside stays allowed, non-ignored-inside stays denied; errors
fail open; test coverage; suites + Tier-1 green).

- [x] Test-first in `scripts/test/dev-branch-guard.test.sh`: a Write from a trunk-cwd repo to an absolute path outside it is allowed (red today); ignored-inside-repo allowed and non-ignored-inside-repo denied stay covered. Run the suite; the new case fails for the right reason.
- [x] Fix `hooks/dev-branch-guard.sh`: branch on the `check-ignore` exit code - deny only on 1; update the header comment's gitignored-path phrasing to path-scope. Suite green.
- [x] Close-review red tests: a tracked-symlinked-dir write and a `../` re-entry write on main must deny (both 128 in check-ignore, inside the repo); a symlink pointing outside must allow.
- [x] Close-review fix: judge location by physical resolution (nearest existing ancestor + tail, `pwd -P`) against the resolved toplevel, then check-ignore on the resolved path; exit-code inference dropped.
- [x] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
