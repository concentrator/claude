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

## Review
