# R072-T001: Size-scale the close review

task: R072-T001
type: mnt

One reviewer dispatch per branch, its depth set by the diff class
inside `agents/code-reviewer.md` rather than by table rows and commit
counts outside it. Supersedes the R-057-T002 reviewer set and the
R-025 checklist stub.

- [x] Add the diff-class rubric to `agents/code-reviewer.md`: doc-only
  diffs get a claim spot-check against the sources the doc cites;
  code and behavior diffs get the full checklist (correctness,
  security, maintainability - the R-025 dimensions as checklist
  lines, not agents); a second verification agent only on a Critical
  finding or a diff touching rules files or CI scripts.
- [x] Reroute `branch-plan.md § Closing routine` step 1: every diff
  class routes to the one `code-reviewer` dispatch; the per-row
  table, the more-than-one-row governor, and the >9-commit governor
  retire; `/simplify` stays for behavior-preserving code diffs;
  align the `verification-policy.md § Verifier isolation` cross-ref.
- [x] Close R-057: mark T002 `[x]` superseded with a one-line
  tombstone naming R072-T001, verify R-057's criteria (T001 evidence
  stands, T002's line moots), stamp `status: done`; tombstone R-025
  in ROADMAP the same way. Correct the R072 requirements scope line
  (`delegation.md` does not exist; the homes are the closing-routine
  table and `verification-policy.md`).

> Mark and commit the task `[x]` in the R's `tasks.md`, plus any
> release-plan entry.
>
> Complete the branch: re-review docs across all commits, cleanup
> (stale/temp data), mark plan complete, commit. R-057's archive move
> rides this final commit on explicit user confirmation
> (`finish.md § 4`).
