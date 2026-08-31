---
task: R068-T001
type: doc
---

Branch: `doc/docs-snapshot-rules`.

The documentation framework lets feature docs accumulate development
chronology and links into planning artifacts; `plan.md § Archival`
then breaks those links at initiative close. This branch makes the
framework rule docs as snapshots of current state with a closed link
scope, and gives evidence and adapted external material their own doc
types inside the docs tree.

## Commits

- [x] `documentation.md`: add the snapshot principle and link scope -
  a doc states current behavior with no chronology, task or plan ids,
  or development details (provenance marks stay, dateless); links go
  only to sibling documents inside the docs tree or external URLs,
  never plan files (live or archived), findings, or `.claude/` paths;
  the mechanical gate expectation (docs gate fails on `dev/plans/`,
  `.claude/`, or non-URL out-of-tree references) lands beside "No
  dead ends" in § Content quality.
- [x] `documentation.md`: define the two doc types - reports
  (`docs/reports/`: probe and test reports, the one docs location
  where datetimes and tenant / client ids are allowed; linked
  plainly; useful, never required) and adapted references
  (`docs/references/`: external or codebase material rewritten to
  project format carrying exactly what docs need, a source URL
  allowed inside) - and retarget § Content quality "Real examples ...
  cited" and § Evidence and provenance from findings and transcripts
  to report docs.
- [x] `layout.md § Docs`: add `reports/` and `references/` under the
  docs home in the tree and the section prose; reword skeleton row 7
  from "Sibling docs and the feature's `references/` inputs" to
  sibling docs, reports, and adapted references.
- [x] `plan.md § Archival`: rewrite the findings disposition - at
  close every findings file is archived uncited, promoted into a doc,
  transformed into a report doc, or spawned into a new plan or task -
  and state that docs never link findings or plan files, so promotion
  moves facts, never links.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (docs row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
