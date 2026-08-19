task: R052-T002
type: feat

# R052-T002 - Ambient branch state

- [x] Findings: choose the injection point (UserPromptSubmit vs
  SessionStart plus a refresh) and size its per-turn context cost
  against R-050's budget concern; present the decision for approval
  and record it with the measurement in the findings file
- [x] The hook: emit current branch and working-tree state into the
  session at the chosen point, registered in `settings.json`, with a
  test that fails when the mechanism is removed; `DESIGN.md` tree-map
  and § Self-enforcement plus `README.md § Contents` in the same
  commit - one red-green commit
- [x] Ship it: `install-dev.sh` copies and registers the hook,
  `scripts/test/install-dev.test.sh` asserts the copied set,
  `README.md § Installing the toolset elsewhere` updated
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [ ] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
