---
task: R046-T003
type: doc
---

# R046-T003 - canon consistency

Branch: `doc/canon-consistency`. Legacy bare ids stay valid, frozen,
and never renumbered: these commits change prose that states the
convention, never an artifact filename or an existing id.

- [ ] `plan.md § Levels` and its § Where things live table: the chain
      and the artifact filenames in composite form, leaving the legacy
      sentence as the one place that names the retired form.
- [ ] `branch-plan.md`: the header example, the findings-file
      references, and the § Closing routine triage item in composite
      form.
- [ ] `finish.md § 1` and `templates.md § References`: composite form.
- [ ] `templates.md`'s `kind:` enum and `write-plan.md § Inputs`' tag
      list aligned with the branch taxonomy in
      `git-workflow.md § Trunk` - resolves the R's open question.
- [ ] `SKILL.md § /dev code`: the dispatch line covers `doc`, `test`,
      and `mnt` tags alongside `feat`/`fix`/`refactor`, so every task
      tag has a declared execution route. `SKILL.md` is governed
      (`rules/skills.md § Approval`): propose the wording and wait for
      approval before writing, and keep the body within its cap.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
