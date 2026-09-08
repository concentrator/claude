---
task: R080-T001
type: mnt
supervised: approved
---

# R080-T001: docs move

Branch: `mnt/docs-move`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 5.

The docs home moves from `dev/docs/` to a top-level `docs/`, so the
doc writer has one target outside the planning tree. This repo tracks
nothing under `dev/docs/`, so here the move is the rules that name the
path; consuming projects move their trees with the steps this task
writes.

- [x] `layout.md § Docs` and `§ Artifacts layout`: the docs home is
  `docs/` with `docs/reports/`, `docs/references/` and `docs/index.md`;
  the lazy-creation entry and the `dev/` sentence in `plan.md § Where
  things live` follow; `companions/documentation.md` names `docs/`
  where it named `dev/docs/`.
- [x] Sweep the remaining sites: `branch-plan.md § Commit cadence` and
  `§ Closing routine` 7, `write-plan.md § Inputs` and step 1,
  `docs.md`, `companions/docs-adoption.md`, `start.md § Conventions`
  pointer, `migrate.md`, `README.md`, `agents/code-reviewer.md`;
  `DESIGN.md` places no docs tree and stays. `git grep dev/docs` over
  `CLAUDE.md`, `rules/`, `skills/`, `scripts/` finds the old path only
  where the root migration names it as the source.
- [x] `companions/root-migration.md`: the path migration gains the
  `dev/docs/` to `docs/` step for consuming projects - `git mv`, the
  `CLAUDE.md § Conventions` pointer, the pointers from outside the
  tree and the moved docs' relative links to project files, then the
  verification gate over the moved index - run through `/dev migrate`;
  `migrate.md` routes to it.
- [x] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, cleanup, commit.
