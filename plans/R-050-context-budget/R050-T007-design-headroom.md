---
task: R050-T007
type: doc
architecture-changing: true
---

# R050-T007 - DESIGN.md headroom for the initiative

Branch: `doc/design-headroom`.

`DESIGN.md` sits two words under its 1000-word cap
(`skills/dev/layout.md`), and three remaining R-050 tasks need room in
it: T002's context-budget paragraph in `§ Self-enforcement`, and a
tree-map line plus a `§ Self-enforcement` mention for each of T003's and
T006's hooks. Roughly 80 words are needed against 2 available, so the
initiative cannot land without this first.

The flag is set because the trims touch `DESIGN.md` prose outside the
tree-map upkeep carve-out (`branch-plan.md § Architecture-changing
branches`). No design decision changes here: the work removes restatement
of facts owned elsewhere, which is R-039's rule applied to the file that
has drifted furthest from it.

Target: leave `DESIGN.md` at or below 920 words, giving the remaining
three tasks their ~80 words with margin. The number is a budget for this
branch, not a new convention; the cap stays 1000.

- [ ] Audit `§ Self-enforcement` and `§ Git & delivery model` sentence by
      sentence against single-home (R-039): for each fact, name the file
      that owns it, and mark the sentence keep, trim, or pointer. Record
      the audit in `R050-T007-design-headroom.findings.md` so the trims
      that follow cite a named owner rather than a word count. A fact with
      no other home stays regardless of length.
- [ ] Apply the trims whose owner is elsewhere, leaving a pointer where a
      reader needs orientation rather than the fact itself. The known
      first case: `§ Self-enforcement` restates the branch guard's
      dispatch rule, which `hooks/dev-branch-guard.sh` already states in
      its own header.
- [ ] Verify the headroom is real, not just the count: add the three
      pending entries as a scratch edit, confirm `check-caps` passes with
      them present, then revert the scratch. A word count alone would pass
      while leaving a later task one line short.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
