---
name: adding-a-feature
description: Use when implementing a feature task via strict TDD.
---

# Adding a Feature

Strict TDD iteration for one feature task from `.claude/plans/<slug>.md`.

## Iteration cadence (one commit per pass — red → green → refactor)

1. **Red** — write a failing test for the next behavior slice. Run it; confirm it fails for the right reason.
2. **Green** — minimal implementation to make the test pass.
3. **Refactor** — clean up code and tests; coverage stays green.
4. **Verify** — run project's test + lint commands. Green.
5. **Docs** — per project `CLAUDE.md § Conventions`: if `release-routine: yes`, add `CHANGELOG.md ## [Unreleased]` entry; if change exposes new public surface, update `README.md`; if `extended-docs: yes`, update per conventions. Update in *this* commit, not later.
6. **Commit** — single-line message. Mark `[x]` in branch plan immediately after committing.

## Code reuse

Before writing new helpers, grep for existing functions with the same purpose.

## Scope discoveries

See `~/.claude/rules/branch-plan.md` § Scope discoveries.

## Done?

If branch plan has open `[ ]` items, run cadence again for next commit.
Last non-final `[x]` → closing routine per `~/.claude/rules/branch-plan.md`.
