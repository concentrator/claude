# Checkpoint push + MR/PR mechanics

Read by `finish`, `auto`, and `declarations.md`. § State check applies
everywhere. § Push and the carve-out below are the auto-mode engine's
checkpoint-**accept** mechanics - the engine pushes at no other point
and never pushes the default branch. Manual `finish` pushes its own
branch (`finish.md § 3`). The `CLAUDE.md § Agent toolchain` keys these
mechanics consume - declared commands, artifacts root, supervisor
bounds - are defined in `declarations.md`.

## State check

MR/PR state (open / merged, checks / pipeline) is read via the declared
state-check command only - one structured call, never text-parsed host
output (`view | grep` pipelines). Canonical forms:

```
gh pr view <n> --json state,mergedAt,statusCheckRollup
# GitLab: glab mr view <iid> --output json
```

Both forms return state, merged-at, and checks/pipeline. The declared
command is the canonical form above - flag shapes like `--web` are
outside it. The view allows ship in `auto-permissions.template.json`.

## Push + MR/PR

```
git push -u origin batch/R<NNN>-B-XXX
gh pr create --head batch/R<NNN>-B-XXX --base <default> \
  --title "B-XXX: <batch theme>" --body-file <report excerpt>
# GitLab: glab mr create --source-branch batch/R<NNN>-B-XXX --target-branch <default> ...
```

MR/PR description: the report's header block, `## Batch review`, and
`## Judgment calls` sections - not the full per-branch detail (the
report file stays in the repo).

No VCS-host CLI in the project toolchain → push the branch, print the
creation URL/instructions for the user. Never silently skip the
push; deferring is an explicit user choice at the checkpoint.

## Permission carve-out for the checkpoint push

Adopter projects deny `Bash(git push:*)` to keep agents from pushing.
**Deny beats allow across all tiers** - an allow rule cannot override
it. Two working patterns:

1. **Narrow the deny** (recommended for recurring batch projects) - in
   the tracked project `.claude/settings.json`, so a fresh clone keeps
   it (`.claude/settings.local.json` only where the carve-out is
   deliberately machine-local):

   ```json
   "allow": ["Bash(git push -u origin batch/*)",
             "Bash(git push -u origin doc/*)",
             "Bash(git push -u origin feat/*)",
             "Bash(git push -u origin fix/*)",
             "Bash(git push -u origin refactor/*)",
             "Bash(git push -u origin mnt/*)",
             "Bash(git push -u origin test/*)",
             "Bash(git push -u origin plan/*)",
             "Bash(glab mr create:*)"],
   "deny":  ["Bash(git push origin <default>:*)", "Bash(git push --force:*)"]
   ```

   The deny shrinks from all-push to default-branch/force push; the
   allow covers the push of any task branch, not only a batch. Cover
   the prefixes the project actually uses (`git-workflow.md § Trunk`) -
   `batch/*` alone stalls every manual `/dev code` branch at push time,
   which is a prompt in the one place a supervised run cannot answer
   one.

2. **Keep the blanket deny** - checkpoint asks, the user approves the
   single `git push -u origin batch/R<NNN>-B-XXX` manually per batch.
   Zero config; one prompt per batch by design.

The pre-flight permission gate checks which pattern is in place and
reports it; it never weakens a deny rule on its own.
