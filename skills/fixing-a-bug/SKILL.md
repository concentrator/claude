---
name: fixing-a-bug
description: Use when fixing a bug from a planned task in the current branch.
---

# Fixing a Bug

Iteration loop for one bug-fix task from `.claude/plans/<slug>.md`.

## Iteration cadence (one commit per pass)

1. **Reproduce** — write a failing test that exhibits the bug. Run it; confirm it fails for the right reason.
2. **Diagnose** — root cause, not symptom. Invoke `systematic-debugging` if non-obvious.
3. **Fix** — minimal change to make the test pass.
4. **Verify** — run project's test + lint commands. Green.
5. **Docs** — minimum: `CHANGELOG.md ## [Unreleased]` entry. README update if fix changes documented behavior. Additional surfaces per project conventions.
6. **Commit** — single-line message. Mark `[x]` in branch plan immediately after committing.

## Scope discovery

If you find a related defect mid-fix, propose a plan edit before continuing. Don't expand scope silently.

## Done?

If branch plan has open `[ ]` items, run cadence again for next commit.
Branch plan all `[x]` → `/dev finish`.
