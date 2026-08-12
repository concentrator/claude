---
task: R046-T003
type: doc
---

# R046-T003 - canon consistency

Branch: `doc/canon-consistency`. Legacy bare ids stay valid, frozen,
and never renumbered: these commits change prose that states the
convention, never an artifact filename or an existing id.

- [x] `plan.md § Levels` and its § Where things live table: the chain
      and the artifact filenames in composite form, leaving the legacy
      sentence as the one place that names the retired form.
- [x] `branch-plan.md`: the header example, the findings-file
      references, and the § Closing routine triage item in composite
      form.
- [x] `finish.md § 1` and `templates.md § References`: composite form,
      the release-plan example included.
- [x] `companions/implementer-prompt.md` and `companions/report-template.md`
      carried the bare form too - outside the R's § Scope, but the
      criterion sweeps every living doc, so they are fixed here.
- [x] `layout.md`'s artifacts tree: composite form. No task owned this
      file until now, though `MAINTENANCE.md § Doc-sync pairs` names it
      for a naming-convention change, and `README.md` plus
      `REQUIREMENTS.md` cite it for the mechanics (close-review finding
      on R046-T002).
- [x] `templates.md`'s `kind:` enum and `write-plan.md § Inputs`' tag
      list aligned with the branch taxonomy in
      `git-workflow.md § Trunk` - resolves the R's open question:
      the enum extends to the six task tags, and `doc`/`test`/`mnt`
      initiatives use the `refactor` body shape rather than gaining
      section sets of their own. `plan.md § Levels` carried the same
      partial tag list and is aligned too.
- [ ] `SKILL.md § /dev code`: the dispatch line covers `doc`, `test`,
      and `mnt` tags alongside `feat`/`fix`/`refactor`, so every task
      tag has a declared execution route. `SKILL.md` is governed
      (`rules/skills.md § Approval`): propose the wording and wait for
      approval before writing, and keep the body within its cap.
- [x] The `tasks.md` index mark becomes its own checkbox every plan
      carries, so a closing branch cannot silently skip it. `templates.md`
      holds no branch-plan template, so the fix landed where the final
      items are actually defined: `branch-plan.md § Closing routine`
      states both items and `write-plan.md § Steps` emits them. The
      duplicated marks clause in that step's prose is gone.
- [ ] `plan.md § Archival`: state the trigger unambiguously - artifacts
      archive when the initiative closes, not per task. The text pairs
      "Closing archives, in two steps" with a whole-directory move at
      initiative close, so it reads both ways; practice is
      initiative-close. The findings-follow-their-consumers rule is
      orthogonal and stays.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
