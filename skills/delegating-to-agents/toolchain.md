# Checkpoint push + MR/PR mechanics

Referenced from SKILL.md. Applies only at checkpoint **accept** —
nothing pushes mid-batch, and the default branch is never pushed by
the engine.

## Push + MR/PR

```
git push -u origin batch/B-XXX
gh pr create --head batch/B-XXX --base <default> \
  --title "B-XXX: <batch theme>" --body-file <report excerpt>
# GitLab: glab mr create --source-branch batch/B-XXX --target-branch <default> ...
```

MR/PR description: the report's header block, `## Batch review`, and
`## Judgment calls` sections — not the full per-branch detail (the
report file stays in the repo).

No VCS-host CLI in the project toolchain → push the branch, print the
creation URL/instructions for the user. Never silently skip the
push; deferring is an explicit user choice at the checkpoint.

## Permission carve-out for the checkpoint push

Adopter projects deny `Bash(git push:*)` to keep agents from pushing.
**Deny beats allow across all tiers** — an allow rule cannot override
it. Two working patterns:

1. **Narrow the deny** (recommended for recurring batch projects) — in
   `.claude/settings.local.json`:

   ```json
   "allow": ["Bash(git push -u origin batch/*)", "Bash(glab mr create:*)"],
   "deny":  ["Bash(git push origin <default>:*)", "Bash(git push --force:*)"]
   ```

   The deny shrinks from all-push to default-branch/force push; the
   allow covers exactly the checkpoint command.

2. **Keep the blanket deny** — checkpoint asks, the user approves the
   single `git push -u origin batch/B-XXX` manually per batch. Zero
   config; one prompt per batch by design.

The pre-flight permission gate checks which pattern is in place and
reports it; it never weakens a deny rule on its own.
