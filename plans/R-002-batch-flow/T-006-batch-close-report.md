task: T-006
type: feat
depends-on: T-005

# feat/batch-close-report - batch close phase + report artifact (REQ-003)

Engine procedure in `delegating-to-agents`. SKILL.md must stay ≤400
words - structural detail goes to a companion report template.

- [x] Author `skills/delegating-to-agents/report-template.md` - per
      branch: commits, test evidence, review findings + resolutions;
      batch level: cross-branch findings, fixes, docs coherence,
      prompt-friction summary (from the `permission_prompts.jsonl`
      checkpoint reader).
- [x] SKILL.md: add the batch close phase - after the last member
      branch merges: full-diff review of `batch/B-XXX` vs default on
      the most capable model, fixes as batch-branch commits, tests +
      lint re-run, docs coherence pass. (Also fixed the T-005 seam:
      step 3 now merges into the batch branch; pre-flight creates it.)
- [x] SKILL.md checkpoint: write `plans/batches/B-XXX.report.md` per
      the template BEFORE the offer; accept is invalid without the
      report; present it. Trim elsewhere to hold the 400-word cap
      (landed at exactly 400).
- [x] agents/code-reviewer.md: verify fitness for batch-level full-diff
      review; extend if needed or record no-change in findings.
      (Extended: batch-mode dispatch contract added - it was
      single-plan oriented.)
- [x] Complete the branch: re-review docs across all commits, cleanup,
      mark plan complete, commit.
