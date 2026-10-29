---
task: R089-T004
type: mnt
mode: normal
---

- [ ] A project whose `gh pr` answers HTTP 403 "GraphQL is not available"
  declares a REST state check: one `gh api` call printing the pull request's
  state, merge time and head sha, no checks, the CI wait carrying them.
  Approach: probe the form under `GH_DEBUG=api` (no `/graphql` request), then
  `toolchain.md § State check`, `declarations.md § Declared commands`.
- [ ] The REST CI wait blocks until the pull request's checks finish and keeps
  the exit contract: 0 when every check passes, non-zero when one fails, and
  a not-yet-registered case `git-workflow.md § Merge order` re-runs. Approach:
  probe `gh run watch --exit-status` on the head sha's run against check runs
  by head sha, on a passing and a failing pull request, then `toolchain.md
  § CI wait`, and `git-workflow.md § Merge order` only if the signal differs.
- [ ] The `/dev run` pre-flight derives from each REST line a rule matching the
  command as declared, and no shipped rule reaches a `gh api` write.
  Approach: confirm how a `:*` rule matches a placeholder glued to a path
  (`pulls/<n>`), then `preflight-permissions.sh` with
  `preflight-permissions-toolchain.test.sh`, `seat-permissions.md § Bash
  prefix set` and `auto-permissions.template.json`.
- [ ] `/dev start` adopts a repository whose `main` already exists: it cuts
  `mnt/dev-scaffold` before § 1's first write, commits the scaffold there and
  delivers it by MR/PR, as `migrate.md § 8` does, protecting `main` as before.
  Approach: the route at the head of `start.md`, then `start.md § 5` and the
  bootstrap bullet of `git-workflow.md § Trunk`.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- Item 1 (probe): The REST state check prints a pull request's state, merge
  time and head sha from one REST call, making no GraphQL request.
- Item 2 (probe): The REST CI wait exits 0 when every check passes and
  non-zero when one fails, making no GraphQL request.
- Item 4 (source): `/dev start` in a repository whose `main` already exists
  delivers the scaffold through a working branch and an MR/PR.

## Proven

- `gh pr checks <n> --watch` exits 0 when every check passes and non-zero
  when one fails: `docs/reports/gh-pr-checks-watch.md`
- Where the host CLI has REST only, every `gh pr` subcommand fails with HTTP
  403 "GraphQL is not available": `docs/reports/dev-dogfood-report.md`
