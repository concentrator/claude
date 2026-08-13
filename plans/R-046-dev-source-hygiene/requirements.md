---
approved: 2026-08-11
status: done 2026-08-13
kind: mnt
---

# R-046: DEV system-source hygiene

## Current state

The toolset documents its own conventions in its own source, and those
documents drift from the conventions they state. Observed while shaping:

- Composite task ids (`R<NNN>-T<NNN>`) are stated in `plan.md § ID
  format`, while `plan.md § Levels` and its § Where things live table,
  `branch-plan.md`, `finish.md`, `templates.md`, `README.md`,
  `REQUIREMENTS.md`, and the `DESIGN.md` tree-map still present the
  retired bare `T-XXX` form as current.
- `README.md` describes an execution surface of two commands, an
  installer that registers one hook, and a root without `hooks/`,
  `scripts/`, `writing.md`, or `delegation.md`; the artifacts root is
  absent.
- The `DESIGN.md` tree-map omits three `skills/dev/` mode files,
  `plans/archive/`, and most of `scripts/test/`, even though
  `MAINTENANCE.md § Tier-2 AI review` names the tree-map as a concern.
- `REQUIREMENTS.md § Planning discipline` cites three `rules/` files
  that moved into `skills/dev/` at R-021.
- `templates.md` admits `kind: feat | bug | refactor`, while the branch
  taxonomy in `git-workflow.md` carries `mnt`, `doc`, and `test`, and
  initiatives have been stamped `mnt` and `chore`.

The Tier-2 review is diff-driven: it confirms each changed file obeys
its governing rule. Staleness a change induces in a file it does not
touch has no owner, which is how every item above survived review.

Two items carried at R-045's close share the theme:
`companions/toolchain.md` hosts three `CLAUDE.md § Agent toolchain`
declaration keys in a file titled for push and MR mechanics, and
`scripts/ci/check-plan-integrity.sh` has no dedicated script test.

## Desired state

- Living documents state the conventions the toolset actually runs on.
- A named review obligation owns induced staleness: a change that
  alters a documented surface updates the documenting doc in the same
  branch. Written-rule level, carried by the branch-close review.
- The repo's change-to-doc pairs have one home, kept out of the generic
  sections that seed into adopter projects.
- Declaration syntax is read from a companion named for it.
- The plan-integrity check has a test of its own.

## Invariants

- Legacy bare `T-XXX` ids stay valid, frozen, and never renumbered
  (`plan.md § ID format`). The sweep changes prose that states the
  convention, never an existing artifact filename or id.
- `plans/archive/` is frozen history and is not edited.
- `MAINTENANCE.md`'s generic sections stay adopter-portable:
  repo-specific pairs live in § This environment only.
- Governed files are proposed, not auto-edited (`rules/claude-md.md`,
  `rules/skills.md` § Approval).
- No new Tier-1 check, and the Tier-1 gate's checks and entry command
  are unchanged.

## Scope

`MAINTENANCE.md`, `README.md`, `DESIGN.md`, `REQUIREMENTS.md`,
`skills/dev/plan.md`, `branch-plan.md`, `finish.md`, `templates.md`,
`write-plan.md`, `SKILL.md`, `layout.md`, `companions/toolchain.md` and
its inbound references, plus a new
`scripts/test/check-plan-integrity.test.sh`.

## Acceptance criteria

- [x] No living markdown presents the retired bare form as current:
      `grep -rn "T-XXX" --include="*.md" .` outside `plans/archive/`
      returns only occurrences explicitly labeled legacy.
      Evidence: the sweep returns only this file's two lines - the
      § Current state description and this criterion's own command.
- [x] `README.md` matches its sources, each checked at close: every
      command in `SKILL.md § Surface` appears, every tracked root entry
      appears in § Contents, and the installer paragraph matches what
      `install-dev.sh` copies and registers.
      Evidence: both loops (commands from `SKILL.md`, root entries from
      `git ls-files`) report nothing missing; the installer paragraph was
      rewritten against `install-dev.sh` and its two out-of-`.claude/`
      writes named.
- [x] The `DESIGN.md` tree-map matches the tree for tracked paths.
      Evidence: no tracked top-level dir or `skills/dev/` mode file is
      absent from the map, and `check-stray.sh` - which derives the
      allowed top-level set from it - is green.
- [x] No living document cites a `rules/` path that does not exist.
      Evidence: every `rules/*.md` citation outside `plans/archive/`
      resolves to a file.
- [x] `MAINTENANCE.md` names doc sync as a review concern, and the
      concern set is enumerated in exactly one file: `branch-plan.md`
      and `DESIGN.md` reference it without restating the list.
      Evidence: the concern list string appears in no file but
      `MAINTENANCE.md`.
- [x] The change-to-doc pair table sits in `MAINTENANCE.md § This
      environment` and covers every trigger named in § Current state.
      Evidence: eight trigger rows under § Doc-sync pairs; the table
      caught three drifts in this initiative's own branches (the
      accretion gate, `layout.md`, the added companion).
- [x] `templates.md`'s `kind:` values and `write-plan.md`'s task-tag
      list match the branch taxonomy in `git-workflow.md § Trunk`, and
      `SKILL.md § /dev code` declares an execution route for every tag
      a task can carry.
      Evidence: both enums read `feat | bug/fix | refactor | doc | test
      | mnt`, and the dispatch line routes `doc`/`test`/`mnt` to
      `branch-plan.md § Commit cadence`, which is now tag-agnostic.
- [x] The `tasks.md` index mark is a checkbox every plan carries, so a
      closing branch cannot complete without it.
      Evidence: `branch-plan.md § Closing routine` states it as the
      first of two mandatory final items, and `write-plan.md` emits it.
      It landed there rather than in `templates.md`, which holds no
      branch-plan template; R046-T004 and R046-T005 both closed with the
      mark in the branch.
- [x] `plan.md § Archival` admits one reading of when a task's
      artifacts move, matching practice: at initiative close.
      Evidence: § Archival opens "Archival runs at **initiative**
      close"; `finish.md § 4` and `MAINTENANCE.md`'s repair line, which
      both instructed a per-task move, now agree.
- [x] The `§ Agent toolchain` declaration keys are read from a
      companion whose title names declaration syntax; `toolchain.md`
      keeps push and MR mechanics only; every inbound reference
      resolves.
      Evidence: `declarations.md` holds the three keys, `toolchain.md`
      holds § State check / § Push + MR/PR / § Permission carve-out, and
      every repointed citation lands on a real heading.
- [x] `scripts/test/check-plan-integrity.test.sh` covers the root-seam
      behaviors (nested-root attribution, the missing-ROADMAP guard)
      and passes under `scripts/test/run-all.sh`.
      Evidence: 17 cases green, one per report site; every report site,
      the `report()` fail flag, and the ROADMAP guard were mutated away
      in turn and each mutation failed the case guarding it.

## Constraints

- Rules level only: the obligation is carried by the branch-close
  review, not by a mechanical gate.
- Each doc repair verifies against the source file it describes, not
  against this document's § Current state list.

## Non-goals

- A `scripts/ci/check-doc-sync.sh` or any other new Tier-1 check.
- Renaming legacy artifacts or ids, or rewriting `plans/archive/`.
- Changing the documentation framework itself
  (`companions/documentation.md`).

## Open questions

None. The `kind:` question was settled in R046-T003: the enum extends
to the six task tags, and `doc`/`test`/`mnt` initiatives use the
`refactor` body shape.

## References

- R-021 moved the DEV process rules into `skills/dev/`; R-045 carried
  the two backlog items at close; R-044 (open) applies the same
  composite-id convention to rollback anchors.
