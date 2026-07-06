task: T-013
type: feat
depends-on: T-012
agentic: approved 2026-06-12

# feat/close-folding - fold small-branch close review into batch close (R-005)

Lever 3 of R-005: the batch full-diff review re-covers most of the
per-branch `code-reviewer` pass (~45–60k each; overlap observed in
B-003), so small branches skip it and get their first review at batch
close. Small-branch predicate - stated, checkable, no agent judgment:
a branch is **small** iff its committed plan has **≤3 non-final commit
checkboxes** AND **no `architecture-changing: true` header** (B-003
member branches were this size - exactly the overlap case). Invariants
held throughout: the mandatory final commit and the tests+lint green
gate before merge into `batch/B-XXX` survive for ALL branches - only
the `code-reviewer` pass folds; branches above the threshold keep the
full close; manual-mode `branch-plan.md § Closing routine` untouched.
`delegating-to-agents/SKILL.md` is at 397/400 words - verify `wc -w`
after every edit; rule detail lives in the policy artifact, the skill
only points.

- [x] Extend the verification-depth policy from T-012 (its companion
      file in `skills/delegating-to-agents/`, per T-012's merged
      shape) with a close-folding entry: the small-branch predicate
      above, read off the committed plan at branch close; folded =
      per-branch `code-reviewer` skipped, first review at batch
      close; final commit and green-merge gate explicitly unaffected.
- [x] delegating-to-agents SKILL.md § Per branch step 3: close
      becomes conditional - small branches (per policy) skip the
      `code-reviewer` pass; mandatory final commit, tests+lint green
      gate, and merge into `batch/B-XXX` unchanged for every branch;
      above-threshold branches close exactly as today. `wc -w` ≤400
      - free words by pointing to the policy, not restating it.
- [x] delegating-to-agents SKILL.md § Batch close step 1: the
      full-diff review receives the list of folded branches and
      reviews their diffs as first-reviewed-here (per-plan coverage,
      not only cross-branch concerns). `wc -w` ≤400 after edit.
- [x] report-template.md § Branches: per-branch "review findings"
      line records "folded into batch review (small branch)" for
      folded members; § Batch review attributes findings in folded
      branches to their branch - checkpoint sees review coverage
      explicitly.
- [x] branch-plan.md § Agentic execution: rules-level statement of
      the folding - auto-mode per-branch close runs the review only
      above the small-branch threshold (predicate by pointer to the
      delegating-to-agents policy); final commit and green-merge gate
      named as all-branch invariants; manual § Closing routine
      explicitly unchanged.
- [x] branch-plan.md § Stop conditions: new row - batch-close review
      finds a folded-branch defect beyond batch-branch fixup (branch
      rework needed) → Halt, report; existing tests/lint and
      spec-check rows unchanged.
- [x] Grep sweep of skills + rules + CLAUDE.md: no stale claim that
      every branch close runs a `code-reviewer` pass; confirmed
      out-of-scope hits (`release`, `dispatching-parallel-agents`
      routing table) left as-is.
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
