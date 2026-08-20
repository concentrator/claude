# R-056 tasks - Settings tiering and session defaults

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R056-T###`, counter scoped to this initiative).

## Open

- [ ] **R056-T001 [mnt]**: migrate the durable rules - create tracked
  `.claude/settings.json` carrying the deny carve-out, the batch-push
  allow, the durable tool-class allows, and the model override; add
  the `.gitignore` allowlist entry; drop `settings.local.json`, its
  one-shot entries with it.

- [ ] **R056-T002 [mnt]**: session default - set
  `"defaultMode": "acceptEdits"` in the tracked user-global
  `settings.json`.
