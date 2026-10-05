# R086-T002 report

## Implementer
### Divergences
- Item 1: `seat-permissions.md` cited the definition's old
  `§ Scratch & Probe Scripts` and `§ Plan & Task Report` headings, which
  the contract shape removes, so those two cites now point at
  `§ Steps` as well; the template's citers are repointed to `§ Inputs`,
  `§ Steps` or `§ Outputs`.
- Item 1: the seat-model initiative's completed branch plans and its
  requirements still name `implementer-prompt.md`; they record delivered
  work and plan text is not the implementer's to edit, so they stand.
- Item 1: rules the definition restated now cite their owner - tests
  per branch type (the `type:` mode files), docs as inputs and the
  full-suite note (`branch-plan.md § Commit cadence` 1-2), the report
  entry form (`§ Task report`), the answer route (`run.md § Question
  resolution`).
- Item 2: `LAYOUT.md` lists the new `rules/code-comments.md` beside
  the other rule files, a file the plan's approach does not name.
- Item 2: "code files" is the rule's `paths:` list of source and shell
  extensions, one glob per line as `rules/js.md` writes them.
### Findings
- [ ] Item 1: the seat-model initiative's `tasks.md` cites
  `agents/dev-implementer.md § Scratch & Probe Scripts` and
  `companions/implementer-prompt.md`, both gone after this item.
  Evidence: observed `git grep -n implementer-prompt` and the heading
  search over that initiative's `tasks.md`

## Review
