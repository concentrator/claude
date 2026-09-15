# R080-T005 findings

Notes the last cold read reported and no planner fixed, one bullet per
gap. `write-plan.md` step 6 sends what a second read finds here rather
than to another planner pass. The implementer reads them with the plan;
the close triages what is still open.

- [x] **Item 1's line budget is about 28 characters short, and `run.md`
  fails its cap if the item is followed literally.** Approach-level, so
  it is the implementer's to fix in the commit that carries the edit
  (`run.md § Seats`). The approach says the swap frees 7 characters and
  tightening "reports every rule with the tier carrying it" to "reports
  each rule's tier" pays for the rest. Measured on the tree: the bullet
  runs 299 characters over its lines, the swap frees 7 and the
  tightening 19, and the cite
  `` (`companions/supervisor-runbook.md § Modes by seat`) `` costs 54 -
  net +28, which pushes the bullet to a fifth line and `run.md` to 301
  against `scripts/ci/check-caps.sh:12`'s `(( n <= 300 ))`. Dropping
  `companions/` from the cite does not close it. The implementer needs
  a shorter route - more tightening in the same bullet, a shorter cite
  form the file already uses, or a line recovered elsewhere in
  § Pre-flight - and the choice is the approach's to record.

- [ ] **Item 5's evidence arms do not cover a third shape the pilot
  history holds, and its stop rule makes the outcome undecidable.**
  Acceptance-level. The item describes two shapes: acceptance text
  changing in commits that carry no code, and approach edits riding the
  implementer commits that carry theirs, the checkbox being the one
  above-the-run-in change an implementer commit makes. The branch's
  mandatory final commit "Complete R080-T007: permission pre-flight" -
  the runner's under `run.md § Close` 4, not a planner's - carries no
  code and changes acceptance text beyond its checkbox, inside an item
  that has no `Approach:` run-in at all. It is neither arm. Item 5 then
  says "Where a check returns something the criterion does not admit,
  the item stops and reports rather than marking", so one implementer
  marks criterion 5 and another halts the branch. A halt here is
  legitimate and takes `run.md § Question resolution` to a planner;
  what the item cannot do is leave the choice open. Everything else in
  the check holds: all 15 commits that changed acceptance text on the
  pilot branch carry no code, and every code-carrying implementer
  commit's only acceptance-region change is its checkbox.

- [ ] **Item 3's "all four verifier-class seats" rests on a paragraph
  `agents/dev-docs-verifier.md` does not have.** Acceptance-level. The
  item says the whole verifier bound is what that file "alone carries
  today across its conduct and its § Probing", and that striking the
  `tasks.md` leaving closes it for four seats. The file has no conduct
  paragraph; its only read-only clause is § Probing's closing "toward
  the checkout you stay read-only", and it carries nothing of "runs no
  git that moves HEAD, switches a branch or changes the working tree" -
  the clause the pilot's own `git checkout main` incident motivated.
  The approach names three files, so an implementer strikes a leaving
  as closed across four seats while the fourth was never audited.
  Either the docs verifier is in scope for the same paragraph, making
  it a fourth file the approach names, or the item says why § Probing's
  shorter clause suffices and drops the "whole verifier bound" framing
  for it.

- [ ] **Item 4's criterion-3 evidence omits one of the criterion's own
  four verifications.** Acceptance-level, one clause. Criterion 3 as
  amended verifies by the plan's `cold-read: passed` header, **the
  commit that recorded it**, the doc-writer commit, and
  `companions/implementer-prompt.md`'s input set. The item lists three
  and drops the recording commit, so the `Evidence:` line written from
  it under-covers the criterion it marks. The commit exists and the
  plan names it elsewhere: "Record the cold-read pass for the reopened
  items".

- [ ] **Item 6's criterion-7 backlog line records a hole without its
  consequence.** Acceptance-level. The item has the implementer append
  the reviewer's missing duty row to `tasks.md`'s backlog, which is the
  right destination, but nothing in it says that `run.md:33` - "A run
  reaching a duty the duty table below leaves unassigned halts and
  reports, never improvises" - makes the missing row bite every spec
  check the flow dispatches, this branch's included. A close-out reader
  gets a note about a table hole and no signal that the live flow has
  been improvising past it, which is the fact that justifies deferring
  a one-line edit to a file at its cap.
