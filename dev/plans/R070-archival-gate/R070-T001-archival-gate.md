---
task: R070-T001
type: feat
---

Branch: `feat/archival-gate`.

The check reads working-tree state only: `status: done` in a
non-archive `dev/plans/*/requirements.md` frontmatter fails unless an
`archival: deferred - <reason>` line exempts it.
`scripts/ci/run-all.sh` registers checks by an explicit list (its
`for c in ...` loop); `scripts/test/run-all.sh` globs `*.test.sh`, so
the self-test registers itself.

## Commits

- [ ] `scripts/ci/check-archival.sh` +
  `scripts/test/check-archival.test.sh`, and `archival` added to the
  `run-all.sh` list: a non-archive `dev/plans/*/requirements.md`
  whose frontmatter carries `status: done` fails the gate with one
  line naming the initiative and the remedy (archive move or
  deferral); clean tree passes; `archive/` exempt. Test cases: clean
  pass, done-unarchived fail, archive-exempt.
- [ ] Defer marker slice, check + test together:
  `archival: deferred - <reason>` in the same frontmatter exempts
  and the check prints the reason; a marker with no reason fails;
  malformed frontmatter (no closing `---`) fails loudly. Test cases:
  deferred pass with reason printed, reasonless fail, malformed
  fail.
- [ ] `plan.md § Archival`, `branch-plan.md § Closing routine`, and
  `finish.md § 4`: the one-delivery flow - the closing branch's
  final commit carries the archive move when it closes the R;
  finish § 4 step 3 verifies the move landed instead of opening a
  follow-up MR/PR (which remains only for late closures already on
  the trunk); no text still describes the move as a routine
  follow-up. The closure itself gates on the user: when the closing
  branch's last task closes the R, the closure check's verdict is
  presented and the closure marks and archive move land only on
  explicit confirmation - never as a side effect of finishing the
  task.
- [ ] `DESIGN.md § Self-enforcement`: the check's row (Tier-2 doc
  sync for an added `scripts/ci/` check).
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md
  § Closing routine` (code + prose rows → both reviews), Tier-2
  compliance review, `bash scripts/ci/run-all.sh` green, cleanup,
  mark plan complete. T001 being the R's last task: present the
  closure check and ask explicitly before closing R070 and carrying
  its archive move in the final commit - the first delivery under
  the rule it ships, confirmation included.
