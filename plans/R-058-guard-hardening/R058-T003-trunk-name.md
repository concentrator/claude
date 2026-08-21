task: R058-T003
type: fix

# R058-T003 - is_trunk resolves the default branch

- [x] `is_trunk()` takes the owning repo and the branch: resolve the
  repo's default branch from `origin/HEAD`
  (`git symbolic-ref --short refs/remotes/origin/HEAD`, `origin/`
  stripped), then `git config init.defaultBranch`, then the literal
  `main`/`master` fallback; both call sites pass the repo; tests add a
  repo whose trunk is `develop` with `origin/HEAD` set (write denied)
  and prove unresolvable detection falls back to the literals
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [ ] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
