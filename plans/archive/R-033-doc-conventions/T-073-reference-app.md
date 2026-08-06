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

- [x] `layout.md § Docs`: the feature-doc template becomes the framework's Reference skeleton; the R-032 detail bar folds into the generalized detail bar; point to `companions/documentation.md`. Remove content now duplicated by the companion.
- [x] Close the T-071 verify gaps in `companions/documentation.md`: state the Elements vs Parameters tiebreak (Elements = components, Parameters = the subject's knobs/inputs), give a decision rule for entity vs flow diagrams, and scope § Formatting as spanning all four Diataxis types (its step rules apply to How-to/Tutorial, not Reference).
- [x] `companions/docs-adoption.md`: the audit grades **convention-conformance** (Diataxis type + skeleton + detail bar) as well as code-drift - a doc built to a prior convention is WARN, a re-align candidate; the build/refresh produces to the framework and completes through the verification gate (T-072).
- [x] `docs.md` (`/dev docs`): surface the align-existing offer - on a project with docs under a prior convention, offer to restructure them to the framework and re-verify; reconcile the wording with the framework (no stale references to the old template).
- [x] Close-review fix: dedupe the docs pipeline - the align offer lives in `docs-adoption.md § Build`, callers keep bare stage names; fix the supersedes-vs-raises contradiction.
- [x] Close-review fix: single-home pointers - drop the grown enumeration, duplicate lead-in, diagram-rule copy, and the coined "provenance ladder"; move the real-examples rule into the framework's content-quality bar.
- [x] Close-review fix: scope the Steps formatting rule inline (Tutorials / How-tos), de-scope the diagram rule from "Features:", shorten the Elements/Parameters tiebreak.
- [x] Complete the branch: re-review docs across all commits, cleanup, mark plan complete, commit.
