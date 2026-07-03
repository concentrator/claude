# Doing a Refactor

Iteration for one refactor task from its branch plan
(`.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md`). Behavior preserved.

## Pre-requisite

Baseline tests green. If any fail before refactoring starts, fix that first as a separate task.

## Iteration cadence (one commit per pass)

1. **Safe step** — small, behavior-preserving change.
2. **Verify** — run project's test + lint commands. Green.
3. **DRY / purity check** — duplicated functionality removed? Side effects isolated?
4. **Docs** — per project `CLAUDE.md § Conventions`: if `release-routine: yes`, add `CHANGELOG.md ## [Unreleased]` entry (public-surface under existing kind headings; internal-only under `### Internal`); update `README.md` + extended docs only if surface changed.
5. **Commit** — single-line message. Mark `[x]` in branch plan immediately after committing.

If a step breaks tests and the fix isn't immediate, revert and try smaller.

## Scope discoveries

See `branch-plan.md` § Scope discoveries.

## Done?

If branch plan has open `[ ]` items, run cadence again for next commit.
Last non-final `[x]` → closing routine per `branch-plan.md`.
