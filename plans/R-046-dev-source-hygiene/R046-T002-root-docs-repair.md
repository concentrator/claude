---
task: R046-T002
type: doc
---

# R046-T002 - root-doc repair

Branch: `doc/root-docs-repair`. Each edit verifies against the source
file it describes, never against the R's § Current state list.

- [ ] `README.md § Contents`: `hooks/`, `scripts/`, and the
      `@import`ed `writing.md` + `delegation.md`; the `plans/` row gains
      `archive/`; every row checked against the tracked root.
- [ ] `README.md § Workflow`: the full command surface read from
      `SKILL.md § Surface`, the two planning rounds, and the composite
      id chain (`R-XXX → R<NNN>-T<NNN> → branch`).
- [ ] `README.md`: new § Artifacts root - the declaration, the `dev/`
      default, and pointers to `layout.md` and
      `plan.md § Where things live`; § Self-hosting states why the root
      resolves to the repo root here.
- [ ] `README.md`: the `core.hooksPath` setup step, and the installer
      paragraph checked against `install-dev.sh` - both hooks, the
      code-size check, the writing conventions.
- [ ] `DESIGN.md § Tree-map`: the missing `skills/dev/` mode files,
      `plans/archive/`, and the `scripts/test/` contents, checked
      against `git ls-files`.
- [ ] `DESIGN.md`: § Self-enforcement cites the Tier-2 concern set
      instead of restating it; tree-map plan-file nodes carry the
      composite form.
- [ ] `REQUIREMENTS.md § Planning discipline`: the three dead `rules/`
      pointers repointed to their `skills/dev/` homes; the id chain in
      composite form.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
