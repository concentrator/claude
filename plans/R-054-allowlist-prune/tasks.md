# R-054 tasks - Prune the local permission allowlist

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R054-T###`, counter scoped to this initiative).

## Open

- [x] **R054-T001 [mnt]**: prune `.claude/settings.local.json` to the
  durable classes per the acceptance criteria; verify the deny block
  and model override survive byte-identical and the file parses.
