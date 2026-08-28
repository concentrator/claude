task: T-005
type: feat

# feat/batch-branch - batch integration branch rails (REQ-003)

Rules text only: the rails the engine obeys. Engine procedure (close
phase, report, push mechanics) lands in T-006/T-007.

- [x] branch-plan.md § Agentic execution intro + Rails: `batch/B-XXX`
      created at pre-flight off the default branch; member branches
      merge into it; the default branch is never modified during a run;
      agents never push.
- [x] § Rails rollback: reject = delete the batch branch; `pre-B-XXX`
      tag stays as belt-and-braces; branch refs kept until checkpoint
      validation (unchanged). (Landed with commit 1 - same Rails
      block.)
- [x] § Stop conditions + checkpoint wording: checkpoint happens on the
      batch branch; push only at accept, batch branch only, never the
      default branch (rail statement; mechanics in T-007).
- [x] § Batches + planning.md: task/batch checkboxes close when the
      batch MR merges to the default branch, not at local merge; align
      the batch-local-merge exception wording to the batch branch.
      (Exception wording lived in dev/SKILL.md § Branching, not
      planning.md - aligned there; § Releases wording also updated.)
- [x] finishing-a-branch § 4: auto-mode closure follows the batch MR
      merge; manual mode unchanged.
- [x] Complete the branch: re-review docs across all commits, cleanup,
      mark plan complete, commit.
