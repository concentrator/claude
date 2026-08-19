# R055-T001 findings

- [x] (promoted to R057-T001) The close-review agent, dispatched for
  a read-only review,
  ran `git checkout main` and switched the session working tree
  mid-review (recovered without loss). The reviewer constraints
  R057-T001 adds to `agents/code-reviewer.md` must cover read-only
  conduct - no branch switching, no writes - not only the
  no-subagents rule.
