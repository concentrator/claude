# R-056 tasks - Settings tiering and session defaults

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R056-T###`, counter scoped to this initiative).

## Open

- [ ] **R056-T001 [mnt]**: migrate the durable rules - create tracked
  `.claude/settings.json` carrying the deny carve-out and the
  batch-push allow, add the `.gitignore` allowlist entry, and strip
  the migrated, shadowed, and one-shot entries from
  `settings.local.json`, leaving the model override.

- [ ] **R056-T002 [mnt]**: session default - set
  `"defaultMode": "acceptEdits"` in the tracked user-global
  `settings.json`.
