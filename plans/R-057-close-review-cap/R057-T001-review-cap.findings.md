# R057-T001 findings

First run of the capped close review - one code-reviewer dispatch
(fable, medium effort per its own frontmatter), findings validated by
the session.

- [x] Critical: the effort-mechanics rewrite claimed a per-call
  `effort` override on the Agent dispatch surface; the tool's actual
  parameter schema has none - the key exists in agent frontmatter
  only. Resolved: policy narrowed to the frontmatter surface, the
  plan item's wording corrected in the same pass. No verifier
  dispatched: the ground truth (the tool schema) was directly
  inspectable, which is the validation step 2 already owes.
- [x] Important: a word-cap trim dropped the pointer that
  distinguishes the auto close-folding threshold from the ≤9-commit
  small-branch definition. Resolved: pointer restored with offsetting
  trims.
- [x] Important: three lines stretched past the file's fill width by
  the trims. Resolved: reflowed.
- [x] Suggestion: "write or update" restored in the doc-reconcile
  step (creation was underspecified). Applied.
- [x] Suggestion: delegation.md's list is no longer purely
  permissive - one bullet now carries a prohibition. Accepted as is;
  the bullet still pre-authorises the session's dispatch.
