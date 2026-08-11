---
task: R046-T004
type: refactor
---

# R046-T004 - declaration syntax gets its own companion

Branch: `refactor/declaration-companion`.

- [ ] New `companions/declarations.md`: the three
      `CLAUDE.md § Agent toolchain` keys - declared commands, supervisor
      bounds, artifacts root - moved from `toolchain.md`, one section
      each, wording unchanged.
- [ ] `companions/toolchain.md` keeps push, MR/PR, and state-check
      mechanics; the moved sections become a pointer to the new
      companion.
- [ ] Repoint every inbound reference found by grep. `CLAUDE.md` is
      governed (`rules/claude-md.md § Approval`): propose its
      `§ Agent toolchain` edit and wait for approval rather than
      editing it silently. Both companions stay within their caps and
      the gate is green in this commit.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
