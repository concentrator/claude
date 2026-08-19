---
approved: pending
kind: mnt
---

# R-056: Settings tiering and session defaults

## Current state

Durable repo-scoped permission rules live only in the gitignored
`.claude/settings.local.json`: the default-branch/force-push deny
carve-out and the batch-push allow vanish on a fresh clone, while the
tracked user-global `settings.json` allows `Bash(git:*)` - GitHub
branch protection is the only surviving backstop. The local file also
carries allows shadowed by that global rule. In the tracked
`settings.json`, `defaultMode` is `"default"`, so every session
starts by prompting for each edit, and `effortLevel` is `"high"`,
which every subagent inherits (effort has no per-dispatch override).

## Desired state

Rules live in the tier matching their lifetime: a tracked project
`.claude/settings.json` holds the durable repo-scoped rules (the deny
carve-out, the batch-push allow), with a `.gitignore` allowlist entry
making it trackable; `settings.local.json` keeps only the model
override and genuine one-offs. The tracked user-global `settings.json`
sets `defaultMode` to `"acceptEdits"` and `effortLevel` to
`"medium"`.

## Invariants

- Deny rules keep binding in every permission mode.
- Hook registrations and the context-budget keys in `settings.json`
  are untouched (`check-settings` stays green).
- `MAINTENANCE.md § Generalize allow rules` remains the owner of
  allowlist dedup; this initiative moves rules between tiers, the
  routine keeps them minimal.

## Scope

`settings.json` (user-global, the repo root), a new tracked
`.claude/settings.json` (project tier), `.gitignore`,
`.claude/settings.local.json`.

## Acceptance criteria

- [ ] A fresh clone carries the default-branch/force-push denies and
  the batch-push allow: they sit in tracked `.claude/settings.json`,
  and `git check-ignore .claude/settings.json` fails.
- [ ] `settings.local.json` holds only the model override and rules
  found in no tracked tier; every migrated or shadowed entry is gone.
- [ ] Tracked `settings.json` has `"defaultMode": "acceptEdits"` and
  `"effortLevel": "medium"`.
- [ ] All touched JSON parses (`jq .`) and `bash
  scripts/ci/run-all.sh` is green.

## Constraints

- Config moves only - no new gate, hook, or script (R-053: the
  observed failure is misplacement, the fix is placement).
- `settings.local.json` stays gitignored; only the project
  `.claude/settings.json` is unignored.

## Open questions

None.

## References

R-054 (pruned the local file; this moves what pruning kept);
`MAINTENANCE.md § Generalize allow rules`;
`skills/dev/companions/verification-policy.md` (effort is
session-level only).
