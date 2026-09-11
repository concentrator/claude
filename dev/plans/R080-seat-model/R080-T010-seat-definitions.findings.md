# R080-T010 findings

Notes a cold read still reported and no planner fixed, one bullet per
gap, each labelled by the item it concerns. `write-plan.md` step 6
sends what a last read finds here rather than to another planner pass.
The notes on items 6 and 8 come from the second read of the first
close-fix change; those on items 9 and 11 from the read of the second,
which the user ruled the last on this plan.

- **Item 6, the testability claim is contradicted by the plan's own
  evidence.** The acceptance says "the one method a seat has for
  testing them is the self-report the decision above disqualifies". The
  decision block's strongest datum is not a self-report but a call: a
  seat asked to call the two names reported that neither exists in its
  set. That method is equally available for `Edit`, `Write`,
  `NotebookEdit` and `Skill` - ask a writing seat to edit a scratch
  file or invoke a skill, and it either does or reports the tool
  missing. So the stated reason for shipping those four unchecked does
  not hold, and the real reason, cost or scope, is unstated. It matters
  because the same decision says a missing name costs a capability
  rather than failing loudly, so four names stay in that failure class
  on a rationale that is not sound.

- **Item 6, "those seats now search through `Bash`" states a standing
  condition as a change.** By the item's own decision the client never
  provided the two names, so no dispatch loses anything: the edit makes
  the declaration match what was already true. The backlog sentence the
  approach quotes phrases it correctly; the acceptance does not.

- **Item 6, "R080's backlog" names no one paragraph.** `tasks.md`
  carries two backlog paragraphs, one opening "Backlog: R080-T001,
  T002 and T004 to T008 still carry" and one opening "Backlog, loop
  simplification (from the R080-T008 run, each a rule edit unless
  noted)". The approach settles on the second, whose own scope label
  fits neither this observation nor the R080-T009-close and
  R080-T010-planning material it already carries. Low severity: that
  paragraph functions as the initiative's rolling backlog.

- **Item 8, the new decision's reason does not discriminate.** The
  acceptance keeps `write-plan.md` step 6 as it is because the step
  "states the input set and the ask as part of the planner flow it
  owns - the same step routes each gap and records `cold-read:
  passed`". Every clause is equally true of `§ Comprehension check` as
  the item leaves it: that section opens by naming step 6, keeps the
  input set, keeps the gap routing and keeps the record. Whatever does
  separate them - presumably that step 6 is the flow's numbered step
  and the companion section is the dispatch's how-to - is unstated, and
  this acceptance is the decision's only home. After the change the ask
  stands in two places, `agents/dev-cold-reader.md` and `write-plan.md`
  step 6.

- **Item 8, the one-home criterion is applied to the ask but not to the
  input set.** After the change the reader's input set stands in three
  places: the definition, `§ Comprehension check` and `write-plan.md`
  step 6. What makes the input set legitimately triplicated while the
  two questions need one home is not stated.

- **Item 8, the list of what stays is under-inclusive.** Read strictly
  against "keeps only what is the dispatcher's", the acceptance names
  three survivors, but the section's closing sentence survives too, per
  the approach. Which rationale sentence goes and which stays is
  settled only by the approach text.

- **Item 9, its `tasks.md:77-84` anchor holds only in plan order.** The
  entry it names sits above every other insertion point on this
  branch, so the numbers survive as long as item 9 runs before items
  10 and 12. Run out of order they go stale exactly as item 10's did,
  and the quoted opening and closing are then the anchor. The plan's
  order is the order, so this is a caution, not a defect.

- **Item 11, the doc-writer cadence keeps three homes outside
  `run.md`.** After the edit it stands once in `run.md § Seats`, which
  is what the acceptance claims, and also in
  `skills/dev/branch-plan.md:41`, `companions/doc-writer-prompt.md:3`
  and the `description:` of `agents/dev-doc-writer.md:3`.
  `writing.md § No repetition` is scoped to one document, so none of
  the three is a casualty of this item. Recorded because the seat
  model's aim is one home per fact, and a later task narrowing that
  will want the list.

## Docs gate, comprehension findings on text the branch did not write

The second docs-gate pass over `README.md` returned no WRONG and no
UNPROVEN. Its comprehension pass found these on sentences no commit on
this branch touched; the three on branch-authored sentences were fixed
before the close.

- [x] **The installer's working directory.** "from a checkout of this
  repo" hides that `install-dev.sh` resolves its source from the
  current directory (`install-dev.sh:19`, `git rev-parse
  --show-toplevel`): run by absolute path from inside another repo, it
  copies from that repo. Promoted to R080's backlog with the next
  three, as one installer-docs line.
- [x] **`jq` is an unstated prerequisite.** The installer exits without
  it (`install-dev.sh:20`) and the hooks depend on it; neither
  `§ Setup` nor `§ Installing` names it. Promoted, as above.
- [x] **"Re-run it to refresh" collides with the dirty-tree guard.** A
  project install dirties the tracked `.gitignore`, so the next re-run
  is refused until that is committed or `--force` is passed. The doc
  states both facts three paragraphs apart. Promoted, as above.
- [x] **The seeded hygiene section's file is unnamed.** It lands in
  `<path>/.claude/MAINTENANCE.md`, not a project-root `MAINTENANCE.md`,
  which the installer leaves alone. Promoted, as above.
- [x] **`§ Self-hosting` reads as if only `Layout:` is declared.** It
  says `CLAUDE.md § Layout` keeps `Docs:`, `Plans:` and `Session:` at
  their defaults; that block declares all four, three with
  default-equal values. Won't fix: the three values are the defaults,
  so the sentence is true.
- [x] **The DEV chain differs from `CLAUDE.md`'s.** README gives
  "initiatives (requirements) → tasks → branch plans → commits" right
  after saying `CLAUDE.md` defines the modes, where the chain is
  "requirements → design → initiatives → tasks → branch plans →
  commits". Won't fix: the README summarises and cites `CLAUDE.md` as
  the definition.
- [x] **Assumed vocabulary.** Hook event names, "seat", "supervisor",
  "batch" and "trunk" appear in `§ Contents` before `§ Workflow`
  explains any of them. Won't fix: `§ Contents` maps paths, and
  `§ Workflow` two sections on defines the terms.
