task: R052-T001
type: fix

# R052-T001 - Commit-path target resolution

- [ ] Findings: extract the denied `git commit` shapes from the local
  session transcripts, settle the non-project signal against them
  (ephemeral path prefix, repo created in the same command, or both -
  readable from the tool call alone), present the decision for
  approval, and record measurement and decision in the findings file
- [ ] Fix the `hooks/dev-branch-guard.sh` commit path per the settled
  signal: new cases in `scripts/test/dev-branch-guard.test.sh` proved
  to fail against the pre-fix hook (non-project commit allowed),
  existing trunk cases still passing (real-trunk commit denied from
  any cwd), and the header's stated resolution rule corrected - one
  red-green commit
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [ ] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
