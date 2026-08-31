# Documentation framework

The global convention for every doc - feature docs, specs, rules, knowledge
entries. Grounded in Diataxis (diataxis.fr). Prose style is `writing.md`
(always loaded); this file governs typing, structure, and content. Feature
docs (`dev/docs/`) are its Reference application
(`layout.md § Docs`).

## Diataxis typing

Every doc is exactly one of these types; never mix them in one file.

| Type | Answers | Shape |
|---|---|---|
| Tutorial | "teach me, start to finish" | Ordered lesson |
| How-to | "help me do X" | Goal-directed steps |
| Reference | "describe how X is" | Lookup, no procedures |
| Explanation | "help me understand X" | Discussion, background |

A spec or feature doc is a **Reference**: it describes how the subject *is*.
Procedures belong in a How-to; do not put steps in a Reference.

Two further types live in their own subdirectories of the docs tree
(`layout.md § Docs`):

- **Reports** (`docs/reports/`): probe and test reports - executed
  calls with their outputs, attached as evidence. The one docs
  location where datetimes and tenant or client ids are allowed.
  Feature docs link them plainly; a report is useful, never required -
  the doc itself states facts without proving them.
- **Adapted references** (`docs/references/`): external or codebase
  material rewritten to project format, carrying exactly what the
  docs need; a source URL is allowed inside.

## Reference discipline

- **Describe, don't instruct.** State facts and structure, not actions.
- **Complete and accurate for its scope**, structured for lookup (tables,
  fixed section order).
- **Mirror reality.** Only verified facts (§ Verification gate).
- **One doc per specific subject.** Narrow and 100% relevant beats broad
  and diluted; a variant split may repeat structure, but a shared fact
  still lives in one doc (§ Content quality).
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
| 7. References | Sibling docs, report docs, and adapted references |

Omit a section only when the subject genuinely has nothing for it.
Tiebreak: a flag or field is a Parameter; the component it configures is
an Element.

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

- C4 model for infrastructure and system context; otherwise an entity
  diagram when the subject is state and relationships, a flow diagram
  when it is a process, both when genuinely both.
- Render inline (mermaid), in-repo; no external assets or hosted images.

## Formatting

- Lookups and comparisons -> tables, not prose.
- Enumerations -> lists, never inline comma-runs.
- Steps (Tutorials / How-tos) -> numbered, imperative, deterministic; no
  "maybe / consider" without a decision rule.
- Fenced code blocks; uniform terminology throughout.

## Content quality

- **Self-sufficient**: everything needed to act, no live access or
  external search. Bar: a fresh reader with only this doc handles the
  hardest in-scope case.
- **Exact, not vague**: concrete values (versions, names, paths,
  limits) - identities and constraints; derived tallies per
  `rules/writing-artifacts.md § One home per number`. Never "check the docs" in place
  of the fact.
- **Actionable over referential**: give the command or value, not a link
  to scrape.
- **Justify or drop**: each requirement states why, or is removed.
- **No dead ends**: no empty, stale, or broken links.
- **Snapshot, not history**: a doc states the subject's current
  behavior only - no development chronology, task or plan ids, round
  dates, or development details. Git holds history and plans hold
  planning; a provenance mark (`layout.md § Docs`) is a state fact
  about claim strength and stays, dateless.
- **Closed link scope**: a doc links only sibling documents inside
  the docs tree or external URLs - never plan files (live or
  archived), findings files, or `.claude/` paths. The docs gate
  fails a doc referencing `dev/plans/`, `.claude/`, or a non-URL
  path outside the docs tree.
- **Right content, right place**: exclude test/environment artifacts;
  include the real parameters.
- **DRY**: a shared fact lives in one doc; others cross-reference it
  (numbers especially - `rules/writing-artifacts.md § One home per number`).
- **Real examples**: an example is an executed call or case shown with its
  output, cited when kept - as a report doc (§ Diataxis typing);
  secrets as placeholders; never invented. It sits in the section it
  illustrates.

## Verification gate

No new or touched doc is complete until an **independent agent** - never
the author -
has verified the claims in scope against ground truth: the live system
for observable facts, the authoritative source (source code, `--help`,
config files, vendor docs) otherwise. The verifier is a subagent the
session dispatches without pausing to confirm - a doc the author also
verified is unverified - bounded by `verification-policy.md § Verifier
isolation`. The prose class sets the scope
and the clearing review: rules, skills, and planning prose - the
changed claims, checked against their sources by the close review
(`branch-plan.md § Closing routine`; reviewer mandate:
`agents/code-reviewer.md`; auto mode: the batch-close full-diff pass);
`dev/docs/` feature docs - every claim, via the dedicated per-claim pass:

- Read the doc's `§ Parameters` preamble before its table. The
  provenance definitions are `layout.md § Docs`'s and a doc may not
  restate or narrow them: one that does has rewritten the standard it
  is judged against and is WRONG at the preamble before any cell is
  checked.
- Per-claim verdict: **VERIFIED** (confirmed live), **DOCS**
  (authoritative source cited), **WRONG**, or **UNPROVEN**. A claim with
  no evidence is UNPROVEN, never VERIFIED. VERIFIED needs a run that
  could have failed: inputs value-identical to the fallback demonstrate
  nothing (`verification-policy.md § Verification modality`).
- Every WRONG is corrected before completion.
- Every UNPROVEN is resolved to VERIFIED/DOCS, or explicitly marked in
  the doc as unverified / expert-needed - never asserted as fact.
- A claim that cannot be independently checked is UNPROVEN; split a large
  doc across parallel reviewers by section (`dispatching-parallel-agents`).
- Comprehension pass, same reviewer: answer from the doc alone - what is
  ambiguous, what context does the doc assume the reader already has,
  and where does it contradict itself. Findings are fixed like WRONG
  claims: the verdicts check that the doc is true, this checks that it
  is usable cold.

A feature doc's pass covers the doc, never the diff: a claim's source
can change under a line no branch touches.

Either path is artifact-free: version-control history records that the
review ran; no separate stamp or ledger is kept.

## Evidence and provenance

- Prefer verified-by-doing over cited-from-docs over inferred.
- A version- or environment-specific fact says which version or
  environment it was verified against - as a provenance mark or in a
  report doc (§ Diataxis typing), never as inline chronology.
- A recalled or documented fact that names a file, flag, or field is
  re-checked against the current system before it is relied on.
