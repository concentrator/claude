# R083-T001 report

## Implementer

- [ ] Item 1: the `verified` paragraph ("could have failed", the
  demonstration-vs-verification bar) is removed from `layout.md § Docs`
  with the rest of the paragraphs under the table; its content is item
  2's to state in `companions/documentation.md`, where a report records
  a run that could have failed.
  Evidence: contract plan item 2 text; `skills/dev/layout.md § Docs`
  after this commit.
- [ ] Item 2: the "inputs value-identical to the fallback demonstrate
  nothing" clause moved from the VERIFIED verdict bullet of
  § Verification gate into the Reports bullet of § Diataxis typing,
  where a report's run that could have failed is defined; the verdict
  bullet keeps "a run that could have failed" and its
  `verification-policy.md § Verification modality` citation.
  Evidence: observed `skills/dev/companions/documentation.md
  § Diataxis typing` and `§ Verification gate` after this commit.
- [ ] Item 3: the `unverified` mark goes with `provenance` and
  `from-spec`, since the item bars any mark: `agents/dev-doc-writer.md`
  3-4 and `doc-writer-prompt.md`'s NEEDS_CONTEXT line now name an empty
  evidence cell, and its report line lists the rows left empty.
  Evidence: observed `git grep -niE 'unverified' -- skills/ agents/
  rules/` before this commit hit those two files; after it, neither.

## Answers
- Review 1: a claim outside § Parameters needs no evidence. Where a
  reference exists it is added; where none exists nothing is required,
  and the claim stands as written. UNPROVEN resolves to an empty cell
  for a § Parameters row and to nothing elsewhere.

## Review
- [ ] UNPROVEN resolution is defined only for § Parameters rows; a
  README, CHANGELOG or § Behavior claim has no evidence cell and no end
  state (Important) - `skills/dev/companions/documentation.md:161`,
  `agents/dev-doc-writer.md:26`. Fix per Answers, Review 1.
  Evidence: contract `documentation.md § Verification gate` puts README
  and the CHANGELOG through the per-claim pass; requirements Constraints
  make references outside § Parameters optional.
- [ ] The Reports bullet restates the verification policy's
  "value-identical to the fallback" rule instead of citing it
  (Important) - `skills/dev/companions/documentation.md:28`. Fix: end
  the sentence at "a run that could have failed
  (`verification-policy.md § Verification modality`)".
  Evidence: contract `MAINTENANCE.md § Tier-2 AI review` counts an echo
  of a rule's text as a restatement.
- [ ] The three `## Implementer` entries are `- [ ]` checkboxes under
  the section head instead of plain bullets under `### Divergences`
  (Suggestion) - this report, lines 5-25. Fix: move them to the
  template form.
  Evidence: contract `skills/dev/branch-plan.md § Task report`.
