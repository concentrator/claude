task: R072-T004
type: mnt

- [x] Define the two test tiers in `companions/declarations.md
  § Declared commands`: `Test (fast)` (lint plus the project-declared
  scoped subset; absent → lint only) and `Test (full)` (the whole
  suite); a project declaring a single `Test:` reads as both.
- [x] Point the per-commit Verify at the fast tier:
  `branch-plan.md § Commit cadence` step 1, § Rails "no commit on
  red", and the per-branch close inside a batch (§ Agentic execution);
  the full tier stays at close only.
- [x] Name the full tier in `finish.md`: § 1 Verify and the § 3 Ship
  gate run `Test (full)` once, CI on the MR/PR the authority.
- [x] Align auto mode: `auto.md` pre-flight and member-branch close
  run the fast tier, batch close runs the full tier;
  `companions/implementer-prompt.md` Verify step names the fast tier.
- [x] Declare the tiers in this repo's `CLAUDE.md § Agent toolchain`:
  fast `bash scripts/ci/run-all.sh`, full adds
  `bash scripts/test/run-all.sh`.

> Mark and commit the task `[x]` in the R's `tasks.md`.
>
> Complete the branch: re-review docs across all commits, cleanup
> (stale/temp data), mark plan complete, commit.
