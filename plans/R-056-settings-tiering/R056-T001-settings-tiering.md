task: R056-T001
type: mnt

# R056-T001 - Migrate the durable rules

- [ ] Create the tracked project tier: `.claude/settings.json` holding
  the default-branch/force-push denies and the batch-push allow;
  narrow the `.gitignore` `.claude/` entry to `.claude/*` plus
  `!.claude/settings.json` so the file is trackable
  (`git check-ignore .claude/settings.json` fails); strip the
  migrated and shadowed entries from `.claude/settings.local.json`
  (gitignored - the strip has no diff, so the commit message records
  it), leaving the model override and the rules no tracked tier
  carries; `DESIGN.md` tree-map gains the new file in the same commit
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [ ] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
