---
approved: 2026-08-19
kind: bug
status: done 2026-08-19
---

# R-055: Archive an initiative when it closes

## Observed behavior

`plan.md § Archival` moves a closed initiative's directory to
`plans/archive/`, and `finish.md § 4` ships that move on "the
closure's plan MR/PR". But that MR/PR opens only when the closure was
not recorded with the branch merge (§ 4.1). In the usual path - the
closure riding the last task's final commit - the closure lands with
the merge, no plan MR/PR opens, and the move has no vehicle. R-049
and R-054 closed this way and still sit under `plans/`.

## Expected behavior

- Closing an initiative always produces the archive move, whichever
  path recorded the closure.
- The vehicle stays a plan MR/PR: a closing task promotes but never
  moves files, so the move never rides a task branch.
- No closed initiative's directory remains under `plans/` outside
  `archive/`.

## Reproduction steps

Close any R via its last task's branch (closure recorded in the final
commit, e.g. e9f4abb closing R-054) and merge. Run `finish.md § 4`:
step 1 no-ops because the closure is recorded, step 2's plan MR/PR
never exists, and the R's directory stays under `plans/`.

## Impact

Closed initiatives accumulate in the working set every planning read
scans, and the archival rule holds only when a closure was recorded
late - the inverse of its intent. Batch mode is unaffected: its
closure path always opens `plan/r<NNN>-close`.

## Acceptance criteria

- [x] `finish.md § 4` opens the closure plan MR/PR whenever the merge
  closed the initiative: it carries the closure records when the
  branch did not, and the archive move always.
  Evidence: `finish.md § 4.3` states the trigger and both payloads;
  landed via PR #354.
- [x] The promotion check precedes the move in that step, citing
  `plan.md § Archival` as the rule's owner.
  Evidence: `finish.md § 4` step 2 (promote, per `plan.md § Archival`)
  runs before step 3's archive move.
- [x] Every ROADMAP `[x]` initiative's directory lives under
  `plans/archive/` (today that means moving R-049 and R-054), moved
  via plan MR/PR with `bash scripts/ci/run-all.sh` green.
  Evidence: a sweep of `plans/R-*/` against ROADMAP marks leaves only
  open initiatives outside `archive/`; the moves ride this closure
  plan branch with the gate green. R-055's own move follows the merge
  via `finish.md § 4`.

## Constraints

- Flow text plus the backlog move only - no new gate or hook (R-053:
  one observed failure, one fix; nothing ships to police recurrence).
- `plan.md § Archival` stays the rule's single home; `finish.md`
  states only where the flow acts.

## Open questions

None.

## References

R-049, R-054 (the unarchived evidence); R-053 (proportionality bound);
`skills/dev/finish.md § 4`, `skills/dev/plan.md § Archival`.
