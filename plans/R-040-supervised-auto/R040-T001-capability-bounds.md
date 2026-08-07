---
task: R040-T001
type: doc
---

# R040-T001 - capability-bounds declaration

Branch: `doc/capability-bounds`.

- [ ] `companions/toolchain.md § Supervisor bounds`: the per-project
      declaration - where it lives (project `CLAUDE.md § Agent
      toolchain`, mirroring the permissions declarations), the
      batch-scoped-delivery default (green `plan/` MRs; green
      batch/member MRs whose checkpoint report verifies acceptance
      criteria), the always-escalate list (releases; changes to
      `CLAUDE.md`, `rules/`, `skills/`; red gates; off-plan work), and
      the absence rule: no declaration = read-only supervisor, every
      merge escalates.
- [ ] `git-workflow.md § Merge policy`: a one-line delegation pointer
      to the companion (cap-aware - the file must stay within its
      1500-word cap; the clause body lives in the companion, exactly
      as the comprehension check does).
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
