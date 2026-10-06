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
- Item 5: the code reviewer's `§ Inputs` names the folded branches'
  list and the ruled-out cases its dispatch already passes
  (`verification-policy.md § Close folding`, the old evidence
  paragraph), and its batch step reviews a folded branch as its first
  review; its evidence bar, missing-test bar and second-agent condition
  now cite `CLAUDE.md § Scope`, `plan.md § Proportionality` and
  `branch-plan.md § Closing routine` 1. With no plan path it asks in its
  report back, its only channel, rather than of the dispatcher.
- Item 5: the cold reader's inputs cite the implementer's `§ Inputs`
  and `branch-plan.md § Modes` for `## Planner`; the docs verifier's
  heredoc bar cites the implementer's scratch paragraph, and the
  settings surface in all three bars cites its config paragraph.
- Item 5: `verification-policy.md § Comprehension check` passes the
  values the cold reader's `§ Inputs` names instead of listing them;
  `seat-permissions.md` names the three read-only bars beside the
  implementer's config paragraph.
- Review 1: the extensions added are `kt`, `kts`, `scala`, `swift`,
  `cs`, `php` and `pl`; with the data globs in, the rule's opening line
  and its `LAYOUT.md` entry name code and data files.
- Review 3: the sentence splits at its second "while", the read-only
  bar becoming a sentence of its own.
### Findings
- [x] Item 1: the seat-model initiative's `tasks.md` cites
  `agents/dev-implementer.md § Scratch & Probe Scripts` and
  `companions/implementer-prompt.md`, both gone after this item.
  Evidence: observed `git grep -n implementer-prompt` and the heading
  search over that initiative's `tasks.md`
- [x] Item 5: `seat-permissions.md`'s `Read(//__HOME__/.claude/rules/**)`
  row traces the rule to `rules/writing-artifacts.md` alone, though
  `agents/dev-implementer.md` and `agents/code-reviewer.md` send their
  seats to `rules/code-comments.md`.
  Evidence: observed `git grep -o "rules/[a-z-]*\.md" -- agents`

## Answers
- Review 1: add the common missing code extensions and `json`, `yaml`,
  `yml` and `toml` to the rule's `paths:`.
- Review 2 and Review 3: fix as proposed; Review 2 also resolves the
  Item 5 finding.
- Item 1 finding: repoint the seat-model initiative's `tasks.md` cites of
  `implementer-prompt.md` and `§ Scratch & Probe Scripts` to the
  implementer's definition.

## Review
- [x] Close review: `rules/code-comments.md` says it applies to every code
  file and governs data files, but its `paths:` lists 20 code globs and no
  data glob (Critical) - rules/code-comments.md:1
  Evidence: observed the frontmatter lists no `*.php`, `*.kt`, `*.json`
  or `*.yaml` glob
- [x] Close review: the `rules/**` read row traces only to
  `rules/writing-artifacts.md` (Suggestion) - seat-permissions.md:53
  Evidence: observed the implementer and code reviewer cite
  `rules/code-comments.md`
- [x] Close review: one sentence chains two "while" clauses (Suggestion) -
  seat-permissions.md:244
  Evidence: contract writing.md § Write like a human
