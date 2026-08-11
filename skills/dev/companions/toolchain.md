# Checkpoint push + MR/PR mechanics

Referenced from SKILL.md and `finish`. § Declared commands,
§ Artifacts root, and § State check apply everywhere; § Push and the
carve-out below apply only at checkpoint **accept** - nothing pushes
mid-batch, and the default branch is never pushed by the engine.

## Declared commands (`## Agent toolchain`)

A project's `CLAUDE.md` declares its routine commands in an `## Agent
toolchain` section - the VCS host (→ `gh`/`glab`) and the exact
change-request / merge / state-check / test / lint / build commands. It
is the single source both modes read:

- `/dev auto` uses it for `permissions.allow` (the pre-flight gate below).
- Manual `finish` runs the declared commands instead of probing the host.

Declare it once; `migrate` backfills it if absent (absent-host fallback:
`finish § 3`).

## Artifacts root (`## Agent toolchain`)

The same section declares where DEV artifacts live, as a
repo-relative directory on its own line:

```
- DEV artifacts root: <dir>/
```

Resolution, including the absent-declaration default, lives in
`plan.md § Where things live`; `layout.md` draws the config and
artifacts trees.

## Supervisor bounds (`## Agent toolchain`)

A project delegating delivery to a supervisor (R-040) declares its
bounds in the same `## Agent toolchain` section - the single home for
merge authority:

```
- Supervisor bounds: batch-scoped delivery; instructions: .claude/supervisor.md
```

No declaration = a read-only supervisor: it reports and escalates,
merges nothing. The default grant, **batch-scoped delivery**, allows
exactly two merge classes:

- green `plan/` MR/PRs;
- green batch/member MR/PRs whose checkpoint report verifies the
  task's acceptance criteria - the approved plan is the decision, the
  supervisor automates its delivery.

Always escalated, under any grant: releases; changes to `CLAUDE.md`,
`rules/`, or `skills/`; red gates; off-plan work. Host gates
(protected trunk, required checks) stay the hard floor - no admin
merges.

Operating instructions beyond authority - project quirks, escalation
additions, never-touch areas - live in the optional
`.claude/supervisor.md` the declaration references; authority never
moves there.

**Merge signature.** Every supervisor merge carries a `supervised`
label plus a merge comment naming the bound applied - host metadata
only, never commit or MR/PR prose (`git-workflow.md § MR/PR messages`
governs prose and is unchanged by supervision).

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
git push -u origin batch/B-XXX
gh pr create --head batch/B-XXX --base <default> \
  --title "B-XXX: <batch theme>" --body-file <report excerpt>
# GitLab: glab mr create --source-branch batch/B-XXX --target-branch <default> ...
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
   `.claude/settings.local.json`:

   ```json
   "allow": ["Bash(git push -u origin batch/*)", "Bash(glab mr create:*)"],
   "deny":  ["Bash(git push origin <default>:*)", "Bash(git push --force:*)"]
   ```

   The deny shrinks from all-push to default-branch/force push; the
   allow covers exactly the checkpoint command.

2. **Keep the blanket deny** - checkpoint asks, the user approves the
   single `git push -u origin batch/B-XXX` manually per batch. Zero
   config; one prompt per batch by design.

The pre-flight permission gate checks which pattern is in place and
reports it; it never weakens a deny rule on its own.
