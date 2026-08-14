---
task: R048-T002
type: feat
---

# R048-T002 - batch-ref gate

Branch: `feat/batch-ref-gate`.

- [x] Branch refs join the gate: `check-batch-tags.sh` iterates
      `refs/heads/batch/*` and `refs/remotes/*/batch/*` with the tag
      logic - a composite `batch/R<NNN>-B-<MMM>` ref whose
      `B-<MMM>.report.md` is on the trunk fails naming ref,
      initiative, and report; any other `batch/*` ref (flat,
      malformed) fails as unresolvable; live refs pass. Test cases:
      stale branch fail, live branch pass, flat `batch/B-001` fail,
      malformed fail; the existing skip path already covers branches.
- [x] Doc sync: `DESIGN.md § Self-enforcement` says batch anchors and
      branch refs; comment header updated. On landing, rename the live
      ref: `git branch -m batch/B-001 batch/R042-B-001` (local action,
      no tracked change - noted here so the gate goes green).
- [x] Close-review fixes: one full-refname enumeration so nested
      `batch/` refs cannot escape, root-prefix-free tree patterns, the
      prune remedy on remote-tracking verdicts, the expected-form
      template in the unresolvable message, ref-accurate skip wording
      and headers, and deduplicated test fixtures.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit. Closing the R's
      last task, the closure check rode this commit: criteria
      evidenced in `requirements.md`, ROADMAP `[x]`.
