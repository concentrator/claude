---
task: R050-T004
type: doc
---

# R050-T004 - session boundary and doc-load discipline

Branch: `doc/session-boundary`.

Single home per R-039: `branch-plan.md` owns both rules, and the three
execution files point at it rather than restating it. `branch-plan.md`
is the right owner because it already owns the delivery unit
(`§ Agentic execution`: "The batch ... is the unit of delivery to
`main` in both modes").

Watch the cap: `branch-plan.md` is the largest file in `skills/dev/`,
so both sections stay terse and the pointers stay one line each.

- [ ] `branch-plan.md`: a section owning the session boundary - the
      session ends when its delivery unit does, with the unit per mode
      in a table (`/dev code`: the task, or the branch where that is
      larger; `/dev auto`: the batch; a supervised worker: the batch).
      State why: context cost tracks window size multiplied by session
      length, so a session that outlives its unit re-bills the finished
      unit's context on every later call.
- [ ] `branch-plan.md`: the doc-load discipline - one doc-load phase
      per unit at its start, sectional reads over whole-file reads, no
      re-read of a doc already loaded in the unit, and outputs (batch
      reports, findings files) read at triage rather than during
      execution. Note the ordering dependency: front-loading only pays
      once the session is bounded, because a doc read early in a long
      session is re-read by every call that follows it.
- [ ] Pointers: `auto.md § Checkpoint`, `finish.md § 3` and
      `supervise.md § Dispatch` each gain a one-line reference to the
      owning section. `supervise.md` also states the exception it
      already implies at `§ Monitor` - the batch boundary binds the
      worker, while the supervisor session spans many, because its
      context stays report-level by design.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, confirm
      no mode file contradicts the owning section, cleanup (stale/temp
      data), mark plan complete, commit.
