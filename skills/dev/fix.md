# Fixing a Bug

Iteration loop for one bug-fix task from its branch plan
(`.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md`).

## Iteration cadence (one commit per pass)

1. **Reproduce** - write a failing test that exhibits the bug. Run it; confirm it fails for the right reason.
2. **Diagnose** - root cause, not symptom. Invoke `systematic-debugging` if non-obvious.
3. **Fix** - minimal change to make the test pass.
4. **Verify** - run project's test + lint commands. Green.
5. **Docs** - per project `CLAUDE.md § Conventions`: if `release-routine: yes`, add `CHANGELOG.md ## [Unreleased]` entry; if fix changes documented behavior, update `README.md`; if `extended-docs: yes`, update per conventions. The feature's `.claude/docs/` doc is read at plan and reconciled at branch close (`branch-plan.md § Closing routine`), not per-commit.
6. **Commit** - single-line message. Mark `[x]` in branch plan immediately after committing.

## Scope discoveries

See `branch-plan.md` § Scope discoveries.

## Done?

If branch plan has open `[ ]` items, run cadence again for next commit.
Last non-final `[x]` → closing routine per `branch-plan.md`.
