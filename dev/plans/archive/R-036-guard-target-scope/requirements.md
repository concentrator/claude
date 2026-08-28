---
approved: 2026-07-22
kind: bug
status: done 2026-07-22
---

# R-036: Branch-guard target scope - judge the owning repo

## Observed behavior

R-034 scoped the guard's Write/Edit arm to the session's cwd repo: any
path outside it is allowed unconditionally ("a path outside the cwd repo
is allowed"). A session anchored in another project can therefore mutate
tracked files of a second checkout sitting on a trunk - observed:
`~/.claude/settings.json` edited in the `main` checkout's working tree
from another session, no deny. The memory-dir save was R-034's motivating
case, but its approved allow was broader than the intent.

## Expected behavior

The guard judges a write by the **target path's owning repo**: resolve
the physical target (R-034 mechanics), find the owning repo via the
nearest existing ancestor's toplevel. Owning repo on a trunk branch and
the path tracked-side there (`check-ignore` exit 1 in that repo) → deny,
regardless of the session's cwd. Allowed: a path gitignored in its owning
repo (the memory dir), an owning repo on a working branch, no owning repo
at all. Resolution or git errors fail open.

## Reproduction steps

1. `cd` into a scratch git repo (any branch).
2. Pipe a Write tool-call JSON targeting a tracked file of a second repo
   whose HEAD is `main` into `bash ~/.claude/hooks/dev-branch-guard.sh`.
3. Observe silence (allow); expected: a deny decision.

## Impact

Any tracked file of any trunk checkout is writable from a session
anchored elsewhere - the local-tripwire purpose of the guard is bypassed
for exactly the mutation class it exists to catch. Trunk history stayed
gated (host protection + the Bash commit arm); exposure is working-tree
only. Severity low-medium.

## Acceptance criteria

- [x] A `Write`/`Edit`/`NotebookEdit` to a tracked-side path of any repo
  on a trunk branch is denied, regardless of the session cwd. Evidence:
  cross-repo deny pin + same-verdict-from-any-cwd pin; live repro against
  a `main` worktree of `~/.claude` denied from a foreign cwd.
- [x] Still allowed: a target gitignored in its owning repo, a target
  whose owning repo is on a working branch, a target with no owning repo;
  errors fail open. Evidence: pins for all three shapes green; memory-dir
  and tmp-scratchpad live checks allow.
- [x] All existing guard test pins stay green. Evidence: full suite OK
  (32 cases).
- [x] New pins cover the cross-repo shapes. Evidence: three R-036 pins
  plus five close-review pins (dot-dot, cwd-independence, .git-internal,
  unborn nested init, outward file symlink).
- [x] R-034's unconditional foreign-allow recorded as narrowed. Evidence:
  ROADMAP R-034 entry note (landed with the shape PR #204).
- [x] Full test suite and Tier-1 gate green. Evidence: `test/run-all` and
  `scripts/ci/run-all.sh` green on every commit.

## Constraints

- Write/Edit arm only; the Bash/commit heuristics are out of scope.
- Fail-open preserved (the real gate stays host protection + CI).
- Branch plan is TDD-sliced: tests and hook change land in one commit.

## Open questions

- none

## References

- R-034 - narrows its "a path outside the cwd repo is allowed" to
  repo-less or non-trunk targets; its resolution mechanics are reused.
- R-024 / T-058, R-021 / T-039 - guard lineage.
