---
task: R040-T002
type: feat
depends-on: R040-T001
---

# R040-T002 - supervisor mode, local sessions

Branch: `feat/supervise-mode`.

- [ ] `skills/dev/supervise.md`: the operating loop - resolve scope
      (the project's open batch, else open tasks with stamped plans);
      dispatch a member via the `/dev auto` engine in a session;
      monitor to checkpoint or halt; verify the boundary with existing
      gates only (Tier-1 suite, checkpoint report vs acceptance
      criteria, closure check, promote-then-archive); then merge
      within the declared bounds (`companions/toolchain.md
      § Supervisor bounds`) or escalate. Escalations are the existing
      artifacts read back - halted members, checkpoint reports'
      queued judgment calls, refused merges - never a parallel store.
      Sync report format: per-initiative state (merged / in-flight /
      halted / escalated) with MR links, derived from artifacts at
      ask time.
- [ ] `SKILL.md` router: the `/dev supervise [scope]` row (cap-aware -
      the dev orchestrator body stays within its 400-word cap; the
      row points at `supervise.md`).
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
