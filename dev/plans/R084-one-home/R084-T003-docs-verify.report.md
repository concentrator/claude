# R084-T003 report

## Implementer
### Divergences
- Item 1: the Snapshot bullet names the doc writer's report as where
  sources live, beside git and plans, rather than only dropping the
  evidence-reference clause, so the bullet still says where each kind
  of non-doc content goes.
- Item 1: the evidence pointers inside later items' sections stay as
  they are until those items rewrite them: `documentation.md
  § Verification gate` and `verification-policy.md § Verification
  modality` (item 2), `agents/dev-doc-writer.md` steps 3 and 4 and
  `companions/doc-writer-prompt.md` (item 3).
- Item 2: the coherence check folds the old comprehension pass's
  question of assumed context into ambiguity to a reader holding only
  the text, keeping the item's two named concerns.
- Item 2: the gate states only that every listed mismatch is fixed; how
  a non-empty list is worked stays with `run.md § Close` 3, which
  item 4 rewrites.
- Item 3: a re-dispatch entry that still has no source stays listed in
  the writer's report, the doc unmarked; this carries over the retired
  rule that such a claim stood as written with an empty cell, since the
  item names no other outcome for it.
- Item 3: the prompt's Exit says the verifier checks each claim against
  the source the report names, citing `documentation.md § Verification
  gate` check 1, so the writer knows why its report must name sources.
- Item 4: `run.md § Close` 3 keeps the existing rule that the re-dispatch
  result goes to the user with the list, as it went with the verdicts,
  and its ledger verify entry now carries the mismatch list.
- Item 5: the prose class drops the clause that the gate's
  source-selection and independence conditions apply, since the gate's
  checks now carry the source rule, and names the docs verifier as the
  seat for `<docs>`, `README.md` and the CHANGELOG entry in place of the
  per-claim pass.
- Item 5: the search's remaining hits outside `dev/plans/` are ordinary
  English on other subjects and stay: "verdict" for the closure check in
  `run.md § Close` 4 and `branch-plan.md § Closing routine` 7, for CI and
  guard results in `scripts/`, and in `worker-host/companions/pitfalls.md`;
  "WRONG:" as an example label in `skills/receiving-code-review/SKILL.md`.

### Findings
- [ ] The code reviewer's doc-only class checks changed claims "against
  the sources the doc cites", while `documentation.md § Sources` puts a
  doc's sources in the doc writer's report and none in the doc.
  Evidence: contract `skills/dev/companions/documentation.md § Sources`
  against `agents/code-reviewer.md` Rubric, Doc-only

## Review
