# R059-T001 findings

Close-review findings; the rule relaxation itself matched the plan.

- [x] Three "defer to the rule" reconciliations landed unevenly: the
  spec-reviewer check kept a paraphrase, `branch-plan.md` and
  `release.md` lost every pointer to the rule. Resolved: pointer-only
  form in the spec-reviewer check and `branch-plan.md § Commit
  cadence` step 3.
- [x] The new section repeated its own no-diff-restating rule in a
  BAD-body bullet, ran the subject constraints unbroken into body
  guidance (semicolon-ban scope unstated), and its GOOD body example
  used a semicolon-joined clause. Resolved: split into Subject/Body
  paragraphs, example reworded, bullet folded into the body prose.
- [x] The added history-precedence sentence collided with
  `writing.md § One home per finding` using a circular test.
  Resolved: replaced with a pointer to that section.
- [x] The trailer ban still conflicts with the harness default that
  appends `Co-Authored-By`. Resolved: promoted to R059-T002
  (`includeCoAuthoredBy: false` in tracked settings).
- [x] `§ MR/PR messages` restates the subject constraints, out of this
  branch's scope by the approved invariant. Resolved: backlog line in
  this R's `tasks.md`.
- [x] The indented example block's rendering depends on CommonMark's
  list rules. Resolved: won't fix - the verifier judged it an optional
  style tightening; the file uses no fences anywhere.
