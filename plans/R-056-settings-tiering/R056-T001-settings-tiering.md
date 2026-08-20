task: R056-T001
type: mnt

# R056-T001 - Migrate the durable rules

- [x] Create the tracked project tier: `.claude/settings.json` holding
  the default-branch/force-push denies, the batch-push allow, the
  durable tool-class allows merged from `.claude/settings.local.json`
  (gate runners, host auth, homebrew reads, the code-review workflow
  and claude-api skill), and the model override; narrow the
  `.gitignore` `.claude/` entry to `.claude/*` plus
  `!.claude/settings.json` so the file is trackable
  (`git check-ignore .claude/settings.json` fails); delete
  `.claude/settings.local.json` and drop the `model` key from the
  user-global `settings.json` working tree (both gitignored or
  no-diff moves - the commit message records them); `DESIGN.md`
  tree-map gains the new file in the same commit
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [ ] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
