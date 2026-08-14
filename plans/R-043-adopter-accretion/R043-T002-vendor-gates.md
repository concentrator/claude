---
task: R043-T002
type: feat
depends-on: R043-T001
---

# R043-T002 - vendor the gate set

Branch: `feat/vendor-gates`.

- [ ] `install-dev.sh` copies `check-accretion.sh`,
      `check-batch-tags.sh`, `resolve-root.sh` into the target's
      `scripts/ci/` and their self-tests into `scripts/test/` (exec
      bits set), alongside the R-026 checks; the summary line names
      the full set. `install-dev.test.sh` asserts each copied file
      and that a copied self-test passes unmodified in the target.
- [ ] Adoption surfaces: `start.md`'s scaffold step names the shipped
      Tier-1 checks including the accretion and batch-tags gates;
      `migrate.md`'s docs-reconcile proposal cites the shipped
      reference copy instead of describing the check from scratch.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit. Closing the R's
      last task, the closure check rides this commit.
