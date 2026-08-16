# R040-T007 findings

- [ ] `fix.md` has no path for a `[fix]` task whose deliverable is
      prose. Its pass opens "Reproduce - write a failing test that
      exhibits the bug", and this task's bug is a missing rule in
      `supervise.md`: there is no executable behaviour to assert, and
      the two conditions being fixed (a supervisor running git in a
      shared tree, a batch ref left at its anchor) are checkpoint-time
      judgments rather than repo invariants a gate could hold. Run under
      `branch-plan.md § Commit cadence` instead, which is what the tag
      table already prescribes for `doc`/`test`/`mnt`.
      Either `fix.md` should say that a prose-only fix runs the cadence
      directly, or a defect in a written rule should be tagged `[doc]`
      and the tag table left alone. The second reading is tidier but
      loses the signal that something was broken rather than merely
      unwritten - which is worth keeping, since this task exists because
      a rule's absence caused fourteen unreviewed commits to reach
      trunk.
      Not resolved here: the fix belongs to `fix.md` or to the tag
      table, and neither is this task's file.
