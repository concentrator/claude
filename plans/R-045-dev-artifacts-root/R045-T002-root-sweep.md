---
task: R045-T002
type: refactor
depends-on: R045-T001
---

# R045-T002 - sweep the system source onto the declared root

- [x] Write the inventory beside this plan
      (`R045-T002-root-sweep.inventory.md`): the adopter path set
      `migrate` will move, and every DEV system-source reference that
      must be rewritten, each entry carried out or deferred with a
      stated reason.
- [x] Core execution docs resolve artifact paths against the root:
      `branch-plan.md`, `write-plan.md`, `finish.md`.
- [x] Mode and surface docs: `docs.md`, `release.md`, `auto.md`,
      `supervise.md`, `SKILL.md`, `brainstorm.md`, `changelog.md`,
      `git-workflow.md`.
- [x] Companion prose: `documentation.md`, `docs-adoption.md`,
      `report-template.md`, `templates.md`, `visual-companion.md`,
      `implementer-prompt.md` (its `.claude/`-prefixed edit rule
      restated over the artifacts root), `toolchain.md`.
- [x] Migration companions made root-aware: `tbd-migration.md` (its
      `.claude/plans/ROADMAP.md` trigger predicate),
      `legacy-migration.md`, `untracked-claude.md` (detection predicate
      and gitignore recipe cover the artifacts root).
- [x] `agents/code-reviewer.md`: root-resolved paths; fix the stale
      `plans/batches/B-XXX.md` reference (batches are per-R).
- [x] `companions/auto-permissions.template.json`: grant globs resolve
      the declared root so headless grants match the artifacts they
      pre-authorize.
- [x] `companions/scripts/start-server.sh` and `stop-server.sh`:
      `SESSION_DIR` under the declared root.
- [ ] `start.md` scaffolds onto the declared root: ask for and record
      the declaration; `plans/` + `ROADMAP.md`, `release-v0.1.0.md`,
      and the docs-index pointer follow it.
- [ ] Gates: `check-plan-integrity.sh` resolves the declared root
      (defaulted seam, repo root here); `check-accretion.sh` and its
      test fixtures follow; amend the `check-references.sh` header
      comment.
- [ ] Vendor transform (R-015 embed path): carry the declaration
      through to embedded copies; adjust its test.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
