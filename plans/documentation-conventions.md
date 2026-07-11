# Documentation conventions

Applies to every reference document, technical spec, and knowledge entry.
The goal is a document an agent or engineer can act on with no live access
and no external search.

## 1. Framework: Diátaxis

Every doc is exactly one of four types; never mix them in one file.

| Type | Answers | Shape |
|---|---|---|
| Tutorial | "teach me, start to finish" | Ordered lesson |
| How-to | "help me do X" | Goal-directed steps |
| Reference | "describe how X is" | Lookup, no procedures |
| Explanation | "help me understand X" | Discussion, background |

A spec is a **Reference** doc: it describes how the subject *is*. Procedures
belong in the How-to; do not put steps in a Reference.

## 2. Reference discipline

- **Describe, don't instruct.** State facts and structure, not actions.
- **Complete and accurate for its scope**, structured for lookup (tables,
  fixed section order).
- **Mirror reality.** Only verified facts (see the verification gate below).
- **One doc per specific subject.** Narrow and 100% relevant beats broad and
  diluted; duplication across sibling docs is accepted.
- **Split by variant when the structure differs.** If two versions or
  variants have genuinely different architecture, they get separate docs, not
  one doc straddling both with conditionals.

## 3. Reference skeleton (fixed order)

| Section | Holds |
|---|---|
| 1. Overview | What the subject is and where it fits |
| 2. Model | Concept model + one diagram |
| 3. Elements | Table: element -> responsibility / definition |
| 4. Behavior | Runtime interactions, precedence, semantics |
| 5. Parameters | Table: name -> default -> meaning |
| 6. Reference data | Domain lookup tables (ports, files, limits, fields) |
| 7. References | Cross-links to sibling docs |

## 4. Detail bar

- For each component, locate and analyse its configuration **and** its logs.
- For each config file, **define every parameter**: name, default, meaning.
  Never paste a config dump without explaining it.
- Include the default snippets that consumers commonly break, verbatim, with a
  note on what depends on them.
- "Autodiscoverable" detail is not optional. Only genuinely hidden internals
  may be deferred to a subject-matter expert, and that deferral is stated.

## 5. Diagrams

- Infrastructure: C4 model. Features: entity or flow diagram.
- Render inline (e.g. mermaid), in-repo, no external assets or hosted images.

## 6. Formatting

- Lookups and comparisons -> **tables**, not prose.
- Enumerations -> **lists**, never inline comma-runs.
- Steps -> **numbered, imperative, deterministic**; no "maybe / consider"
  without a decision rule.
- Fenced code blocks; uniform terminology; tidy spacing.
- No em dashes (use hyphens). No AI-tell words ("delve", "leverage",
  "seamless", "robust", "comprehensive", "streamline"). No filler.
- No repetition: do not restate a point already made in the same document.

## 7. Content quality

- **Self-sufficient**: everything needed to act, no external search. Bar: a
  fresh reader with only this doc handles the hardest in-scope case.
- **Exact, not vague**: concrete values (versions, names, paths, limits).
  Never "check the docs / the console" in place of the fact.
- **Actionable over referential**: give the command or value, not a link to
  scrape.
- **Justify or drop**: each requirement states why, or is removed.
- **No dead ends**: no empty, stale, or broken links.
- **Right content, right place**: exclude test/environment artifacts; include
  the real parameters.
- **DRY**: a shared fact lives in one doc; others cross-reference it.

## 8. Verification gate (before "complete")

No document is complete until an **independent agent** has verified every
factual claim against ground truth: the live system for observable facts, the
authoritative source (source code, `--help`, config files, vendor docs)
otherwise. The author does not self-certify; the reviewer is a separate agent
with access to ground truth.

- The review emits a per-claim verdict: **VERIFIED** (confirmed live),
  **DOCS** (authoritative source cited), **WRONG**, or **UNPROVEN**. A claim
  with no evidence is UNPROVEN, never VERIFIED.
- Every **WRONG** is corrected before completion.
- Every **UNPROVEN** is either resolved to VERIFIED/DOCS, or explicitly marked
  in the document as unverified / expert-needed. It is never asserted as fact.
- Scope the review to what is independently checkable; split a large document
  across reviewers by section and run them in parallel.
- The version-control history records that the audit happened; no separate
  artifact is retained.

## 9. Evidence and provenance

- Prefer verified-by-doing over cited-from-docs over inferred.
- When a fact is version- or environment-specific, say which version or
  environment it was verified against.
- A recalled or documented fact that names a file, flag, or field is
  re-checked against the current system before it is relied on.
