task: T-071
type: feat

# feat/doc-framework - the global Diataxis documentation convention (R-033)

T-071 of `plans/R-033-doc-conventions/`. Create the generalized documentation
framework as an on-demand companion, referenced from `layout.md § Docs`, and
absorb the loose source. Settled: home is `companions/documentation.md`;
formatting defers to `writing.md`. The verification gate is T-072.

Acceptance criteria: see `requirements.md` (global convention exists -
Diataxis typing, reference discipline, skeleton, generalized detail bar,
diagrams, content quality, provenance; formatting -> `writing.md`; ships to
adopters).

- [x] Create `skills/dev/companions/documentation.md`: Diataxis typing (one of tutorial / how-to / reference / explanation, never mixed), reference discipline, the fixed Reference skeleton, the detail bar generalized to any subject's elements/parameters (not just config/logs/ports), diagrams (C4 for infra, entity/flow for features; inline mermaid, no external assets), the content-quality bar, and the provenance ladder. Formatting: reference `writing.md`, do not restate the em-dash / AI-tell / no-repetition rules.
- [x] Reference the framework from `layout.md § Docs`: feature docs are its Reference application; keep `layout.md` within its cap (move depth to the companion).
- [x] Remove `plans/documentation-conventions.md` (absorbed); check no reference to it dangles.
- [x] Close-review fix: drop the companion's mispointing cross-reference and repeated `writing.md` delegation.
- [x] Close-review fix: state in `layout.md § Docs` that the template below stays the feature-doc skeleton (T-073 folds it).
- [x] Close-review fix: repoint plan-set references to the absorbed source (`requirements.md`, T-072, ROADMAP).
- [x] Record the live-verify gaps (Elements/Parameters tiebreak, entity-vs-flow rule, Formatting scope) as a T-073 plan item.
- [x] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
