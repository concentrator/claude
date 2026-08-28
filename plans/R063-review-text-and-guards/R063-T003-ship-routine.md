task: R063-T003
type: doc
depends-on: R063-T001

# Ship routine: one named path from a landed branch to a merged MR/PR

Delivery today is spread over `finish.md § 3` (push + MR/PR / keep /
discard) and `§ 4` (post-merge), with the poll-to-green and the merge
approval unwritten. This task names the whole path **Ship**, states
its steps once in `finish.md`, and adds `/dev ship` so the same steps
run on any landed branch, not only from the closing routine.

## Terms

- **Ship** - the delivery routine: gate, push, open the MR/PR, poll the
  state check to success, ask for merge approval, merge, post-merge.
- **Landed branch** - every commit the branch plan calls for is
  committed; nothing uncommitted in the tree.
- **Merge approval** - the user's explicit "merge" after the pipeline
  is green. A `plan/` branch has it already: approving the plan's
  content delivers its MR/PR (`plan.md § Planning rounds`), so Ship
  merges a `plan/` branch on green without a second ask
  (`git-workflow.md § Merge policy`).
- **Kept** - the branch's state when Ship is offered and not chosen:
  nothing runs, the branch stays; the report says so. Not an option
  the user picks.

## Commits

- [ ] `finish.md § 2` step 3 offers **ship / discard**; no answer
  keeps the branch and the report says "kept, not shipped".
  `finish.md § 3` replaces **Push + MR/PR** and **Keep** with **Ship**,
  whose steps are: (1) gate - `bash scripts/ci/run-all.sh` and the
  declared test/lint; a failure stops Ship and is reported; (2)
  `git push -u origin <branch>`, then open the MR/PR via the declared
  change-request command (no declared host → push and print the
  URL), and stay on the branch; (3) poll the declared state check
  until it reports success, per `git-workflow.md § Merge policy`;
  (4) report the MR/PR number and pipeline state in one line and ask
  for merge approval - a `plan/` branch skips the ask (§ Terms); (5)
  on approval, merge via the declared merge command, then `§ 4`.
  Ship ends with one line: MR/PR number and final state (merged,
  open awaiting approval, or kept). **Discard** is unchanged.
- [ ] `git-workflow.md § Merge policy` names `finish.md § 3 Ship` as
  the routine that asks for the user's merge call, one clause, no
  restatement of the steps.
- [ ] `skills/dev/SKILL.md` router gains `/dev ship`, Read
  `finish.md § 3 Ship`: run Ship on the current landed branch; on
  the default branch, or with uncommitted changes → error naming the
  condition. `README.md` command sentence names `/dev ship` beside
  `/dev release`.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose row: `code-reviewer`), Tier-2 compliance review over
  the diff, `bash scripts/ci/run-all.sh` green, cleanup, mark plan
  complete, commit.
