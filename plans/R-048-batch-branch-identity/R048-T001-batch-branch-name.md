---
task: R048-T001
type: doc
---

# R048-T001 - composite batch branch name

Branch: `doc/batch-branch-name`.

- [x] The composite branch form `batch/R<NNN>-B-<MMM>` (e.g.
      `batch/R042-B-001`) replaces flat `batch/B-XXX` at every living
      mention: `auto.md` (pre-flight, close, checkpoint-accept),
      `branch-plan.md § Agentic execution/§ Batches/§ Rails`,
      `companions/toolchain.md` (push + MR/PR commands),
      `companions/report-template.md` (`batch-branch:` field),
      `git-workflow.md § Trunk`, `agents/code-reviewer.md`,
      `DESIGN.md § Git & delivery model`, and foundational
      `REQUIREMENTS.md` - like-for-like token swaps within each file's
      word cap.
- [x] The lifecycle rail: `branch-plan.md § Rails` and `auto.md`
      checkpoint-accept state the batch branch is deleted, local and
      origin, after its MR/PR merges; freeing words elsewhere in the
      section if the cap requires it.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
