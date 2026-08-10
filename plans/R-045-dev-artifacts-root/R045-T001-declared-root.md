---
task: R045-T001
type: doc
---

# R045-T001 - the declared artifacts root

- [x] `plan.md`: split `§ Where things live` into guarded config
      (`.claude/`) and root-resolved artifacts (`<root>/plans/...`);
      state the resolution rule - the project `CLAUDE.md § Agent
      toolchain` declaration, absence resolving to `dev/`, this repo
      resolving to the repo root.
- [ ] `layout.md`: split the single tree into the guarded `.claude/`
      config tree (settings, hooks, skills, rules, `REQUIREMENTS.md`,
      `DESIGN.md`, `MAINTENANCE.md`, `references/`, `adr/`) and the
      `<root>/` artifacts tree (`plans/`, `docs/`); creation policy and
      the disallowed-content rules follow their tree.
- [ ] `companions/toolchain.md`: document the declaration key beside
      the other toolchain declarations; add the declaration to this
      repo's `CLAUDE.md § Agent toolchain`; extend `DESIGN.md
      § Self-hosting layout` with the this-repo resolution.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
