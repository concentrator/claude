---
task: R040-T025
type: mnt
---

Branch: `mnt/line-caps`.

`scripts/ci/check-caps.sh` holds a `skills/dev/*.md` mode file to 1500
words. Words do not measure a document: a file at the cap takes every
edit as a trade, and the trades cut meaning - the R040-T021 close review
restored two conditions its trims had dropped. `CLAUDE.md` is already
held by lines in the same check; the mode-file tier follows, with a
line-length ceiling so a rewrap cannot buy lines.

## Terms used below

- **Mode file** - a file `git ls-files skills/dev` lists directly under
  `skills/dev/`, `SKILL.md` excluded; `companions/` stay exempt, as
  today. `SKILL.md` keeps its word tiers (`rules/skills.md § Size`),
  `DESIGN.md` its 1000 words.
- **The tier** - at most 300 lines, and no line over 80 characters.
  A table row (a line starting with `|`) is exempt from the length
  ceiling, since it cannot wrap. A report names the file and the
  count, or the file, the line number and its length for the first
  over-long line.

## Commits

- [x] `check-caps.sh`: the mode-file loop measures the tier, the header
  comment and the R-021 note say lines; `scripts/test/check-caps.test.sh`,
  new, with six fixture cases - 301 lines caught, an 81-character prose
  line caught with its line number, an 81-character table row passes, a
  compliant file passes, 80 multibyte characters pass, a companion is
  outside the tier - hermetic like the sibling self-tests
  (`scripts/test/isolation.test.sh` names the scrub).
- [x] Rewrap every prose line the new check reports, in every mode
  file it reports (ten files, 36 lines at planning time), wording
  untouched; `bash scripts/ci/run-all.sh` green.
- [x] `rules/skills.md § Size` states the mode-file tier in lines and
  characters; `DESIGN.md § Self-enforcement` stays unchanged unless
  it names the unit.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [x] Complete the branch: close review per `branch-plan.md § Closing
  routine` (code row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
