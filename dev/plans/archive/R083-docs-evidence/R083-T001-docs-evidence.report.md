# R083-T001 report

## Implementer
### Divergences
- Item 1: the `verified` paragraph ("could have failed", the
  demonstration-vs-verification bar) is removed from `layout.md § Docs`
  with the rest of the paragraphs under the table; its content is item
  2's to state in `companions/documentation.md`, where a report records
  a run that could have failed.
- Item 2: the "inputs value-identical to the fallback demonstrate
  nothing" clause left the VERIFIED verdict bullet of § Verification
  gate; the Reports bullet of § Diataxis typing and the verdict bullet
  both cite `verification-policy.md § Verification modality` for a run
  that could have failed instead of restating it.
- Item 3: the `unverified` mark goes with `provenance` and
  `from-spec`, since the item bars any mark: `agents/dev-doc-writer.md`
  3-4 and `doc-writer-prompt.md`'s NEEDS_CONTEXT line now name an empty
  evidence cell, and its report line lists the rows left empty;
  `git grep -niE 'unverified' -- skills/ agents/ rules/` hit those two
  files before item 3 and neither after it.

## Answers
- Review 1: a claim outside § Parameters needs no evidence. Where a
  reference exists it is added; where none exists nothing is required,
  and the claim stands as written. UNPROVEN resolves to an empty cell
  for a § Parameters row and to nothing elsewhere.

## Review
- [x] UNPROVEN resolution is defined only for § Parameters rows; a
  README, CHANGELOG or § Behavior claim has no evidence cell and no end
  state (Important) - `skills/dev/companions/documentation.md:161`,
  `agents/dev-doc-writer.md:26`. Fix per Answers, Review 1.
  Evidence: contract `documentation.md § Verification gate` puts README
  and the CHANGELOG through the per-claim pass; requirements Constraints
  make references outside § Parameters optional.
- [x] The Reports bullet restates the verification policy's
  "value-identical to the fallback" rule instead of citing it
  (Important) - `skills/dev/companions/documentation.md:28`. Fix: end
  the sentence at "a run that could have failed
  (`verification-policy.md § Verification modality`)".
  Evidence: contract `MAINTENANCE.md § Tier-2 AI review` counts an echo
  of a rule's text as a restatement.
- [x] The three `## Implementer` entries are `- [ ]` checkboxes under
  the section head instead of plain bullets under `### Divergences`
  (Suggestion) - this report, lines 5-25. Fix: move them to the
  template form.
  Evidence: contract `skills/dev/branch-plan.md § Task report`.
