# R-052 tasks - Branch discipline and commit target resolution

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R052-T###`, counter scoped to this initiative).

## Open

- [ ] **R052-T001 [fix]**: commit-path target resolution - settle which
  signal marks a repo as non-project work against the command shapes
  that actually occur, implement it in `hooks/dev-branch-guard.sh`, add
  guard cases proved to fail against the pre-fix hook, and correct the
  header's stated resolution rule.
- [ ] **R052-T002 [feat]**: ambient branch state - a hook putting the
  current branch and working-tree state in front of every session in
  both modes, its per-turn context cost sized against R-050's budget.
- [ ] **R052-T003 [doc]**: the DEV planning flow creates its branch
  before its first artifact write - the sequence stated where the flow
  acts, not only where the rule lives. DEV-scoped: VIBE carries no new
  rule.
