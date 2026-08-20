---
approved: 2026-08-19
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
starts by prompting for each edit.

## Desired state

Durable rules live in one tracked project tier: `.claude/settings.json`
holds the deny carve-out, the batch-push allow, the durable tool-class
allows merged from the local file (gate runners, host auth, homebrew
reads, the code-review workflow and claude-api skill), and the model
override, with a `.gitignore` allowlist entry making it trackable.
`settings.local.json` is dropped; session approvals may recreate it,
and a regrown copy holds only entries found in no tracked tier until
the next prune. The tracked user-global `settings.json` sets
`defaultMode` to `"acceptEdits"`; `effortLevel` stays `"high"` -
review cost is handled by R-057's capped close review, not by
lowering session effort.

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
`.claude/settings.local.json` (merged and removed).

## Acceptance criteria

- [ ] A fresh clone carries the default-branch/force-push denies, the
  batch-push allow, the durable tool-class allows, and the model
  override: they sit in tracked `.claude/settings.json`, and
  `git check-ignore .claude/settings.json` fails.
- [ ] `.claude/settings.local.json` is gone; no tracked file and no
  surviving local tier duplicates a tracked rule.
- [ ] Tracked `settings.json` has `"defaultMode": "acceptEdits"`,
  `"effortLevel"` unchanged at `"high"`, and no `model` key - the
  override's one home is the project tier.
- [ ] All touched JSON parses (`jq .`) and `bash
  scripts/ci/run-all.sh` is green.

## Constraints

- Config moves only - no new gate, hook, or script (R-053: the
  observed failure is misplacement, the fix is placement).
- Only the project `.claude/settings.json` is unignored; `.claude/*`
  stays ignored, so a regrown `settings.local.json` never lands in a
  commit.

## Open questions

None.

## References

R-054 (pruned the local file; this moves what pruning kept);
R-057 (owns review cost); `MAINTENANCE.md § Generalize allow rules`.
