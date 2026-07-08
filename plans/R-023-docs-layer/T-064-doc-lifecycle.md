task: T-064
type: feat
depends-on: T-063

# feat/doc-lifecycle - read at plan, reconcile at close (R-023)

T-064 of `plans/R-023-docs-layer/`. Wire the doc lifecycle into DEV: read the
relevant `.claude/docs/` at plan time, and a hard reconcile at branch close
(a new feature writes the doc for what shipped; a fix/refactor reconciles the
existing doc). TDD stays the code-level spec - the doc is not written before
each code piece. Depends on T-063 (the artifact + template must exist).

Acceptance criteria: see `requirements.md` (planning reads the docs; the
closing routine writes/reconciles the feature doc to match shipped code as a
hard step; the mode files note the read-at-plan / reconcile-at-close model).

- [x] Read at plan: add "read the feature's `.claude/docs/`" to planning inputs - `write-plan.md § Inputs` and the `/dev code` pre-flight (`branch-plan.md`) - so a change is planned against the current doc.
- [x] Reconcile at close: add a hard step to `branch-plan.md § Closing routine` - write (new feature) or reconcile (fix/refactor) the feature doc so it matches shipped code, before the merge options.
- [x] Note the model in the execution mode files: `feat.md`/`fix.md`/`refactor.md` "Docs" step states docs are read at plan and written/reconciled at close, not per-commit.
- [x] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
