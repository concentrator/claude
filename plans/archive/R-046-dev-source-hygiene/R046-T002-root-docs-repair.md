---
task: R046-T002
type: doc
---

# R046-T002 - root-doc repair

Branch: `doc/root-docs-repair`. Each edit verifies against the source
file it describes, never against the R's § Current state list.

- [x] `README.md § Contents`: `hooks/`, `scripts/`, and the
      `@import`ed `writing.md` + `delegation.md`; the `plans/` row gains
      `archive/`; every row checked against the tracked root.
- [x] `README.md § Workflow`: the full command surface read from
      `SKILL.md § Surface`, the two planning rounds, and the composite
      id chain (`R-XXX → R<NNN>-T<NNN> → branch`).
- [x] `README.md`: new § Artifacts root - the declaration, the `dev/`
      default, and pointers to `layout.md` and
      `plan.md § Where things live`; § Self-hosting states why the root
      resolves to the repo root here.
- [x] `README.md`: the `core.hooksPath` setup step, and the installer
      paragraph checked against `install-dev.sh` - both hooks, the
      code-size check, the writing conventions.
- [x] `DESIGN.md § Tree-map`: the missing `skills/dev/` mode files,
      `plans/archive/`, and the `scripts/test/` contents, checked
      against `git ls-files`.
- [x] `DESIGN.md`: the tree-map's plan-file nodes carry the composite
      form, and § Self-enforcement's Tier-1 list names the accretion
      gate - `run-all.sh` has run `check-accretion.sh` since `6631f83`
      and the list never learned it (found by dry-running the doc-sync
      pairs in R046-T001). The § Self-enforcement Tier-2 restatement is
      already gone, fixed in that task.
- [x] `REQUIREMENTS.md § Planning discipline`: the three dead `rules/`
      pointers repointed to their `skills/dev/` homes; the id chain in
      composite form.
- [x] Trim `DESIGN.md` (user-requested): § Components keeps what the
      tree-map does not state and cedes the inventory to it, the symlink
      note loses a local path, and § Invariants drops the retired `REQ`
      term. Creates the cap headroom the close-review fixes need.
- [x] Apply the close-review fixes: the installer's full payload and its
      writes outside `.claude/`, the branch guard's commit denial, a
      `README.md` row for the tracked-root criterion, the gate running
      tests as well as checks (`README.md` and `DESIGN.md`), a settled
      example for the id routing, and `commands` out of
      `REQUIREMENTS.md § Vision`.
- [x] Route the uncovered `layout.md` to R046-T003 and add it to the R's
      § Scope - no task owned the file the new pointers rely on.
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
