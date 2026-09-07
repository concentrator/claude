---
approved: yes
kind: mnt
---

# R079: Undated stamps

## Motivation

The `agentic:` and `supervised:` stamps carry an approval date
(`approved YYYY-MM-DD`) that duplicates what git already records: the
commit and MR/PR that added the stamp. `plan.md § Approval and
closure` makes exactly this argument for the `approved:` frontmatter
field - "the date of an approval is in the commit and MR/PR that
carried it" - then defends the stamp date one sentence later, so the
same document holds both positions. The consumers (`auto.md`
pre-flight, `supervise.md § Resolve`) check the stamp's presence,
never its date: nothing reads the date, and a hand-written date can
drift from the commit that actually carried the approval.

## Goals

- The stamps become `agentic: approved` and `supervised: approved` -
  no date. Which review an approval came from stays resolvable via
  the commit that added the stamp, the same trail `approved:` already
  relies on.
- `branch-plan.md` (§ Header example, § Stamps) and
  `plan.md § Approval and closure` state the dateless form; the
  sentence defending the date goes.
- The one live dated stamp
  (`dev/plans/R-042-planning-pocs/R042-T001-spike-provision.md`)
  migrates to the dateless form.

## Non-goals

- No change to what the stamps admit (auto / supervised eligibility)
  or to when they are applied.
- No change to the `approved:` frontmatter field - already undated.
- Archived plans keep their dated stamps (`rules/writing-artifacts.md
  § State the present` exempts `archive/`).

## Acceptance criteria

- [x] No tracked rule, skill, or open plan writes or shows a dated
  stamp: `grep -rn "approved 20\|approved YYYY" skills/ rules/
  dev/plans/ --exclude-dir=archive` returns nothing.
  Evidence: grep clean in the delivered tree - the only quoting lines
  are this R's own, archived in the same commit.
- [x] Stamp consumers still resolve: `auto.md` and `supervise.md`
  wording matches the dateless form.
  Evidence: both check stamp presence only (`auto.md` pre-flight,
  `supervise.md § Resolve`); confirmed by both close-review passes.
- [x] Tier-1 gate green (`bash scripts/ci/run-all.sh`).
  Evidence: `run-all: ALL OK` at close; full suite 19/19 green.

## Constraints

- Doc-sync pairs (`MAINTENANCE.md § This environment`): a naming
  convention change checks every `skills/dev/` file stating it.

## Open questions

None.

## References

- `skills/dev/branch-plan.md § Stamps` - the definitions.
- `skills/dev/plan.md § Approval and closure` - the `approved:` field
  precedent and the sentence to retire.
