# Documentation framework

The global convention for every doc - feature docs, specs, rules, knowledge
entries. Grounded in Diataxis (diataxis.fr). Prose style is `writing.md`
(always loaded); this file governs typing, structure, and content. Feature
docs (`.claude/docs/`) are its Reference application (`layout.md § Docs`).

## Diataxis typing

Every doc is exactly one of four types; never mix them in one file.

| Type | Answers | Shape |
|---|---|---|
| Tutorial | "teach me, start to finish" | Ordered lesson |
| How-to | "help me do X" | Goal-directed steps |
| Reference | "describe how X is" | Lookup, no procedures |
| Explanation | "help me understand X" | Discussion, background |

A spec or feature doc is a **Reference**: it describes how the subject *is*.
Procedures belong in a How-to; do not put steps in a Reference.

## Reference discipline

- **Describe, don't instruct.** State facts and structure, not actions.
- **Complete and accurate for its scope**, structured for lookup (tables,
  fixed section order).
- **Mirror reality.** Only verified facts (§ Evidence and provenance).
- **One doc per specific subject.** Narrow and 100% relevant beats broad
  and diluted; duplication across sibling docs is accepted.
- **Split by variant when the structure differs.** Two variants with
  genuinely different architecture get separate docs, not one doc
  straddling both with conditionals.

## Reference skeleton (fixed order)

| Section | Holds |
|---|---|
| 1. Overview | What the subject is and where it fits |
| 2. Model | Concept model + one diagram |
| 3. Elements | Table: element -> responsibility / definition |
| 4. Behavior | Runtime interactions, precedence, semantics |
| 5. Parameters | Table: name -> default -> meaning |
| 6. Reference data | Domain lookup tables (limits, fields, codes, paths) |
| 7. References | Cross-links to sibling docs |

Omit a section only when the subject genuinely has nothing for it.

## Detail bar

- Enumerate **every element of the subject** - parameter, input, field,
  option, endpoint, file - and define each: name, type/default, meaning.
- For each component, cover both its inputs (configuration, parameters)
  and its outputs (results, logs, errors).
- Never paste an artifact (config dump, schema, sample output) without
  explaining it.
- Include verbatim the defaults consumers commonly break, with a note on
  what depends on them.
- "Autodiscoverable" detail is not optional. Only genuinely hidden
  internals may be deferred to a subject-matter expert, and that deferral
  is stated in the doc.

## Diagrams

- Infrastructure: C4 model. Features: entity or flow diagram.
- Render inline (mermaid), in-repo; no external assets or hosted images.

## Formatting

Prose style per `writing.md`. Structure:

- Lookups and comparisons -> tables, not prose.
- Enumerations -> lists, never inline comma-runs.
- Steps -> numbered, imperative, deterministic; no "maybe / consider"
  without a decision rule.
- Fenced code blocks; uniform terminology throughout.

## Content quality

- **Self-sufficient**: everything needed to act, no live access or
  external search. Bar: a fresh reader with only this doc handles the
  hardest in-scope case.
- **Exact, not vague**: concrete values (versions, names, paths, limits);
  never "check the docs" in place of the fact.
- **Actionable over referential**: give the command or value, not a link
  to scrape.
- **Justify or drop**: each requirement states why, or is removed.
- **No dead ends**: no empty, stale, or broken links.
- **Right content, right place**: exclude test/environment artifacts;
  include the real parameters.
- **DRY**: a shared fact lives in one doc; others cross-reference it.

## Evidence and provenance

- Prefer verified-by-doing over cited-from-docs over inferred.
- A version- or environment-specific fact says which version or
  environment it was verified against.
- A recalled or documented fact that names a file, flag, or field is
  re-checked against the current system before it is relied on.
