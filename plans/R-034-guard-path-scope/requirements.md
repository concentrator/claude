---
approved: 2026-07-12
kind: bug
status: done 2026-07-12
---

# R-034: Branch-guard scope - foreign-path writes

## Observed behavior

With the session cwd in any git repo on `main`, `hooks/dev-branch-guard.sh`
denies a `Write`/`Edit`/`NotebookEdit` targeting an absolute path outside
that repo (observed: a global memory save to
`~/.claude/projects/.../memory/`). `git check-ignore` exits 128 for a path
outside the repo, so the gitignored carve-out (T-058) never triggers and
the trunk deny fires.

## Expected behavior

The guard denies only a write that can land on the cwd repo's trunk: a
path inside the repo's working tree and not gitignored. A path outside the
repo, or an ignored path, is allowed; `check-ignore` errors keep failing
open (allow).

## Reproduction steps

1. `cd` into any git repo on `main` (not `~/.claude`).
2. Pipe a Write tool-call JSON with
   `file_path: /Users/skywalker/.claude/projects/.../memory/x.md` into
   `bash ~/.claude/hooks/dev-branch-guard.sh`.
3. Observe a deny decision; expected: silence (allow).

## Impact

Every cross-repo write from a trunk cwd is falsely blocked - global memory
saves, edits to a second checkout. Severity low (workarounds exist), but
the behavior contradicts the guard's own header spec ("judges the real
target, not the session cwd branch").

## Acceptance criteria

- [x] A `Write`/`Edit`/`NotebookEdit` to a path outside the cwd repo is
  allowed when the cwd repo is on a trunk branch. Evidence: foreign-path
  test case + live memory-path repro allowed (T-074, PR #195).
- [x] A write to a gitignored path inside the repo stays allowed; a write
  to a non-ignored path inside the repo on a trunk stays denied. Evidence:
  pre-existing suite cases green; close review added symlinked-dir and
  `../`-re-entry deny pins (in-repo paths misreported as 128).
- [x] `check-ignore` failures other than "not ignored" fail open.
  Evidence: hook allows on non-1 exits for in-repo paths; resolution
  failure and no-toplevel paths exit 0 (allow).
- [x] `scripts/test/dev-branch-guard.test.sh` covers the foreign-path
  case; the full test suite and Tier-1 gate are green. Evidence: 4 new
  cases; `test/run-all` + `tier1` green on PR #195.

## Constraints

- Minimal change to the hook's `Write`/`Edit` arm; the Bash/commit
  heuristics are out of scope.
- Preserve the documented fail-open stance.

## Open questions

- none

## References

- R-024 / T-058 - branch-guard precision (introduced the carve-out this
  extends).
- R-021 / T-039 - the branch-guard hook.
