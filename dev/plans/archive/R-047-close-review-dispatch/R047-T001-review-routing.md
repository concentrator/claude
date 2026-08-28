---
task: R047-T001
type: doc
---

# R047-T001 - review routing

Branch: `doc/review-routing`.

- [x] `branch-plan.md § Closing routine` step 1: the content-keyed
      dispatch table replaces the tag mapping - the size governor
      (`small` = ≤9 commits; >9 or mixed → both) and the Tier-2
      sentence word-for-word untouched, the cap held by trading words.
      Verified in this commit by walking the table against R-046's five
      branches plus R-047's own: exactly one route each.
- [x] `documentation.md § Verification gate`: state what clears the
      gate per prose class - rules, skills, and planning prose: an
      independent close review checking the changed claims against
      their sources; `docs/` feature docs: the dedicated per-claim pass
      with VERIFIED/DOCS verdicts, unchanged.
- [x] `delegation.md § Close-review fan-out` cites the content rule
      instead of implying the tag mapping. The file loads every
      session: propose the wording and wait for approval before
      writing.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
