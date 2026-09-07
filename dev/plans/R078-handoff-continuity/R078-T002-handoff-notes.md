---
task: R078-T002
type: mnt
---

# R078-T002: the notes key

Branch: `mnt/handoff-notes`. Requirements:
`dev/plans/R078-handoff-continuity/requirements.md`.

- [ ] The `notes` key: `handoff.md § Writing the note` adds `notes` to
  the key list and the example block - short factual lines (facts,
  decisions, observations, explanations no durable artifact owns),
  expected when the note is written mid-task, `none` when empty; the
  block stays keys-only, no narrative. `hooks/dev-handoff-nudge.sh`'s
  block reason names the key so a mid-pass compaction prompts for the
  facts; `dev-handoff-nudge.test.sh` gains the reason assertion beside
  the existing two.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, R078 closure check per `plan.md § Approval and closure`
  when this closes the R's last open task (criteria verified with
  one-line evidence, ROADMAP `[x]`, archival in the closing delivery),
  cleanup.
