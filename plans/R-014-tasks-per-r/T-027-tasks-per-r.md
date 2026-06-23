task: T-027
type: refactor
architecture-changing: true

# refactor/tasks-per-r — per-initiative task indexes (R-014)

T-027 of `plans/R-014-tasks-per-r/requirements.md`. One coherent branch:
deprecate the flat `plans/TASKS.md`, give each `R-XXX-<slug>/` a lazily
created `tasks.md`, and update every live consumer (rules, skills,
DESIGN, the integrity check). Self-modifying — the check that validates
tasks is rewritten while the tasks relocate.

**Sequencing principle.** Docs describe the target state first, then the
per-R files are created, then the check rewrite + flat-file removal land
in one atomic commit — so `run-all` (esp. `check-plan-integrity`) is
green at every commit and the PR head is fully coherent.

**Out of scope (no history rewrite).** Closed branch plans (T-003, T-004,
T-008..T-011, T-024), `B-001.report.md`, and R-014's own
`requirements.md` ("being split") mention `TASKS.md` as historical
record — left untouched.

- [x] Repoint rules + top-level structure docs to per-R `tasks.md`:
      `planning.md` (§ Levels item 2 — index is the R's lazily-created
      `tasks.md`; § Where things live — drop root `TASKS.md`; next-free
      id = max T-id across per-R files), `project-layout.md` (layout tree
      + creation policy — per-R `tasks.md`, remove the root `TASKS.md`
      node), `branch-plan.md` (findings-promotion + closure references →
      the R's `tasks.md`), and the live pointers in `REQUIREMENTS.md` and
      `ROADMAP.md`. Prose only; flat `TASKS.md` still present so the check
      stays green.
- [x] Update `DESIGN.md`: planning-structure description + tree-map —
      per-R `tasks.md`, remove the root `TASKS.md` node. (architecture
      commit)
- [x] Repoint the `~/.claude` skills to per-R `tasks.md`: `writing-plans`
      (inputs + next-id computed across per-R files), `finishing-a-branch`
      §4 (mark `T-XXX [x]` in the parent R's `tasks.md`; "next task" →
      `ROADMAP` / the open batch), `starting-a-project` (scaffold +
      creation-policy mention).
- [x] Update `migrating-to-dev`: repoint its `TASKS.md` references to
      per-R `tasks.md`, and add the adopter split-operation step — a
      structure-reconcile that splits an existing flat `TASKS.md` into
      per-R `tasks.md` (status preserved).
- [x] Create the per-R `tasks.md` files: split the 26 tasks from
      `plans/TASKS.md` into each `plans/R-YYY-<slug>/tasks.md`, preserving
      checkbox status and the one-line format. Flat `TASKS.md` still
      present → check still reads it → green.
- [x] Atomic swap: rewrite `scripts/ci/check-plan-integrity.sh` to read
      every `plans/R-*/tasks.md` (each task's `(R-XXX)` equals its owning
      dir; no duplicate T-id across files; branch-plan `task:` /
      `depends-on:` resolve) and `git rm plans/TASKS.md` in the same
      commit. Per-R files are now the source → check green.
- [x] Complete the branch: re-review docs across all commits, confirm
      `run-all` green on the migrated tree, mark the plan complete; stamp
      follows per the ledger protocol; hand off to `finishing-a-branch`
      (refactor → user review + merge).

**Scope discovery (resolved in-branch).** Deleting `plans/TASKS.md` left
an illustrative reference in `R-004`'s (open) requirements pointing at
the removed file. Fixed mechanically (→ per-R `tasks.md`) to keep `main`
coherent; R-004's design analysis is unchanged.
