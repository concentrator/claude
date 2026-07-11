task: T-073
type: refactor
depends-on: T-071, T-072

# refactor/reference-app - fold the feature-docs layer into the framework (R-033)

T-073 of `plans/R-033-doc-conventions/`. Rework the existing feature-docs
layer (R-023/030/031/032) as the Reference application of the framework: the
template becomes the Reference skeleton, the audit grades convention-
conformance + code-drift, and `/dev docs` offers to align old-convention
docs. Behavior generalizes; no duplicate or contradictory convention remains.
Depends on T-071 (framework) and T-072 (gate).

Acceptance criteria: see `requirements.md` (feature-docs layer reworked as
the Reference application; audit grades convention-conformance so
old-convention docs are WARN and offered for alignment + re-verification; no
duplicate convention).

- [ ] `layout.md § Docs`: the feature-doc template becomes the framework's Reference skeleton; the R-032 detail bar folds into the generalized detail bar; point to `companions/documentation.md`. Remove content now duplicated by the companion.
- [ ] `companions/docs-adoption.md`: the audit grades **convention-conformance** (Diataxis type + skeleton + detail bar) as well as code-drift - a doc built to a prior convention is WARN, a re-align candidate; the build/refresh produces to the framework and completes through the verification gate (T-072).
- [ ] `docs.md` (`/dev docs`): surface the align-existing offer - on a project with docs under a prior convention, offer to restructure them to the framework and re-verify; reconcile the wording with the framework (no stale references to the old template).
- [ ] Complete the branch: re-review docs across all commits, cleanup, mark plan complete, commit.
