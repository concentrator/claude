task: T-071
type: feat

# feat/doc-framework - the global Diataxis documentation convention (R-033)

T-071 of `plans/R-033-doc-conventions/`. Create the generalized documentation
framework as an on-demand companion, referenced from `layout.md § Docs`, and
absorb the loose source. Settled: home is `companions/documentation.md`;
formatting defers to `writing.md`. The verification gate (section 8) is T-072.

Acceptance criteria: see `requirements.md` (global convention exists -
Diataxis typing, reference discipline, skeleton, generalized detail bar,
diagrams, content quality, provenance; formatting -> `writing.md`; ships to
adopters).

- [ ] Create `skills/dev/companions/documentation.md`: Diataxis typing (one of tutorial / how-to / reference / explanation, never mixed), reference discipline, the fixed Reference skeleton, the detail bar generalized to any subject's elements/parameters (not just config/logs/ports), diagrams (C4 for infra, entity/flow for features; inline mermaid, no external assets), the content-quality bar, and the provenance ladder. Formatting: reference `writing.md`, do not restate the em-dash / AI-tell / no-repetition rules.
- [ ] Reference the framework from `layout.md § Docs`: feature docs are its Reference application; keep `layout.md` within its cap (move depth to the companion).
- [ ] Remove `plans/documentation-conventions.md` (absorbed); check no reference to it dangles.
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
