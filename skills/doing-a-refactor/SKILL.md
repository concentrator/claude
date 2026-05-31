---
name: doing-a-refactor
description: Use when refactoring without behavior change in current branch.
---

# Doing a Refactor

Iteration for one refactor task from `.claude/plans/<slug>.md`. Behavior preserved.

## Pre-requisite

Baseline tests green. If any fail before refactoring starts, fix that first as a separate task.

## Iteration cadence (one commit per pass)

1. **Safe step** — small, behavior-preserving change.
2. **Verify** — run project's test + lint commands. Green.
3. **DRY / purity check** — duplicated functionality removed? Side effects isolated?
4. **Docs** — minimum: `CHANGELOG.md ## [Unreleased]` entry. Public-surface changes go under existing kind headings; internal-only refactors go under `### Internal`. README + extended docs only if surface changed.
5. **Commit** — single-line message. Mark `[x]` in branch plan immediately after committing.

If a step breaks tests and the fix isn't immediate, revert and try smaller.

## Scope discovery

If a refactor reveals a defect, surface it — do not fix it in this task. Add to plan separately.

## Done?

If branch plan has open `[ ]` items, run cadence again for next commit.
Branch plan all `[x]` → `/dev finish`.
