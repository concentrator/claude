# Finishing

The run ends with the report on a branch and, until the merge rule is shipped, every pull request open and stacked. The review session finishes the project, then judges.

1. **Read the summary** from the run's message, or from its last assistant message via `list_events` when the send was refused.
2. **List the open pull requests** with `base` and `head`. Stacked ones have the previous head as base.
3. **Retarget before merging.** Set every stacked pull request's base to `main` with `update_pull_request` first, then merge in number order with `merge_pull_request`, method `merge`, passing `expectedHeadSha`. Merging a stacked PR while its base is still a branch lands it on that branch, not on `main`; GitHub retargets only when the base branch is deleted.
4. **Verify `main`:** shallow pull, `git status --short` empty, the report present, tests green (`node --test`), the app runs, `CHANGELOG.md` stamped.
5. **Tag the release by hand** on a trusted machine: `git tag -a v0.1.0 <release merge sha> -m v0.1.0 && git push origin v0.1.0`. Cloud sessions cannot create tags.
6. **Verify the report's toolset claims** against the tested commit before repeating them.
7. **Write the judgement:** verdict per criterion with the review session's own evidence where it differs from the run's, then the three findings lists. Deliver it to the owner, and append the run's row to the comparison table in `docs/reports/dogfood-runs.md`.
8. **Clean up:** the owner deletes the repository, or keeps it as the baseline for the next run's diff. Merged branches stay unless the owner deletes them; branch deletion is refused to the session as destructive.

## Before trusting the run's report

- Every toolset claim opened at the tested commit.
- Token figures recomputed from the run's `get_session` usage, not only the run's own sums.
- The merged `main` verified as in step 4.
- Verdict changes against the baseline explained by a named finding, or flagged as unexplained.
