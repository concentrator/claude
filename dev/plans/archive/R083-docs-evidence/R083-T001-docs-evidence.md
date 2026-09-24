---
task: R083-T001
type: mnt
mode: normal
---

# R083-T001: evidence references replace provenance marks

- [x] `layout.md § Docs` is the one home of evidence: column `provenance`
  becomes `evidence` - a report doc for a probed claim; a source path and
  symbol or heading, spec or vendor page, or adapted reference for a read
  one; two for a row with both. Empty is no evidence, read as unproven, the
  row kept. It names what a doc may cite; a citation of a citation is none.
  Approach: replace the paragraphs under the table; the restate ban stays.
- [x] `companions/documentation.md` cites `layout.md § Docs` and keeps no
  provenance word: a report records the call, its output and environment
  from a run that could have failed, and a probed claim without one has no
  evidence; an UNPROVEN claim gets evidence or an empty cell, and no verdict
  is written into a doc. § Evidence and provenance becomes § Evidence.
  Approach: § Diataxis typing, § Content quality, § Verification gate.
- [x] The doc writer and the verification policy use the rules' words:
  `agents/dev-doc-writer.md` fills each row's evidence cell or leaves it
  empty, never a mark; `doc-writer-prompt.md` reports the rows left empty;
  `verification-policy.md § Verification modality` cites the source read.
  Approach: those three files; `git grep -niE 'provenance|from-spec'` over
  `skills/ agents/ rules/` then finds nothing.
- [x] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
