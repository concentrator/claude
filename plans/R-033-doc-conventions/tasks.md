# R-033 tasks

Tasks for R-033 (`plans/R-033-doc-conventions/requirements.md`) - adopt the
Diataxis documentation framework globally, with the feature-docs layer as its
Reference application and the verification gate as the docs completion gate.
Format per `skills/dev/plan.md § Levels`.

- [x] T-071 (R-033) [feat]: the global documentation convention - generalized Diataxis framework (typing, reference discipline, Reference skeleton, generalized detail bar, diagrams, content quality, provenance; formatting defers to `writing.md`); absorb + remove the loose `plans/documentation-conventions.md`
- [x] T-072 (R-033) [feat]: the verification gate - independent-agent per-claim verification (VERIFIED/DOCS/WRONG/UNPROVEN, no self-certify, UNPROVEN handling, parallel split), wired as the docs completion gate in the closing routine, `/dev docs`, and `migrate` (depends-on T-071)
- [ ] T-073 (R-033) [refactor]: rework the feature-docs layer as the Reference application - `layout.md § Docs` (skeleton + folded detail bar), `companions/docs-adoption.md`, `docs.md`; reconcile R-032 (depends-on T-071, T-072)
