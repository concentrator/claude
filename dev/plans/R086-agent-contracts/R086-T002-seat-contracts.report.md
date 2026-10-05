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
- Item 3: `branch-plan.md § Modes` cited `write-plan.md` step 3 for
  the strict proof, now a pointer, so it cites `agents/dev-planner.md
  § Steps` 2 instead, a file the plan's approach does not name.
- Item 3: the task report skeleton, inside `write-plan.md` step 3
  before, is the definition's own step 6, so `write-plan.md` step 5
  points to the definition's steps 5 to 7.
- Item 3: rules the template and `write-plan.md` restated now cite
  their owner - the item form (`branch-plan.md § Body`), the header
  fields (`§ Header`), the `## Planner` form (`§ Modes`), the plan's
  present tense (`rules/writing-artifacts.md`), the cold-read sequence
  (`write-plan.md` step 6). The requirements, `tasks.md`, the report
  and the other plans are found beside the plan file the dispatch
  names, no longer passed as paths of their own.
- Item 3: the seat-model initiative's completed branch plans and its
  requirements still name `planner-prompt.md`; they stand, as in
  Item 1.
- Item 4: `agents/dev-docs-verifier.md` cited the doc writer's step 3
  for its report's sources, now in the definition's `§ Outputs`, so
  that cite points there, a file the plan's approach names for item 5.
- Item 4: `run.md § Close` 3 dispatches the doc writer naming the base
  commit and the plan file, the values its `§ Inputs` names; the
  template's `## Exit` account of the gate is a cite of
  `documentation.md § Verification gate` in step 5.
- Item 4: the seat-model initiative's completed branch plans and its
  requirements still name `doc-writer-prompt.md`; they stand, as in
  Item 1.
### Findings
- [ ] Item 1: the seat-model initiative's `tasks.md` cites
  `agents/dev-implementer.md § Scratch & Probe Scripts` and
  `companions/implementer-prompt.md`, both gone after this item.
  Evidence: observed `git grep -n implementer-prompt` and the heading
  search over that initiative's `tasks.md`

## Review
