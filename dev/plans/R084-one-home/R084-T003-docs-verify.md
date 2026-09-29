---
task: R084-T003
type: mnt
mode: normal
---

- [x] What a doc's claim is confirmed against has one home,
  `documentation.md § Sources` in place of § Evidence, named in the doc
  writer's report and never in the doc; the definition leaves
  `layout.md § Docs`, whose `§ Parameters` table drops its evidence
  column and preamble rule while every input keeps its row.
  Approach: then the evidence wording of the Reports and Snapshot bullets.
- [ ] The docs gate is three checks returning one mismatch list: each
  claim against its section's source, one no source confirms listed; the
  whole doc for ambiguity and contradiction; conformity to `writing.md`,
  `rules/writing-artifacts.md` and the framework. No verdict names.
  Approach: `documentation.md § Verification gate`, its prose class kept
  on changed text; then `verification-policy.md § Verification modality`.
- [ ] The doc writer's report names, per section of each doc it touched,
  the source it confirmed against and each claim none confirmed, never a
  log of its steps; the doc holds no evidence cell or mark, and a
  re-dispatch takes the mismatch list verbatim and fixes every entry.
  Approach: `agents/dev-doc-writer.md` steps 3 and 4, then the inputs,
  exit and report format of `companions/doc-writer-prompt.md`.
- [ ] The docs verifier reads the writer's report first, runs the gate's
  three checks over each doc and returns one mismatch list; the runner
  passes it the report, and a non-empty list re-dispatches one fresh doc
  writer whose result goes to the user, never to a second verification.
  Approach: `agents/dev-docs-verifier.md` with its description line, then
  `skills/dev/run.md § Close` 3.
- [ ] The close review runs the gate's three checks on changed rules,
  skills and planning prose, a mismatch reported as Critical, and no
  retired term survives: `git grep` over tracked files outside
  `dev/plans/` finds no verdict name, evidence cell or per-claim pass.
  Approach: the prose class of `agents/code-reviewer.md`, then the search
  and a rewrite of each hit.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
