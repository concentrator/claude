---
task: R082-T001
type: mnt
mode: normal
---

# R082-T001: gate the plan files a branch changes

- [x] `scripts/ci/check-plan-text.sh` checks only the `<plans>` files a
  branch changes against its merge-base with the default branch, working
  tree included, `<plans>/archive/` excluded; `FROM` goes; `R<NNN>-` and
  `R-NNN-` dirs both match; no default branch prints a named SKIP.
  Approach: the base lookup of `hooks/dev-precompact-state.sh`; test repos
  commit `main` then branch; `.github/workflows/ci.yml` gets fetch-depth 0.
- [x] A project install copies the gate as shipped: `scripts/install-dev.sh`
  drops the `FROM` carry, the first-install `FROM` computation and the
  step-4 comment's `FROM` sentences.
  Approach: `scripts/install-dev.sh`, then the `FROM` half of the
  re-install case in `scripts/test/install-dev.test.sh`.
- [x] A backlog line in a changed `tasks.md` is one line: outside task
  entries, headings and the `Why:` paragraph, a line continuing the one
  above it, or indented under a non-task bullet, fails `backlog line over
  1 line`.
  Approach: the `tasks` mode of `scan`; test a wrapped paragraph, a wrapped
  bullet, and one-line bullets that pass.
- [ ] A branch that adds a `*.findings.md` under `<plans>` fails `findings
  file: use the task report`; an existing or renamed one passes.
  Approach: the added status of the item-1 diff with rename detection; a
  test case each.
- [ ] Any other changed `.md` in an initiative dir outside `batches/` is a
  branch plan: a checkbox item over 6 lines with its indented continuation
  fails `item over 6 lines`; `skills/dev/branch-plan.md § Body` states it.
  Approach: a `plan` mode in `scan`; test 6- and 7-line items. `scan` is
  45 lines against the 50-line cap of `scripts/ci/check-code-size.sh`.
- [ ] `<plans>/ROADMAP.md` passes the gate, so the next branch adding or
  closing an entry is not failed by legacy text: every entry at most 3
  lines, naming no other initiative's id, its meaning kept.
  Approach: run the gate with the file changed and trim each entry it
  names; a legacy `R-NNN` entry keeps its own id.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
